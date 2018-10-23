<?php
/** **********************************************************************
 * CHUM-BioTransit Project
 * ***********************************************************************
 *
 * InventoryManagement plugin custom code
 *
 * Class CollectionCustom
 * 
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-10-22
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
		Participant.participant_identifier AS participant_identifier,
		Collection.acquisition_label AS acquisition_label,
		Collection.collection_site AS collection_site,
		Collection.collection_datetime AS collection_datetime,
		Collection.collection_datetime_accuracy AS collection_datetime_accuracy,
		Collection.collection_property AS collection_property,
		Collection.collection_notes AS collection_notes,
		Collection.created AS created,
Collection.chum_biotransit_visit_nbr, 
Participant.chum_biotransit_institution,
Participant.chum_biotransit_participant_study_number,
StudySummary.title
		FROM collections AS Collection 
		LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted <> 1 
LEFT JOIN study_summaries AS StudySummary ON StudySummary.id = Participant.chum_biotransit_study_summary_id AND StudySummary.deleted <> 1 
		WHERE Collection.deleted <> 1 %%WHERE%%'; 
    
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
            $title = 
                (strlen($collectionData['ViewCollection']['chum_biotransit_participant_study_number']) ? $collectionData['ViewCollection']['chum_biotransit_participant_study_number'] : '?') 
                . ' - ' 
                . __('visit') 
                . ': ' 
                . (strlen($collectionData['ViewCollection']['chum_biotransit_visit_nbr']) ? $collectionData['ViewCollection']['chum_biotransit_visit_nbr'] : '?');
            
            $return = array(
                'menu' => array(
                    null,
                    $title
                ),
                'title' => array(
                    null,
                    $title
                ),
                'structure alias' => 'view_collection',
                'data' => $collectionData
            );
        }
        
        return $return;
    }
}