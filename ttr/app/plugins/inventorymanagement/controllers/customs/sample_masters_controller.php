<?php

class SampleMastersControllerCustom extends SampleMastersController{

	function add($collection_id, $sample_control_id, $parent_sample_master_id = null) {
		//special add cases for specimens. Automatically creates a collection
		if($collection_id == 0 && $parent_sample_master_id == null){
			$this->Structures->set('collections', 'collections');
			$sample_control_data = $this->SampleControl->find('first', array('conditions' => array('SampleControl.id' => $sample_control_id)));
			if(empty($sample_control_data)){
				$this->redirect('/pages/err_inv_no_data', null, true);
			}
				
			// Set parent data
			$dropdown = array();
			foreach($this->SampleControl->find('all') as $ctrl_unit){
				$dropdown[$ctrl_unit['SampleControl']['id']] = __($ctrl_unit['SampleControl']['sample_type'], true);
			}
			$this->SampleMaster->setParentSampleDropdown($dropdown);
			$this->set('parent_sample_master_id', null);

			// Set new sample control information
			$this->set('sample_control_data', $sample_control_data);
				
			// Set menu
			$atim_menu_link = '/inventorymanagement/';
			$this->set('atim_menu', $this->Menus->get($atim_menu_link));

			$atim_menu_variables = (empty($parent_sample_data)? array('Collection.id' => $collection_id) : array('Collection.id' => $collection_id, 'SampleMaster.initial_specimen_sample_id' => $parent_sample_data['SampleMaster']['initial_specimen_sample_id']));

			$this->set('atim_menu_variables', $atim_menu_variables);

			// set structure alias based on VALUE from CONTROL table
			$this->Structures->set($sample_control_data['SampleControl']['form_alias']);
				
			// MANAGE DATA RECORD
			if(empty($this->data)) {
				$this->data = array();
				$this->data['SampleMaster']['sample_type'] = $sample_control_data['SampleControl']['sample_type'];
				$this->data['SampleMaster']['sample_category'] = $sample_control_data['SampleControl']['sample_category'];
			}else{
				$this->data['Collection']['collection_property'] = 'participant collection';
				$this->Collection->set($this->data);
				$submitted_data_validates = $this->Collection->validates();
				
				// Set additional data
				$this->data['SampleMaster']['sample_control_id'] = $sample_control_data['SampleControl']['id'];
				$this->data['SampleMaster']['sample_type'] = $sample_control_data['SampleControl']['sample_type'];
				$this->data['SampleMaster']['sample_category'] = $sample_control_data['SampleControl']['sample_category'];
					
				// The created sample is a specimen
				if(isset($this->data['SampleMaster']['parent_id'])) { $this->redirect('/pages/err_inv_system_error', null, true); }
				$this->data['SampleMaster']['initial_specimen_sample_type'] = $this->data['SampleMaster']['sample_type'];
				$this->data['SampleMaster']['initial_specimen_sample_id'] = null; 	// ID will be known after sample creation
					
				// Validates data
					
				
					
				$this->SampleMaster->set($this->data);
				$submitted_data_validates = ($this->SampleMaster->validates())? $submitted_data_validates: false;
					
				//for error field highlight in detail
				$this->SampleDetail->validationErrors = $this->SampleMaster->validationErrors;
					
				$this->SpecimenDetail->set($this->data);
				$submitted_data_validates = ($this->SpecimenDetail->validates())? $submitted_data_validates: false;
					
				if($submitted_data_validates){
					//save collection data
					$this->Collection->save();
					$collection_id = $this->Collection->getLastInsertId();
					$this->data['SampleMaster']['collection_id'] = $collection_id;
					
					// Save sample data
					$sample_master_id = null;
					if($this->SampleMaster->save($this->data, false)) {
						$sample_master_id = $this->SampleMaster->getLastInsertId();

						// Record additional sample data
						$sample_data_to_update = array();
						$sample_data_to_update['SampleMaster']['sample_code'] = $this->createSampleCode($sample_master_id, $this->data, $sample_control_data);
						$sample_data_to_update['SampleMaster']['initial_specimen_sample_id'] = $sample_master_id;
							
						$this->SampleMaster->id = $sample_master_id;
						if(!$this->SampleMaster->save($sample_data_to_update, false)) { $this->redirect('/pages/err_inv_system_error', null, true); }
							
						// Save either specimen or derivative detail
						// SpecimenDetail
						$this->data['SpecimenDetail']['sample_master_id'] = $sample_master_id;
						if(!$this->SpecimenDetail->save($this->data['SpecimenDetail'], false)) { 
							$this->redirect('/pages/err_inv_system_error', null, true); 
						}
							
						$this->atimFlash('your data has been saved', '/inventorymanagement/sample_masters/detail/' . $collection_id . '/' . $sample_master_id);
					}
				}
			}

		}else{
			parent::add($collection_id, $sample_control_id, $parent_sample_master_id);
		}
	}
}

?>