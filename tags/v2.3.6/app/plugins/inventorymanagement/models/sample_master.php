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
		$aliquot_master = AppModel::getInstance("inventorymanagement", "AliquotMaster", true);
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
		// set lab_book_master_id to null by default to erase previous labbook in edit mode if required
		$data['DerivativeDetail']['lab_book_master_id'] = '';
		
		if(array_key_exists('lab_book_master_code', $data['DerivativeDetail']) && strlen($data['DerivativeDetail']['lab_book_master_code']) > 0){
			$result = $lab_book->syncData($data, $sync ? array('DerivativeDetail') : array(), $data['DerivativeDetail']['lab_book_master_code'], $lab_book_ctrl_id);
			if(is_numeric($result)){
				//went well, we have the lab book id as a result
				$data['DerivativeDetail']['lab_book_master_id'] = $result;
			}else{
				//error
				$msg = $result;
			}
		}else if((array_key_exists('sync_with_lab_book', $data['DerivativeDetail']) && $this->data['DerivativeDetail']['sync_with_lab_book']) || (isset($data[0]['sync_with_lab_book_now']) && $data[0]['sync_with_lab_book_now'])){
				$msg = __('to synchronize with a lab book, you need to define a lab book to use', true);
		}
		
		return $msg;
	}
	
	/**
	 * Create Sample code of a created sample. 
	 * 
	 * @param $sample_master_id Id of the created sample.
	 * @param $sample_master_data Array that contains sample master data of the created sample.
	 * @param $sample_control_data Array that contains sample control data of the created sample.
	 * 
	 * @return The sample code of the created sample.
	 * 
	 * @author N. Luc
	 * @since 2007-06-20
	 */
	function createCode($sample_master_id, $sample_master_data, $sample_control_data){	
		$sample_code = $sample_control_data['SampleControl']['sample_type_code'] . ' - '. $sample_master_id;		
		return $sample_code;		
	}

	/**
	 * Check if a sample can be deleted.
	 * 
	 * @param $sample_master_id Id of the studied sample.
	 * 
	 * @return Return results as array:
	 * 	['allow_deletion'] = true/false
	 * 	['msg'] = message to display when previous field equals false
	 * 
	 * @author N. Luc
	 * @since 2007-10-16
	 */
	function allowDeletion($sample_master_id){
		// Check sample has no chidlren	
		$returned_nbr = $this->find('count', array('conditions' => array('SampleMaster.parent_id' => $sample_master_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { 
			return array('allow_deletion' => false, 'msg' => 'derivative exists for the deleted sample'); 
		}
	
		// Check sample is not linked to aliquot
		$aliquot_master_model = AppModel::getInstance("Iventorymanagement", "AliquotMaster", true);	
		$returned_nbr = $aliquot_master_model->find('count', array('conditions' => array('AliquotMaster.sample_master_id' => $sample_master_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { 
			return array('allow_deletion' => false, 'msg' => 'aliquot exists for the deleted sample'); 
		}

		// Verify this sample has not been used.
		// Note: Not necessary because we can not delete a sample aliquot 
		// when this one has been used at least once.
		
		// Verify that no parent sample aliquot is attached to the sample list  
		// 'used aliquot' that allows to display all source aliquots used to create 
		// the studied sample.
		$source_aliquot_model = AppModel::getInstance("Inventorymanagement", "SourceAliquot", true);
		$returned_nbr = $source_aliquot_model->find('count', array('conditions' => array('SourceAliquot.sample_master_id' => $sample_master_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { 
			return array('allow_deletion' => false, 'msg' => 'an aliquot of the parent sample is defined as source aliquot'); 
		}

		// Check sample is not linked to qc
		$quality_ctrl_model = AppModel::getInstance("Inventorymanagement", "QualityCtrl", true);	
		$returned_nbr = $quality_ctrl_model->find('count', array('conditions' => array('QualityCtrl.sample_master_id' => $sample_master_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { 
			return array('allow_deletion' => false, 'msg' => 'quality control exists for the deleted sample'); 
		}

		// Check sample has not been linked to review	
		$specimen_review_master_model = AppModel::getInstance("Inventorymanagement", "SpecimenReviewMaster", true);
		$returned_nbr = $specimen_review_master_model->find('count', array('conditions' => array('SpecimenReviewMaster.sample_master_id' => $sample_master_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { 
			return array('allow_deletion' => false, 'msg' => 'review exists for the deleted sample'); 
		}

		return array('allow_deletion' => true, 'msg' => '');
	}
	
	/**
	 * Format parent sample data array for display.
	 * 
	 * @param $parent_sample_data Parent sample data
	 * 
	 * @return Parent sample list into array having following structure: 
	 * 	array($parent_sample_master_id => $sample_title_built_by_function)
	 *
	 * @author N. Luc
	 * @since 2009-09-11
	 */	
	function formatParentSampleDataForDisplay($parent_sample_data) {
		$formatted_data = array();
		if(!empty($parent_sample_data) && isset($parent_sample_data['SampleMaster'])) {
			$formatted_data[$parent_sample_data['SampleMaster']['id']] = $parent_sample_data['SampleMaster']['sample_code'] . ' [' . __($parent_sample_data['SampleMaster']['sample_type'], TRUE) . ']';
		}
		
		return $formatted_data;
	}
}

?>