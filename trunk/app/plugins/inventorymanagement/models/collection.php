<?php

class Collection extends InventorymanagementAppModel {

	var $hasMany = array(
		'SampleMaster' => array(
			'className'   => 'Inventorymanagement.SampleMaster',
			 'foreignKey'  => 'collection_id'));  	

	function summary($variables=array()) {
		$return = false;
		
		if(isset($variables['Collection.id'])) {
			$this->bindModel(array('belongsTo' => array('Bank' => array('className' => 'Administrates.Bank', 'foreignKey' => 'bank_id'))));	
			$result = $this->find('first', array('conditions'=>array('Collection.id'=>$variables['Collection.id'])));
			
			$return = array(
				'Summary' => array(
					'menu' => array(null, $result['Collection']['acquisition_label']),
					'title' => array(null, $result['Collection']['acquisition_label']),
					
					'description'=> array(
						__('collection bank', true) => $result['Bank']['name'],
						__('collection datetime', true) => $result['Collection']['collection_datetime'],
						__('Reception Date', true) 		 => $result['Collection']['reception_datetime']
					)
				)
			);			
		}
		
		return $return;
	}
	
	function contentFilterSummary($variables=array()) {
		$return = false;
			
		if(array_key_exists('filter_value', $variables) && (!array_key_exists('SampleMaster.initial_specimen_sample_id', $variables))) {
			$filter_value = (empty($variables['filter_value']))? 'all content': $variables['filter_value'];
					
			$return = array(
				'Summary' => array(
					'menu' => array(null, __($filter_value, true),
					'title' => false,
					'description'=> false)));	
		}
		
		return $return;
	}
	
}

?>
