<?php

class ViewCollectionCustom extends ViewCollection
{

    var $name = 'ViewCollection';

    // TODO: Kidney transplant customisation
    // Added Collection.chum_kidney_transp_collection_time to view.
    public static $tableQuery = "
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
-- 		Collection.acquisition_label AS acquisition_label,
		Collection.collection_site AS collection_site,
		Collection.collection_datetime AS collection_datetime,
		Collection.collection_datetime_accuracy AS collection_datetime_accuracy,
		Collection.collection_property AS collection_property,
		Collection.collection_notes AS collection_notes,
		Collection.created AS created,
CONCAT(IFNULL(MiscIdentifier.identifier_value, '?'), Collection.chum_kidney_transp_collection_part_type, Collection.chum_kidney_transp_collection_time) acquisition_label,
Bank.name AS bank_name,
MiscIdentifier.identifier_value AS identifier_value,
MiscIdentifierControl.misc_identifier_name AS identifier_name,
Collection.visit_label AS visit_label,
Collection.qc_nd_pathology_nbr,
Collection.chum_kidney_transp_collection_part_type,
Collection.chum_kidney_transp_collection_time
		FROM collections AS Collection
		LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted <> 1
LEFT JOIN banks As Bank ON Collection.bank_id = Bank.id AND Bank.deleted <> 1
LEFT JOIN misc_identifiers AS MiscIdentifier on MiscIdentifier.misc_identifier_control_id = Bank.misc_identifier_control_id AND MiscIdentifier.participant_id = Participant.id AND MiscIdentifier.deleted <> 1
LEFT JOIN misc_identifier_controls AS MiscIdentifierControl ON MiscIdentifier.misc_identifier_control_id=MiscIdentifierControl.id
    WHERE Collection.deleted <> 1 %%WHERE%%";

    /**
     *
     * @param array $variables
     * @return array|bool
     */
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
            
            $return = array(
                'menu' => array(
                    null,
                    $collectionData['ViewCollection']['acquisition_label']
                ),
                'title' => array(
                    null,
                    __('collection') . ' : ' . $collectionData['ViewCollection']['acquisition_label']
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
            if ($collectionData['ViewCollection']['participant_id']) {
                $participantModel = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
                $participantRisk = $participantModel->find('count', array(
                    'conditions' => array(
                        'Participant.chum_kidney_transp_vih' => 'y',
                        'Participant.id' => $collectionData['ViewCollection']['participant_id']
                    )
                ));
                if ($participantRisk) {
                    AppController::addWarningMsg(__('aliquots of the collection present a confirmed biological hazard'));
                }
            } else {
                AppController::addWarningMsg(__('no participant is linked to the collection - biological hazard can not be evaluated'));
            }
        }
        
        return $return;
    }
}