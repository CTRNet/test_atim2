<?php

if(empty($this->data)) {
	
	if(in_array($sample_control_data['SampleControl']['sample_type'], array('blood'))) {
		// Set default blood data based on last created blood
		$data = $this->SampleMaster->find('first', array(
			'conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.sample_control_id' => $sample_control_data['SampleControl']['id']), 
			'order' => array('SampleMaster.created DESC')));
		
		if(empty($data)) {
			// No existing blood... find tissue
			$data = $this->SampleMaster->find('first', array(
				'conditions' => array('SampleMaster.collection_id' => $collection_id), 
				'order' => array('SampleMaster.created DESC')));			
		}
		
		$preset = array();
		$preset['SpecimenDetail']['qc_hb_sample_code'] = 'S';	
		if(empty($data)) {
			$preset['SpecimenDetail']['reception_by'] = 'urszula krzemien';			
			
		} else  {
			$preset['SampleMaster']['sop_master_id'] = $data['SampleMaster']['sop_master_id'];
			$preset['SampleMaster']['is_problematic'] = $data['SampleMaster']['is_problematic'];
			
			foreach(array("supplier_dept", "reception_by", "reception_datetime", "reception_datetime_accuracy") as $val){
				$preset['SpecimenDetail'][$val] = $data['SpecimenDetail'][$val];
			}
		}
		$this->set("preset", $preset);		
	
	} else if(in_array($sample_control_data['SampleControl']['sample_type'], array('tissue'))) {
		// Set default tissue data on last created tissue
		$data = $this->SampleMaster->find('first', array(
			'conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.sample_control_id' => $sample_control_data['SampleControl']['id']), 
			'order' => array('SampleMaster.created DESC')));

		if(empty($data)) {
			// No existing tissue... find blood
			$data = $this->SampleMaster->find('first', array(
				'conditions' => array('SampleMaster.collection_id' => $collection_id), 
				'order' => array('SampleMaster.created DESC')));			
		}		
		
		$preset = array();
		if(empty($data)) {
			$preset['SpecimenDetail']['supplier_dept'] = "pathology";
			$preset['SpecimenDetail']['reception_by'] = 'urszula krzemien';
			$preset['SpecimenDetail']['qc_hb_sample_code'] = 'T';	
			
		} else  {
			$preset['SampleMaster']['sop_master_id'] = $data['SampleMaster']['sop_master_id'];
			$preset['SampleMaster']['is_problematic'] = $data['SampleMaster']['is_problematic'];
			
			foreach(array("supplier_dept", "reception_by", "reception_datetime", "reception_datetime_accuracy") as $val){
				$preset['SpecimenDetail'][$val] = $data['SpecimenDetail'][$val];
			}
					
			if(array_key_exists('tissue_source',$data['SampleDetail'])) {
				// Default existing sample was a tissue
				$preset['SpecimenDetail']['qc_hb_sample_code'] = ($data['SpecimenDetail']['qc_hb_sample_code'] == 'T')? 'N' : 'T';
				foreach(array("tissue_source", "tissue_laterality", "pathology_reception_datetime", "qc_hb_patho_report_no") as $val){
					$preset['SampleDetail'][$val] = $data['SampleDetail'][$val];
				}
			} else {
				// Default existing sample was a blood
				$preset['SpecimenDetail']['supplier_dept'] = "pathology";
				$preset['SpecimenDetail']['reception_by'] = 'urszula krzemien';
				$preset['SpecimenDetail']['qc_hb_sample_code'] = 'T';	
			}
		}
		
		$this->set("preset", $preset);		
	
	} else if(in_array($sample_control_data['SampleControl']['sample_type'], array('pbmc', 'plasma', 'serum')) && (!empty($parent_sample_master_id))) {
		// Set default blood derivative data based on last created blood derivative
		$data = $this->SampleMaster->find('first', array(
			'conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.parent_id' => $parent_sample_master_id), 
			'order' => array('SampleMaster.created DESC')));
	
		if(empty($data)) {
			// No existing derivative for the parent... find other collection blood derivative
			$data = $this->SampleMaster->find('first', array(
				'conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.sample_type' => array('pbmc', 'plasma', 'serum')), 
				'order' => array('SampleMaster.created DESC')));	
		}	
			
		$preset = array();
		if(empty($data)) {
			$preset['DerivativeDetail']['creation_site'] = "ICM";
			$preset['DerivativeDetail']['creation_by'] = 'urszula krzemien';
			
		} else  {
			$preset['SampleMaster']['sop_master_id'] = $data['SampleMaster']['sop_master_id'];
			$preset['SampleMaster']['is_problematic'] = $data['SampleMaster']['is_problematic'];
			
			foreach(array("creation_site", "creation_by", "creation_datetime") as $val){
				$preset['DerivativeDetail'][$val] = $data['DerivativeDetail'][$val];
			}
		}
		$this->set("preset", $preset);		
	}
	
}

?>