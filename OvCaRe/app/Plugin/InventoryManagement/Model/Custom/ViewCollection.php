<?php
class ViewCollectionCustom extends ViewCollection{
	
	var $name = 'ViewCollection';
	
	static $table_query = '
		SELECT
		Collection.id AS collection_id,
		Collection.bank_id AS bank_id,
		Collection.sop_master_id AS sop_master_id,
Collection.collection_voa_nbr,
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
Collection.ovcare_collection_type,
TreatmentDetail.path_num
		FROM collections AS Collection
		LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted <> 1
LEFT JOIN txd_surgeries as TreatmentDetail ON TreatmentDetail.treatment_master_id = Collection.treatment_master_id
		WHERE Collection.deleted <> 1 %%WHERE%%';
		
	function summary($variables=array()) {
		$return = false;
		
		if(isset($variables['Collection.id'])) {
			$collection_data = $this->find('first', array('conditions'=>array('ViewCollection.collection_id' => $variables['Collection.id'])));
			
			$title = '';
			if(empty($collection_data['ViewCollection']['participant_identifier'])) {
				$title = __('VOA#').': - [-]';
			} else {
				$title = __('VOA#').': '.(empty($collection_data['ViewCollection']['collection_voa_nbr'])? '-':$collection_data['ViewCollection']['collection_voa_nbr'])." [".$collection_data['ViewCollection']['participant_identifier']."]";
			}
			
			$participant_identifier = empty($collection_data['ViewCollection']['participant_identifier'])? 'n/a' : $collection_data['ViewCollection']['participant_identifier'];
			$return = array(
				'menu' => array(null, $title),
				'title' => array(null, $title),
				'structure alias' 	=> 'view_collection',
				'data'				=> $collection_data
			);
		}
		
		return $return;
	}
}
