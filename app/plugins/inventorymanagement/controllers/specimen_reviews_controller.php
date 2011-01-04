<?php

class SpecimenReviewsController extends InventoryManagementAppController {

	var $components = array('Inventorymanagement.Aliquots');
		
	var $uses = array(
		'Inventorymanagement.Collection',
		'Inventorymanagement.SampleMaster',
		
		'Inventorymanagement.SpecimenReviewControl',
		'Inventorymanagement.SpecimenReviewMaster',
		'Inventorymanagement.SpecimenReviewDetail',
	
		'Inventorymanagement.AliquotMaster',
		'Inventorymanagement.AliquotReviewControl',
		'Inventorymanagement.AliquotReviewMaster',
		'Inventorymanagement.AliquotReviewDetail',
		'Inventorymanagement.AliquotUse'
	);
	
	var $paginate = array(
		'SpecimenReviewMaster' => array('limit' => pagination_amount, 'order' => 'SpecimenReviewMaster.review_date ASC'),
		'AliquotReviewMaster' => array('limit' => pagination_amount, 'order' => 'AliquotReviewMaster.review_code DESC'));
	
	/* --------------------------------------------------------------------------
	 * DISPLAY FUNCTIONS
	 * -------------------------------------------------------------------------- */

	function listAll($collection_id, $sample_master_id) {
		if((!$collection_id) || (!$sample_master_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }		
		
		// MANAGE DATA
		
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id), 'recursive' => '-1'));
		if(empty($sample_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }	
		
		$this->data = $this->paginate($this->SpecimenReviewMaster, array('SpecimenReviewMaster.sample_master_id'=>$sample_master_id));
		
		// Set list of available review
		$review_controls = $this->SpecimenReviewControl->find('all', array('conditions'=>array('SpecimenReviewControl.specimen_sample_type' => $sample_data['SampleMaster']['sample_type'], 'SpecimenReviewControl.flag_active' => '1' )));
		$this->set( 'review_controls', $review_controls );
		if(empty($review_controls)) { $this->SpecimenReviewControl->validationErrors[]	= 'no path review exists for this type of sample'; }
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/specimen_reviews/listAll/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%'));		

		$this->set( 'atim_menu_variables', 
			array('Collection.id' => $sample_data['SampleMaster']['collection_id'], 
			'SampleMaster.id' => $sample_master_id,
			'SampleMaster.initial_specimen_sample_id' => $sample_data['SampleMaster']['initial_specimen_sample_id']) );
			
		$this->Structures->set('specimen_review_masters');
			
		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) {
			require($hook_link);
		}
	}
	
	function add($collection_id, $sample_master_id, $specimen_review_control_id) {
		if ((!$collection_id) || (!$sample_master_id) || (!$specimen_review_control_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }		
		
		// MANAGE DATA
		
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id), 'recursive' => '-1'));
		if(empty($sample_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }	
		
		$criteria = array(
			'SpecimenReviewControl.id' => $specimen_review_control_id, 
			'SpecimenReviewControl.sample_control_id' => $sample_data['SampleMaster']['sample_control_id'], 
			'SpecimenReviewControl.flag_active' => '1');
		$review_control_data = $this->SpecimenReviewControl->find('first', array('conditions' => $criteria, 'recursive' => '2'));	
					
		if(empty($review_control_data)) { $this->redirect( '/pages/err_inv_no_data', null, true ); }
		
		$this->set( 'review_control_data', $review_control_data );
		
		$is_aliquot_review_defined = false;
		if(array_key_exists('flag_active', $review_control_data['AliquotReviewControl']) && $review_control_data['AliquotReviewControl']['flag_active']) { $is_aliquot_review_defined = true; }
		$this->set( 'is_aliquot_review_defined', $is_aliquot_review_defined);
		
		// Set available aliquot
		if($is_aliquot_review_defined) {
			$this->set('aliquot_list', $this->AliquotReviewMaster->getAliquotListForReview($sample_master_id, (($review_control_data['AliquotReviewControl']['aliquot_type_restriction'] == 'all')? null : $review_control_data['AliquotReviewControl']['aliquot_type_restriction'])));
		}		
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/specimen_reviews/listAll/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%'));		

		$this->set( 'atim_menu_variables', 
			array('Collection.id' => $sample_data['SampleMaster']['collection_id'], 
			'SampleMaster.id' => $sample_master_id,
			'SampleMaster.initial_specimen_sample_id' => $sample_data['SampleMaster']['initial_specimen_sample_id'],
			'SpecimenReviewControl.id' => $specimen_review_control_id) );
					
		$this->Structures->set($review_control_data['SpecimenReviewControl']['form_alias'], 'specimen_review_structure');
		if($is_aliquot_review_defined) {
			$this->Structures->set('empty', 'empty_structure');
			$this->Structures->set($review_control_data['AliquotReviewControl']['form_alias'], 'aliquot_review_structure');
		}
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		if ( empty($this->data) ) {
			$this->data = NULL;
			$this->set('specimen_review_data', array());
			$this->set('aliquot_review_data', array());

		} else {
	
			// reset array
			$specimen_review_data['SpecimenReviewMaster'] = $this->data['SpecimenReviewMaster'];
			$specimen_review_data['SpecimenReviewDetail'] = $this->data['SpecimenReviewDetail'];
			unset($this->data['SpecimenReviewMaster']);
			unset($this->data['SpecimenReviewDetail']);
			$aliquot_review_data = $this->data;
			$this->data = NULL;
			
			$specimen_review_data['SpecimenReviewMaster']['specimen_review_control_id'] = $specimen_review_control_id;
			$specimen_review_data['SpecimenReviewMaster']['specimen_sample_type'] = $review_control_data['SpecimenReviewControl']['specimen_sample_type'];
			$specimen_review_data['SpecimenReviewMaster']['review_type'] = $review_control_data['SpecimenReviewControl']['review_type'];
			$specimen_review_data['SpecimenReviewMaster']['collection_id'] = $collection_id;
			$specimen_review_data['SpecimenReviewMaster']['sample_master_id'] = $sample_master_id;

			foreach($aliquot_review_data as $key => $new_aliquot_review) {
				$aliquot_review_data[$key]['AliquotReviewMaster']['aliquot_review_control_id'] = $review_control_data['AliquotReviewControl']['id'];			
			}
			
			$this->set('specimen_review_data', $specimen_review_data);
			$this->set('aliquot_review_data', $aliquot_review_data);	
						
			// LAUNCH SPECIAL VALIDATION PROCESS
			$submitted_data_validates = true;
			
			// Validate specimen review
			$this->SpecimenReviewMaster->set($specimen_review_data);
			$submitted_data_validates = ($this->SpecimenReviewMaster->validates())? $submitted_data_validates: false;
			
			// Validate aliquot review
			if($is_aliquot_review_defined) {
				$all_aliquot_review_master_errors = array();
				foreach($aliquot_review_data as $key => $new_aliquot_review) {
					// Aliquot Review Master
					$this->AliquotReviewMaster->set($new_aliquot_review);
					$submitted_data_validates = ($this->AliquotReviewMaster->validates())? $submitted_data_validates: false;
					$all_aliquot_review_master_errors = array_merge($all_aliquot_review_master_errors, $this->AliquotReviewMaster->validationErrors);
				}
				if(!empty($all_aliquot_review_master_errors)) {
					$this->AliquotReviewMaster->validationErrors = array();
					foreach($all_aliquot_review_master_errors as $field => $error_message) {
						$this->AliquotReviewMaster->validationErrors[$field] = $error_message;					
					}
				}			
			}
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }
			
			//LAUNCH SAVE PROCESS
			if($submitted_data_validates) {
							
				// Set additional specimen review data and save
				$specimen_review_data['SpecimenReviewMaster']['id'] = null;
				if(!$this->SpecimenReviewMaster->save($specimen_review_data, false)) { $this->redirect('/pages/err_inv_record_err', null, true); }
				$specimen_review_master_id = $this->SpecimenReviewMaster->id;
				
				$is_aliquot_use_created = false;
				if($is_aliquot_review_defined) {
					$use_data_source = $this->AliquotUse->getDataSource();
					$use_data_source->begin($this->AliquotUse);
					foreach($aliquot_review_data as $key => $new_aliquot_review) {
						// 1- Save aliquot use... won't save used volume!
						$aliquot_use_id = null;
						if(array_key_exists('aliquot_masters_id', $new_aliquot_review['AliquotReviewMaster']) && (!empty($new_aliquot_review['AliquotReviewMaster']['aliquot_masters_id']))) {
							$new_used_aliquot = array();
							$new_used_aliquot['AliquotUse']['aliquot_master_id'] = $new_aliquot_review['AliquotReviewMaster']['aliquot_masters_id'];	
							$new_used_aliquot['AliquotUse']['use_definition'] = 'path review';
							$new_used_aliquot['AliquotUse']['use_code'] = $specimen_review_data['SpecimenReviewMaster']['review_code'];
							$new_used_aliquot['AliquotUse']['use_datetime'] = $specimen_review_data['SpecimenReviewMaster']['review_date'];
							$new_used_aliquot['AliquotUse']['use_recorded_into_table'] = 'aliquot_review_masters';					
							
							// - AliquotUse
							$this->AliquotUse->id = null;
							if(!$this->AliquotUse->save($new_used_aliquot, false)) { $this->redirect('/pages/err_inv_record_err', null, true); }
							$aliquot_use_id = $this->AliquotUse->getLastInsertId();
							
							$is_aliquot_use_created = true;
						}
						
						// 2- Save aliquot review
						$this->AliquotReviewMaster->id = null;
						$new_aliquot_review['AliquotReviewMaster']['id'] = null;
						$new_aliquot_review['AliquotReviewMaster']['specimen_review_master_id'] = $specimen_review_master_id;					
						$new_aliquot_review['AliquotReviewMaster']['aliquot_use_id'] = $aliquot_use_id;
						if(!$this->AliquotReviewMaster->save($new_aliquot_review, false)) { $this->redirect('/pages/err_inv_record_err', null, true); }
					}
					$use_data_source->commit($this->AliquotUse);
				}
				
				$this->atimFlash(__('your data has been saved', true).  
					($is_aliquot_use_created? '<br>' . __('work directly on aliquot to change aliquot information (status, used volume, etc)', true): ''),
					'/inventorymanagement/specimen_reviews/detail/' . $collection_id . '/' . $sample_master_id . '/' . $specimen_review_master_id);	
			}
		} 
	}
	
	function detail($collection_id, $sample_master_id, $specimen_review_id) {
		if ((!$collection_id) || (!$sample_master_id) || (!$specimen_review_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }		
		
		// MANAGE DATA
		$this->data = NULL;
		
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id), 'recursive' => '-1'));
		if(empty($sample_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }	
		
		// Get specimen review data
		$criteria = array(
			'SpecimenReviewMaster.id' => $specimen_review_id, 
			'SpecimenReviewMaster.collection_id' => $collection_id, 
			'SpecimenReviewMaster.sample_master_id' => $sample_master_id);
		$specimen_review_data = $this->SpecimenReviewMaster->find('first', array('conditions' => $criteria, 'recursive' => '2'));	
		if(empty($specimen_review_data)) { $this->redirect( '/pages/err_inv_no_data', null, true ); }	
		$this->set('specimen_review_data', $specimen_review_data);
			
		$is_aliquot_review_defined = false;
		if(array_key_exists('flag_active', $specimen_review_data['SpecimenReviewControl']['AliquotReviewControl']) && $specimen_review_data['SpecimenReviewControl']['AliquotReviewControl']['flag_active']) { $is_aliquot_review_defined = true; }
		$this->set( 'is_aliquot_review_defined', $is_aliquot_review_defined);
		
		// Get Aliquot Review Data
		if($is_aliquot_review_defined) {
			$criteria = array(
				'AliquotReviewMaster.specimen_review_master_id' => $specimen_review_id, 
				'AliquotReviewMaster.aliquot_review_control_id' => $specimen_review_data['SpecimenReviewControl']['AliquotReviewControl']['id']);
			$aliquot_review_data = $this->AliquotReviewMaster->find('all', array('conditions' => $criteria));				
			$this->set('aliquot_review_data', $aliquot_review_data);
			
			// Set available aliquot
			$this->set('aliquot_list', $this->AliquotReviewMaster->getAliquotListForReview($sample_master_id, (($specimen_review_data['SpecimenReviewControl']['AliquotReviewControl']['aliquot_type_restriction'] == 'all')? null : $specimen_review_data['SpecimenReviewControl']['AliquotReviewControl']['aliquot_type_restriction'])));
		}

		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/specimen_reviews/listAll/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%'));		

		$this->set( 'atim_menu_variables', 
			array('Collection.id' => $sample_data['SampleMaster']['collection_id'], 
			'SampleMaster.id' => $sample_master_id,
			'SampleMaster.initial_specimen_sample_id' => $sample_data['SampleMaster']['initial_specimen_sample_id'],
			'SpecimenReviewMaster.id' => $specimen_review_id) );
					
		$this->Structures->set($specimen_review_data['SpecimenReviewControl']['form_alias'], 'specimen_review_structure');
		if($is_aliquot_review_defined) {
			$this->Structures->set('empty', 'empty_structure');
			$this->Structures->set($specimen_review_data['SpecimenReviewControl']['AliquotReviewControl']['form_alias'], 'aliquot_review_structure');
		}
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }	
	}
	
	function edit($collection_id, $sample_master_id, $specimen_review_id, $undo = false) {
		if ((!$collection_id) || (!$sample_master_id) || (!$specimen_review_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }		
		// MANAGE DATA
		
		// Get sample data
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id), 'recursive' => '-1'));
		if(empty($sample_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }	
		
		// Get specimen review data
		$criteria = array(
			'SpecimenReviewMaster.id' => $specimen_review_id, 
			'SpecimenReviewMaster.collection_id' => $collection_id, 
			'SpecimenReviewMaster.sample_master_id' => $sample_master_id);
		$initial_specimen_review_data = $this->SpecimenReviewMaster->find('first', array('conditions' => $criteria, 'recursive' => '2'));	
		if(empty($initial_specimen_review_data)) { $this->redirect( '/pages/err_inv_no_data', null, true ); }	
		
		$is_aliquot_review_defined = false;
		if(array_key_exists('flag_active', $initial_specimen_review_data['SpecimenReviewControl']['AliquotReviewControl']) && $initial_specimen_review_data['SpecimenReviewControl']['AliquotReviewControl']['flag_active']) { $is_aliquot_review_defined = true; }
		$this->set( 'is_aliquot_review_defined', $is_aliquot_review_defined);
		
		$review_control_data = array('SpecimenReviewControl' => $initial_specimen_review_data['SpecimenReviewControl']);
		$this->set( 'review_control_data', $review_control_data );
		
		// Get Aliquot Review Data
		$initial_aliquot_review_data_list = array();
		if($is_aliquot_review_defined) {
			$criteria = array(
				'AliquotReviewMaster.specimen_review_master_id' => $specimen_review_id, 
				'AliquotReviewMaster.aliquot_review_control_id' => $initial_specimen_review_data['SpecimenReviewControl']['AliquotReviewControl']['id']);
			$initial_aliquot_review_data_list = $this->AliquotReviewMaster->find('all', array('conditions' => $criteria));				
			
			// Set available aliquot
			$this->set('aliquot_list', $this->AliquotReviewMaster->getAliquotListForReview($sample_master_id, (($initial_specimen_review_data['SpecimenReviewControl']['AliquotReviewControl']['aliquot_type_restriction'] == 'all')? null : $initial_specimen_review_data['SpecimenReviewControl']['AliquotReviewControl']['aliquot_type_restriction'])));
		}

		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/specimen_reviews/listAll/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%'));		

		$this->set( 'atim_menu_variables', 
			array('Collection.id' => $sample_data['SampleMaster']['collection_id'], 
			'SampleMaster.id' => $sample_master_id,
			'SampleMaster.initial_specimen_sample_id' => $sample_data['SampleMaster']['initial_specimen_sample_id'],
			'SpecimenReviewMaster.id' => $specimen_review_id) );
					
		$this->Structures->set($initial_specimen_review_data['SpecimenReviewControl']['form_alias'], 'specimen_review_structure');
		if($is_aliquot_review_defined) {
			$this->Structures->set('empty', 'empty_structure');
			$this->Structures->set($initial_specimen_review_data['SpecimenReviewControl']['AliquotReviewControl']['form_alias'], 'aliquot_review_structure');
		}
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }	
		
		if ( empty($this->data) || $undo ) {
			$this->data = NULL;
			$this->set('specimen_review_data', $initial_specimen_review_data);
			$this->set('aliquot_review_data', $initial_aliquot_review_data_list);
				
		} else {
			// reset array
			$specimen_review_data['SpecimenReviewMaster'] = $this->data['SpecimenReviewMaster'];
			$specimen_review_data['SpecimenReviewDetail'] = $this->data['SpecimenReviewDetail'];
			unset($this->data['SpecimenReviewMaster']);
			unset($this->data['SpecimenReviewDetail']);
			$aliquot_review_data = array_values($this->data);//compact the array as some key might be missing
			$this->data = NULL;
			
			foreach($aliquot_review_data as $key => $new_aliquot_review) {
				$aliquot_review_data[$key]['AliquotReviewMaster']['aliquot_review_control_id'] = $review_control_data['SpecimenReviewControl']['AliquotReviewControl']['id'];			
			}
			
			$this->set('specimen_review_data', $specimen_review_data);
			$this->set('aliquot_review_data', $aliquot_review_data);
			
			// LAUNCH SPECIAL VALIDATION PROCESS
			$submitted_data_validates = true;
			
			// Validate specimen review
			$this->SpecimenReviewMaster->set($specimen_review_data);
			$this->SpecimenReviewMaster->id = $specimen_review_id;
			$submitted_data_validates = ($this->SpecimenReviewMaster->validates())? $submitted_data_validates: false;
			
			// Validate aliquot review
			if($is_aliquot_review_defined) {
				$all_aliquot_review_master_errors = array();
				foreach($aliquot_review_data as $key => $new_aliquot_review) {
					// Aliquot Review Master
					$this->AliquotReviewMaster->set($new_aliquot_review);
					$submitted_data_validates = ($this->AliquotReviewMaster->validates())? $submitted_data_validates: false;
					$all_aliquot_review_master_errors = array_merge($all_aliquot_review_master_errors, $this->AliquotReviewMaster->validationErrors);
				}
				if(!empty($all_aliquot_review_master_errors)) {
					$this->AliquotReviewMaster->validationErrors = array();
					foreach($all_aliquot_review_master_errors as $field => $error_message) {
						$this->AliquotReviewMaster->validationErrors[$field] = $error_message;					
					}
				}			
			}
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }
			
			//LAUNCH SAVE PROCESS
			if($submitted_data_validates) {
				
				// Check aliquot use information has to be updated
				$force_all_aliquot_uses_updates = false;
				
				$new_review_date = $specimen_review_data['SpecimenReviewMaster']['review_date']['year'].'-'.
					$specimen_review_data['SpecimenReviewMaster']['review_date']['month'].'-'.
					$specimen_review_data['SpecimenReviewMaster']['review_date']['day'];
				if(($new_review_date != $initial_specimen_review_data['SpecimenReviewMaster']['review_date']) 
				|| ($specimen_review_data['SpecimenReviewMaster']['review_code'] != $initial_specimen_review_data['SpecimenReviewMaster']['review_code'])) {
					$force_all_aliquot_uses_updates = true;
				}				
				
				// Set additional specimen review data and save
				$this->SpecimenReviewMaster->id = $specimen_review_id;
				if(!$this->SpecimenReviewMaster->save($specimen_review_data, false)) { $this->redirect('/pages/err_inv_record_err', null, true); }
				
				$is_aliquot_use_managed = false;
				
				if($is_aliquot_review_defined) {
					// Build aliquot review array with id = key
					$initial_aliquot_review_data_from_id = array();
					foreach($initial_aliquot_review_data_list as $initial_aliquot_review) {
						$initial_aliquot_review_data_from_id[$initial_aliquot_review['AliquotReviewMaster']['id']] = array('AliquotReviewMaster' => $initial_aliquot_review['AliquotReviewMaster']);	
					}
					
					// Launch process to update/create/delete aliquot review
					$use_data_source = $this->AliquotUse->getDataSource();
					$use_data_source->begin($this->AliquotUse); 
					foreach($aliquot_review_data as $key => $submitted_aliquot_review) {
						if(isset($initial_aliquot_review_data_from_id[$submitted_aliquot_review['AliquotReviewMaster']['id']])) {
							//---------------------------------------------------------------------------
							// 1- Existing aliquot review to update
							//---------------------------------------------------------------------------
								
							$aliquot_review_id = $submitted_aliquot_review['AliquotReviewMaster']['id'];
							$initial_aliquot_review = $initial_aliquot_review_data_from_id[$aliquot_review_id];
							unset($initial_aliquot_review_data_from_id[$aliquot_review_id]);
														
							// *** 1.1 Manage aliquot use... won't save used volume! *** 
							
							$aliquot_use_id_to_record = null;
							
							if(array_key_exists('aliquot_masters_id', $initial_aliquot_review['AliquotReviewMaster'])) {
								$is_aliquot_use_managed = true;
								if($initial_aliquot_review['AliquotReviewMaster']['aliquot_masters_id'] != $submitted_aliquot_review['AliquotReviewMaster']['aliquot_masters_id']) {
									// 1.1.a The studied aliquot has been changed
									
									if(!empty($initial_aliquot_review['AliquotReviewMaster']['aliquot_use_id'])) {
										// The review was linked to another aliquot: delete aliquot use
										
										$aliquot_use_id_to_delete = $initial_aliquot_review['AliquotReviewMaster']['aliquot_use_id'];
										if(!$this->AliquotUse->atim_delete($aliquot_use_id_to_delete)) { $this->redirect('/pages/err_inv_system_error', null, true); }
										$aliquot_use_id_to_record = null;
										
										if(!$this->AliquotMaster->updateAliquotCurrentVolume($initial_aliquot_review['AliquotReviewMaster']['aliquot_masters_id'])) { $this->redirect('/pages/err_inv_record_err', null, true); }
									}
									
									if(!empty($submitted_aliquot_review['AliquotReviewMaster']['aliquot_masters_id'])) {
										// The review will be linked to a new aliquot: create new aliquot use
										
										$new_aliquot_use_data = array();
										$new_aliquot_use_data['AliquotUse']['aliquot_master_id'] = $submitted_aliquot_review['AliquotReviewMaster']['aliquot_masters_id'];	
										$new_aliquot_use_data['AliquotUse']['use_definition'] = 'path review';
										$new_aliquot_use_data['AliquotUse']['use_code'] = $specimen_review_data['SpecimenReviewMaster']['review_code'];
										$new_aliquot_use_data['AliquotUse']['use_datetime'] = $specimen_review_data['SpecimenReviewMaster']['review_date'];
										$new_aliquot_use_data['AliquotUse']['use_recorded_into_table'] = 'aliquot_review_masters';		
									
										$this->AliquotUse->id = null;
										if(!$this->AliquotUse->save($new_aliquot_use_data, false)) { $this->redirect('/pages/err_inv_record_err', null, true); }
										$aliquot_use_id_to_record = $this->AliquotUse->getLastInsertId();										
									}
									
								} else { 
									// 1.1.b The studied aliquot has not been changed
									
									$aliquot_use_id_to_record = $initial_aliquot_review['AliquotReviewMaster']['aliquot_use_id'];
									if((!empty($aliquot_use_id_to_record)) && $force_all_aliquot_uses_updates) {
										// Update aliquot use based on aliquot review update
										
										$aliquot_use_data = array();
										$aliquot_use_data['AliquotUse']['use_code'] = $specimen_review_data['SpecimenReviewMaster']['review_code'];
										$aliquot_use_data['AliquotUse']['use_datetime'] = $specimen_review_data['SpecimenReviewMaster']['review_date'];				
										
										$this->AliquotUse->id = $aliquot_use_id_to_record;
										if(!$this->AliquotUse->save($aliquot_use_data, false)) { $this->redirect('/pages/err_inv_record_err', null, true); }
									}
								}
							}
							// *** 1.2 Update Aliquot Review *** 
							
							$this->AliquotReviewMaster->id = $aliquot_review_id;
							$submitted_aliquot_review['AliquotReviewMaster']['aliquot_use_id'] = $aliquot_use_id_to_record;
							if(!$this->AliquotReviewMaster->save($submitted_aliquot_review, false)) { $this->redirect('/pages/err_inv_record_err', null, true); }
							$use_data_source->commit($this->AliquotUse);
						}else{
							
					//---------------------------------------------------------------------------
					// 2- New aliquot review to create
					//---------------------------------------------------------------------------
							// *** 1.1- Save aliquot use... won't save used volume! ***
							$aliquot_use_id = null;
							if(array_key_exists('aliquot_masters_id', $submitted_aliquot_review['AliquotReviewMaster']) && (!empty($submitted_aliquot_review['AliquotReviewMaster']['aliquot_masters_id']))) {
								$new_used_aliquot = array();
								$new_used_aliquot['AliquotUse']['aliquot_master_id'] = $submitted_aliquot_review['AliquotReviewMaster']['aliquot_masters_id'];	
								$new_used_aliquot['AliquotUse']['use_definition'] = 'path review';
								$new_used_aliquot['AliquotUse']['use_code'] = $specimen_review_data['SpecimenReviewMaster']['review_code'];
								$new_used_aliquot['AliquotUse']['use_datetime'] = $specimen_review_data['SpecimenReviewMaster']['review_date'];
								$new_used_aliquot['AliquotUse']['use_recorded_into_table'] = 'aliquot_review_masters';					
								
								// - AliquotUse
								$this->AliquotUse->id = null;
								if(!$this->AliquotUse->save($new_used_aliquot, false)) { $this->redirect('/pages/err_inv_record_err', null, true); }
								$aliquot_use_id = $this->AliquotUse->getLastInsertId();
								
								$is_aliquot_use_managed = true;
							}
							
							// *** 1.2- Save aliquot review ***
							$this->AliquotReviewMaster->id = null;
							$submitted_aliquot_review['AliquotReviewMaster']['id'] = null;
							$submitted_aliquot_review['AliquotReviewMaster']['aliquot_review_control_id'] = $review_control_data['SpecimenReviewControl']['AliquotReviewControl']['id'];
							$submitted_aliquot_review['AliquotReviewMaster']['specimen_review_master_id'] = $specimen_review_id;					
							$submitted_aliquot_review['AliquotReviewMaster']['aliquot_use_id'] = $aliquot_use_id;
							if(!$this->AliquotReviewMaster->save($submitted_aliquot_review, false)) { $this->redirect('/pages/err_inv_record_err', null, true); }
							$use_data_source->commit($this->AliquotUse);
						}
					}
					
					//---------------------------------------------------------------------------
					// 3- Old aliquot review to delete
					//---------------------------------------------------------------------------
					
					foreach($initial_aliquot_review_data_from_id as $initial_aliquot_review_to_delete) {
						
						if(array_key_exists('aliquot_masters_id', $initial_aliquot_review_to_delete['AliquotReviewMaster']) && (!empty($initial_aliquot_review_to_delete['AliquotReviewMaster']['aliquot_masters_id']))) {
							// The review was linked to an aliquot: delete aliquot use
							$aliquot_use_id_to_delete = $initial_aliquot_review_to_delete['AliquotReviewMaster']['aliquot_use_id'];
							if(!$this->AliquotUse->atim_delete($aliquot_use_id_to_delete)) { $this->redirect('/pages/err_inv_system_error', null, true); }
							$is_aliquot_use_managed = true;

							if(!$this->AliquotMaster->updateAliquotCurrentVolume($initial_aliquot_review_to_delete['AliquotReviewMaster']['aliquot_masters_id'])) { $this->redirect('/pages/err_inv_record_err', null, true); }
						}
						
						$aliquot_review_id_to_delete = $initial_aliquot_review_to_delete['AliquotReviewMaster']['id'];
						if(!$this->AliquotReviewMaster->atim_delete($aliquot_review_id_to_delete)) { $this->redirect('/pages/err_inv_system_error', null, true); }
					}	
				}				
				
				$this->atimFlash(__('your data has been saved', true).  
					($is_aliquot_use_managed? '<br>' . __('work directly on aliquot to change aliquot information (status, used volume, etc)', true): ''),
					'/inventorymanagement/specimen_reviews/detail/' . $collection_id . '/' . $sample_master_id . '/' . $specimen_review_id);	
			}
		}
	}
	
	function delete($collection_id, $sample_master_id, $specimen_review_id) {
		if ((!$collection_id) || (!$sample_master_id) || (!$specimen_review_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }		
		
		// MANAGE DATA
		
		// Get sample data
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id), 'recursive' => '-1'));
		if(empty($sample_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }	
		
		// Get specimen review data
		$criteria = array(
			'SpecimenReviewMaster.id' => $specimen_review_id, 
			'SpecimenReviewMaster.collection_id' => $collection_id, 
			'SpecimenReviewMaster.sample_master_id' => $sample_master_id);
		$specimen_review_data = $this->SpecimenReviewMaster->find('first', array('conditions' => $criteria, 'recursive' => '2'));	
		if(empty($specimen_review_data)) { $this->redirect( '/pages/err_inv_no_data', null, true ); }	
		
		// Get Aliquot Review Data
		$criteria = array(
			'AliquotReviewMaster.specimen_review_master_id' => $specimen_review_id, 
			'AliquotReviewMaster.aliquot_review_control_id' => $specimen_review_data['SpecimenReviewControl']['AliquotReviewControl']['id']);
		$aliquot_review_data_list = $this->AliquotReviewMaster->find('all', array('conditions' => $criteria));				

		// Check deletion is allowed
		$arr_allow_deletion = $this->allowSpecimeReviewDeletion($collection_id);
		
		// CUSTOM CODE
				
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }		
		
		if($arr_allow_deletion['allow_deletion']) {
			// 1- Delete aliquot review
			foreach($aliquot_review_data_list as $new_linked_review) {
				if(array_key_exists('aliquot_masters_id', $new_linked_review['AliquotReviewMaster']) && (!empty($new_linked_review['AliquotReviewMaster']['aliquot_masters_id']))) {
					// The review was linked to an aliquot: delete aliquot use
					$aliquot_use_id_to_delete = $new_linked_review['AliquotReviewMaster']['aliquot_use_id'];
					if(!$this->AliquotUse->atim_delete($aliquot_use_id_to_delete)) { $this->redirect('/pages/err_inv_system_error', null, true); }
					$is_aliquot_use_managed = true;

					if(!$this->AliquotMaster->updateAliquotCurrentVolume($new_linked_review['AliquotReviewMaster']['aliquot_masters_id'])) { $this->redirect('/pages/err_inv_record_err', null, true); }
				}
				
				$aliquot_review_id_to_delete = $new_linked_review['AliquotReviewMaster']['id'];
				if(!$this->AliquotReviewMaster->atim_delete($aliquot_review_id_to_delete)) { $this->redirect('/pages/err_inv_system_error', null, true); }	
			}
			
			// 2- Delete sample review
			if(!$this->SpecimenReviewMaster->atim_delete($specimen_review_id)) { $this->redirect('/pages/err_inv_system_error', null, true); }
				
			$this->atimFlash('your data has been deleted', '/inventorymanagement/specimen_reviews/listAll/' . $collection_id . '/' . $sample_master_id);
		} else {
			$this->flash($arr_allow_deletion['msg'], '/inventorymanagement/specimen_reviews/detail/' . $collection_id . '/' . $sample_master_id . '/' . $specimen_review_id);
		}			
	}
	
	/* --------------------------------------------------------------------------
	 * ADDITIONAL FUNCTIONS
	 * -------------------------------------------------------------------------- */
	
	/**
	 * Check if a review can be deleted.
	 * 
	 * @param $specimen_review_id Id of the studied review.
	 * 
	 * @return Return results as array:
	 * 	['allow_deletion'] = true/false
	 * 	['msg'] = message to display when previous field equals false
	 * 
	 * @author N. Luc
	 * @since 2007-10-16
	 */
	 
	function allowSpecimeReviewDeletion($specimen_review_id){
		return array('allow_deletion' => true, 'msg' => '');
	}
}

?>
