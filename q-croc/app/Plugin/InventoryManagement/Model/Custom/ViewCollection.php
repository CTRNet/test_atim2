<?php

class ViewCollectionCustom extends ViewCollection{
	
	var $name = 'ViewCollection';
	
	static $table_query = '
		SELECT
		Collection.id AS collection_id,
--	Collection.bank_id AS bank_id,
		Collection.sop_master_id AS sop_master_id,
Collection.qcroc_sop_followed AS qcroc_sop_followed,
Collection.qcroc_sop_deviations AS qcroc_sop_deviations,
		Collection.participant_id AS participant_id,
		Collection.diagnosis_master_id AS diagnosis_master_id,
		Collection.consent_master_id AS consent_master_id,
		Collection.treatment_master_id AS treatment_master_id,
		Collection.event_master_id AS event_master_id,
		Participant.participant_identifier AS participant_identifier,
Participant.qcroc_initials AS qcroc_initials,
		Collection.acquisition_label AS acquisition_label,
		Collection.collection_site AS collection_site,
--	Collection.collection_datetime AS collection_datetime,
--	Collection.collection_datetime_accuracy AS collection_datetime_accuracy,
Collection.qcroc_prior_to_chemo AS qcroc_prior_to_chemo,
		Collection.collection_property AS collection_property,
		Collection.collection_notes AS collection_notes,
		Collection.created AS created,
		
Collection.qcroc_protocol AS qcroc_protocol,
TreatmentMaster.qcroc_biopsy_type AS qcroc_biopsy_type,
TreatmentMaster.qcroc_cycle AS qcroc_cycle,

Collection.qcroc_collection_date AS qcroc_collection_date	
	
		FROM collections AS Collection
		LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted <> 1
LEFT JOIN treatment_masters AS TreatmentMaster ON Collection.treatment_master_id = TreatmentMaster.id AND TreatmentMaster.deleted <> 1
	
		WHERE Collection.deleted <> 1 %%WHERE%%';	
		
	function summary($variables=array()) {
		$return = false;
		
		if(isset($variables['Collection.id'])) {
			$collection_data = $this->find('first', array('conditions'=>array('ViewCollection.collection_id' => $variables['Collection.id'])));
			
			$return = array(
				'menu' => array(null, $collection_data['ViewCollection']['participant_identifier'] . ' ' .$collection_data['ViewCollection']['qcroc_collection_date']),
				'title' => array(null, __('collection') . ' : ' . $collection_data['ViewCollection']['participant_identifier']),
				'structure alias' 	=> 'view_collection',
				'data'				=> $collection_data
			);
		}
		
		return $return;
	}

}

