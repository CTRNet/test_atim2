<?php

if($sample_control_data['SampleControl']['sample_type'] == 'blood') {
	
	// ** BLOOD **
	
	// Set default blood data based on last created blood
	$data_to_duplicate = $this->SampleMaster->find('first', array(
		'conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.sample_control_id' => $sample_control_data['SampleControl']['id']), 
		'order' => array('SampleMaster.created DESC'),
		'recursive' => '0'));
	
	if(empty($data_to_duplicate)) {
		// No existing blood... find tissue
		$data_to_duplicate = $this->SampleMaster->find('first', array(
			'conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleControl.sample_type' => 'tissue'), 
			'order' => array('SampleMaster.created DESC'),
			'recursive' => '0'));			
	}

	$this->request->data['SpecimenDetail']['qc_hb_sample_code'] = 'S';	
	$this->request->data['SpecimenDetail']['reception_by'] = 'louise rousseau';
	if(!empty($data_to_duplicate)) {
		$this->request->data['SampleMaster']['is_problematic'] = $data_to_duplicate['SampleMaster']['is_problematic'];
		$this->request->data['SampleMaster']['sop_master_id'] = $data_to_duplicate['SampleMaster']['sop_master_id'];
		$this->request->data['SpecimenDetail']['reception_by'] = $data_to_duplicate['SpecimenDetail']['reception_by'];
		$this->request->data['SpecimenDetail']['supplier_dept'] = $data_to_duplicate['SpecimenDetail']['supplier_dept'];
		$this->request->data['SpecimenDetail']['reception_datetime'] = $data_to_duplicate['SpecimenDetail']['reception_datetime'];
		$this->request->data['SpecimenDetail']['reception_datetime_accuracy'] = $data_to_duplicate['SpecimenDetail']['reception_datetime_accuracy'];		
	}

} else if($sample_control_data['SampleControl']['sample_type'] == 'tissue') {
	
	// ** TISSUE **
	
	// Set default tissue data on last created tissue
	$data_to_duplicate = $this->SampleMaster->find('first', array(
		'conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.sample_control_id' => $sample_control_data['SampleControl']['id']), 
		'order' => array('SampleMaster.created DESC'),
		'recursive' => '0'));
	
	if(empty($data_to_duplicate)) {
		// No existing tissue... find blood
		$data_to_duplicate = $this->SampleMaster->find('first', array(
			'conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleControl.sample_type' => 'blood'), 
			'order' => array('SampleMaster.created DESC'),
			'recursive' => '0'));			
	}		
		
	$this->request->data['SpecimenDetail']['supplier_dept'] = "pathology";
	$this->request->data['SpecimenDetail']['reception_by'] = 'louise rousseau';
	$this->request->data['SpecimenDetail']['qc_hb_sample_code'] = 'T';	
	if(!empty($data_to_duplicate)) {
		$this->request->data['SampleMaster']['is_problematic'] = $data_to_duplicate['SampleMaster']['is_problematic'];
		$this->request->data['SampleMaster']['sop_master_id'] = $data_to_duplicate['SampleMaster']['sop_master_id'];
		$this->request->data['SpecimenDetail']['reception_by'] = $data_to_duplicate['SpecimenDetail']['reception_by'];
		$this->request->data['SpecimenDetail']['supplier_dept'] = $data_to_duplicate['SpecimenDetail']['supplier_dept'];
		$this->request->data['SpecimenDetail']['reception_datetime'] = $data_to_duplicate['SpecimenDetail']['reception_datetime'];
		$this->request->data['SpecimenDetail']['reception_datetime_accuracy'] = $data_to_duplicate['SpecimenDetail']['reception_datetime_accuracy'];		
		if(array_key_exists('tissue_source',$data_to_duplicate['SampleDetail'])) {
			// Default existing sample was a tissue
			$this->request->data['SpecimenDetail']['qc_hb_sample_code'] = ($data_to_duplicate['SpecimenDetail']['qc_hb_sample_code'] == 'T')? 'N' : 'T';
			$this->request->data['SampleDetail']['tissue_source'] = $data_to_duplicate['SampleDetail']['tissue_source'];	
			$this->request->data['SampleDetail']['pathology_reception_datetime'] = $data_to_duplicate['SampleDetail']['pathology_reception_datetime'];	
			$this->request->data['SampleDetail']['qc_hb_patho_report_no'] = $data_to_duplicate['SampleDetail']['qc_hb_patho_report_no'];	
		}	
	}
	
} else if(in_array($sample_control_data['SampleControl']['sample_type'], array('pbmc', 'plasma', 'serum'))) {

	// ** PBMC, PLASMA, SERUM **
	
	// Set default blood derivative data based on last created blood derivative
	$data_to_duplicate = $this->SampleMaster->find('first', array(
		'conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.parent_id' => $parent_sample_master_id), 
		'order' => array('SampleMaster.created DESC'),
		'recursive' => '0'));

	if(empty($data_to_duplicate)) {
		// No existing derivative for the parent... find other collection blood derivative
		$data_to_duplicate = $this->SampleMaster->find('first', array(
			'conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleControl.sample_type' => array('pbmc', 'plasma', 'serum')), 
			'order' => array('SampleMaster.created DESC'),
			'recursive' => '0'));	
	}	
		
	$this->request->data['DerivativeDetail']['creation_site'] = "cr. st-luc";
	$this->request->data['DerivativeDetail']['creation_by'] = 'louise rousseau';
	if(!empty($data_to_duplicate)) {
		$this->request->data['SampleMaster']['sop_master_id'] = $data_to_duplicate['SampleMaster']['sop_master_id'];
		$this->request->data['SampleMaster']['is_problematic'] = $data_to_duplicate['SampleMaster']['is_problematic'];	
		$this->request->data['DerivativeDetail']['creation_site'] = $data_to_duplicate['DerivativeDetail']['creation_site'];
		$this->request->data['DerivativeDetail']['creation_by'] = $data_to_duplicate['DerivativeDetail']['creation_by'];
		$this->request->data['DerivativeDetail']['creation_datetime'] = $data_to_duplicate['DerivativeDetail']['creation_datetime'];
	}
	
} else {
	
	$this->request->data['DerivativeDetail']['creation_site'] = "cr. st-luc";
	$this->request->data['DerivativeDetail']['creation_by'] = 'louise rousseau';
	$this->request->data['SampleDetail']['qc_hb_macs_enzymatic_milieu'] = 'collagenase + dnase';
	
}

?>