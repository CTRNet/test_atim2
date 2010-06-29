<?php
 
 	// --------------------------------------------------------------------------------
	// Generate Sample Label
	// -------------------------------------------------------------------------------- 
	if($submitted_data_validates) {
		$working_data = $this->data;
		$working_data['SampleControl'] = $sample_data['SampleControl'];
		$working_data['SampleMaster']['initial_specimen_sample_id'] = $sample_data['SampleMaster']['initial_specimen_sample_id'];
		
		$this->data['SampleMaster']['sample_label'] = $this->createSampleLabel($collection_id, $working_data);
	}



	// For specimen: Check selected type code 
	// Plus for tissue: set read only fields (tissue source, nature, laterality)		
	$management_done 
		= $this->manageLabTypeCodeAndLaterality($submitted_data_validates);

exit;
	// --------------------------------------------------------------------------------
	// Update Derivatives Sample Labels of the managed Specimen
	// -------------------------------------------------------------------------------- 	
	if($submitted_data_validates && $bool_is_specimen && ($sample_data['SampleMaster']['sample_label'] != $this->data['SampleMaster']['sample_label'])) {
		// Sample Labels of the specimen derivatives have to be updated: Manage sample data record into the hook + update derivatives sample label
		
		// Keep warning for developper
		pr('WARNING: Save process done into the hook! Check sample_masters_controller.php upgrade has no impact on the hook line code!');				
			
		$submitted_data_validates = false;
		$specimen_sample_label = $this->data['SampleMaster']['sample_label'];
				
		// 1- Save specimen data
		
		$this->SampleMaster->id = $sample_master_id;
		if($this->SampleMaster->save($this->data, false)) {
			$this->SpecimenDetail->id = $sample_data['SpecimenDetail']['id'];
			if(!$this->SpecimenDetail->save($this->data['SpecimenDetail'], false)) { $this->redirect('/pages/err_inv_system_error', null, true); }
			
			// 2- Update derivatives sample label
			
			// Get bank_participant_identifier	
			App::import('Model', 'Inventorymanagement.ViewCollection');		
			$ViewCollection= new ViewCollection();
			
			$view_collection = $ViewCollection->find('first', array('conditions' => array('ViewCollection.collection_id' => $collection_id)));
			if(empty($view_collection)) { $this->redirect('/pages/err_inv_system_error', null, true); }
			
			$bank_participant_identifier = empty($view_collection['ViewCollection']['identifier_value'])? '' : $view_collection['ViewCollection']['identifier_value'];			
			
			// Get derivatives
			$this->SampleMaster->contain('SampleMaster', 'SampleControl', 'DerivativeDetail', 'SampleDetail');
			$specimen_derivatives_list = $this->SampleMaster->find('all', array('conditions' => array('SampleMaster.initial_specimen_sample_id' => $sample_master_id, 'SampleMaster.sample_category' => 'derivative')));
			
			// Update derivative sample label
			foreach($specimen_derivatives_list as $new_derivative) {
				$derivative_data_to_save = array();
				$derivative_data_to_save['SampleMaster']['sample_label'] = 	$this->createSampleLabel($collection_id, $new_derivative, $bank_participant_identifier, $specimen_sample_label);
			
				$this->SampleMaster->id = $new_derivative['SampleMaster']['id'];
				if(!$this->SampleMaster->save($derivative_data_to_save)) { $this->redirect('/pages/err_inv_system_error', null, true); }
			}
			
			// Redirect user
			$this->flash('your data has been updated', '/inventorymanagement/sample_masters/detail/' . $collection_id . '/' . $sample_master_id);		
		}	
	}			
			
?>
