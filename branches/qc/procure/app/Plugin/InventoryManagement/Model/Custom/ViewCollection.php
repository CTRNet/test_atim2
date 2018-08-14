<?php

class ViewCollectionCustom extends ViewCollection
{

    var $name = 'ViewCollection';

    static $tableQuery = '
		SELECT
		Collection.id AS collection_id,
		Collection.bank_id AS bank_id,
		Collection.sop_master_id AS sop_master_id,
		Collection.participant_id AS participant_id,
		Collection.diagnosis_master_id AS diagnosis_master_id,
		Collection.consent_master_id AS consent_master_id,
		Collection.treatment_master_id AS treatment_master_id,
		Collection.event_master_id AS event_master_id,
Collection.procure_visit AS procure_visit,
Collection.procure_collected_by_bank AS procure_collected_by_bank,
		Participant.participant_identifier AS participant_identifier,
Participant.procure_participant_attribution_number,
		Collection.acquisition_label AS acquisition_label,
		Collection.collection_site AS collection_site,
		Collection.collection_datetime AS collection_datetime,
		Collection.collection_datetime_accuracy AS collection_datetime_accuracy,
		Collection.collection_property AS collection_property,
		Collection.collection_notes AS collection_notes,
		Collection.created AS created
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
            $title = empty($collectionData['ViewCollection']['participant_identifier']) ? ($collectionData['ViewCollection']['procure_visit'] == 'Controls' ? 'Controls' : '?') : $collectionData['ViewCollection']['participant_identifier'];
            $date = empty($collectionData['ViewCollection']['collection_datetime']) ? '' : ' ' . substr($collectionData['ViewCollection']['collection_datetime'], 0, strpos($collectionData['ViewCollection']['collection_datetime'], ' '));
            $return = array(
                'menu' => array(
                    null,
                    $title . $date
                ),
                'title' => array(
                    null,
                    __('collection') . ' : ' . $title
                ),
                'structure alias' => 'view_collection',
                'data' => $collectionData
            );
            
            // Check Consent
            $consentStatus = $this->getUnconsentedParticipantCollections(array(
                'data' => $collectionData
            ));
            if (! empty($consentStatus)) {
                if (! $collectionData['ViewCollection']['participant_id']) {
                    AppController::addWarningMsg(__('no participant is linked to the current participant collection'));
                } else 
                    if ($consentStatus[$variables['Collection.id']] == null) {
                        AppController::addWarningMsg(__('no consent is linked to the current participant collection'));
                    }
            }
            // Check Aliquot Barcode
            $aliquotMasterModel = AppModel::getInstance("InventoryManagement", "AliquotMaster", true);
            $aliquotCount = $aliquotMasterModel->find('count', array(
                'conditions' => array(
                    'AliquotMaster.collection_id' => $collectionData['ViewCollection']['collection_id'],
                    "AliquotMaster.barcode NOT LIKE '% " . $collectionData['ViewCollection']['procure_visit'] . " -%'"
                ),
                'recursive' => -1
            ));
            if ($aliquotCount) {
                AppController::addWarningMsg(__('at least one aliquot procure identification does not match the collection visit'));
            }
            
            // Check Aliquot Barcode
            $aliquotMasterModel = AppModel::getInstance("InventoryManagement", "AliquotMaster", true);
            $aliquotCount = $aliquotMasterModel->find('count', array(
                'conditions' => array(
                    'AliquotMaster.collection_id' => $collectionData['ViewCollection']['collection_id'],
                    "AliquotMaster.barcode NOT LIKE '% " . $collectionData['ViewCollection']['procure_visit'] . " -%'"
                ),
                'recursive' => -1
            ));
            if ($aliquotCount) {
                AppController::addWarningMsg(__('at least one aliquot procure identification does not match the collection visit'));
            }
        }
        
        return $return;
    }

    public function getUnconsentedParticipantCollections(array $collection)
    {
        $data = null;
        if (array_key_exists('id', $collection)) {
            $data = $this->find('all', array(
                'conditions' => array(
                    'ViewCollection.collection_id' => $collection['id']
                ),
                'recursive' => -1
            ));
        } else {
            $data = array_key_exists('ViewCollection', $collection['data']) ? array(
                $collection['data']
            ) : $collection['data'];
        }
        
        $results = array();
        $participantsToFetch = array();
        foreach ($data as $index => &$dataUnit) {
            if (empty($dataUnit['ViewCollection']['participant_id'])) {
                // removing missing consents (participant)
                $results[$dataUnit['ViewCollection']['collection_id']] = null;
            } else {
                $participantsToFetch[$dataUnit['ViewCollection']['participant_id']] = $dataUnit['ViewCollection']['collection_id'];
            }
        }
        if (! empty($participantsToFetch)) {
            // find all collections participants unlinked to a consent
            $consentModel = AppModel::getInstance("ClinicalAnnotation", "ConsentMaster", true);
            $consentData = $consentModel->find('all', array(
                'fields' => array(
                    'ConsentMaster.id',
                    'ConsentMaster.id, ConsentMaster.participant_id'
                ),
                'conditions' => array(
                    'ConsentMaster.participant_id' => array_keys($participantsToFetch)
                ),
                'recursive' => - 1
            ));
            foreach ($consentData as $consentDataUnit)
                unset($participantsToFetch[$consentDataUnit['ConsentMaster']['participant_id']]);
            foreach ($participantsToFetch as $participantId => $collectionId)
                $results[$collectionId] = null;
        }
        return $results;
    }
}