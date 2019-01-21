<?php

class ViewCollectionCustom extends ViewCollection
{

    var $name = 'ViewCollection';

    var $useTable = 'view_collections';

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
Collection.gld_pre_post_surgery,
Collection.gld_pre_post_chemo,
Collection.gld_pre_post_radio,
Collection.gld_pre_post_immuno,
		Collection.created AS created
		FROM collections AS Collection
		LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted <> 1
		WHERE Collection.deleted <> 1 %%WHERE%%';

    public function summary($variables = array())
    {
        $return = parent::summary($variables);
        
        if (isset($variables['Collection.id'])) {
            $collectionData = $this->find('first', array(
                'conditions' => array(
                    'ViewCollection.collection_id' => $variables['Collection.id']
                ),
                'recursive' => - 1
            ));
            
            $collectionDatetimeAcc = $collectionData['ViewCollection']['collection_datetime_accuracy'];
            $length = 10;
            switch ($collectionDatetimeAcc) {
                case 'y':
                case 'm':
                    $length = 4;
                    break;
                    $length = 7;
                case 'd':
                    break;
            }
            $title = (strlen($collectionData['ViewCollection']['participant_identifier']) ? 
                $collectionData['ViewCollection']['participant_identifier'] : '?') . 
                ' / ' . 
                (strlen($collectionData['ViewCollection']['collection_datetime']) ? substr($collectionData['ViewCollection']['collection_datetime'], 0, $length) : '?');
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
}