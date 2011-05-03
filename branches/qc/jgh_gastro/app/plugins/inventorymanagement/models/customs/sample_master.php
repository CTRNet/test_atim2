<?php

class SampleMasterCustom extends SampleMaster {
	
	var $name = "SampleMaster";
	var $useTable = "sample_masters";
		
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
				'menu'				=> array(null, __($specimen_data['SampleMaster']['sample_type'], true) . ' : ' . $specimen_data['SpecimenDetail']['specimen_biobank_id']),
				'title' 			=> array(null, __($specimen_data['SampleMaster']['sample_type'], true) . ' : ' . $specimen_data['SpecimenDetail']['specimen_biobank_id']),
				'data' 				=> $specimen_data,
	 			'structure alias' 	=> 'sample_masters_for_search_result'
			);
		}	
		
		return $return;
	}
}

?>