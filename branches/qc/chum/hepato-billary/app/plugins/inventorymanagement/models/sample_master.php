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
		
		if (isset($variables['Collection.id']) && isset($variables['SampleMaster.initial_specimen_sample_id'])) {
			// Get specimen data
			$criteria = array(
				'SampleMaster.collection_id' => $variables['Collection.id'],
				'SampleMaster.id' => $variables['SampleMaster.initial_specimen_sample_id']);
			$specimen_data = $this->find('first', array('conditions' => $criteria));
			
			// Build filter information
			$filter_data = '';
			if(array_key_exists('FilterLevel', $variables) && ($variables['FilterLevel'] == 'sample') && isset($variables['SampleMaster.id']) 
			&& $variables['SampleMaster.initial_specimen_sample_id'] == $variables['SampleMaster.id']) {
				// User is working on specimen: Build filter value to add it to menu
				$studied_sample_type = array_key_exists('SampleTypeForFilter', $variables)? $variables['SampleTypeForFilter']: '';
				$studied_aliquot_type = array_key_exists('AliquotTypeForFilter', $variables)? $variables['AliquotTypeForFilter']: '';
				
				$filter_data = empty($studied_sample_type)? '': __($studied_sample_type, true);
				$filter_data .= empty($filter_data)? '': ' ';
				$filter_data .= empty($studied_aliquot_type)? '': __($studied_aliquot_type, true);
				$filter_data = empty($filter_data)? '': ' > ' . $filter_data;
			}

			// Set summary	 	
	 		$return = array(
				'Summary' => array(
					'menu' => array(null, __($specimen_data['SampleMaster']['sample_type'], true) . ' : ' . $specimen_data['SampleMaster']['sample_code'] . $filter_data),
					'title' => array(null, __($specimen_data['SampleMaster']['sample_type'], true) . ' : ' . $specimen_data['SampleMaster']['sample_code']),

					'description' => array(
						__('type', true) => __($specimen_data['SampleMaster']['sample_type'], true),
						__('sample code', true) => $specimen_data['SampleMaster']['sample_code'],
						__('category', true) => __($specimen_data['SampleMaster']['sample_category'], true)
					)
				)
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
				 	
			// Build filter information
			$filter_data = '';
			if(array_key_exists('FilterLevel', $variables) && ($variables['FilterLevel'] == 'sample') && $variables['SampleMaster.initial_specimen_sample_id'] != $variables['SampleMaster.id']) {
				// User is working on derivative: Build filter value to add it to menu
				$studied_sample_type = array_key_exists('SampleTypeForFilter', $variables)? $variables['SampleTypeForFilter']: '';
				$studied_aliquot_type = array_key_exists('AliquotTypeForFilter', $variables)? $variables['AliquotTypeForFilter']: '';
				
				$filter_data = empty($studied_sample_type)? '': __($studied_sample_type, true);
				$filter_data .= empty($filter_data)? '': ' ';
				$filter_data .= empty($studied_aliquot_type)? '': __($studied_aliquot_type, true);
				$filter_data = empty($filter_data)? '': ' > ' . $filter_data;
			}

			// Set summary	 	
	 		$return = array(
				'Summary' => array(
					'menu' => array(null, __($derivative_data['SampleMaster']['sample_type'], true) . ' : ' . $derivative_data['SampleMaster']['sample_code'] . $filter_data),
					'title' => array(null, __($derivative_data['SampleMaster']['sample_type'], true) . ' : ' . $derivative_data['SampleMaster']['sample_code']),

					'description' => array(
						__('type', true) => __($derivative_data['SampleMaster']['sample_type'], true),
						__('sample code', true) => $derivative_data['SampleMaster']['sample_code'],
						__('category', true) => __($derivative_data['SampleMaster']['sample_category'], true),
						__('creation date', true) => $derivative_data['DerivativeDetail']['creation_datetime']
					)
				)
			);
		}	
		
		return $return;
	}
			 	 
//   var $actAs = array('MasterDetail');
	
//	function summary($variables=array()) {
//		$return = false;
//		

//		
//		return $return;
//	}


}

?>