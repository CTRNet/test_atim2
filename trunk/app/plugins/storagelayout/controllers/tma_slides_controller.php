<?php

class TmaSlidesController extends StoragelayoutAppController {
	
	var $components = array('Storagelayout.Storages');
	
	var $uses = array(
		'Storagelayout.StorageMaster',
		'Storagelayout.TmaSlide',
		'Storagelayout.StorageCoordinate',
		'Storagelayout.StorageControl');
	
	var $paginate = array('TmaSlide' => array('limit' => 10,'order' => 'TmaSlide.barcode DESC'));

	/* --------------------------------------------------------------------------
	 * DISPLAY FUNCTIONS
	 * -------------------------------------------------------------------------- */	
		
	function listAll($tma_block_storage_master_id) {
		if (!$tma_block_storage_master_id) { $this->redirect('/pages/err_sto_funct_param_missing', null, true); }

		// MANAGE DATA

		// Get the storage data
		$storage_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $tma_block_storage_master_id)), null, 1);
		if(empty($storage_data)) { $this->redirect('/pages/err_sto_no_data', null, true); }	
		
		// Verify storage is tma block
		if(strcmp($storage_data['StorageControl']['is_tma_block'], 'TRUE') != 0) { $this->redirect('/pages/err_sto_system_error', null, true); }

		// Get TMA slide liste
		$this->data = $this->paginate($this->TmaSlide, array('TmaSlide.tma_block_storage_master_id' => $tma_block_storage_master_id));
		
		// MANAGE FORM, MENU AND ACTION BUTTONS

		// Get the current menu object. Needed to disable menu options based on storage type		
		$atim_menu = $this->Menus->get('/storagelayout/tma_slides/listAll/%%StorageMaster.id%%');
		
		// Inactivate Storage Coordinate Menu (unpossible for TMA type)
		$atim_menu = $this->Storages->inactivateStorageCoordinateMenu($atim_menu);
		
		$this->set('atim_menu', $atim_menu);
		$this->set('atim_menu_variables', array('StorageMaster.id' => $tma_block_storage_master_id));

		// Set structure					
		$this->Structures->set('tma_slides');
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}
	
	 function add($tma_block_storage_master_id) {
		if (!$tma_block_storage_master_id) { $this->redirect('/pages/err_sto_funct_param_missing', null, true); }

		// MANAGE DATA

		// Get the storage data
		$storage_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $tma_block_storage_master_id)));
		if(empty($storage_data)) { $this->redirect('/pages/err_sto_no_data', null, true); }	

		// Verify storage is tma block
		if(strcmp($storage_data['StorageControl']['is_tma_block'], 'TRUE') != 0) { $this->redirect('/pages/err_sto_system_error', null, true); }

		// Set list of available SOPs to build TMA slide
		$this->set('arr_tma_slide_sops', $this->getTmaSlideSopList());

		// MANAGE FORM, MENU AND ACTION BUTTONS

		// Get the current menu object. Needed to disable menu options based on storage type		
		$atim_menu = $this->Menus->get('/storagelayout/tma_slides/listAll/%%StorageMaster.id%%');
		
		// Inactivate Storage Coordinate Menu (unpossible for TMA type)
		$atim_menu = $this->Storages->inactivateStorageCoordinateMenu($atim_menu);
		
		$this->set('atim_menu', $atim_menu);
		$this->set('atim_menu_variables', array('StorageMaster.id' => $tma_block_storage_master_id));

		// Set structure					
		$this->Structures->set('tma_slides');
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		if(empty($this->data)) {
			// Set default value
			$this->set('matching_storage_list', array());

		} else {			
			// Set tma block storage master id
			$this->data['TmaSlide']['tma_block_storage_master_id'] = $tma_block_storage_master_id;
			
			// Validates data
			$submitted_data_validates = true;
			
			// Check the slide storage definition (selection label versus selected storage_master_id)
			$arr_storage_selection_results = $this->Storages->validateStorageIdVersusSelectionLabel($this->data['FunctionManagement']['recorded_storage_selection_label'], $this->data['TmaSlide']['storage_master_id']);
					
			$this->data['TmaSlide']['storage_master_id'] = $arr_storage_selection_results['selected_storage_master_id'];
			$this->set('matching_storage_list', $arr_storage_selection_results['matching_storage_list']);							
			if(!empty($arr_storage_selection_results['storage_definition_error'])) {
				$submitted_data_validates = false;
				$this->TmaSlide->validationErrors['storage_master_id'] = $arr_storage_selection_results['storage_definition_error'];		
			
			} else {
				// Check slide position within storage
				$storage_data = (empty($this->data['TmaSlide']['storage_master_id'])? null: $arr_storage_selection_results['matching_storage_list'][$this->data['TmaSlide']['storage_master_id']]);
				$arr_position_results = $this->Storages->validatePositionWithinStorage($this->data['TmaSlide']['storage_master_id'], $this->data['TmaSlide']['storage_coord_x'], $this->data['TmaSlide']['storage_coord_y'], $storage_data);
				
				// Manage errors
				if(!empty($arr_position_results['position_definition_error'])) {
					$submitted_data_validates = false;
					$error = $arr_position_results['position_definition_error'];	
					if($arr_position_results['error_on_x'] && $arr_position_results['error_on_y']) {	
						$this->TmaSlide->validationErrors['storage_coord_x'] = $error; 
						$this->TmaSlide->validationErrors['storage_coord_y'] = ' ';
					} else if($arr_position_results['error_on_x']) {
						$this->TmaSlide->validationErrors['storage_coord_x'] = $error;					
					} else if($arr_position_results['error_on_y']) {	
						$this->TmaSlide->validationErrors['storage_coord_y'] = $error;					
					}				
				}
								
				// Reset slide storage data
				$this->data['TmaSlide']['storage_coord_x'] = $arr_position_results['validated_position_x'];
				$this->data['TmaSlide']['coord_x_order'] = $arr_position_results['position_x_order'];
				$this->data['TmaSlide']['storage_coord_y'] = $arr_position_results['validated_position_y'];
				$this->data['TmaSlide']['coord_y_order'] = $arr_position_results['position_y_order'];
			}
			
			if($this->isDuplicatedTmaSlideBarcode($this->data)) {
				$submitted_data_validates = false;
			}
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }		
			
			if($submitted_data_validates) {
				// Save data	
				if ($this->TmaSlide->save($this->data)) {
					$this->flash('your data has been saved', '/storagelayout/tma_slides/listAll/' . $tma_block_storage_master_id);				
				}
			}
		}
	}
	
	function detail($tma_block_storage_master_id, $tma_slide_id, $is_tree_view_detail_form = 0) {
		if((!$tma_block_storage_master_id) || (!$tma_slide_id)) { $this->redirect('/pages/err_sto_funct_param_missing', null, true); }
		
		// MANAGE DATA

		// Get the storage data
		$storage_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $tma_block_storage_master_id)));
		if(empty($storage_data)) { $this->redirect('/pages/err_sto_no_data', null, true); }	

		// Verify storage is tma block
		if(strcmp($storage_data['StorageControl']['is_tma_block'], 'TRUE') != 0) { $this->redirect('/pages/err_sto_system_error', null, true); }
		
		// Get the tma slide data
		$tma_slide_data = $this->TmaSlide->find('first', array('conditions' => array('TmaSlide.id' => $tma_slide_id, 'TmaSlide.tma_block_storage_master_id' => $tma_block_storage_master_id)));
		if(empty($tma_slide_data)) { $this->redirect('/pages/err_sto_no_data', null, true); }		
		$this->data = $tma_slide_data; 
		
		// Set list of available SOPs to build TMA slide
		$this->set('arr_tma_slide_sops', $this->getTmaSlideSopList());

		// Define if this detail form is displayed into the children storage tree view
		$this->set('is_tree_view_detail_form', $is_tree_view_detail_form);
			
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Get the current menu object. Needed to disable menu options based on storage type		
		$atim_menu = $this->Menus->get('/storagelayout/tma_slides/listAll/%%StorageMaster.id%%');
		
		// Inactivate Storage Coordinate Menu (unpossible for TMA type)
		$atim_menu = $this->Storages->inactivateStorageCoordinateMenu($atim_menu);
		
		$this->set('atim_menu', $atim_menu);
		
		$atim_menu_variables = array();
		$atim_menu_variables['TmaSlide.id'] = $tma_slide_id;
		$atim_menu_variables['StorageMaster.id'] = $tma_block_storage_master_id;
		$this->set('atim_menu_variables', $atim_menu_variables);
		
		// Set structure					
		$this->Structures->set('tma_slides');
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }	
	}
	
	function edit($tma_block_storage_master_id, $tma_slide_id) {
		if((!$tma_block_storage_master_id) || (!$tma_slide_id)) { $this->redirect('/pages/err_sto_funct_param_missing', null, true); }

		// MANAGE DATA

		// Get the storage data
		$storage_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $tma_block_storage_master_id)));
		if(empty($storage_data)) { $this->redirect('/pages/err_sto_no_data', null, true); }	

		// Verify storage is tma block
		if(strcmp($storage_data['StorageControl']['is_tma_block'], 'TRUE') != 0) { $this->redirect('/pages/err_sto_system_error', null, true); }
		
		// Get the tma slide data
		$tma_slide_data = $this->TmaSlide->find('first', array('conditions' => array('TmaSlide.id' => $tma_slide_id, 'TmaSlide.tma_block_storage_master_id' => $tma_block_storage_master_id)));
		if(empty($tma_slide_data)) { $this->redirect('/pages/err_sto_no_data', null, true); }		

		// Set list of available SOPs to build TMA slide
		$this->set('arr_tma_slide_sops', $this->getTmaSlideSopList());
		
		// Get parent storage data
		$parent_storage_data = array();
		if(!empty($tma_slide_data['TmaSlide']['storage_master_id'])) {
			$parent_storage_data = $this->StorageMaster->atim_list(array('conditions' => array('StorageMaster.id' => $tma_slide_data['TmaSlide']['storage_master_id'])));
			if(empty($parent_storage_data)) { $this->redirect('/pages/err_sto_no_data', null, true); }	
		}
		$this->set('matching_storage_list', $parent_storage_data);			
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Get the current menu object. Needed to disable menu options based on storage type		
		$atim_menu = $this->Menus->get('/storagelayout/tma_slides/listAll/%%StorageMaster.id%%');
		
		// Inactivate Storage Coordinate Menu (unpossible for TMA type)
		$atim_menu = $this->Storages->inactivateStorageCoordinateMenu($atim_menu);
		
		$this->set('atim_menu', $atim_menu);
		
		$atim_menu_variables = array();
		$atim_menu_variables['TmaSlide.id'] = $tma_slide_id;
		$atim_menu_variables['StorageMaster.id'] = $tma_block_storage_master_id;
		$this->set('atim_menu_variables', $atim_menu_variables);
		
		// Set structure					
		$this->Structures->set('tma_slides');
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		if(empty($this->data)) {
			$this->data = $tma_slide_data;	

		} else {
			//Update data
			
			// Validates data
			$submitted_data_validates = true;
			
			// Check the slide storage definition (selection label versus selected storage_master_id)
			$arr_storage_selection_results = $this->Storages->validateStorageIdVersusSelectionLabel($this->data['FunctionManagement']['recorded_storage_selection_label'], $this->data['TmaSlide']['storage_master_id']);
					
			$this->data['TmaSlide']['storage_master_id'] = $arr_storage_selection_results['selected_storage_master_id'];
			$this->set('matching_storage_list', $arr_storage_selection_results['matching_storage_list']);							
			if(!empty($arr_storage_selection_results['storage_definition_error'])) {
				$submitted_data_validates = false;
				$this->TmaSlide->validationErrors['storage_master_id'] = $arr_storage_selection_results['storage_definition_error'];		
			
			} else {
				// Check slide position within storage
				$storage_data = (empty($this->data['TmaSlide']['storage_master_id'])? null: $arr_storage_selection_results['matching_storage_list'][$this->data['TmaSlide']['storage_master_id']]);
				$arr_position_results = $this->Storages->validatePositionWithinStorage($this->data['TmaSlide']['storage_master_id'], $this->data['TmaSlide']['storage_coord_x'], $this->data['TmaSlide']['storage_coord_y'], $storage_data);
				if(!empty($arr_position_results['position_definition_error'])) {
					$submitted_data_validates = false;
					$error = $arr_position_results['position_definition_error'];
					if($arr_position_results['error_on_x'] && $arr_position_results['error_on_y']) {	
						$this->TmaSlide->validationErrors['storage_coord_x'] = $error; 
						$this->TmaSlide->validationErrors['storage_coord_y'] = $error;
					} else if($arr_position_results['error_on_x']) {
						$this->TmaSlide->validationErrors['storage_coord_x'] = $error;					
					} else if($arr_position_results['error_on_y']) {	
						$this->TmaSlide->validationErrors['storage_coord_y'] = $error;					
					}
				}				
				$this->data['TmaSlide']['storage_coord_x'] = $arr_position_results['validated_position_x'];
				$this->data['TmaSlide']['coord_x_order'] = $arr_position_results['position_x_order'];
				$this->data['TmaSlide']['storage_coord_y'] = $arr_position_results['validated_position_y'];
				$this->data['TmaSlide']['coord_y_order'] = $arr_position_results['position_y_order'];			
			}
			
			if($this->isDuplicatedTmaSlideBarcode($this->data, $tma_slide_id)) {
				$submitted_data_validates = false;
			}
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }		

			if($submitted_data_validates) {
				// Save tma slide data
				$this->TmaSlide->id = $tma_slide_id;		
				if($this->TmaSlide->save($this->data)) { 				
					$this->flash('your data has been updated', '/storagelayout/tma_slides/detail/' . $tma_block_storage_master_id . '/' . $tma_slide_id); 
				}
			}	
		}
	}
	
	function delete($tma_block_storage_master_id, $tma_slide_id) {
		if((!$tma_block_storage_master_id) || (!$tma_slide_id)) { $this->redirect('/pages/err_sto_funct_param_missing', null, true); }

		// MANAGE DATA

		// Get the storage data
		$storage_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $tma_block_storage_master_id)));
		if(empty($storage_data)) { $this->redirect('/pages/err_sto_no_data', null, true); }	

		// Verify storage is tma block
		if(strcmp($storage_data['StorageControl']['is_tma_block'], 'TRUE') != 0) { $this->redirect('/pages/err_sto_system_error', null, true); }
		
		// Get the tma slide data
		$tma_slide_data = $this->TmaSlide->find('first', array('conditions' => array('TmaSlide.id' => $tma_slide_id, 'TmaSlide.tma_block_storage_master_id' => $tma_block_storage_master_id)));
		if(empty($tma_slide_data)) { $this->redirect('/pages/err_sto_no_data', null, true); }		

		// Check deletion is allowed
		$arr_allow_deletion = $this->allowTMASlideDeletion($tma_slide_id);
		
		// CUSTOM CODE
		
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }
		
		if($arr_allow_deletion['allow_deletion']) {
			// Delete tma slide
			if($this->TmaSlide->atim_delete($tma_slide_id)) {
				$this->flash('your data has been deleted', '/storagelayout/tma_slides/listAll/' . $tma_block_storage_master_id);
			} else {
				$this->flash('error deleting data - contact administrator', '/storagelayout/tma_slides/detail/' . $tma_block_storage_master_id . '/' . $tma_slide_id);
			}		
		} else {
			$this->flash($arr_allow_deletion['msg'], '/storagelayout/tma_slides/detail/' . $tma_block_storage_master_id . '/' . $tma_slide_id);
		}		
	}

	/* --------------------------------------------------------------------------
	 * ADDITIONAL FUNCTIONS
	 * -------------------------------------------------------------------------- */	
	
	/**
	 * Check the tma slide barcode does not already exist and set error if this one already exists.
	 * 
	 * @param $tma_slide_data TMA slide data.
	 * @param $tma_slide_id Id of the tma slide when this one is known.
	 * 
	 * @return Return true if barcode has already been set.
	 * 
	 * @author N. Luc
	 * @since 2008-02-04
	 */
	 
	function isDuplicatedTmaSlideBarcode($tma_slide_data, $tma_slide_id = null) {
		if(empty($tma_slide_data['TmaSlide']['barcode'])) {
			return false;
		}

		// Build list of TMA slide having the same barcode
		$duplicated_tma_barcodes = $this->TmaSlide->find('list', array('conditions' => array('TmaSlide.barcode' => $tma_slide_data['TmaSlide']['barcode']), 'recursive' => '-1'));

		if(empty($duplicated_tma_barcodes)) {
			// The new barcode does not exist into the db
			return false;
		} else if((!empty($tma_slide_id)) && isset($duplicated_tma_barcodes[$tma_slide_id]) && (sizeof($duplicated_tma_barcodes) == 1)) {
			// TMA slide has been created therefore and the recorded barcode is the barcode of the studied TMA slide
			return false;			
		}
		
		// The same barcode exists for at least one TMA slide different than the studied one
		$this->TmaSlide->validationErrors['barcode']	= 'barcode must be unique';
		
		return true;	
	}
	
	/**
	 * Check tma slide can be deleted.
	 * 
	 * @param $tma_slide_id Id of the tma slide when this one is known.
	 * 
	 * @return Return results as array:
	 * 	['allow_deletion'] = true/false
	 * 	['msg'] = message to display when previous field equals false
	 * 
	 * @author N. Luc
	 * @since 2009-09-14
	 */
	 
	function allowTMASlideDeletion($tma_slide_id){
		return array('allow_deletion' => true, 'msg' => '');
	}
	
	/**
	 * Get list of SOPs existing to build TMA Slide.
	 * 
	 * Note: Function to allow bank to customize this function when they don't use 
	 * SOP module.
	 *
	 * @author N. Luc
	 * @since 2009-09-11
	 * @updated N. Luc
	 */
	 
	function getTmaSlideSopList() {
		return $this->getSopList('tma_slide');
	}
	
}

?>
