<?php

/** **********************************************************************
 * CUSM
 * ***********************************************************************
 *
 * Inventory Management plugin custom code
 * 
 * @author N. Luc - CTRNet (nicol.luc@gmail.com)
 * @since 2018-10-15
 */
class ViewCollectionCustom extends ViewCollection
{

    var $name = 'ViewCollection';

    public static $tableQuery = '
		SELECT
		Collection.id AS collection_id,
		Collection.bank_id AS bank_id,
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
Collection.cusm_collection_type,
MiscIdentifier.identifier_value    
		FROM collections AS Collection
		LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted <> 1
LEFT JOIN misc_identifiers AS MiscIdentifier ON Collection.misc_identifier_id = MiscIdentifier.id AND MiscIdentifier.deleted <> 1
		WHERE Collection.deleted <> 1 %%WHERE%%';
    
    public function summary($variables = array())
    {
        $return = false;
        
        if (isset($variables['Collection.id'])) {
            $collectionData = $this->find('first', array(
                'conditions' => array(
                    'ViewCollection.collection_id' => $variables['Collection.id']
                ),
                'recursive' => - 1
            ));
            $structurePermissibleValuesCustom = AppModel::getInstance("", "StructurePermissibleValuesCustom", true);
            $translatedCollectionType = $structurePermissibleValuesCustom->getTranslatedCustomDropdownValue('Collection Types', $collectionData['ViewCollection']['cusm_collection_type']);
            $summaryLabel = $collectionData['ViewCollection']['identifier_value'] . ($translatedCollectionType ? " - $translatedCollectionType" : '');
            
            $return = array(
                'menu' => array(
                    null,
                    $summaryLabel
                ),
                'title' => array(
                    null,
                    __('collection') . ' : ' . $summaryLabel
                ),
                'structure alias' => 'view_collection',
                'data' => $collectionData
            );
            
            $consentStatus = $this->getUnconsentedParticipantCollections(array(
                'data' => $collectionData
            ));
            if (! empty($consentStatus)) {
                if (! $collectionData['ViewCollection']['participant_id']) {
                    AppController::addWarningMsg(__('no participant is linked to the current participant collection'));
                } elseif ($consentStatus[$variables['Collection.id']] == null) {
                    $link = '';
                    if (AppController::checkLinkPermission('/ClinicalAnnotation/ClinicalCollectionLinks/detail/')) {
                        $link = sprintf(' <a href="%sClinicalAnnotation/ClinicalCollectionLinks/detail/%d/%d">%s</a>', AppController::getInstance()->request->webroot, $collectionData['ViewCollection']['participant_id'], $collectionData['ViewCollection']['collection_id'], __('click here to access it'));
                    }
                    AppController::addWarningMsg(__('no consent is linked to the current participant collection') . '.' . $link);
                } else {
                    AppController::addWarningMsg(__('the linked consent status is [%s]', __($consentStatus[$variables['Collection.id']])));
                }
            }
        }
        
        return $return;
    }
}