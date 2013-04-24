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
				'menu'				=> array(null, __($specimen_data['SampleControl']['sample_type'], true) . ' ' . $specimen_data['SampleMaster']['ld_lymph_specimen_number'] . ' ('. $specimen_data['SampleMaster']['sample_code'].')'),
				'title' 			=> array(null, __($specimen_data['SampleControl']['sample_type'], true) . ' ' . $specimen_data['SampleMaster']['ld_lymph_specimen_number'] . ' ('. $specimen_data['SampleMaster']['sample_code'].')'),
				'data' 				=> $specimen_data,
	 			'structure alias' 	=> 'sample_masters'
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
					'menu' 				=> array(null, __($derivative_data['SampleControl']['sample_type'], true) . ' (' . $derivative_data['SampleMaster']['sample_code'] . ')'),
					'title' 			=> array(null, __($derivative_data['SampleControl']['sample_type'], true) . ' (' . $derivative_data['SampleMaster']['sample_code'] . ')'),
					'data' 				=> $derivative_data,
	 				'structure alias' 	=> 'sample_masters'
			);
		}	
		
		return $return;
	}
}

?>