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
			 	'foreignKey'  => 'sample_master_id'),	 	
		'DerivativeDetail' => array(
			'className'   => 'Inventorymanagement.DerivativeDetail',
			 	'foreignKey'  => 'sample_master_id'));
			 				
	var $hasMany = array(
		'AliquotMaster' => array(
			'className'   => 'Inventorymanagement.AliquotMaster',
			 	'foreignKey'  => 'sample_master_id'));  


	
	function summary($variables=array()) {
		$return = false;
		
		if(isset($variables['Collection.id'])) {
			
			$result = $this->find('first', array('conditions'=>array('SampleMaster.collection_id' => $variables['Collection.id'])));
			
			$filter_value = 'all content';
			if(isset($variables['filter_value'])) {
				$filter_value = __($variables['filter_value'], TRUE);
			}
				
			$return = array(
				'Summary' => array(
					'menu' => array(NULL, $filter_value),
					'title' => array(),
					
					'description'=> array()
				)
			);			
		}
		
		return $return;
	}


			 	 
//   var $actAs = array('MasterDetail');
	
//	function summary( $variables=array() ) {
//		$return = false;
//		
//		if ( isset($variables['SampleMaster.id']) ) {
//			
//			$result = $this->find('first', array('conditions'=>array('SampleMaster.id'=>$variables['SampleMaster.id'])));
//			
//			$return = array(
//				'Summary'	 => array(
//					'menu'     	=> array( NULL, $result['SampleMaster']['sample_code'] ),
//					'title'	  	=> array( NULL, $result['SampleMaster']['sample_code'] ),
//
//					'description' => array(
//						__('product code', TRUE)		=>  __($result['SampleMaster']['product code'], TRUE),
//						__('category', TRUE)			=>	__($result['SampleMaster']['sample_category'], TRUE),
//						__('type', TRUE)				=>	__($result['SampleMaster']['sample_type'], TRUE)
//					)
//				)
//			);
//		}
//		
//		return $return;
//	}
}

?>