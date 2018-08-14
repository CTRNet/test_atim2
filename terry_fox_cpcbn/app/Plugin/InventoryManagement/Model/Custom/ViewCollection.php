<?php

class ViewCollectionCustom extends ViewCollection
{

    var $name = 'ViewCollection';

    public static $tableQuery = '
		SELECT 
		Collection.id AS collection_id,
--		Collection.bank_id AS bank_id,
		Collection.sop_master_id AS sop_master_id,
		Collection.participant_id AS participant_id,
		Collection.diagnosis_master_id AS diagnosis_master_id,
		Collection.consent_master_id AS consent_master_id,
		Collection.treatment_master_id AS treatment_master_id,
		Collection.event_master_id AS event_master_id,
		Collection.collection_protocol_id AS collection_protocol_id,
		Participant.participant_identifier AS participant_identifier,
		Collection.acquisition_label AS acquisition_label,
		Collection.collection_site AS collection_site,
		Collection.collection_datetime AS collection_datetime,
		Collection.collection_datetime_accuracy AS collection_datetime_accuracy,
		Collection.collection_property AS collection_property,
		Collection.collection_notes AS collection_notes,
Collection.created AS created, 
Participant.qc_tf_bank_participant_identifier AS qc_tf_bank_participant_identifier,
Participant.qc_tf_bank_id AS bank_id, 
Collection.qc_tf_collection_type AS qc_tf_collection_type
		FROM collections AS Collection 
		LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted <> 1 
		WHERE Collection.deleted <> 1 %%WHERE%%';
    
    public function summary($variables = array())
    {
        $return = false;
        
        if (isset($variables['Collection.id'])) {
            $collectionData = $this->find('first', array(
                'conditions' => array(
                    'ViewCollection.collection_id' => $variables['Collection.id']
                )
            ));
            
            $title = '';
            if ($collectionData['ViewCollection']['collection_property'] == 'independent collection') {
                $title = __('independent collection');
            } elseif (empty($collectionData['ViewCollection']['participant_identifier'])) {
                $title = __('unlinked collection');
            } elseif ($collectionData['ViewCollection']['qc_tf_bank_participant_identifier'] == CONFIDENTIAL_MARKER) {
                $title = __('participant identifier') . ' ' . $collectionData['ViewCollection']['participant_identifier'];
            } else {
                $title = __('bank patient #') . ' ' . $collectionData['ViewCollection']['qc_tf_bank_participant_identifier'];
            }
            
            $return = array(
                'menu' => array(
                    null,
                    $title
                ),
                'title' => array(
                    null,
                    __('collection') . ' : ' . $title
                ),
                'structure alias' => 'view_collection',
                'data' => $collectionData
            );
        }
        
        return $return;
    }

    public function beforeFind($queryData)
    {
        if (isset($_SESSION['Auth']) &&($_SESSION['Auth']['User']['group_id'] != '1') && is_array($queryData['conditions']) && AppModel::isFieldUsedAsCondition("ViewCollection.qc_tf_bank_participant_identifier", $queryData['conditions'])) {
            AppController::addWarningMsg(__('your search will be limited to your bank'));
            $GroupModel = AppModel::getInstance("", "Group", true);
            $groupData = $GroupModel->findById($_SESSION['Auth']['User']['group_id']);
            $userBankId = $groupData['Group']['bank_id'];
            $queryData['conditions'][] = array(
                "ViewCollection.bank_id" => $userBankId
            );
        }
        return $queryData;
    }

    public function afterFind($results, $primary = false)
    {
        $results = parent::afterFind($results);
        if (isset($_SESSION['Auth']) && $_SESSION['Auth']['User']['group_id'] != '1') {
            $GroupModel = AppModel::getInstance("", "Group", true);
            $groupData = $GroupModel->findById($_SESSION['Auth']['User']['group_id']);
            $userBankId = $groupData['Group']['bank_id'];
            if (isset($results[0]['ViewCollection']['bank_id']) || isset($results[0]['ViewCollection']['qc_tf_bank_participant_identifier'])) {
                foreach ($results as &$result) {
                    if ((! isset($result['ViewCollection']['bank_id'])) || $result['ViewCollection']['bank_id'] != $userBankId) {
                        $result['ViewCollection']['bank_id'] = CONFIDENTIAL_MARKER;
                        $result['ViewCollection']['qc_tf_bank_participant_identifier'] = CONFIDENTIAL_MARKER;
                        $result['ViewCollection']['collection_site'] = CONFIDENTIAL_MARKER;
                    }
                }
            } elseif (isset($results['ViewCollection'])) {
                pr('TODO afterFind ViewCollection');
                pr($results);
                exit();
            }
        }
        
        return $results;
    }
}