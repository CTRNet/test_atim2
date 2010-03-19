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
						__('collection site', true) => __($collection_data['Collection']['collection_site'], true)
					)
				)
			);			
		}
		
		return $return;
	}
	
}

?>
