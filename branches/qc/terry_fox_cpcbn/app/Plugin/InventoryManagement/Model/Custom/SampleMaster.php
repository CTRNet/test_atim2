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
			$specimen_data = $this->find('first', array('conditions' => $criteria, 'recursive' => '0'));

			$title = __($specimen_data['SampleControl']['sample_type']) . ' #' . $specimen_data['SampleMaster']['sample_code'];
			if(isset($specimen_data['SampleDetail']['qc_tf_collected_specimen_nature'])) {
				$title = __($specimen_data['SampleControl']['sample_type']) .' '.__($specimen_data['SampleDetail']['qc_tf_collected_specimen_nature']).' #' . $specimen_data['SampleMaster']['sample_code'];
				
			}
			// Set summary	 	
	 		$return = array(
				'menu'				=> array(null, $title),
				'title' 			=> array(null, $title),
				'data' 				=> $specimen_data,
	 			'structure alias' 	=> 'sample_masters'
			);
		}	
		
		return $return;
	}
}
