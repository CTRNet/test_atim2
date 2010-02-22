<?php

class Collection extends InventorymanagementAppModel {

	var $hasMany = array(
		'SampleMaster' => array(
			'className'   => 'Inventorymanagement.SampleMaster',
			 'foreignKey'  => 'collection_id')); 
			 
	var $hasOne = array(
		'ClinicalCollectionLink' => array(
			'className' => 'Clinicalannotation.ClinicalCollectionLink',
			'foreignKey' => 'collection_id',
			'dependent' => true));
	
	function summary($variables=array()) {
		$return = false;
		
		if(isset($variables['Collection.id'])) {
			$this->bindModel(array('belongsTo' => array('Bank' => array('className' => 'Administrates.Bank', 'foreignKey' => 'bank_id'))));	
			$collection_data = $this->find('first', array('conditions'=>array('Collection.id' => $variables['Collection.id'])));
			
			$return = array(
				'Summary' => array(
					'menu' => array('collection', $collection_data['Collection']['acquisition_label']),
					'title' => array(null, $collection_data['Collection']['acquisition_label']),
					
					'description'=> array(
						__('participant identifier', true) => $collection_data['Bank']['name'],
						__('collection bank', true) => $collection_data['Bank']['name'],
						__('collection datetime', true) => $collection_data['Collection']['collection_datetime'],
						__('collection site', true) => $collection_data['Collection']['collection_site']
					)
				)
			);			
		}
		
		return $return;
	}
	
	function contentFilterSummary($variables=array()) {
		$return = false;

		if(array_key_exists('FilterLevel', $variables) && ($variables['FilterLevel'] == 'collection')) {
			// User is working on collection content view: either tree view, collection samples list or collection aliquots list)

			// Build filter information
			$studied_sample_type = array_key_exists('SampleTypeForFilter', $variables)? $variables['SampleTypeForFilter']: '';
			$studied_aliquot_type = array_key_exists('AliquotTypeForFilter', $variables)? $variables['AliquotTypeForFilter']: '';
			
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
