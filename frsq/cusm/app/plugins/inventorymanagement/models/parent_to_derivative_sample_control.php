<?php

class ParentToDerivativeSampleControl extends InventoryManagementAppModel {
	
	var $belongsTo = array(
		'ParentSampleControl' => array(
			'className'   => 'Inventorymanagement.SampleControl',
			 'foreignKey'  => 'parent_sample_control_id'),
		'DerivativeControl' => array(
			'className'   => 'Inventorymanagement.SampleControl',
			 'foreignKey'  => 'derivative_sample_control_id'));  	
	
	function getActiveSamples(){
		$data = $this->find('all', array('conditions' => array('flag_active' => 1), 'recursive' => -1));
		$relations = array();
		//arrange the data
		foreach($data as $unit){
			$key = $unit["ParentToDerivativeSampleControl"]["parent_sample_control_id"];
			$value = $unit["ParentToDerivativeSampleControl"]["derivative_sample_control_id"];
			if(!isset($relations[$key])){
				$relations[$key] = array();
			}
			$relations[$key][] = $value;
		}
		
		//start from the top and find the active samples
		return self::getActiveIdsFromRelations($relations, "");
	}
	
	private static function getActiveIdsFromRelations($relations, $current_check){
		$active_ids = array();
		foreach($relations[$current_check] as $sample_id){
			if($current_check != $sample_id){
				$active_ids[] = $sample_id;
				if(isset($relations[$sample_id])){
					$active_ids = array_merge($active_ids, self::getActiveIdsFromRelations($relations, $sample_id));
				}
			}
		}
		return array_unique($active_ids);
	}
}

?>
