<?php

class SampleMaster extends InventorymanagementAppModel {
	
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
		
		if (isset($variables['SampleMaster.initial_specimen_sample_id']) && isset($variables['Collection.id'])) {
			$criteria = array(
				'SampleMaster.collection_id' => $variables['Collection.id'],
				'SampleMaster.id' => $variables['SampleMaster.initial_specimen_sample_id']);
			$result = $this->find('first', array('conditions' => $criteria));
	 	
	 		$return = array(
				'Summary' => array(
					'menu' => array(null, __($result['SampleMaster']['sample_type'], true) . ' : ' . $result['SampleMaster']['sample_code']),
					'title' => array(null, __($result['SampleMaster']['sample_type'], true) . ' : ' . $result['SampleMaster']['sample_code']),

					'description' => array(
						__('type', true) => __($result['SampleMaster']['sample_type'], true),
						__('sample code', true) => $result['SampleMaster']['sample_code'],
						__('category', true) => __($result['SampleMaster']['sample_category'], true)
					)
				)
			);
		}	
		
		return $return;
	}

	function derivativeSummary($variables=array()) {
		$return = false;
		
		if (isset($variables['SampleMaster.id']) && isset($variables['Collection.id'])) {
			$criteria = array(
				'SampleMaster.collection_id' => $variables['Collection.id'],
				'SampleMaster.id' => $variables['SampleMaster.id']);
			$result = $this->find('first', array('conditions' => $criteria));
	 	
	 		$return = array(
				'Summary' => array(
					'menu' => array(null, __($result['SampleMaster']['sample_type'], true) . ' : ' . $result['SampleMaster']['sample_code']),
					'title' => array(null, __($result['SampleMaster']['sample_type'], true) . ' : ' . $result['SampleMaster']['sample_code']),

					'description' => array(
						__('type', true) => __($result['SampleMaster']['sample_type'], true),
						__('sample code', true) => $result['SampleMaster']['sample_code'],
						__('category', true) => __($result['SampleMaster']['sample_category'], true),
						__('creation date', true) => $result['DerivativeDetail']['creation_datetime']
					)
				)
			);
		}	
		
		return $return;
	}
			 	 
//   var $actAs = array('MasterDetail');
	
//	function summary( $variables=array() ) {
//		$return = false;
//		

//		
//		return $return;
//	}


}

?>