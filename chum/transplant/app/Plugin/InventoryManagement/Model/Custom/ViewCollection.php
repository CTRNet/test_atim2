<?php

class ViewCollectionCustom extends ViewCollection
{

    var $name = 'ViewCollection';

    // TODO: Kidney transplant customisation
    // Added Collection.chum_kidney_transp_collection_time to view.
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
		Participant.participant_identifier AS participant_identifier,
		Collection.acquisition_label AS acquisition_label,
		Collection.collection_site AS collection_site,
		Collection.collection_datetime AS collection_datetime,
		Collection.collection_datetime_accuracy AS collection_datetime_accuracy,
		Collection.collection_property AS collection_property,
		Collection.collection_notes AS collection_notes,
		Collection.created AS created,
Bank.name AS bank_name,
MiscIdentifier.identifier_value AS identifier_value,
MiscIdentifierControl.misc_identifier_name AS identifier_name,
Collection.visit_label AS visit_label,
Collection.qc_nd_pathology_nbr,
Collection.chum_kidney_transp_collection_time,
TreatmentMaster.qc_nd_sardo_tx_all_patho_nbrs as qc_nd_pathology_nbr_from_sardo
		FROM collections AS Collection
		LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted <> 1
LEFT JOIN banks As Bank ON Collection.bank_id = Bank.id AND Bank.deleted <> 1
LEFT JOIN misc_identifiers AS MiscIdentifier on MiscIdentifier.misc_identifier_control_id = Bank.misc_identifier_control_id AND MiscIdentifier.participant_id = Participant.id AND MiscIdentifier.deleted <> 1
LEFT JOIN misc_identifier_controls AS MiscIdentifierControl ON MiscIdentifier.misc_identifier_control_id=MiscIdentifierControl.id
LEFT JOIN treatment_masters AS TreatmentMaster ON TreatmentMaster.id = Collection.treatment_master_id AND TreatmentMaster.deleted <> 1
			WHERE Collection.deleted <> 1 %%WHERE%%';

    public function find($type = 'first', $query = array())
    {
        if (isset($query['conditions'])) {
            $identifierValues = array();
            $queryConditions = is_array($query['conditions']) ? $query['conditions'] : array(
                $query['conditions']
            );
            foreach ($queryConditions as $key => $newCondition) {
                if ($key === 'ViewCollection.identifier_value') {
                    $identifierValues = $newCondition;
                    break;
                } elseif (is_string($newCondition)) {
                    if (preg_match_all('/ViewCollection\.identifier_value LIKE \'%([0-9]+)%\'/', $newCondition, $matches)) {
                        $identifierValues = $matches[1];
                        break;
                    }
                }
            }
            if (! empty($identifierValues)) {
                $miscIdentifierModel = AppModel::getInstance('ClinicalAnnotation', 'MiscIdentifier', true);
                $result = $miscIdentifierModel->find('all', array(
                    'conditions' => array(
                        'MiscIdentifier.misc_identifier_control_id' => array(6,18,19),
                        'MiscIdentifier.identifier_value' => $identifierValues
                    ),
                    'fields' => 'MiscIdentifier.identifier_value'
                ));
                if ($result) {
                    $allValues = array();
                    foreach ($result as $newRes)
                        $allValues[] = $newRes['MiscIdentifier']['identifier_value'];
                    AppController::addWarningMsg(__('no labos [%s] matche old bank numbers', implode(', ', $allValues)));
                }
            }
            $gtKey = array_key_exists('ViewCollection.identifier_value >=', $query['conditions']);
            $ltKey = array_key_exists('ViewCollection.identifier_value <=', $query['conditions']);
            if ($gtKey || $ltKey) {
                $infValue = $gtKey ? str_replace(',', '.', $query['conditions']['ViewCollection.identifier_value >=']) : '';
                $supValue = $ltKey ? str_replace(',', '.', $query['conditions']['ViewCollection.identifier_value <=']) : '';
                if (strlen($infValue . $supValue) && (is_numeric($infValue) || ! strlen($infValue)) && (is_numeric($supValue) || ! strlen($supValue))) {
                    // Return just numeric
                    $query['conditions']['ViewCollection.identifier_value REGEXP'] = "^[0-9]+([\,\.][0-9]+){0,1}$";
                    // Define range
                    if ($gtKey) {
                        $query['conditions']["(REPLACE(ViewCollection.identifier_value, ',','.') * 1) >="] = $infValue;
                        unset($query['conditions']['ViewCollection.identifier_value >=']);
                    }
                    if ($ltKey) {
                        $query['conditions']["(REPLACE(ViewCollection.identifier_value, ',','.') * 1) <="] = $supValue;
                        unset($query['conditions']['ViewCollection.identifier_value <=']);
                    }
                    // Manage Order
                    if (! isset($query['order'])) {
                        // supperfluou?s
                        $query['order'][] = "(REPLACE(ViewCollection.identifier_value, ',','.') * 1)";
                    } elseif (is_array($query['order']) && isset($query['order']['ViewCollection.identifier_value'])) {
                        $query['order']["(REPLACE(ViewCollection.identifier_value, ',','.') * 1)"] = $query['order']['ViewCollection.identifier_value'];
                        unset($query['order']['ViewCollection.identifier_value']);
                    } elseif (is_string($query['order']) && preg_match('/^ViewCollection.identifier_value\ ([A-Za-z]+)$/', $query['order'], $matches)) {
                        $orderBy = $matches[1];
                        $query['order'] = "IF(concat('', REPLACE(ViewCollection.identifier_value, ',', '.') * 1) = REPLACE(ViewCollection.identifier_value, ',', '.'), '0', '1') $orderBy, ViewCollection.identifier_value*IF(concat('',REPLACE(ViewCollection.identifier_value, ',', '.') * 1) = REPLACE(ViewCollection.identifier_value, ',', '.'), '1', '') $orderBy, ViewCollection.identifier_value $orderBy";
                    }
                }
            }
        }
        
        if (isset($query['order'])) {
            if (is_array($query['order']) && isset($query['order']['ViewCollection.identifier_value']) && sizeof($query['order']) == 1) {
                // Display first numerical values then alphanumerical values
                $orderBy = $query['order']['ViewCollection.identifier_value'];
                $query['order'][] = "IF(concat('',REPLACE(ViewCollection.identifier_value, ',', '.') * 1) = REPLACE(ViewCollection.identifier_value, ',', '.'), '0', '1') $orderBy, ViewCollection.identifier_value*IF(concat('',REPLACE(ViewCollection.identifier_value, ',', '.') * 1) = REPLACE(ViewCollection.identifier_value, ',', '.'), '1', '') $orderBy, ViewCollection.identifier_value $orderBy";
                unset($query['order']['ViewCollection.identifier_value']);
            } elseif (is_string($query['order']) && preg_match('/^ViewCollection.identifier_value\ ([A-Za-z]+)$/', $query['order'], $matches)) {
                $orderBy = $matches[1];
                $query['order'] = "IF(concat('', REPLACE(ViewCollection.identifier_value, ',', '.') * 1) = REPLACE(ViewCollection.identifier_value, ',', '.'), '0', '1') $orderBy, ViewCollection.identifier_value*IF(concat('',REPLACE(ViewCollection.identifier_value, ',', '.') * 1) = REPLACE(ViewCollection.identifier_value, ',', '.'), '1', '') $orderBy, ViewCollection.identifier_value $orderBy";
            }
        }
        return parent::find($type, $query);
    }

    /**
     *
     * @param array $variables            
     * @return array|bool
     */
    public function summary($variables = array())
    {
        // TODO: Kidney transplant customisation
        
        $return = false;
        
        if (isset($variables['Collection.id'])) {
            
//             $bankIds = $this->tryCatchQuery("SELECT GROUP_CONCAT(bk.id SEPARATOR ',') as bank_ids
//                 FROM banks bk 
//                 INNER JOIN misc_identifier_controls mc ON bk.misc_identifier_control_id = mc.id 
//                 WHERE mc.misc_identifier_name = 'kidney transplant bank no lab'");
//             $bankIds = isset($bankIds[0][0]['bank_ids']) ? explode(',', $bankIds[0][0]['bank_ids']) : '';
            
            $collectionData = $this->find('first', array(
                'conditions' => array(
                    'ViewCollection.collection_id' => $variables['Collection.id']
                ),
                'recursive' => - 1
            ));
            
//             if (! in_array($collectionData['ViewCollection']['bank_id'], $bankIds)) {
                // Keep for futur version merged with the ATiM-Oncology Axis
            if (Configure::read('chum_atim_conf') != 'KIDNEY_TRANSLPANT') {
                return parent::summary($variables);
            } else {
                $structurePermissibleValuesCustom = AppModel::getInstance("", "StructurePermissibleValuesCustom", true);
                
                $acquisitionLabel = strlen($collectionData['ViewCollection']['identifier_value']) ? $collectionData['ViewCollection']['identifier_value'] : '?';
                $acquisitionLabel .= ' - ' . (strlen($collectionData['ViewCollection']['visit_label']) ? $structurePermissibleValuesCustom->getTranslatedCustomDropdownValue('qc visit label', $collectionData['ViewCollection']['visit_label']) : '?');
                $acquisitionLabel .= ' - ' . (strlen($collectionData['ViewCollection']['chum_kidney_transp_collection_time']) ? $structurePermissibleValuesCustom->getTranslatedCustomDropdownValue('Collection Times', $collectionData['ViewCollection']['chum_kidney_transp_collection_time']) : '?');
                
                $return = array(
                    'menu' => array(
                        null,
                        $acquisitionLabel
                    ),
                    'title' => array(
                        null,
                        __('collection') . ' : ' . $acquisitionLabel
                    ),
                    'structure alias' => 'view_collection',
                    'data' => $collectionData
                );
            }
        }
        
        return $return;
    }
}