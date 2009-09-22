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


	
	function generalSummary($variables=array()) {
		// To display tree view or list all sample menus
		$return = false;
		
		if(isset($variables['Collection.id'])) {
			if(!isset($variables['SampleMaster.id'])) {			
				// Set menu
				$filter_value = 'all content';
				if(isset($variables['filter_value'])) {
					$filter_value = __($variables['filter_value'], TRUE);
				}
				
				$return = array(
					'Summary' => array(
						'menu' => array(NULL, $filter_value),
						'title' => false,
						'description'=> false));	
		
			} else if (isset($variables['SampleMaster.initial_specimen_sample_id']) && ($variables['SampleMaster.id'] != $variables['SampleMaster.initial_specimen_sample_id'])) {
				// A specific sample is studied and this one is a derivative: Add Specimen information
				$criteria = array(
					'SampleMaster.collection_id'=>$variables['Collection.id'],
					'SampleMaster.id'=>$variables['SampleMaster.initial_specimen_sample_id']);
				$result = $this->find('first', array('conditions' => $criteria));
				
				$return = array(
					'Summary' => array(
						'menu' => false,
						'title' => array(NULL, __($result['SampleMaster']['sample_type'], TRUE) . ' : ' . $result['SampleMaster']['sample_code']),
						
						'description'=> array(
							__('category', TRUE) => __($result['SampleMaster']['sample_category'], TRUE),
							__('type', TRUE) => __($result['SampleMaster']['sample_type'], TRUE),
							__('sample code', TRUE) => $result['SampleMaster']['sample_code'])
					)
				);		
			}
		}
		
		return $return;
	}

	function sampleSummary($variables=array()) {
				$return = false;
				
		if (isset($variables['SampleMaster.id']) && isset($variables['Collection.id'])) {
			$criteria = array(
				'SampleMaster.collection_id' => $variables['Collection.id'],
				'SampleMaster.id' => $variables['SampleMaster.id']);
			$result = $this->find('first', array('conditions' => $criteria));
	 	
	 		$initial_specimen_sample_type = '';
	 		if($result['SampleMaster']['sample_category'] === 'derivative') {
	 			$initial_specimen_sample_type = __($result['SampleMaster']['initial_specimen_sample_type'], TRUE) . ' ';
	 		}
			
			$return = array(
				'Summary' => array(
					'menu' => array(NULL, $initial_specimen_sample_type . __($result['SampleMaster']['sample_type'], TRUE) . ' : ' . $result['SampleMaster']['sample_code']),
					'title' => array(NULL, __($result['SampleMaster']['sample_type'], TRUE) . ' : ' . $result['SampleMaster']['sample_code']),

					'description' => array(
						__('category', TRUE) => __($result['SampleMaster']['sample_category'], TRUE),
						__('type', TRUE) => __($result['SampleMaster']['sample_type'], TRUE),
						__('sample code', TRUE) => $result['SampleMaster']['sample_code']
						
					)
				)
			);
		}				
				
				
				$result = $this->find('first', array('conditions'=>array('SampleMaster.collection_id' => $variables['Collection.id'])));
			
			
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