<?php

class TmaSlidesController extends StoragelayoutAppController {
	
	var $components = array('Storagelayout.Storages');
	
	var $uses = array(
		'Storagelayout.StorageMaster',
		'Storagelayout.TmaSlide',
		'Storagelayout.StorageCoordinate',
		'Storagelayout.StorageControl');
	
	var $paginate = array('TmaSlide' => array('limit' => pagination_amount,'order' => 'TmaSlide.barcode DESC'));

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
		$atim_menu = $this->inactivateStorageCoordinateMenu($atim_menu);
		
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

		// MANAGE FORM, MENU AND ACTION BUTTONS

		// Get the current menu object. Needed to disable menu options based on storage type		
		$atim_menu = $this->Menus->get('/storagelayout/tma_slides/listAll/%%StorageMaster.id%%');
		
		// Inactivate Storage Coordinate Menu (unpossible for TMA type)
		$atim_menu = $this->inactivateStorageCoordinateMenu($atim_menu);
		
		$this->set('atim_menu', $atim_menu);
		$this->set('atim_menu_variables', array('StorageMaster.id' => $tma_block_storage_master_id));

		// Set structure					
		$this->Structures->set('tma_slides');
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		if(!empty($this->data)) {
			// Set tma block storage master id
			$this->data['TmaSlide']['tma_block_storage_master_id'] = $tma_block_storage_master_id;
			
			// Validates data
			$submitted_data_validates = true;
			
			$this->TmaSlide->set($this->data);
			if(!$this->TmaSlide->validates()){
				$submitted_data_validates = false;
			}
			
			// Reste data to get position data
			$this->data = $this->TmaSlide->data;
				
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }		
			
			if($submitted_data_validates) {
				// Save data	
				if ($this->TmaSlide->save($this->data, false)) {
					$this->atimFlash('your data has been saved', '/storagelayout/tma_slides/listAll/' . $tma_block_storage_master_id);				
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
		
		// Define if this detail form is displayed into the children storage tree view
		$this->set('is_tree_view_detail_form', $is_tree_view_detail_form);
			
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Get the current menu object. Needed to disable menu options based on storage type		
		$atim_menu = $this->Menus->get('/storagelayout/tma_slides/listAll/%%StorageMaster.id%%');
		
		// Inactivate Storage Coordinate Menu (unpossible for TMA type)
		$atim_menu = $this->inactivateStorageCoordinateMenu($atim_menu);
		
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

		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Get the current menu object. Needed to disable menu options based on storage type		
		$atim_menu = $this->Menus->get('/storagelayout/tma_slides/listAll/%%StorageMaster.id%%');
		
		// Inactivate Storage Coordinate Menu (unpossible for TMA type)
		$atim_menu = $this->inactivateStorageCoordinateMenu($atim_menu);
		
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
			$tma_slide_data['FunctionManagement']['recorded_storage_selection_label'] = $this->StorageMaster->getStorageLabelAndCodeForDisplay(array('StorageMaster' => $tma_slide_data['StorageMaster']));
			$this->data = $tma_slide_data;
			
		} else {
			//Update data
			
			// Validates data
			$submitted_data_validates = true;
			
			$this->data['TmaSlide']['id'] = $tma_slide_id;
			$this->TmaSlide->set($this->data);
			if(!$this->TmaSlide->validates()){
				$submitted_data_validates = false;
			}
			
			// Reste data to get position data
			$this->data = $this->TmaSlide->data;
						
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }		

			if($submitted_data_validates) {
				// Save tma slide data
				$this->TmaSlide->id = $tma_slide_id;		
				if($this->TmaSlide->save($this->data, false)) { 				
					$this->atimFlash('your data has been updated', '/storagelayout/tma_slides/detail/' . $tma_block_storage_master_id . '/' . $tma_slide_id); 
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
				$this->atimFlash('your data has been deleted', '/storagelayout/tma_slides/listAll/' . $tma_block_storage_master_id);
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
	
}

?>
