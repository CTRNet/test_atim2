<?php

class ViewCollectionCustom extends ViewCollection{
	
	var $name = 'ViewCollection';
	
	static $table_query = '
		SELECT
		Collection.id AS collection_id,
--		Collection.bank_id AS bank_id,
		Collection.sop_master_id AS sop_master_id,
		Collection.participant_id AS participant_id,
		Collection.diagnosis_master_id AS diagnosis_master_id,
		Collection.consent_master_id AS consent_master_id,
		Collection.treatment_master_id AS treatment_master_id,
		Collection.event_master_id AS event_master_id,
		Participant.participant_identifier AS participant_identifier,
		Collection.acquisition_label AS acquisition_label,
		Collection.collection_site AS collection_site,
--		Collection.collection_datetime AS collection_datetime,
--		Collection.collection_datetime_accuracy AS collection_datetime_accuracy,
		Collection.collection_property AS collection_property,
		Collection.collection_notes AS collection_notes,
		Collection.created AS created,

MiscIdentifier.misc_identifier_control_id AS qcroc_protocol_id,
MiscIdentifier.identifier_value AS qcroc_patient_no,
Collection.qcroc_collection_date AS qcroc_collection_date,
Collection.qcroc_collection_date_accuracy AS qcroc_collection_date_accuracy,

Collection.qcroc_sop_followed AS qcroc_sop_followed,
Collection.qcroc_sop_deviations AS qcroc_sop_deviations,

-- Blood
			
Collection.qcroc_banking_nbr AS qcroc_banking_nbr,

-- Biopsy
			
Collection.qcroc_biopsy_type AS qcroc_biopsy_type,
Collection.qcroc_radiologist AS qcroc_radiologist,
Collection.qcroc_coordinator AS qcroc_coordinator
			
		FROM collections AS Collection
		LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted <> 1
LEFT JOIN misc_identifiers AS MiscIdentifier ON MiscIdentifier.id = Collection.misc_identifier_id AND MiscIdentifier.deleted != 1	
		WHERE Collection.deleted <> 1 %%WHERE%%';	
		
	function summary($variables=array()) {
		$return = false;
		
		if(isset($variables['Collection.id'])) {
			$this->unbindModel(array('belongsTo' => array('Collection','Participant','DiagnosisMaster','ConsentMaster')));
			$this->bindModel(array('belongsTo' => array('MiscIdentifierControl' => array('className' => 'ClinicalAnnotation.MiscIdentifierControl', 'foreignKey' => 'qcroc_protocol_id'))));
			$collection_data = $this->find('first', array('conditions'=>array('ViewCollection.collection_id' => $variables['Collection.id'])));
			$patient_no = $collection_data['ViewCollection']['qcroc_banking_nbr']? $collection_data['MiscIdentifierControl']['misc_identifier_name'].'-'.$collection_data['ViewCollection']['qcroc_patient_no'] : 'n/a';		
			$return = array(
				'menu' => array(null, $patient_no . ' ' .$collection_data['ViewCollection']['qcroc_collection_date']),
				'title' => array(null, __('collection') . ' : ' . $patient_no),
				'structure alias' 	=> 'view_collection',
				'data'				=> $collection_data
			);
		}
		
		return $return;
	}
	
	function  getSitesAndHDQStaff() {
		$result = array();
	
		$lang = Configure::read('Config.language') == "eng" ? "en" : "fr";
	
		$StructurePermissibleValuesCustom = AppModel::getInstance('', 'StructurePermissibleValuesCustom', true);
		$all_values = $StructurePermissibleValuesCustom->find('all', array('conditions' => array('StructurePermissibleValuesCustomControl.name' => array('Staff : Sites', 'Staff : HDQ'))));
		foreach($all_values as $new_value) $result[$new_value['StructurePermissibleValuesCustom']['value']] = strlen($new_value['StructurePermissibleValuesCustom'][$lang])? $new_value['StructurePermissibleValuesCustom'][$lang] : $new_value['StructurePermissibleValuesCustom']['value'];
	
		asort($result);
		return $result;
	}
	
	function  getLaboratoryStaff() {
		$result = array();
	
		$lang = Configure::read('Config.language') == "eng" ? "en" : "fr";
	
		$StructurePermissibleValuesCustom = AppModel::getInstance('', 'StructurePermissibleValuesCustom', true);
		$all_values = $StructurePermissibleValuesCustom->find('all', array('conditions' => array('StructurePermissibleValuesCustomControl.name' => array('Staff : JGH', 'Staff : HDQ'))));
		foreach($all_values as $new_value) $result[$new_value['StructurePermissibleValuesCustom']['value']] = strlen($new_value['StructurePermissibleValuesCustom'][$lang])? $new_value['StructurePermissibleValuesCustom'][$lang] : $new_value['StructurePermissibleValuesCustom']['value'];
	
		asort($result);
		return $result;
	}
	
	function  getSitesAndLaboratoryStaff() {
		$result = array();
	
		$lang = Configure::read('Config.language') == "eng" ? "en" : "fr";
	
		$StructurePermissibleValuesCustom = AppModel::getInstance('', 'StructurePermissibleValuesCustom', true);
		$all_values = $StructurePermissibleValuesCustom->find('all', array('conditions' => array('StructurePermissibleValuesCustomControl.name' => array('Staff : JGH', 'Staff : Sites', 'Staff : HDQ'))));
		foreach($all_values as $new_value) $result[$new_value['StructurePermissibleValuesCustom']['value']] = strlen($new_value['StructurePermissibleValuesCustom'][$lang])? $new_value['StructurePermissibleValuesCustom'][$lang] : $new_value['StructurePermissibleValuesCustom']['value'];
	
		asort($result);
		return $result;
	}

}

