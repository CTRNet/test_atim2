<?php

class ViewCollectionCustom extends ViewCollection
{

    var $name = 'ViewCollection';

    var $belongsTo = array(
        'Collection' => array(
            'className' => 'InventoryManagement.Collection',
            'foreignKey' => 'collection_id',
            'type' => 'INNER'
        ),
        'Participant' => array(
            'className' => 'ClinicalAnnotation.Participant',
            'foreignKey' => 'participant_id'
        ),
        'DiagnosisMaster' => array(
            'className' => 'ClinicalAnnotation.DiagnosisMaster',
            'foreignKey' => 'diagnosis_master_id'
        ),
        'ConsentMaster' => array(
            'className' => 'ClinicalAnnotation.ConsentMaster',
            'foreignKey' => 'consent_master_id'
        ),
        'MiscIdentifier' => array(
            'className' => 'ClinicalAnnotation.MiscIdentifier',
            'foreignKey' => 'misc_identifier_id'
        )
    );

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
Collection.misc_identifier_id AS misc_identifier_id,
		Collection.collection_protocol_id AS collection_protocol_id,
		Participant.participant_identifier AS participant_identifier,
		Collection.acquisition_label AS acquisition_label,
		Collection.collection_site AS collection_site,
		Collection.collection_datetime AS collection_datetime,
		Collection.collection_datetime_accuracy AS collection_datetime_accuracy,
		Collection.collection_property AS collection_property,
		Collection.collection_notes AS collection_notes,
		Collection.created AS created,
Collection.qc_lady_follow_up AS qc_lady_follow_up,
Collection.qc_lady_pre_op AS qc_lady_pre_op,
Collection.qc_lady_banking_nbr AS qc_lady_banking_nbr,
Collection.qc_lady_visit AS qc_lady_visit,
Collection.qc_lady_specimen_type AS qc_lady_specimen_type,
Collection.qc_lady_specimen_type_precision AS qc_lady_specimen_type_precision,
Collection.qc_lady_sop_followed AS qc_lady_sop_followed,
Collection.qc_lady_sop_deviations AS qc_lady_sop_deviations,
MiscIdentifier.identifier_value AS misc_identifier_value
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
                )
            ));
            $label = (empty($collectionData['ViewCollection']['participant_identifier']) ? '-' : $collectionData['ViewCollection']['participant_identifier']) . ' ' . substr($collectionData['ViewCollection']['collection_datetime'], 0, strpos($collectionData['ViewCollection']['collection_datetime'], ' '));
            
            $return = array(
                'menu' => array(
                    null,
                    $label
                ),
                'title' => array(
                    null,
                    __('collection') . ' : ' . $label
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