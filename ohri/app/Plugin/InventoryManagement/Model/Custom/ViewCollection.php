<?php

class ViewCollectionCustom extends ViewCollection
{

    var $useTable = 'view_collections';

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
            
            $collectionTitle = __('unlinked');
            if (! empty($collectionData['ViewCollection']['participant_identifier'])) {
                $collectionTitle = empty($collectionData['ViewCollection']['misc_identifier_value']) ? '-' : $collectionData['ViewCollection']['misc_identifier_value'];
                $collectionTitle .= ' ( ' . __('ATiM#') . ' ' . $collectionData['ViewCollection']['participant_identifier'] . ')';
            }
            if (! empty($collectionData['ViewCollection']['collection_datetime'])) {
                $formattedCollectionDate = substr($collectionData['ViewCollection']['collection_datetime'], 0, strpos($collectionData['ViewCollection']['collection_datetime'], ' '));
                switch ($collectionData['ViewCollection']['collection_datetime_accuracy']) {
                    case 'y':
                        $formattedCollectionDate = '+/-' . substr($formattedCollectionDate, 0, strpos($formattedCollectionDate, '-'));
                        break;
                    case 'm':
                        $formattedCollectionDate = substr($formattedCollectionDate, 0, strpos($formattedCollectionDate, '-'));
                        break;
                    case 'd':
                        $formattedCollectionDate = substr($formattedCollectionDate, 0, strrpos($formattedCollectionDate, '-'));
                        break;
                    default:
                }
                $collectionTitle .= ' : ' . $formattedCollectionDate;
            }
            
            $return = array(
                'menu' => array(
                    null,
                    $collectionTitle
                ),
                'title' => array(
                    null,
                    __('collection') . ' : ' . $collectionTitle
                ),
                'structure alias' => 'view_collection',
                'data' => $collectionData
            );
            
            $consentStatus = $this->getUnconsentedParticipantCollections(array(
                'data' => $collectionData
            ));
            if (! empty($consentStatus)) {
                if ($consentStatus[$variables['Collection.id']] == null) {
                    AppController::addWarningMsg(__('no consent is linked to the current participant collection'));
                } else {
                    AppController::addWarningMsg(__('the linked consent status is [%s]', $consentStatus[$variables['Collection.id']], true));
                }
            }
        }
        
        return $return;
    }
}