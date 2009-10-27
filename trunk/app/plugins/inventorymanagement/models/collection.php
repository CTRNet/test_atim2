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
			$collection_data = $this->find('first', array('conditions'=>array('Collection.id' => $variables['Collection.id'])));
			
			$return = array(
				'Summary' => array(
					'menu' => array(null, $collection_data['Collection']['acquisition_label']),
					'title' => array(null, $collection_data['Collection']['acquisition_label']),
					
					'description'=> array(
						__('collection bank', true) => $collection_data['Bank']['name'],
						__('collection datetime', true) => $collection_data['Collection']['collection_datetime'],
						__('Reception Date', true) => $collection_data['Collection']['reception_datetime']
					)
				)
			);			
		}
		
		return $return;
	}
	
	function contentFilterSummary($variables=array()) {
		$return = false;

		if(!array_key_exists('SampleMaster.id', $variables)) {
			// User is working on collection content view: either tree view, collection samples list or collection aliquots list)

			// Build filter information
			$studied_sample_type = array_key_exists('sample_type_for_filter', $variables)? $variables['sample_type_for_filter']: '';
			$studied_aliquot_type = array_key_exists('aliquot_type_for_filter', $variables)? $variables['aliquot_type_for_filter']: '';
			
			$filter_data = empty($studied_sample_type)? '': __($studied_sample_type, true);
			$filter_data .= empty($filter_data)? '': ' ';
			$filter_data .= empty($studied_aliquot_type)? '': __($studied_aliquot_type, true);
			$filter_data = empty($filter_data)? __('all content', true): $filter_data;

			// Set summary						
			$return = array(
				'Summary' => array(
					'menu' => array(null, $filter_data,
					'title' => false,
					'description'=> false)));	
		}
		
		return $return;
	}
	
}

?>
