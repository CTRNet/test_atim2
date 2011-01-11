<?php

class SampleMaster extends InventorymanagementAppModel {
	
	private static $parent_sample_dropdown = array();
	
	var $belongsTo = array(       
		'SampleControl' => array(           
			'className'    => 'Inventorymanagement.SampleControl',            
			'foreignKey'    => 'sample_control_id'),        
		'Collection' => array(           
			'className'    => 'Inventorymanagement.Collection',            
			'foreignKey'    => 'collection_id'));   

	var $hasOne = array(
		'SpecimenDetail' => array(
			'className'   => 'Inventorymanagement.SpecimenDetail',
			 	'foreignKey'  => 'sample_master_id',
			 	'dependent' => true),	 	
		'DerivativeDetail' => array(
			'className'   => 'Inventorymanagement.DerivativeDetail',
			 	'foreignKey'  => 'sample_master_id',
			 	'dependent' => true));
			 				
	var $hasMany = array(
		'AliquotMaster' => array(
			'className'   => 'Inventorymanagement.AliquotMaster',
			 	'foreignKey'  => 'sample_master_id'));  
	
	function specimenSummary($variables=array()) {
		$return = false;
		
		if (isset($variables['Collection.id']) && isset($variables['SampleMaster.initial_specimen_sample_id'])) {
			// Get specimen data
			$criteria = array(
				'SampleMaster.collection_id' => $variables['Collection.id'],
				'SampleMaster.id' => $variables['SampleMaster.initial_specimen_sample_id']);
			$specimen_data = $this->find('first', array('conditions' => $criteria));
			
			// Set summary	 	
	 		$return = array(
				'menu'				=> array(null, __($specimen_data['SampleMaster']['sample_type'], true) . ' : ' . $specimen_data['SampleMaster']['sample_code']),
				'title' 			=> array(null, __($specimen_data['SampleMaster']['sample_type'], true) . ' : ' . $specimen_data['SampleMaster']['sample_code']),
				'data' 				=> $specimen_data,
	 			'structure alias' 	=> 'sample_masters_for_search_result'
			);
		}	
		
		return $return;
	}

	function derivativeSummary($variables=array()) {
		$return = false;
		
		if (isset($variables['Collection.id']) && isset($variables['SampleMaster.initial_specimen_sample_id']) && isset($variables['SampleMaster.id'])) {
			// Get derivative data
			$criteria = array(
				'SampleMaster.collection_id' => $variables['Collection.id'],
				'SampleMaster.id' => $variables['SampleMaster.id']);
			$derivative_data = $this->find('first', array('conditions' => $criteria));
				 	
			// Set summary	 	
	 		$return = array(
					'menu' 				=> array(null, __($derivative_data['SampleMaster']['sample_type'], true) . ' : ' . $derivative_data['SampleMaster']['sample_code']),
					'title' 			=> array(null, __($derivative_data['SampleMaster']['sample_type'], true) . ' : ' . $derivative_data['SampleMaster']['sample_code']),
					'data' 				=> $derivative_data,
	 				'structure alias' 	=> 'sample_masters_for_search_result'
			);
		}	
		
		return $return;
	}

	public function setParentSampleDropdown(array $dropdown){
		self::$parent_sample_dropdown = $dropdown;
	}
	
	public function getParentSampleDropdown(){
		
		return self::$parent_sample_dropdown;
	}
}

?>