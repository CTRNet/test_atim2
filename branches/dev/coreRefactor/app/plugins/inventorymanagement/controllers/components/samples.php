<?php

class SamplesComponent extends Object {
	
	function initialize(&$controller, $settings=array()) {
		$this->controller =& $controller;
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
	
	function buildCollectionContentForTreeView($collection_id, $studied_specimen_sample_control_id = null) {
		//TODO: OPTIMIZE ME, I AM SLOW
		// Search collection content to display		
		$criteria = array();
		if($studied_specimen_sample_control_id) { 
			// Limit display to specific specimen type plus derivative
			$specimen_criteria['SampleMaster.sample_control_id'] = $studied_specimen_sample_control_id; 
			$specimen_criteria['SampleMaster.collection_id'] = $collection_id;
			$studied_collection_specimens = $this->controller->SampleMaster->atim_list(array('conditions' => $specimen_criteria, 'recursive' => '-1'));
			if(empty($studied_collection_specimens)) { return array(); }
			$criteria['SampleMaster.initial_specimen_sample_id'] = array_keys($studied_collection_specimens);	
		}
		$criteria['SampleMaster.collection_id'] = $collection_id;
		$this->controller->SampleMaster->contain(array('SampleControl', 'SpecimenDetail', 'DerivativeDetail', 'AliquotMaster' => array('AliquotControl', 'StorageMaster')));
		$collection_content_to_display = $this->controller->SampleMaster->find('threaded', array('conditions' => $criteria, 'order' => 'SampleMaster.sample_type DESC, SampleMaster.sample_code DESC', 'recursive' => '3'));
		if(empty($collection_content_to_display)) { return array(); }
		
		// Build formatted collection data for tree view
		return $this->completeCollectionContentForTreeView($collection_content_to_display);
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
	
	function completeCollectionContentForTreeView($children_list) {
		
		$formatted_children_data = array();
		
		foreach($children_list as $key => $new_sample) {
			$formatted_sample_data = array();
			$formatted_sample_data['SampleMaster'] = $new_sample['SampleMaster'];
			if($new_sample['SampleMaster']['sample_type'] == "blood"){
				$formatted_sample_data['SampleMaster']['sample_type'] = __("blood", true)." (".__($new_sample['SampleDetail']['blood_type'], true).")"; 
			}else if($new_sample['SampleMaster']['sample_type'] == "tissue"){
				$formatted_sample_data['SampleMaster']['sample_type'] = __("tissue", true)." (".__($new_sample['SampleDetail']['tissue_source'], true).")";
			}
			$formatted_sample_data['children'] = $this->completeCollectionContentForTreeView($new_sample['children']);
			
			// Add Aliquot
			$new_sample_aliquots = $new_sample['AliquotMaster'];
			$new_sample_aliquots= array_reverse($new_sample_aliquots);
			foreach($new_sample_aliquots as $new_aliquot) {
				if($new_aliquot['aliquot_type'] == "block"){
					$aliquot = $this->controller->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.id' => $new_aliquot['id'])));
					$new_aliquot['aliquot_type'] = __("block", true)." (".__($aliquot['AliquotDetail']['block_type'], true).")";
				}
				$aliquot_control_data = $new_aliquot['AliquotControl'];
				unset($new_aliquot['AliquotControl']);
				$storage_master_data = $new_aliquot['StorageMaster'];
				unset($new_aliquot['StorageMaster']);
				$formatted_aliquot_data = array(
					'AliquotMaster' => $new_aliquot, 
					'StorageMaster' => $storage_master_data);
				array_unshift($formatted_sample_data['children'], $formatted_aliquot_data);
			}			
			
			$children_list[$key] = $formatted_sample_data;
		}
		
		return $children_list;
	}
}

?>