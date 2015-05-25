<?php
class ViewCollectionCustom extends ViewCollection{
	
	var $name = 'ViewCollection';
	
	static $table_query = "
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
--		Collection.acquisition_label AS acquisition_label,
CAST(CONCAT(SUBSTR(MiscIdentifierControl.misc_identifier_name, 7),'-',
IF(Collection.qcroc_collection_type = 'B', 'B', ''),IFNULL(IF(Collection.qcroc_collection_visit = '', '?', Collection.qcroc_collection_visit), '?'),'-',
IFNULL(LPAD(MiscIdentifier.identifier_value, IF(Collection.qcroc_collection_type = 'B', 2, 3), '0'), '?')) AS char(30)) AS acquisition_label,			
		Collection.collection_site AS collection_site,
		Collection.collection_datetime AS collection_datetime,
		Collection.collection_datetime_accuracy AS collection_datetime_accuracy,
		Collection.collection_property AS collection_property,
		Collection.collection_notes AS collection_notes,
		Collection.created AS created,
MiscIdentifier.identifier_value,
Collection.qcroc_misc_identifier_control_id,
Collection.qcroc_collection_type,
Collection.qcroc_collection_visit
		FROM collections AS Collection
		LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted <> 1
LEFT JOIN misc_identifiers AS MiscIdentifier on MiscIdentifier.misc_identifier_control_id = Collection.qcroc_misc_identifier_control_id AND MiscIdentifier.participant_id = Collection.participant_id AND MiscIdentifier.deleted <> 1
LEFT JOIN misc_identifier_controls AS MiscIdentifierControl on MiscIdentifierControl.id = Collection.qcroc_misc_identifier_control_id
		WHERE Collection.deleted <> 1 %%WHERE%%";
	
	function summary($variables=array()) {
		$return = false;
	
		if(isset($variables['Collection.id'])) {
			$collection_data = $this->find('first', array('conditions'=>array('ViewCollection.collection_id' => $variables['Collection.id']), 'recursive' => '-1'));
			$this->Collection = AppModel::getInstance("InventoryManagement", "Collection", true);
			$qcroc_project_number = array_shift($this->Collection->getQcrocCollectionProjectNumbers($collection_data['ViewCollection']['qcroc_misc_identifier_control_id']));
			
			//Build Title
			$title = $qcroc_project_number.
				'-'.$collection_data['ViewCollection']['qcroc_collection_type'].
				($collection_data['ViewCollection']['qcroc_collection_visit']? $collection_data['ViewCollection']['qcroc_collection_visit'] : '?').
				'-'.($collection_data['ViewCollection']['identifier_value']? $collection_data['ViewCollection']['identifier_value'] : '?');
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