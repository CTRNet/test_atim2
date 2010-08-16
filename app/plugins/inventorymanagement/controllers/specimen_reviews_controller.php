<?php

class SpecimenReviewsController extends InventoryManagementAppController {
	
	var $uses = array(
		'Inventorymanagement.Collection',
		'Inventorymanagement.SampleMaster',
//		'Inventorymanagement.AliquotMaster',
		
		'Inventorymanagement.SpecimenReviewControl',
		'Inventorymanagement.SpecimenReviewMaster',
		'Inventorymanagement.SpecimenReviewDetail',
		'Inventorymanagement.AliquotReviewControl',
		'Inventorymanagement.AliquotReviewMaster',
		'Inventorymanagement.AliquotReviewDetail',
		'Inventorymanagement.AliquotUse'
	);
	
	var $paginate = array('SpecimenReviewMaster' => array('limit' => pagination_amount, 'order' => 'SpecimenReviewMaster.review_date ASC'));
	
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
		if(isset($review_control_data['AliquotReviewControl']['flag_active']) && $review_control_data['AliquotReviewControl']['flag_active']) { $is_aliquot_review_defined = true; }
		$this->set( 'is_aliquot_review_defined', $is_aliquot_review_defined);
		
		// Set available aliquot
		if($is_aliquot_review_defined) {
			$this->set('aliquot_list', $this->AliquotReviewMaster->getAliquotListForReview(true, $sample_master_id, (($review_control_data['AliquotReviewControl']['aliquot_type_restriction'] == 'all')? null : $review_control_data['AliquotReviewControl']['aliquot_type_restriction'])));
		}		
		
		// Set default data
		$specimen_review_data = array();
		$new_string = __('new', true);
		$aliquot_review_data = array(array('AliquotReviewMaster' => array('id' => $new_string)));
		
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
			$this->set('specimen_review_data', $specimen_review_data);
			$this->set('aliquot_review_data', $aliquot_review_data);

		} else {
	
			// reset array
			$specimen_review_data['SpecimenReviewMaster'] = $this->data['SpecimenReviewMaster'];
			$specimen_review_data['SpecimenReviewDetail'] = $this->data['SpecimenReviewDetail'];
			unset($this->data['SpecimenReviewMaster']);
			unset($this->data['SpecimenReviewDetail']);
			$aliquot_review_data = $this->data;
			$this->data = NULL;
			$this->set('specimen_review_data', $specimen_review_data);
			$this->set('aliquot_review_data', $aliquot_review_data);	
						
			// LAUNCH SPECIAL VALIDATION PROCESS
			$submitted_data_validates = true;
			
			// Validate specimen review
			$this->SpecimenReviewMaster->set($specimen_review_data);
			$submitted_data_validates = ($this->SpecimenReviewMaster->validates())? $submitted_data_validates: false;

pr('BUG FIX: Remove validates on Detail when bug #955 will be fixed... ');
			$this->SpecimenReviewDetail->set($specimen_review_data);
			$submitted_data_validates = ($this->SpecimenReviewDetail->validates())? $submitted_data_validates: false;
			
			// Validate aliquot review
			if($is_aliquot_review_defined) {
				$errors = array();
				foreach($aliquot_review_data as $key => $new_aliquot_review) {
					// Aliquot Review Master
					$this->AliquotReviewMaster->set($new_aliquot_review);
					$submitted_data_validates = ($this->AliquotReviewMaster->validates())? $submitted_data_validates: false;			
					foreach($this->AliquotReviewMaster->validationErrors as $key => $value) {
						$errors['AliquotReviewMaster'][$key] = $value;
					}
					
					// Aliquot Review Detail
					$this->AliquotReviewDetail->set($new_aliquot_review);
					$submitted_data_validates = ($this->AliquotReviewDetail->validates())? $submitted_data_validates: false;			
					foreach($this->AliquotReviewDetail->validationErrors as $key => $value) {
						$errors['AliquotReviewDetail'][$key] = $value;
					}
				}
				if(!empty($errors)) {
					foreach($errors as $model => $model_errors) {
						foreach($model_errors as $field => $error_message) {
							$this->{$model}->validationErrors[$field] = $error_message;
						}					
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
				$specimen_review_data['SpecimenReviewMaster']['specimen_review_control_id'] = $specimen_review_control_id;
				$specimen_review_data['SpecimenReviewMaster']['specimen_sample_type'] = $review_control_data['SpecimenReviewControl']['specimen_sample_type'];
				$specimen_review_data['SpecimenReviewMaster']['review_type'] = $review_control_data['SpecimenReviewControl']['review_type'];
				$specimen_review_data['SpecimenReviewMaster']['collection_id'] = $collection_id;
				$specimen_review_data['SpecimenReviewMaster']['sample_master_id'] = $sample_master_id;
				if(!$this->SpecimenReviewMaster->save($specimen_review_data, false)) { $this->redirect('/pages/err_inv_record_err', null, true); }
				$specimen_review_master_id = $this->SpecimenReviewMaster->id;
				
				if($is_aliquot_review_defined) {
					// Set additional aliquot review data and save
					foreach($aliquot_review_data as $key => $new_aliquot_review) {
						// 1- Save aliquot use... won't save used volume
						$aliquot_use_id = null;
						if(isset($new_aliquot_review['AliquotReviewMaster']['aliquot_masters_id']) && (!empty($new_aliquot_review['AliquotReviewMaster']['aliquot_masters_id']))) {
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
						}
						
						// 2- Save aliquot review
						$this->AliquotReviewMaster->id = null;
						$new_aliquot_review['AliquotReviewMaster']['id'] = null;
						$new_aliquot_review['AliquotReviewMaster']['aliquot_review_control_id'] = $review_control_data['AliquotReviewControl']['id'];
						$new_aliquot_review['AliquotReviewMaster']['specimen_review_master_id'] = $specimen_review_master_id;					
						$new_aliquot_review['AliquotReviewMaster']['aliquot_use_id'] = $aliquot_use_id;
						if(!$this->AliquotReviewMaster->save($new_aliquot_review, false)) { $this->redirect('/pages/err_inv_record_err', null, true); }
					}
				}
				
				$this->atimFlash(__('your data has been saved', true). ' ' . __('please update volume directly into aliquot use if required', true), '/inventorymanagement/specimen_reviews/listAll/' . $collection_id . '/' . $sample_master_id);	
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
		if(isset($specimen_review_data['SpecimenReviewControl']['AliquotReviewControl']['flag_active']) && $specimen_review_data['SpecimenReviewControl']['AliquotReviewControl']['flag_active']) { $is_aliquot_review_defined = true; }
		$this->set( 'is_aliquot_review_defined', $is_aliquot_review_defined);
		
		// Get Aliquot Review Data
		if($is_aliquot_review_defined) {
			$criteria = array(
				'AliquotReviewMaster.specimen_review_master_id' => $specimen_review_id, 
				'AliquotReviewMaster.aliquot_review_control_id' => $specimen_review_data['SpecimenReviewControl']['AliquotReviewControl']['id']);
			$aliquot_review_data = $this->AliquotReviewMaster->find('all', array('conditions' => $criteria));				
			$this->set('aliquot_review_data', $aliquot_review_data);
			
			// Set available aliquot
			$this->set('aliquot_list', $this->AliquotReviewMaster->getAliquotListForReview(true, $sample_master_id, (($specimen_review_data['SpecimenReviewControl']['AliquotReviewControl']['aliquot_type_restriction'] == 'all')? null : $specimen_review_data['SpecimenReviewControl']['AliquotReviewControl']['aliquot_type_restriction'])));
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
	
	function edit() {
		$this->atimFlash('under development', '/inventorymanagement/specimen_reviews/listAll/' . $collection_id . '/' . $sample_master_id);		
	}
	
	function delete() {
		$this->atimFlash('under development', '/inventorymanagement/specimen_reviews/listAll/' . $collection_id . '/' . $sample_master_id);		
	}
}

?>
