<?php

class SpecimenReviewsController extends InventoryManagementAppController {

	var $components = array();
		
	var $uses = array(
		'InventoryManagement.Collection',
		'InventoryManagement.SampleMaster',
		
		'InventoryManagement.SpecimenReviewControl',
		'InventoryManagement.SpecimenReviewMaster',
		'InventoryManagement.SpecimenReviewDetail',
	
		'InventoryManagement.AliquotMaster',
		'InventoryManagement.AliquotReviewControl',
		'InventoryManagement.AliquotReviewMaster',
		'InventoryManagement.AliquotReviewDetail'
	);
	
	var $paginate = array(
		'SpecimenReviewMaster' => array('limit' => pagination_amount, 'order' => 'SpecimenReviewMaster.review_date ASC'),
		'AliquotReviewMaster' => array('limit' => pagination_amount, 'order' => 'AliquotReviewMaster.review_code DESC')
	);
	
	function listAll($collection_id, $sample_master_id){
		// MANAGE DATA
		
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id), 'recursive' => '-1'));
		if(empty($sample_data)) { 
			$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		}	
		
		$this->request->data = $this->paginate($this->SpecimenReviewMaster, array('SpecimenReviewMaster.sample_master_id'=>$sample_master_id));
		
		// Set list of available review
		$review_controls = $this->SpecimenReviewControl->find('all', array('conditions'=>array('SpecimenReviewControl.sample_control_id' => $sample_data['SampleMaster']['sample_control_id'], 'SpecimenReviewControl.flag_active' => '1' )));
		$this->set( 'review_controls', $review_controls );
		if(empty($review_controls)) { 
			$this->SpecimenReviewControl->validationErrors[]	= 'no path review exists for this type of sample'; 
		}
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('atim_menu', $this->Menus->get('/InventoryManagement/SpecimenReviews/listAll/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%'));		

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
		// MANAGE DATA
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id), 'recursive' => '-1'));
		if(empty($sample_data)) { 
			$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		}	
		
		$criteria = array(
			'SpecimenReviewControl.id' => $specimen_review_control_id, 
			'SpecimenReviewControl.sample_control_id' => $sample_data['SampleMaster']['sample_control_id'], 
			'SpecimenReviewControl.flag_active' => '1');
		$review_control_data = $this->SpecimenReviewControl->find('first', array('conditions' => $criteria, 'recursive' => '2'));	
					
		if(empty($review_control_data)) { 
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}
		
		$this->set( 'review_control_data', $review_control_data );
		
		$is_aliquot_review_defined = false;
		if(array_key_exists('flag_active', $review_control_data['AliquotReviewControl']) && $review_control_data['AliquotReviewControl']['flag_active']) { $is_aliquot_review_defined = true; }
		$this->set( 'is_aliquot_review_defined', $is_aliquot_review_defined);
		
		// Set available aliquot
		if($is_aliquot_review_defined) {
			$this->set('aliquot_list', $this->AliquotReviewMaster->getAliquotListForReview($sample_master_id, (($review_control_data['AliquotReviewControl']['aliquot_type_restriction'] == 'all')? null : $review_control_data['AliquotReviewControl']['aliquot_type_restriction'])));
		}		
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('atim_menu', $this->Menus->get('/InventoryManagement/SpecimenReviews/listAll/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%'));		

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
		if( $hook_link ) { 
			require($hook_link); 
		}
		
		if ( empty($this->request->data) ) {
			$this->request->data = NULL;
			$this->set('specimen_review_data', array());
			$this->set('aliquot_review_data', array());
			
			$hook_link = $this->hook('initial_display');
			if($hook_link){
				require($hook_link);
			}

		} else {	
			// reset array
			$specimen_review_data['SpecimenReviewMaster'] = $this->request->data['SpecimenReviewMaster'];
			$specimen_review_data['SpecimenReviewDetail'] = array_key_exists('SpecimenReviewDetail', $this->request->data)? $this->request->data['SpecimenReviewDetail'] : array();
			unset($this->request->data['SpecimenReviewMaster']);
			unset($this->request->data['SpecimenReviewDetail']);
			$aliquot_review_data = $this->request->data;
			$this->request->data = NULL;
			
			$specimen_review_data['SpecimenReviewMaster']['specimen_review_control_id'] = $specimen_review_control_id;
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
			$specimen_review_data = $this->SpecimenReviewMaster->data;
			
			// Validate aliquot review
			if($is_aliquot_review_defined) {
				$all_aliquot_review_master_errors = array();
				foreach($aliquot_review_data as &$new_aliquot_review){
					// Aliquot Review Master
					$this->AliquotReviewMaster->set($new_aliquot_review);
					$submitted_data_validates = ($this->AliquotReviewMaster->validates()) ? $submitted_data_validates : false;
					$all_aliquot_review_master_errors = array_merge($all_aliquot_review_master_errors, $this->AliquotReviewMaster->validationErrors);
					$new_aliquot_review = $this->AliquotReviewMaster->data;
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
			if( $hook_link ) { 
				require($hook_link); 
			}
			
			//LAUNCH SAVE PROCESS
			if($submitted_data_validates) {
						
				// Set additional specimen review data and save
				$specimen_review_data['SpecimenReviewMaster']['id'] = null;
				if(!$this->SpecimenReviewMaster->save($specimen_review_data, false)) { 
					$this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true); 
				}
				$specimen_review_master_id = $this->SpecimenReviewMaster->id;
				
				$studied_aliquot_master_ids = array();
				if($is_aliquot_review_defined) {
					foreach($aliquot_review_data as $new_aliquot_review) {
						// Save aliquot review
						$this->AliquotReviewMaster->id = null;
						$new_aliquot_review['AliquotReviewMaster']['id'] = null;
						$new_aliquot_review['AliquotReviewMaster']['specimen_review_master_id'] = $specimen_review_master_id;
						if(!$this->AliquotReviewMaster->save($new_aliquot_review, false)) { 
							$this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true); 
						}

						//Track aliquot to update
						if(!empty($new_aliquot_review['AliquotReviewMaster']['aliquot_master_id'])) { 
							$studied_aliquot_master_ids[] = $new_aliquot_review['AliquotReviewMaster']['aliquot_master_id']; 
						}						
					}
				}
				
				//Update aliquot use counter
				foreach($studied_aliquot_master_ids as $new_id ) {
					if(!$this->AliquotMaster->updateAliquotUseAndVolume($new_id, false, true)) { 
						$this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true); 
					}
				}	

				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) {
					require($hook_link);
				}
				$this->atimFlash(__('your data has been saved'), '/InventoryManagement/SpecimenReviews/detail/' . $collection_id . '/' . $sample_master_id . '/' . $specimen_review_master_id);	
			}
		} 
	}
	
	function detail($collection_id, $sample_master_id, $specimen_review_id) {
		
		// MANAGE DATA
		$this->request->data = NULL;
		
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id), 'recursive' => '-1'));
		if(empty($sample_data)) { 
			$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		}	
		
		// Get specimen review data
		$criteria = array(
			'SpecimenReviewMaster.id' => $specimen_review_id, 
			'SpecimenReviewMaster.collection_id' => $collection_id, 
			'SpecimenReviewMaster.sample_master_id' => $sample_master_id);
		$specimen_review_data = $this->SpecimenReviewMaster->find('first', array('conditions' => $criteria, 'recursive' => '2'));	
		if(empty($specimen_review_data)) { 
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}	
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
		
		$this->set('atim_menu', $this->Menus->get('/InventoryManagement/SpecimenReviews/listAll/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%'));		

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
		if( $hook_link ) { 
			require($hook_link); 
		}	
	}
	
	function edit($collection_id, $sample_master_id, $specimen_review_id, $undo = false) {
		// MANAGE DATA
		
		// Get sample data
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id), 'recursive' => '-1'));
		if(empty($sample_data)) { $this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); }	
		
		// Get specimen review data
		$criteria = array(
			'SpecimenReviewMaster.id' => $specimen_review_id, 
			'SpecimenReviewMaster.collection_id' => $collection_id, 
			'SpecimenReviewMaster.sample_master_id' => $sample_master_id);
		$initial_specimen_review_data = $this->SpecimenReviewMaster->find('first', array('conditions' => $criteria, 'recursive' => '2'));	
		if(empty($initial_specimen_review_data)) { $this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }	
		
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
		
		$this->set('atim_menu', $this->Menus->get('/InventoryManagement/SpecimenReviews/listAll/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%'));		

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
		if( $hook_link ) { 
			require($hook_link); 
		}	
		
		if ( empty($this->request->data) || $undo ) {
			$this->request->data = NULL;
			$this->set('specimen_review_data', $initial_specimen_review_data);
			$this->set('aliquot_review_data', $initial_aliquot_review_data_list);
			
			$hook_link = $this->hook('initial_display');
			if($hook_link){
				require($hook_link);
			}
			
		} else {
			// reset array
			$specimen_review_data['SpecimenReviewMaster'] = $this->request->data['SpecimenReviewMaster'];
			$specimen_review_data['SpecimenReviewDetail'] = array_key_exists('SpecimenReviewDetail', $this->request->data)? $this->request->data['SpecimenReviewDetail'] : array();
			unset($this->request->data['SpecimenReviewMaster']);
			unset($this->request->data['SpecimenReviewDetail']);
			$aliquot_review_data = array_values($this->request->data);//compact the array as some key might be missing
			$this->request->data = NULL;
			
			foreach($aliquot_review_data as $key => $new_aliquot_review) {
				$aliquot_review_data[$key]['AliquotReviewMaster']['aliquot_review_control_id'] = $review_control_data['SpecimenReviewControl']['AliquotReviewControl']['id'];			
			}
			
			$this->set('specimen_review_data', $specimen_review_data);
			$this->set('aliquot_review_data', $aliquot_review_data);
			
			// LAUNCH SPECIAL VALIDATION PROCESS
			// Validate specimen review
			$this->SpecimenReviewMaster->set($specimen_review_data);
			$this->SpecimenReviewMaster->id = $specimen_review_id;
			$submitted_data_validates = $this->SpecimenReviewMaster->validates();
			$specimen_review_data = $this->SpecimenReviewMaster->data;
			
			// Validate aliquot review
			if($is_aliquot_review_defined) {
				$all_aliquot_review_master_errors = array();
				foreach($aliquot_review_data as $key => $new_aliquot_review) {
					// Aliquot Review Master
					$this->AliquotReviewMaster->set($new_aliquot_review);
					$submitted_data_validates = $this->AliquotReviewMaster->validates() && $submitted_data_validates;
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
			if( $hook_link ) { 
				require($hook_link); 
			}
			
			//LAUNCH SAVE PROCESS
			if($submitted_data_validates) {
				// Set additional specimen review data and save
				$this->SpecimenReviewMaster->id = $specimen_review_id;
				if(!$this->SpecimenReviewMaster->save($specimen_review_data, false)) { 
					$this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true); 
				}
			
				if($is_aliquot_review_defined) {
					// Build aliquot review array with id = key
					$initial_aliquot_review_data_from_id = array();
					$aliquot_ids_to_update = array();
					
					foreach($initial_aliquot_review_data_list as $initial_aliquot_review) {
						$initial_aliquot_review_data_from_id[$initial_aliquot_review['AliquotReviewMaster']['id']] = array('AliquotReviewMaster' => $initial_aliquot_review['AliquotReviewMaster']);	
						
						// Track aliquot that should be udpated
						$studied_aliquot_master_id = $initial_aliquot_review['AliquotReviewMaster']['aliquot_master_id'];
						if(!empty($studied_aliquot_master_id)){
							$aliquot_ids_to_update[$studied_aliquot_master_id] = $studied_aliquot_master_id;
						}
					}
					
					// Launch process to update/create/delete aliquot review
					foreach($aliquot_review_data as $key => $submitted_aliquot_review) {
						// Track aliquot that should be udpated
						$studied_aliquot_master_id = $submitted_aliquot_review['AliquotReviewMaster']['aliquot_master_id'];
						if(!empty($studied_aliquot_master_id)){
							$aliquot_ids_to_update[$studied_aliquot_master_id] = $studied_aliquot_master_id;						
						}
						
						if(isset($initial_aliquot_review_data_from_id[$submitted_aliquot_review['AliquotReviewMaster']['id']])) {
					
							//---------------------------------------------------------------------------
							// 1- Existing aliquot review to update
							//---------------------------------------------------------------------------
								
							$aliquot_review_id = $submitted_aliquot_review['AliquotReviewMaster']['id'];
							$initial_aliquot_review = $initial_aliquot_review_data_from_id[$aliquot_review_id];
							unset($initial_aliquot_review_data_from_id[$aliquot_review_id]);
														
							$this->AliquotReviewMaster->id = $aliquot_review_id;
							if(!$this->AliquotReviewMaster->save($submitted_aliquot_review, false)) { 
								$this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true); 
							}

						}else{
							
							//---------------------------------------------------------------------------
							// 2- New aliquot review to create
							//---------------------------------------------------------------------------
							
							$this->AliquotReviewMaster->id = null;
							$submitted_aliquot_review['AliquotReviewMaster']['id'] = null;
							$submitted_aliquot_review['AliquotReviewMaster']['aliquot_review_control_id'] = $review_control_data['SpecimenReviewControl']['AliquotReviewControl']['id'];
							$submitted_aliquot_review['AliquotReviewMaster']['specimen_review_master_id'] = $specimen_review_id;					
							if(!$this->AliquotReviewMaster->save($submitted_aliquot_review, false)) { 
								$this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true); 
							}
						}
					}
					
					//---------------------------------------------------------------------------
					// 3- Old aliquot review to delete
					//---------------------------------------------------------------------------
					
					foreach($initial_aliquot_review_data_from_id as $initial_aliquot_review_to_delete) {				
						$aliquot_review_id_to_delete = $initial_aliquot_review_to_delete['AliquotReviewMaster']['id'];
						if(!$this->AliquotReviewMaster->atimDelete($aliquot_review_id_to_delete)) { 
							$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
						}
					}

					//---------------------------------------------------------------------------
					// 4- Update aliquot master data
					//---------------------------------------------------------------------------
					foreach($aliquot_ids_to_update as $aliq_id) {
						if(!$this->AliquotMaster->updateAliquotUseAndVolume($aliq_id, false, true)) { 
							$this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true); 
						}
					}
				}				
				
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) {
					require($hook_link);
				}
				$this->atimFlash(__('your data has been saved'), '/InventoryManagement/SpecimenReviews/detail/' . $collection_id . '/' . $sample_master_id . '/' . $specimen_review_id);	
			}
		}
	}
	
	function delete($collection_id, $sample_master_id, $specimen_review_id) {
		// MANAGE DATA
		
		// Get sample data
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id), 'recursive' => '-1'));
		if(empty($sample_data)) { $this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); }	
		
		// Get specimen review data
		$criteria = array(
			'SpecimenReviewMaster.id' => $specimen_review_id, 
			'SpecimenReviewMaster.collection_id' => $collection_id, 
			'SpecimenReviewMaster.sample_master_id' => $sample_master_id);
		$specimen_review_data = $this->SpecimenReviewMaster->find('first', array('conditions' => $criteria, 'recursive' => '2'));	
		if(empty($specimen_review_data)) { $this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }	
		
		// Get Aliquot Review Data
		$criteria = array('AliquotReviewMaster.specimen_review_master_id' => $specimen_review_id);
		$aliquot_review_data_list = $this->AliquotReviewMaster->find('all', array('conditions' => $criteria));				

		// Check deletion is allowed
		$arr_allow_deletion = $this->SpecimenReviewMaster->allowDeletion($specimen_review_id);
		
		// CUSTOM CODE
				
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }		
		
		if($arr_allow_deletion['allow_deletion']) {
			$aliquot_ids_to_update = array();
			
			// 1- Delete aliquot review
			foreach($aliquot_review_data_list as $new_linked_review) {
				// Track aliquot that should be udpated
				$studied_aliquot_master_id = $new_linked_review['AliquotReviewMaster']['aliquot_master_id'];
				if(!empty($studied_aliquot_master_id)) $aliquot_ids_to_update[$studied_aliquot_master_id] = $studied_aliquot_master_id;
						
				$aliquot_review_id_to_delete = $new_linked_review['AliquotReviewMaster']['id'];
				if(!$this->AliquotReviewMaster->atimDelete($aliquot_review_id_to_delete)) { $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); }	
			}
			
			// 2- Update aliquot master
			foreach($aliquot_ids_to_update as $aliq_id) {
				if(!$this->AliquotMaster->updateAliquotUseAndVolume($aliq_id, false, true)) { $this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true); }
			}
					
			// 3- Delete sample review
			if(!$this->SpecimenReviewMaster->atimDelete($specimen_review_id)) { $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); }
				
			$this->atimFlash('your data has been deleted', '/InventoryManagement/SpecimenReviews/listAll/' . $collection_id . '/' . $sample_master_id);
		} else {
			$this->flash($arr_allow_deletion['msg'], '/InventoryManagement/SpecimenReviews/detail/' . $collection_id . '/' . $sample_master_id . '/' . $specimen_review_id);
		}			
	}
}

?>
