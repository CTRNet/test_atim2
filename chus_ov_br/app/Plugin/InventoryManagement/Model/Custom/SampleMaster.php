<?php

class SampleMasterCustom extends SampleMaster {
	
	var $useTable = 'sample_masters';
	var $name = 'SampleMaster';
	
	function specimenSummary($variables=array()) {
		$return = false;
		
		if (isset($variables['Collection.id']) && isset($variables['SampleMaster.initial_specimen_sample_id'])) {
			// Get specimen data
			$criteria = array(
				'SampleMaster.collection_id' => $variables['Collection.id'],
				'SampleMaster.id' => $variables['SampleMaster.initial_specimen_sample_id']);
			$specimen_data = $this->find('first', array('conditions' => $criteria));
			
			// Set summary	 	
	 		$return = array(
				'menu'				=> array(null, __($specimen_data['SampleControl']['sample_type']) . ' : ' . $specimen_data['SampleMaster']['sample_code']),
				'title' 			=> array(null, __($specimen_data['SampleControl']['sample_type']) . ' : ' . $specimen_data['SampleMaster']['sample_code']),
				'data' 				=> $specimen_data,
	 			'structure alias' 	=> 'sample_masters,specimens'
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
				 	
			// Set summary	 	
	 		$return = array(
					'menu' 				=> array(null, __($derivative_data['SampleControl']['sample_type']) . ' : ' . $derivative_data['SampleMaster']['sample_code']),
					'title' 			=> array(null, __($derivative_data['SampleControl']['sample_type']) . ' : ' . $derivative_data['SampleMaster']['sample_code']),
					'data' 				=> $derivative_data,
	 				'structure alias' 	=> 'sample_masters,derivatives'
			);
		}	
		
		return $return;
	}
	
	function validateChusCollectionDates($collection_data, $specimen_data) {	
		$chus_collection_date = empty($collection_data['Collection']['chus_collection_date'])? 
			'-1' : 
			$collection_data['Collection']['chus_collection_date'].'|'.$collection_data['Collection']['chus_collection_date_accuracy'];
		$chus_specimen_collection_date = empty($specimen_data['SpecimenDetail']['chus_collection_datetime'])? 
			'-1' : 
			substr($specimen_data['SpecimenDetail']['chus_collection_datetime'], 0, strpos($specimen_data['SpecimenDetail']['chus_collection_datetime'], ' ')).'|'.
			str_replace(array('h', 'i'), array('c','c'), $specimen_data['SpecimenDetail']['chus_collection_datetime_accuracy']);
		if($chus_collection_date !== $chus_specimen_collection_date) return false;
		return true;
	}
}
