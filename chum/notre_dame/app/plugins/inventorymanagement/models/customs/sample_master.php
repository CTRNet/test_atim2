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
				'Summary' => array(
					'menu' => array(null, __($specimen_data['SampleMaster']['sample_type'], true) . ' : ' . $specimen_data['SampleMaster']['sample_label']),
					'title' => array(null, __($specimen_data['SampleMaster']['sample_type'], true) . ' : ' . $specimen_data['SampleMaster']['sample_label']),

					'description' => array(
						__('type', true) => __($specimen_data['SampleMaster']['sample_type'], true).($specimen_data['SampleMaster']['sample_type'] == "blood" ? " (".__($specimen_data['SampleDetail']['blood_type'], true).")" : ""),
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
				 	
			// Set summary	 	
	 		$return = array(
				'Summary' => array(
					'menu' => array(null, __($derivative_data['SampleMaster']['sample_type'], true) . ' : ' . $derivative_data['SampleMaster']['sample_label']),
					'title' => array(null, __($derivative_data['SampleMaster']['sample_type'], true) . ' : ' . $derivative_data['SampleMaster']['sample_label']),

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

}

?>