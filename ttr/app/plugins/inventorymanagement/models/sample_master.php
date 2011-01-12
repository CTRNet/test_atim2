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
	 * Will build formatted data gathering collection content for tree view.
	 * 
	 * @param $collection_id Id of the studied collection.
	 * @param $studied_specimen_sample_control_id Sample control id of the studied specimen type
	 * the user defined to realize a filter on products included into the collection tree view.
	 * (Ex: Just blood collection specimens and all their derivatives).
	 * 
	 * @return The completed nested array
	 * 
	 * @author N. Luc
	 * @since 2009-09-13
	 */
	
	function buildCollectionContentForTreeView($collection_id, $display_aliquots, $studied_specimen_sample_control_id = null) {
		// Search collection content to display		
		$criteria = array();
		if($studied_specimen_sample_control_id) { 
			// Limit display to specific specimen type plus derivative
			$specimen_criteria['SampleMaster.sample_control_id'] = $studied_specimen_sample_control_id; 
			$specimen_criteria['SampleMaster.collection_id'] = $collection_id;
			$studied_collection_specimens = $this->atim_list(array('conditions' => $specimen_criteria, 'recursive' => '-1'));
			if(empty($studied_collection_specimens)) { return array(); }
			$criteria['SampleMaster.initial_specimen_sample_id'] = array_keys($studied_collection_specimens);	
		}
		$criteria['SampleMaster.collection_id'] = $collection_id;
		if($display_aliquots) {
			$this->contain(array('SampleControl', 'SpecimenDetail', 'DerivativeDetail', 'AliquotMaster' => array('AliquotControl', 'StorageMaster')));
		} else {
			$this->contain(array('SampleControl', 'SpecimenDetail', 'DerivativeDetail'));
		}
		$collection_content_to_display = $this->find('threaded', array('conditions' => $criteria, 'order' => 'SampleMaster.sample_type DESC, SampleMaster.sample_code DESC', 'recursive' => '3'));
		if(empty($collection_content_to_display)) {
			return array(); 
		}
		
		// Load model
		if(self::$aliquot_master_model == null){
			self::$aliquot_master_model = AppModel::atimNew("Inventorymanagement", "AliquotMaster", true);
		}
				
		// Build formatted collection data for tree view
		return $this->completeCollectionContentForTreeView($collection_content_to_display, $display_aliquots);
	}
	
	/**
	 * Parsing a nested array gathering collection samples, the funtion will add
	 * aliquots records for each sample.
	 * 
	 * @param $children_list Nested array gathering collection samples.
	 * 
	 * @return The completed nested array
	 * 
	 * @author N. Luc
	 * @since 2009-09-13
	 */
	
	function completeCollectionContentForTreeView($children_list, $display_aliquots) {
		$formatted_children_data = array();
		
		foreach($children_list as $key => $new_sample){
			$formatted_sample_data = array();
			$formatted_sample_data['SampleMaster'] = $new_sample['SampleMaster'];
			if($new_sample['SampleMaster']['sample_type'] == "blood"){
				$formatted_sample_data['0']['detail_type'] = __($new_sample['SampleDetail']['blood_type'], true); 
			}else if($new_sample['SampleMaster']['sample_type'] == "tissue"){
				$formatted_sample_data['0']['detail_type'] = __($new_sample['SampleDetail']['tissue_source'], true);
			}
			$formatted_sample_data['children'] = $this->completeCollectionContentForTreeView($new_sample['children'], $display_aliquots);
			
			// Add Aliquot
			if($display_aliquots) {
				$new_sample_aliquots = $new_sample['AliquotMaster'];
				$new_sample_aliquots = array_reverse($new_sample_aliquots);
				foreach($new_sample_aliquots as $new_aliquot) {
					$aliquot_control_data = $new_aliquot['AliquotControl'];
					unset($new_aliquot['AliquotControl']);
					$storage_master_data = $new_aliquot['StorageMaster'];
					unset($new_aliquot['StorageMaster']);
					$formatted_aliquot_data = array(
						'AliquotMaster' => $new_aliquot, 
						'StorageMaster' => $storage_master_data);
					if($new_aliquot['aliquot_type'] == "block"){
						$aliquot = self::$aliquot_master_model->find('first', array('conditions' => array('AliquotMaster.id' => $new_aliquot['id'])));
						$formatted_aliquot_data[0]['detail_type'] = __($aliquot['AliquotDetail']['block_type'], true);
					}
					array_unshift($formatted_sample_data['children'], $formatted_aliquot_data);
				}	
			}

			// Reset Data
			$children_list[$key] = $formatted_sample_data;
		}
		
		return $children_list;
	}
}

?>