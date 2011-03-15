<?php

class SampleMaster extends InventorymanagementAppModel {
	
	public static $derivatives_dropdown = array();
	
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

	public static $aliquot_master_model = null;
		
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

	public function getParentSampleDropdown(){
		return array();
	}
	
	public function getDerivativesDropdown(){
		return self::$derivatives_dropdown;
	}
	
	/**
	 * @param array $sample_master_ids The sample master ids whom child existence will be verified
	 * @return array The sample master ids having a child
	 */
	function hasChild(array $sample_master_ids){
		//fetch the sample ids having samples as child
		$result = array_filter($this->find('list', array('fields' => array("SampleMaster.parent_id"), 'conditions' => array('SampleMaster.parent_id' => $sample_master_ids), 'group' => array('SampleMaster.parent_id'))));
		
		//fetch the aliquots ids having the remaining samples as parent
		//we can fetch the realiquots too because they imply the presence of a direct child
		$sample_master_ids = array_diff($sample_master_ids, $result);
		$aliquot_master = AppModel::atimNew("inventorymanagement", "AliquotMaster", true);
		return array_merge($result, array_filter($aliquot_master->find('list', array('fields' => array('AliquotMaster.sample_master_id'), 'conditions' => array('AliquotMaster.sample_master_id' => $sample_master_ids), 'group' => array('AliquotMaster.sample_master_id')))));
		
	}
	
	/**
	 * Validates a lab book. Update the lab_book_master_id if it's ok.
	 * @param array $data The data to work with
	 * @param LabBookMaster $lab_book Any LabBookMaster object (it's assumed the caller is already using one)
	 * @param int $lab_book_ctrl_id The lab_book_ctrl_id that is allowed
	 * @param boolean $sync If true, will synch with the lab book when it's valid
	 * @return An empty string on success, an error string on failure.
	 */
	function validateLabBook(array &$data, $lab_book, $lab_book_ctrl_id, $sync){
		$msg = "";
		if(strlen($data['DerivativeDetail']['lab_book_master_code']) > 0){
			$result = $lab_book->syncData($data, $sync ? array('DerivativeDetail') : array(), $data['DerivativeDetail']['lab_book_master_code'], $lab_book_ctrl_id);
			if(is_numeric($result)){
				//went well, we have the lab book id as a result
				$data['DerivativeDetail']['lab_book_master_id'] = $result;
			}else{
				//error
				$msg = $result;
			}
		}else if($this->data['DerivativeDetail']['sync_with_lab_book'] || (isset($data[0]) && isset($data[0]['sync_with_lab_book_now']) && $data[0]['sync_with_lab_book_now'])){
				$msg = __('to synchronize with a lab book, you need to define a lab book to use', true);
		}
		return $msg;
	}
}

?>