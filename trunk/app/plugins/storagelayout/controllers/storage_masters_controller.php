<?php

class StorageMastersController extends StoragelayoutAppController {

	var $components = array('Storagelayout.Storages');
	
	var $uses = array(
		'Storagelayout.StorageMaster',
		'Storagelayout.StorageControl',
		'Storagelayout.StorageCoordinate',
		'Storagelayout.TmaSlide',
		'Storagelayout.StorageCoordinate',
		'Inventorymanagement.AliquotMaster');
	
	var $paginate = array('StorageMaster' => array('limit' => 10, 'order' => 'StorageMaster.selection_label ASC'));

	/* --------------------------------------------------------------------------
	 * DISPLAY FUNCTIONS
	 * -------------------------------------------------------------------------- */
	 
	function index() {
		// clear SEARCH criteria
		$_SESSION['ctrapp_core']['search'] = null; 
		
		// set variables to display on view
		$this->set('storage_list', $this->Storages->getStorageList());	
		
		//find all storage control types to build add button
		$this->set('storage_controls_list', $this->StorageControl->find('all', array('conditions' => array('StorageControl.status' => 'active'))));
	}
		
	function search() {
		$this->set('atim_menu', $this->Menus->get('/storagelayout/storage_masters/index/'));
		
		if($this->data) $_SESSION['ctrapp_core']['search']['criteria'] = $this->Structures->parse_search_conditions();
		
		$this->data = $this->paginate($this->StorageMaster, $_SESSION['ctrapp_core']['search']['criteria']);
		
		//find all storage control types to build add button
		$this->set('storage_controls_list', $this->StorageControl->find('all', array('conditions' => array('StorageControl.status' => 'active'))));
		
		// if SEARCH form data, save number of RESULTS and URL
		$_SESSION['ctrapp_core']['search']['results'] = $this->params['paging']['StorageMaster']['count'];
		$_SESSION['ctrapp_core']['search']['url'] = '/storagelayout/storage_masters/search';
	}
	
	function detail($storage_master_id, $is_tree_view_detail_form = 0, $storage_category = null) {
		// Note: The $storage_category variable is not really used.
		//       Just added to parameters list to be consistent with use_link set into menu table
		//       for TMA.
		
		if(!$storage_master_id) { $this->redirect('/pages/err_sto_no_stor_id', null, true); }
		
		// MANAGE DATA
		
		// Get the storage data
		$storage_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $storage_master_id)));
		if(empty($storage_data)) { $this->redirect('/pages/err_sto_no_stor_data', null, true); }		
		$this->data = $storage_data;
		
		$this->setStorageCoordinateValues(array('StorageControl' => $storage_data['StorageControl']));

		// Get parent storage information
		$parent_storage_id = $storage_data['StorageMaster']['parent_id'];
		$parent_storage_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $parent_storage_id)));
		if(!empty($parent_storage_id) && empty($parent_storage_data)) { $this->redirect('/pages/err_sto_no_stor_data', null, true); }	
		$this->set('parent_storage_data', $parent_storage_data);	
		
		$storage_path_data = $this->Storages->getStoragePathData($parent_storage_id);
		$this->set('storage_path_data', (empty($storage_path_data)? array():$storage_path_data));
		
		// Set list of available SOPs to build TMA
		if(strcmp($storage_data['StorageControl']['is_tma_block'], 'TRUE') == 0) {	
			$this->set('arr_tma_sops', $this->getTmaSopList());
		}
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Get the current menu object. Needed to disable menu options based on storage type
		$atim_menu = null;
		$is_tma = false;
		if(strcmp($storage_data['StorageControl']['is_tma_block'], 'TRUE') == 0) {
			// TMA menu
			$atim_menu = $this->Menus->get('/storagelayout/storage_masters/detail/%%StorageMaster.id%%/0/TMA');
			$atim_menu = $this->Storages->inactivateChildrenStorageMenu($atim_menu);
			$is_tma = true;
		} else {
			$atim_menu = $this->Menus->get('/storagelayout/storage_masters/detail/%%StorageMaster.id%%');
		}
		
		if(!$this->Storages->allowCustomCoordinates($storage_data['StorageControl']['id'], array('StorageControl' => $storage_data['StorageControl']))) {
			// Check storage supports custom coordinates and disable access to coordinates menu option if required
			$atim_menu = $this->Storages->inactivateStorageCoordinateMenu($atim_menu);
		}
					
		if(empty($storage_data['StorageControl']['coord_x_type'])) {
			// Check storage supports coordinates and disable access to storage layout menu option if required
			$atim_menu = $this->Storages->inactivateStorageLayoutMenu($atim_menu);
		}
		
		$this->set('atim_menu', $atim_menu);
		$this->set('atim_menu_variables', array('StorageMaster.id' => $storage_master_id));

		// Set structure				
		$this->set('atim_structure', $this->Structures->get('form', $storage_data['StorageControl']['form_alias']));

		// Set boolean
		$this->set('is_tma', $is_tma);		

		// Define if this detail form is displayed into the children storage tree view
		$this->set('is_tree_view_detail_form', $is_tree_view_detail_form);
		
		// Get all storage control types to build the add to selected button
		$this->set('storage_controls_list', $this->StorageControl->find('all', array('conditions' => array('StorageControl.status' => 'active'))));

		// MANAGE FORM TO DEFINE STORAGE POSITION INTO PARENT (SECOND FORM)
		
		$bool_define_position = false;
		$parent_coord_x_title = null;
		$parent_coord_y_title = null;
		
		if((!empty($parent_storage_id)) && (!is_null($parent_storage_data['StorageControl']['form_alias_for_children_pos']))) {
			// storage position can be set within the parent storage
			$bool_define_position = true;

			// set structure				
			$this->set('atim_structure_for_position', $this->Structures->get('form', $parent_storage_data['StorageControl']['form_alias_for_children_pos']));
						
			// set data to display on view
			$parent_coord_x_title = $parent_storage_data['StorageControl']['coord_x_title'];
			$parent_coord_y_title = $parent_storage_data['StorageControl']['coord_y_title'];
		}
		
		$this->set('parent_coord_x_title', $parent_coord_x_title);
		$this->set('parent_coord_y_title', $parent_coord_y_title);		
		$this->set('bool_define_position', $bool_define_position);
	}	
	
	function add($storage_control_id, $predefined_parent_storage_id = null) {
		if(!$storage_control_id) { $this->redirect('/pages/err_sto_no_stor_cont_id', null, true); }
		
		// MANAGE DATA
		
		$storage_control_data = $this->StorageControl->find('first', array('conditions' => array('StorageControl.id' => $storage_control_id)));
		if(empty($storage_control_data)) { $this->redirect('/pages/err_sto_no_stor_cont_data', null, true); }	
	
		$this->set('storage_type', $storage_control_data['StorageControl']['storage_type']);		
		$this->setStorageCoordinateValues($storage_control_data);
		
		// Set parent storage list for selection
		$available_parent_storage_list = array(); 
		if(is_null($predefined_parent_storage_id)) { 
			$available_parent_storage_list = $this->Storages->getStorageList();
		} else {
			$predefined_parent_storage_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $predefined_parent_storage_id, 'StorageControl.is_tma_block' => 'FALSE')));
			if(empty($predefined_parent_storage_data)) { $this->redirect('/pages/err_sto_no_stor_data', null, true); }		
			$available_parent_storage_list[$predefined_parent_storage_id] = $predefined_parent_storage_data;
		}
		$this->set('available_parent_storage_list', $available_parent_storage_list);	
		
		// Set list of available SOPs to build TMA
		if(strcmp($storage_control_data['StorageControl']['is_tma_block'], 'TRUE') == 0) {	
			$this->set('arr_tma_sops', $this->getTmaSopList());
		}

		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Set menu
		$atim_menu = $this->Menus->get('/storagelayout/storage_masters/index/');		
		$this->set('atim_menu', $atim_menu);
		$this->set('atim_menu_variables', array('StorageControl.id' => $storage_control_id));
		
		// set structure alias based on VALUE from CONTROL table
		$this->set('atim_structure', $this->Structures->get('form', $storage_control_data['StorageControl']['form_alias']));
	
		// MANAGE DATA RECORD
			
		if(!empty($this->data)) {	
			
			//Get Parent Data
			$parent_storage_data = null;
			if(!empty($this->data['StorageMaster']['parent_id'])) {
				$parent_storage_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $this->data['StorageMaster']['parent_id'])));
				if(empty($parent_storage_data)) { $this->redirect('/pages/err_sto_no_stor_data', null, true); }	
			}
			
			// Set control ID en type
			$this->data['StorageMaster']['storage_control_id'] = $storage_control_data['StorageControl']['id'];
			$this->data['StorageMaster']['storage_type'] = $storage_control_data['StorageControl']['storage_type'];			
			
			// Set storage temperature information
			$this->data['StorageMaster']['set_temperature'] = $storage_control_data['StorageControl']['set_temperature'];
				
			if((strcmp($storage_control_data['StorageControl']['set_temperature'], 'FALSE') == 0) && (!empty($parent_storage_data))) {
				// Define storage surrounding temperature based on selected parent temperature
				$this->data['StorageMaster']['temperature'] = $parent_storage_data['StorageMaster']['temperature'];
				$this->data['StorageMaster']['temp_unit'] = $parent_storage_data['StorageMaster']['temp_unit'];
			}				
			
			// Set selection label
			$this->data['StorageMaster']['selection_label'] = $this->getStorageSelectionLabel($this->data);	

			// Validates data
			$submitted_data_validates = true;

			if($this->IsDuplicatedStorageBarCode($this->data)) { $submitted_data_validates = false; }
			
			if($submitted_data_validates) {
				// Save storage data
				$bool_save_done = true;
				
				$storage_master_id = null;
				if($this->StorageMaster->save($this->data)) {
					$storage_master_id = $this->StorageMaster->getLastInsertId();
				} else {
					$bool_save_done = false;
				}
				
				// Create storage code
				if($bool_save_done) {
					$storage_data_to_update = array();
					$storage_data_to_update['StorageMaster']['code'] = $this->createStorageCode($storage_master_id, $this->data, $storage_control_data);

					$this->StorageMaster->id = $storage_master_id;					
					if(!$this->StorageMaster->save($storage_data_to_update)) {
						$bool_save_done = false;
					}
				}
					
				if($bool_save_done) {
					$link = '';
					if(empty($parent_storage_data) || is_null($parent_storage_data['StorageControl']['form_alias_for_children_pos'])){
						// No position has to be set for this storage
						$link = '/storagelayout/storage_masters/detail/' . $storage_master_id;
					} else {
						$link = '/storagelayout/storage_masters/editStoragePosition/' . $storage_master_id;
					}
					$this->flash('Your data has been saved . ', $link);				
				}						
			}
		}		
	}
			
	function edit($storage_master_id) {
		if(!$storage_master_id) { $this->redirect('/pages/err_sto_no_stor_id', null, true); }
		
		// MANAGE DATA

		// Get the storage data
		$storage_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $storage_master_id)));
		if(empty($storage_data)) { $this->redirect('/pages/err_sto_no_stor_data', null, true); }

		$this->setStorageCoordinateValues(array('StorageControl' => $storage_data['StorageControl']));

		// Set parent storage list for selection
		$this->set('available_parent_storage_list', $this->Storages->getStorageList($storage_master_id));

		// Set list of available SOPs to build TMA
		if(strcmp($storage_data['StorageControl']['is_tma_block'], 'TRUE') == 0) {	
			$this->set('arr_tma_sops', $this->getTmaSopList());
		}	
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Get the current menu object. Needed to disable menu options based on storage type
		$atim_menu = null;
		if(strcmp($storage_data['StorageControl']['is_tma_block'], 'TRUE') == 0) {
			// TMA menu
			$atim_menu = $this->Menus->get('/storagelayout/storage_masters/detail/%%StorageMaster.id%%/0/TMA');
			$atim_menu = $this->Storages->inactivateChildrenStorageMenu($atim_menu);
		} else {
			$atim_menu = $this->Menus->get('/storagelayout/storage_masters/detail/%%StorageMaster.id%%');
		}
		
		if(!$this->Storages->allowCustomCoordinates($storage_data['StorageControl']['id'], array('StorageControl' => $storage_data['StorageControl']))) {
			// Check storage supports custom coordinates and disable access to coordinates menu option if required
			$atim_menu = $this->Storages->inactivateStorageCoordinateMenu($atim_menu);
		}
					
		if(empty($storage_data['StorageControl']['coord_x_type'])) {
			// Check storage supports coordinates and disable access to storage layout menu option if required
			$atim_menu = $this->Storages->inactivateStorageLayoutMenu($atim_menu);
		}

		$this->set('atim_menu', $atim_menu);
		$this->set('atim_menu_variables', array('StorageMaster.id' => $storage_master_id));

		// Set structure				
		$this->set('atim_structure', $this->Structures->get('form', $storage_data['StorageControl']['form_alias']));

		// MANAGE DATA RECORD

		if(empty($this->data)) {
				$this->data = $storage_data;	
		} else {
			//Update data

			//Get Parent Data
			$parent_storage_data = null;
			if(!empty($this->data['StorageMaster']['parent_id'])) {
				$parent_storage_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $this->data['StorageMaster']['parent_id'])));
				if(empty($parent_storage_data)) { $this->redirect('/pages/err_sto_no_stor_data', null, true); }	
			}

			// Define parent storage has been modified
			$is_new_parent_storage = ($this->data['StorageMaster']['parent_id'] !== $storage_data['StorageMaster']['parent_id'])? true : false;
			
			// Update selection label
			$this->data['StorageMaster']['selection_label'] = $this->getStorageSelectionLabel($this->data);

			// Update storage surrounding temperature
			if(((strcmp($storage_data['StorageControl']['set_temperature'], 'FALSE')) == 0) && $is_new_parent_storage) {
				// Parent storage has changed: Manage surrounding temperature
				if(empty($parent_storage_data)) {
					$this->data['StorageMaster']['temperature'] = null;
					$this->data['StorageMaster']['temp_unit'] = null;						
				} else {
					// Define storage surrounding temperature based on selected parent temperature
					$this->data['StorageMaster']['temperature'] = $parent_storage_data['StorageMaster']['temperature'];
					$this->data['StorageMaster']['temp_unit'] = $parent_storage_data['StorageMaster']['temp_unit'];						
				}
			}	
				
			// Update parent storage coordinate values				
			if($is_new_parent_storage){
				// Parent storage has been changed, delete coordinate values
				$this->data['StorageMaster']['parent_storage_coord_x'] = null;
				$this->data['StorageMaster']['coord_x_order'] = null;
				$this->data['StorageMaster']['parent_storage_coord_y'] = null;
				$this->data['StorageMaster']['coord_y_order'] = null;
			}

			// Save storage data
			$this->StorageMaster->id = $storage_master_id;		
			if($this->StorageMaster->save($this->data)) { 
				// Manage children temperature
				$storage_temperature = (array_key_exists('temperature', $this->data['StorageMaster']))? $this->data['StorageMaster']['temperature'] : $storage_data['StorageMaster']['temperature'];
				$storage_temp_unit = (array_key_exists('temp_unit', $this->data['StorageMaster']))? $this->data['StorageMaster']['temp_unit'] : $storage_data['StorageMaster']['temp_unit'];
				$this->updateChildrenSurroundingTemperature($storage_master_id, $storage_temperature, $storage_temp_unit);
				
				// Manage children selection label
				if(strcmp($this->data['StorageMaster']['selection_label'], $storage_data['StorageMaster']['selection_label']) != 0) {	
					$this->updateChildrenStorageSelectionLabel($storage_master_id, $this->data);
				}		
				
				// Redirect user to new page
				$link = '/storagelayout/storage_masters/detail/' . $storage_master_id;
				if($is_new_parent_storage){
					// Parent has been changed
					if(empty($parent_storage_data) || is_null($parent_storage_data['StorageControl']['form_alias_for_children_pos'])){
						// No position has to be set for this storage: keep usual link
					} else {
						$link = '/storagelayout/storage_masters/editStoragePosition/' . $storage_master_id;
					}					
				}			
				$this->flash('Your data has been updated . ', $link); 
			}	
		}
	}
	
	/**
	 * Create a FORM to set postion of storage within a parent storage.
	 * 
	 * @param $storage_master_id Storage master id of the storage that must be positionned.
	 * 
	 * @author N. Luc
	 * @since 2007-05-22
	 * @updated A. Suggitt
	 */
	 
	function editStoragePosition($storage_master_id) {
		if(!$storage_master_id) { $this->redirect('/pages/err_sto_no_stor_id', null, true); }
		
		// MANAGE STORAGE DATA
		
		// Get the storage data
		$storage_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $storage_master_id)));
		if(empty($storage_data)) { $this->redirect('/pages/err_sto_no_stor_data', null, true); }

		$this->setStorageCoordinateValues(array('StorageControl' => $storage_data['StorageControl']));

		// Get parent storage information
		$parent_storage_id = $storage_data['StorageMaster']['parent_id'];
		$parent_storage_data = $this->StorageMaster->find('first',array('conditions' => array('StorageMaster.id' => $parent_storage_id)));
		if(!empty($parent_storage_id) && empty($parent_storage_data)) { $this->redirect('/pages/err_sto_no_stor_data', null, true); }
		$this->set('parent_storage_data', $parent_storage_data);		
				
		if(empty($parent_storage_id) || is_null($parent_storage_data['StorageControl']['form_alias_for_children_pos'])){
			// No position has to be set for this storage
			$this->flash('The position cannot be set for this storage item', '/storagelayout/storage_masters/detail/' . $storage_master_id);					
			return;
		}

		$storage_path_data = $this->Storages->getStoragePathData($parent_storage_id);
		$this->set('storage_path_data', (empty($storage_path_data)? array():$storage_path_data));

		// Set list of available SOPs to build TMA
		if(strcmp($storage_data['StorageControl']['is_tma_block'], 'TRUE') == 0) {	
			$this->set('arr_tma_sops', $this->getTmaSopList());
		}		
		
		// MANAGE FORM, MENU AND ACTION BUTTONS	
		
		// Get the current menu object. Needed to disable menu options based on storage type
		$atim_menu = null;
		if(strcmp($storage_data['StorageControl']['is_tma_block'], 'TRUE') == 0) {
			// TMA menu
			$atim_menu = $this->Menus->get('/storagelayout/storage_masters/detail/%%StorageMaster.id%%/0/TMA');
			$atim_menu = $this->Storages->inactivateChildrenStorageMenu($atim_menu);
		} else {
			$atim_menu = $this->Menus->get('/storagelayout/storage_masters/detail/%%StorageMaster.id%%');
		}
		
		if(!$this->Storages->allowCustomCoordinates($storage_data['StorageControl']['id'], array('StorageControl' => $storage_data['StorageControl']))) {
			// Check storage supports custom coordinates and disable access to coordinates menu option if required
			$atim_menu = $this->Storages->inactivateStorageCoordinateMenu($atim_menu);
		}
		
		if(empty($storage_data['StorageControl']['coord_x_type'])) {
			// Check storage supports coordinates and disable access to storage layout menu option if required
			$atim_menu = $this->Storages->inactivateStorageLayoutMenu($atim_menu);
		}
		
		$this->set('atim_menu', $atim_menu);		
		$this->set('atim_menu_variables', array('StorageMaster.id' => $storage_master_id));
		
		// set structure				
		$this->set('atim_structure', $this->Structures->get('form', $storage_data['StorageControl']['form_alias']));
		
		// MANAGE (SECOND)FORM TO DEFINE STORAGE POSITION INTO PARENT 
		
		// Build predefined list of allowed positions
		$arr_allowed_x_position = $this->Storages->buildAllowedStoragePosition($parent_storage_data, 'x');
		$this->set('a_coord_x_list', $arr_allowed_x_position['array_to_display']);
		$arr_allowed_y_position = $this->Storages->buildAllowedStoragePosition($parent_storage_data, 'y');
		$this->set('a_coord_y_list', $arr_allowed_y_position['array_to_display']);
		
		// Set structure 				
		$this->set('atim_structure_to_set_position', $this->Structures->get('form', $parent_storage_data['StorageControl']['form_alias_for_children_pos']));
		
		// MANAGE DATA RECORD
		
		if(empty($this->data)) {
			// All the storage data (including storage position within the parent) are recorded into the master table.
			$this->data = $storage_data;
		} else { 
			// Update position
			$storage_data_to_update = array();
			if(isset($this->data['StorageMaster']['parent_storage_coord_x'])) { 		
				$storage_data_to_update['StorageMaster']['parent_storage_coord_x'] = $this->data['StorageMaster']['parent_storage_coord_x']; 
				$coord_x_order = (is_null($this->data['StorageMaster']['parent_storage_coord_x']) || ($this->data['StorageMaster']['parent_storage_coord_x'] == ''))? null: $arr_allowed_x_position['array_to_order'][$this->data['StorageMaster']['parent_storage_coord_x']];
				$storage_data_to_update['StorageMaster']['coord_x_order'] = $coord_x_order; 
			}	
			if(isset($this->data['StorageMaster']['parent_storage_coord_y'])) { 
				$storage_data_to_update['StorageMaster']['parent_storage_coord_y'] = $this->data['StorageMaster']['parent_storage_coord_y']; 
				$coord_y_order = (is_null($this->data['StorageMaster']['parent_storage_coord_y']) || ($this->data['StorageMaster']['parent_storage_coord_y'] == ''))? null: $arr_allowed_y_position['array_to_order'][$this->data['StorageMaster']['parent_storage_coord_y']];
				$storage_data_to_update['StorageMaster']['coord_y_order'] = $coord_y_order; 
			}	
			
			$this->StorageMaster->id = $storage_master_id;		
			if($this->StorageMaster->save($storage_data_to_update)) { 
				$this->flash('Your data has been updated . ', '/storagelayout/storage_masters/detail/' . $storage_master_id); 
			}	
		}
	}
	
	function delete($storage_master_id) {
		if(!$storage_master_id) { $this->redirect('/pages/err_sto_no_stor_id', null, true); }
		
		// Get the storage data
		$storage_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $storage_master_id), 'recursive' => '-1'));
		if(empty($storage_data)) { $this->redirect('/pages/err_sto_no_stor_data', null, true); }		

		// Check deletion is allowed
		$arr_allow_deletion = $this->allowStorageDeletion($storage_master_id);
	
		if($arr_allow_deletion['allow_deletion']) {
			// First remove storage from tree
			//TODO should perhaps be included into a general app function
			$this->StorageMaster->id = $storage_master_id;	
			$cleaned_storage_data = array('StorageMaster' => array('parent_id' => null));
			$this->StorageMaster->save($cleaned_storage_data);
			
			// Create has many relation to delete the storage coordinate
			$this->StorageMaster->bindModel(array('hasMany' => array('StorageCoordinate' => array('className' => 'StorageCoordinate', 'foreignKey' => 'storage_master_id', 'dependent' => true))));	
			
			// Delete storage
			if($this->StorageMaster->atim_delete($storage_master_id, true)) {
				//TODO;
				pr('to test');exit;
				$this->flash('Your data has been deleted . ', '/storagelayout/storage_masters/index/');
			} else {
				$this->flash('Error deleting data - Contact administrator . ', '/storagelayout/storage_masters/index/');
			}		
		
		} else {
			$this->flash($arr_allow_deletion['msg'], '/storagelayout/storage_masters/detail/' . $storage_master_id);
		}		
	}
	
	/**
	 * Display into a tree view the studied storage and all its children storages (recursive call)
	 * plus both aliquots and TMA slides stored into those storages starting from a specific parent storage.
	 * 
	 * @param $storage_master_id Storage master id of the studied storage that will be used as tree root.
	 * 
	 * @author N. Luc
	 * @since 2007-05-22
	 * @updated A. Suggitt
	 */
	 
	function contentTreeView($storage_master_id) {
		if(!$storage_master_id) { $this->redirect('/pages/err_sto_no_stor_id', null, true); }
			
		// MANAGE STORAGE DATA
		
		// Get the storage data
		$storage_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $storage_master_id)));
		if(empty($storage_data)) { $this->redirect('/pages/err_sto_no_stor_data', null, true); }
		$storage_content = $this->StorageMaster->find('threaded', array('conditions' => array('StorageMaster.lft >=' => $storage_data['StorageMaster']['lft'], 'StorageMaster.rght <=' => $storage_data['StorageMaster']['rght']), 'order' => 'StorageMaster.coord_x_order ASC, StorageMaster.coord_y_order ASC', 'recursive' => '-1'));
		$storage_content = $this->completeStorageContent($storage_content);
		
		$this->data = $storage_content;
						
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Get the current menu object. Needed to disable menu options based on storage type
		$atim_menu = $this->Menus->get('/storagelayout/storage_masters/contentTreeView/%%StorageMaster.id%%');
	
		if(!$this->Storages->allowCustomCoordinates($storage_data['StorageControl']['id'], array('StorageControl' => $storage_data['StorageControl']))) {
			// Check storage supports custom coordinates and disable access to coordinates menu option if required
			$atim_menu = $this->Storages->inactivateStorageCoordinateMenu($atim_menu);
		}
					
		if(empty($storage_data['StorageControl']['coord_x_type'])) {
			// Check storage supports coordinates and disable access to storage layout menu option if required
			$atim_menu = $this->Storages->inactivateStorageLayoutMenu($atim_menu);
		}

		$this->set('atim_menu', $atim_menu);
		$this->set('atim_menu_variables', array('StorageMaster.id' => $storage_master_id));

		// Set structure				
		$atim_structure = array();
		$atim_structure['StorageMaster']	= $this->Structures->get('form','storage_masters_for_storage_tree_view');
		$atim_structure['AliquotMaster']	= $this->Structures->get('form','aliquot_masters_for_storage_tree_view');
		$atim_structure['TmaSlide']	= $this->Structures->get('form','tma_slides_for_storage_tree_view');
		$this->set('atim_structure', $atim_structure);			
	}		
	
	/**
	 * Parsing a nested array gathering storages and all their children storages, the funtion will add
	 * both aliquots and TMA slides stored into each storage.
	 * 
	 * @param $storage_content Nested array gathering storages and all their children storages
	 * 
	 * @return The completed nested array
	 * 
	 * @author N. Luc
	 * @since 2009-09-13
	 */
	
	function completeStorageContent($storage_content) {
		foreach ($storage_content as $key => $new_storage) {
			
			// recursive first on existing MODEL CHILDREN
			if (isset($new_storage['children']) && count($new_storage['children'])) {
				$storage_content[$key]['children'] = $this->completeStorageContent($new_storage['children']);
			}
			
			// get OUTSIDE MODEL data and append as CHILDREN
					
			// 1-Add storage aliquots
			$this->AliquotMaster->unbindModel(array('belongsTo' => array('Collection', 'StorageMaster', 'AliquotControl')));			
			$storage_aliquots = $this->AliquotMaster->find('all', array('conditions' => array('AliquotMaster.storage_master_id' => $new_storage['StorageMaster']['id']), 'order' => 'AliquotMaster.coord_x_order ASC, AliquotMaster.coord_y_order ASC', 'recursive' => '0'));
			foreach ($storage_aliquots as $aliquot) { $storage_content[$key]['children'][] = $aliquot; }				
			
			// 2-Add storage TMA slides
			$this->TmaSlide->unbindModel(array('belongsTo' => array('StorageMaster')));		
			$storage_tma_slides = $this->TmaSlide->find('all', array('conditions' => array('TmaSlide.storage_master_id' => $new_storage['StorageMaster']['id']), 'order' => 'TmaSlide.coord_x_order ASC, TmaSlide.coord_y_order ASC'));
			foreach ($storage_tma_slides as $slide) {
				$slide['Generated']['tma_block_identification'] = $slide['Block']['barcode'];
				$storage_content[$key]['children'][] = $slide; 
			}
		}
		
		return $storage_content;
	}
	
	/**
	 * Create a FORM to allow user to either manage aliquot position or remove aliquot 
	 * from storage.
	 * 
	 * @param $storage_master_id ID of the studied storage. 
	 * 
	 * @author N. Luc
	 * @since 2007-08-20
	 */

	function editAliquotPosition($storage_master_id=null){
		if(!$storage_master_id) { $this->redirect('/pages/err_sto_no_stor_id', null, true); }
		
		// MANAGE STORAGE DATA
		
		// Get the storage data
		$storage_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $storage_master_id)));
		if(empty($storage_data)) { $this->redirect('/pages/err_sto_no_stor_data', null, true); }
		
		// Build predefined list of allowed positions
		$this->set('parent_coord_x_title', $storage_data['StorageControl']['coord_x_title']);
		$this->set('a_coord_x_list', $this->Storages->buildAllowedStoragePosition($storage_data, 'x'));
		$this->set('parent_coord_y_title', $storage_data['StorageControl']['coord_y_title']);
		$this->set('a_coord_y_list', $this->Storages->buildAllowedStoragePosition($storage_data, 'y'));

		// Search data of storage aliquots
		$a_storage_aliquot_data = $this->AliquotMaster->find('all', array('conditions' => array('AliquotMaster.storage_master_id' => $storage_master_id), 'order' => 'AliquotMaster.storage_coord_y ASC, AliquotMaster.storage_coord_x ASC', 'recursive' => '-1'));	
		if(empty($a_storage_aliquot_data)) { 
			$this->flash('no aliquot is stored into this storage', '/storagelayout/storage_masters/contentTreeView/' . $storage_master_id);  
			return;
		}
				
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Get the current menu object. Needed to disable menu options based on storage type
		$atim_menu = $this->Menus->get('/storagelayout/storage_masters/contentTreeView/%%StorageMaster.id%%');
	
		if(!$this->Storages->allowCustomCoordinates($storage_data['StorageControl']['id'], array('StorageControl' => $storage_data['StorageControl']))) {
			// Check storage supports custom coordinates and disable access to coordinates menu option if required
			$atim_menu = $this->Storages->inactivateStorageCoordinateMenu($atim_menu);
		}
					
		if(empty($storage_data['StorageControl']['coord_x_type'])) {
			// Check storage supports coordinates and disable access to storage layout menu option if required
			$atim_menu = $this->Storages->inactivateStorageLayoutMenu($atim_menu);
		}

		$this->set('atim_menu', $atim_menu);
		$this->set('atim_menu_variables', array('StorageMaster.id' => $storage_master_id));

		// Set structure 		
		$structure_alias = (is_null($storage_data['StorageControl']['form_alias_for_children_pos']))? 'manage_storage_aliquots_without_position': $storage_data['StorageControl']['form_alias_for_children_pos'] . '_for_aliquot';	
		$this->set('atim_structure', $this->Structures->get('form', $structure_alias));

		//TODO editAliquotPosition: underdevelopment
		//Becarful about position order (with integer): use order field
		$this->flash('under development', '/storagelayout/storage_masters/contentTreeView/' . $storage_master_id);
		return;
		
		// MANAGE DATA RECORD
				
		if(empty($this->data)) {
			$this->data = $a_storage_aliquot_data;
				
		} else { 
			// Update position
			$storage_data_to_update = array();
			if(isset($this->data['StorageMaster']['parent_storage_coord_x'])) { $storage_data_to_update['StorageMaster']['parent_storage_coord_x'] = $this->data['StorageMaster']['parent_storage_coord_x']; }	
			if(isset($this->data['StorageMaster']['parent_storage_coord_y'])) { $storage_data_to_update['StorageMaster']['parent_storage_coord_y'] = $this->data['StorageMaster']['parent_storage_coord_y']; }	
						
			$this->StorageMaster->id = $storage_master_id;		
			if($this->StorageMaster->save($storage_data_to_update)) { 
				$this->flash('Your data has been updated . ', '/storagelayout/storage_masters/detail/' . $storage_master_id); 
			}
			
			
						// ** Save Data **
			
			// setup MODEL(s) validation array(s) for displayed FORM 
			foreach ($this->Forms->getValidateArray($form_title) as $validate_model=>$validate_rules) {
				$this->{$validate_model}->validate = $validate_rules;
			}
			
			// set a FLAG
			$submitted_data_validates = true;
			
			// Execute Validation 
			
			foreach ($this->data as $key=>$val) {
				if (!$this->AliquotMaster->validates($val)) {
					$submitted_data_validates = false;
				}	
			}

			// look for CUSTOM HOOKS, "validation"
			$custom_ctrapp_controller_hook 
				= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
				'controllers' . DS . 'hooks' . DS . 
				$this->params['controller'] . '_' . $this->params['action'] . '_validation.php';
			
			if (file_exists($custom_ctrapp_controller_hook)) {
				require($custom_ctrapp_controller_hook);
			}
			
			if ($submitted_data_validates) {
				
				// Launch Save
				
				$bool_save_done = true;
				
				// save each ROW
				foreach ($this->data as $key=>$val) {
					
					if(strcmp($val['FunctionManagement']['remove_from_storage'], 'yes') == 0){
						// User would like to delete postion data
						$val['AliquotMaster']['storage_master_id'] = null;
						$val['AliquotMaster']['storage_coord_x'] = null;
						$val['AliquotMaster']['storage_coord_y'] = null;
					}
						
					//TODO: Update only modified records
					$val['AliquotMaster']['modified'] = date('Y-m-d G:i');
					$val['AliquotMaster']['modified_by'] = $this->othAuth->user('id');	
				
					if(!$this->AliquotMaster->save($val)){
						$bool_save_done = false;
					}
					
					if(!$bool_save_done){
						break;
					}
				}
		
				if(!$bool_save_done){
					$this->redirect('/pages/err_sto_aliquot_record_err'); 
					exit;
				} else {
					$this->flash('Your data has been updated . ',
						'/storage_masters/searchStorageAliquots/' . $storage_master_id);
				}			
			}
		}
	}	
	
	/**
	 * Create a FORM to allow user to either manage children storage position or remove children storage 
	 * from storage.
	 * 
	 * @param $storage_master_id ID of the studied storage. 
	 * 
	 * @author N. Luc
	 * @since 2007-08-20
	 */

	function editChildrenStoragePosition($storage_master_id=null){
		if(!$storage_master_id) { $this->redirect('/pages/err_sto_no_stor_id', null, true); }
		
		// MANAGE STORAGE DATA
		
		// Get the storage data
		$storage_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $storage_master_id)));
		if(empty($storage_data)) { $this->redirect('/pages/err_sto_no_stor_data', null, true); }

		//TODO editChildrenStoragePosition: underdevelopment
		$this->flash('under development', '/storagelayout/storage_masters/contentTreeView/' . $storage_master_id);
		return;	
	}
	
	/**
	 * Display the content of a storage into a layout.
	 * 
	 * @param $storage_master_id Id of the studied storage.
	 * 
	 * @author N. Luc
	 * @since 2007-05-22
	 */
	 
	function storageLayout($storage_master_id) {
		if(!$storage_master_id) { 
			$this->redirect('/pages/err_sto_no_stor_id', null, true); 
		}
		
		// MANAGE STORAGE DATA
		
		// Get the storage data
		$storage_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $storage_master_id)));
		if(empty($storage_data)) { 
			$this->redirect('/pages/err_sto_no_stor_data', null, true); 
		}
		
		if($storage_data['StorageControl']['coord_x_type'] == "list"){
			$coordinate_tmp = $this->StorageCoordinate->find('all', array('conditions' => array('StorageCoordinate.storage_master_id' => $storage_master_id), 'recursive' => '-1', 'order' => 'StorageCoordinate.order ASC'));
			foreach($coordinate_tmp as $key => $value){
				$coordinate_list[$value['StorageCoordinate']['id']]['StorageCoordinate'] = $value['StorageCoordinate'];
			} 
		}
		// Storage layout not allowed for this type of storage
		if(empty($storage_data['StorageControl']['coord_x_type'])) { 
			$this->redirect('/pages/err_sto_no_stor_layout', null, true); 
		}
		
		$storage_master_c = $this->StorageMaster->find('all', array('conditions' => array('StorageMaster.parent_id' => $storage_master_id)));
		$aliquot_master_c = $this->AliquotMaster->find('all', array('conditions' => array('AliquotMaster.storage_master_id' => $storage_master_id)));
		$tma_slide_c = $this->TmaSlide->find('all', array('conditions' => array('TmaSlide.storage_master_id' => $storage_master_id)));

		if(!empty($this->data)){		
			$data = array();
			$unclassified = array();
			$json = (json_decode($this->data));
			//have cells with id as key
			for($i = sizeof($json) - 1; $i >= 0; -- $i){
				//builds a $cell[type][id] array
				$data[$json[$i]->{'type'}][$json[$i]->{'id'}] = (array)$json[$i]; 
			}
			
			if($storage_data['StorageControl']['coord_x_type'] == "list"){
				foreach($data['StorageMaster'] as &$value){
					if(is_numeric($value['x'])){
						$value['x'] = $coordinate_list[$value['x']]['StorageCoordinate']['coordinate_value'];
					}
				}
			}
			//update StorageMaster
			$this->updateAndSaveDataArray($storage_master_c, "StorageMaster", "parent_storage_coord_x", "parent_storage_coord_y", "parent_id", $data, $this->StorageMaster);
			
			//Update AliquotMaster
			$this->updateAndSaveDataArray($aliquot_master_c, "StorageMaster", "storage_coord_x", "storage_coord_y", "storage_master_id", $data, $this->AliquotMaster);
			
			//Update TmaSlide
			$this->updateAndSaveDataArray($tma_slide_c, "StorageMaster", "storage_coord_x", "storage_coord_y", "storage_master_id", $data, $this->TmaSlide);
		}
					
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Get the current menu object. Needed to disable menu options based on storage type
		$atim_menu = $this->Menus->get('/storagelayout/storage_masters/storageLayout/%%StorageMaster.id%%');
	
		if(!$this->Storages->allowCustomCoordinates($storage_data['StorageControl']['id'], array('StorageControl' => $storage_data['StorageControl']))) {
			// Check storage supports custom coordinates and disable access to coordinates menu option if required
			$atim_menu = $this->Storages->inactivateStorageCoordinateMenu($atim_menu);
		}

		$this->set('atim_menu', $atim_menu);
		$this->set('atim_menu_variables', array('StorageMaster.id' => $storage_master_id));

		// Set structure				
		$this->set('atim_structure', $this->Structures->get('form', 'storagemasters'));
		$data['parent'] = $storage_data;
		if(isset($coordinate_list)){
			$data['parent']['list'] = $coordinate_list;
			$rkey_coordinate_list = array();
			foreach($coordinate_list as $values){
				$rkey_coordinate_list[$values['StorageCoordinate']['coordinate_value']] = $values;
			}
		}else{
			$coordinate_list = null;
		}
		$data['children'] = $storage_master_c;
		$data['children'] = array_merge($data['children'], $aliquot_master_c);
		$data['children'] = array_merge($data['children'], $tma_slide_c);

		foreach($data['children'] as &$children_array){
			if(isset($children_array['StorageMaster'])){
				buildChildrenArray(&$children_array, "StorageMaster", "parent_storage_coord_x", "parent_storage_coord_y", "selection_label", $rkey_coordinate_list);
			}else if(isset($children_array['AliquotMaster'])){
				buildChildrenArray(&$children_array, "AliquotMaster", "storage_coord_x", "storage_coord_y", "barcode", $rkey_coordinate_list);
			}else if(isset($children_array['TmaSlide'])){
				buildChildrenArray(&$children_array, "TmaSlide", "storage_coord_x", "storage_coord_y", "barcode", $rkey_coordinate_list);
			}
		}
//		pr($data);
		$this->set('data', $data);
	}
	
	/* --------------------------------------------------------------------------
	 * ADDITIONAL FUNCTIONS
	 * -------------------------------------------------------------------------- */		
	
	/**
	 * Set all variables to display storage coordinate properties to allocate postion 
	 * to an entity stored into this storage.
	 * 
	 * @param $storage_control_data Control data of the studied storage.
	 * 
	 * @author N. Luc
	 * @since 2007-05-22
	 * @updated A. Suggitt
	 */
	 
	function setStorageCoordinateValues($storage_control_data) {
		$string_null_value = 'n/a';
			
		$this->set('coord_x_title', isset($storage_control_data['StorageControl']['coord_x_title'])? $storage_control_data['StorageControl']['coord_x_title']: $string_null_value);
		$this->set('coord_x_type', isset($storage_control_data['StorageControl']['coord_x_type'])? $storage_control_data['StorageControl']['coord_x_type']: $string_null_value);
		$this->set('coord_x_size', isset($storage_control_data['StorageControl']['coord_x_size'])? $storage_control_data['StorageControl']['coord_x_size']: $string_null_value);

		$this->set('coord_y_title', isset($storage_control_data['StorageControl']['coord_y_title'])? $storage_control_data['StorageControl']['coord_y_title']: $string_null_value);
		$this->set('coord_y_type', isset($storage_control_data['StorageControl']['coord_y_type'])? $storage_control_data['StorageControl']['coord_y_type']: $string_null_value);				
		$this->set('coord_y_size', isset($storage_control_data['StorageControl']['coord_y_size'])? $storage_control_data['StorageControl']['coord_y_size']: $string_null_value);	
	}

	/**
	 * Check if a storage can be deleted.
	 * 
	 * @param $storage_master_id Id of the studied storage.
	 * 
	 * @return Return results as array:
	 * 	['allow_deletion'] = true/false
	 * 	['msg'] = message to display when previous field equals false
	 * 
	 * @author N. Luc
	 * @since 2007-08-16
	 * @updated A. Suggitt
	 */
	 
	function allowStorageDeletion($storage_master_id) {	
		// Check storage contains no chlidren storage
		$nbr_children_storages = $this->StorageMaster->find('count', array('conditions' => array('StorageMaster.parent_id' => $storage_master_id), 'recursive' => '-1'));
		if($nbr_children_storages > 0) { return array('allow_deletion' => false, 'msg' => 'children storage exists within the deleted storage'); }
		
		// Check storage contains no aliquots
		$nbr_storage_aliquots = $this->AliquotMaster->find('count', array('conditions' => array('AliquotMaster.storage_master_id' => $storage_master_id), 'recursive' => '-1'));
		if($nbr_storage_aliquots > 0) { return array('allow_deletion' => false, 'msg' => 'aliquot exists within the deleted storage'); }

		// Check storage is not attached to tma slide	
		$nbr_tma_slides = $this->TmaSlide->find('count', array('conditions' => array('TmaSlide.std_tma_block_id' => $storage_master_id), 'recursive' => '-1'));
		if($nbr_tma_slides > 0) { return array('allow_deletion' => false, 'msg' => 'slide exists for the deleted tma'); }
		
		// verify storage is not attached to tma slide
		$nbr_children_storages = $this->TmaSlide->find('count', array('conditions' => array('TmaSlide.storage_master_id' => $storage_master_id), 'recursive' => '-1'));
		if($nbr_children_storages > 0) { return array('allow_deletion' => false, 'msg' => 'slide exists within the deleted storage'); }
					
		return array('allow_deletion' => true, 'msg' => '');
	}
	
	/**
	 * Get the selection label of a storage.
	 *
	 * @param $storage_data Storage data including storage master, storage control, etc.
	 * 
	 * @return The new storage selection label.
	 * 
	 * @author N. Luc
	 * @since 2009-09-13
	 */
	 
	function getStorageSelectionLabel($storage_data) {
		if(empty($storage_data['StorageMaster']['parent_id'])) {
			// No parent exists: Selection Label equals short label
			return $storage_data['StorageMaster']['short_label'];
		
		}
		
		// Set selection label according to the parent selection label		
		$parent_storage_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $storage_data['StorageMaster']['parent_id']), 'recursive' => '-1'));
		if(empty($parent_storage_data)) { $this->redirect('/pages/err_sto_no_stor_data', null, true); }
		
		return ($this->createSelectionLabel($storage_data, $parent_storage_data));
	}		

	/**
	 * Manage the selection label of the children storages of a specific parent storage.
	 *
	 * @param $parent_storage_id ID of the parent storage that should be studied
	 * to update the selection labels of its children storages.
	 * @param $parent_storage_data Parent storage data.
	 * 
	 * @author N. Luc
	 * @since 2008-01-31
	 * @updated A. Suggitt
	 */
	 
	function updateChildrenStorageSelectionLabel($parent_storage_id, $parent_storage_data){
		// TODO Perhaps could code lines be moved to model? (just pb of customisation)
		$arr_studied_parents_data = array($parent_storage_id => $parent_storage_data);
		
		while(!empty($arr_studied_parents_data)) {
			// Search 'direct' children to update
			$conditions = array();
			$conditions['StorageMaster.parent_id'] = array_keys($arr_studied_parents_data);
	
			$children_storage_to_update = $this->StorageMaster->find('all', array('conditions' => $conditions, 'recursive' => '-1'));	
			$new_arr_studied_parents_data = array();
			foreach($children_storage_to_update as $new_children_to_update) {
				// New children to update
				$studied_children_id = $new_children_to_update['StorageMaster']['id'];
				$parent_storage_data = $arr_studied_parents_data[$new_children_to_update['StorageMaster']['parent_id']];
				
				$storage_data_to_update = array();
				$storage_data_to_update['StorageMaster']['selection_label'] = $this->createSelectionLabel($new_children_to_update, $parent_storage_data);
	
				$this->StorageMaster->id = $studied_children_id;					
				if(!$this->StorageMaster->save($storage_data_to_update)) { $this->redirect('/pages/err_sto_system_error', null, true); }		
	
				// Re-populate the list of parent storages to study
				$new_children_to_update['StorageMaster']['selection_label'] = $storage_data_to_update['StorageMaster']['selection_label'];
				$new_arr_studied_parents_data[$studied_children_id] = $new_children_to_update;
			}
			
			$arr_studied_parents_data = $new_arr_studied_parents_data;			
		}

		return;		
	}	
	
	/**
	 * Create the selection label of a storage.
	 *
	 * @param $storage_data Storage data including storage master, storage control, etc.
	 * @param $storage_data Parent storage data including storage master, storage control, etc.
	 * 
	 * @return The created selection label.
	 * 
	 * @author N. Luc
	 * @since 2009-09-13
	 */
	 
	function createSelectionLabel($storage_data, $parent_storage_data) {
		if(!array_key_exists('selection_label', $parent_storage_data['StorageMaster'])) { $this->redirect('/pages/err_sto_system_error_0093', null, true); }
		if(!array_key_exists('short_label', $storage_data['StorageMaster'])) { $this->redirect('/pages/err_sto_system_error_0032', null, true); }
		return ($parent_storage_data['StorageMaster']['selection_label'] . '-' . $storage_data['StorageMaster']['short_label']);
	}
	
	/**
	 * Check the new storage barcode does not already exists and set error if not.
	 *
	 * @param $storage_data Storage data including storage master, storage control, etc.
	 * @param $storage_master_id Id of the storage when this one is known.
	 *
	 * @return true if the new barcode already exists.
	 * 
	 * @author N. Luc
	 * @since 2008-01-31
	 * @updated A. Suggitt
	 */
	 
	function IsDuplicatedStorageBarCode($storage_data, $storage_master_id = null) {
		if(empty($storage_data['StorageMaster']['barcode'])) {
			return false;
		}
		
		// Build list of storage having the same barcode
		$duplicated_storage_barcodes = $this->StorageMaster->find('list', array('conditions' => array('StorageMaster.barcode' => $storage_data['StorageMaster']['barcode']), 'recursive' => '-1'));

		if(empty($duplicated_storage_barcodes)) {
			// The new barcode does not exist into the db
			return false;
		} else if((!empty($storage_master_id)) && isset($duplicated_storage_barcodes[$storage_master_id]) && (sizeof($duplicated_storage_barcodes) == 1)) {
			// Storage has been created therefore and the recorded barcode is the barcode of the studied storage
			return false;			
		}
		
		// The same barcode exists for at least one storage different than the studied one
		$this->StorageMaster->validationErrors['barcode']	= 'barcode must be unique';
		
		return true;
				
	}
	
	/**
	 * Create code of a new storage. 
	 * 
	 * @param $storage_master_id Storage master id of the studied storage.
	 * @param $storage_data Storage data including storage master, storage control, etc.
	 * @param $storage_control_data Control data of the studied storage.
	 * 
	 * @return The new code.
	 * 
	 * @author N. Luc
	 * @since 2008-01-31
	 * @updated A. Suggitt
	 */
	 
	function createStorageCode($storage_master_id, $storage_data, $storage_control_data) {
		$storage_code = $storage_control_data['StorageControl']['storage_type_code'] . ' - ' . $storage_master_id;
		
		return $storage_code;
	}
	
	/**
	 * Update the surrounding temperature and unit of children storages.
	 * 
	 * Note: only children storages having temperature or unit different than the parent will
	 * be updated.
	 * 
	 * @param $parent_storage_master_id Id of the parent storage. 
	 * @param $parent_temperature Parent storage temperature.
	 * @param $parent_temp_unit Parent storage temperature unit.
	 *
	 * @author N. Luc
	 * @since 2007-05-22
	 * @updated A. Suggitt
	 */
	 
	function updateChildrenSurroundingTemperature($parent_storage_master_id, $parent_temperature, $parent_temp_unit) {	
		// TODO Perhaps could code lines be moved to model?
		$studied_parent_storage_ids = array($parent_storage_master_id => $parent_storage_master_id);
		
		while(!empty($studied_parent_storage_ids)) {
			// Search 'direct' children to update
			$conditions = array();
			$conditions['StorageMaster.parent_id'] = $studied_parent_storage_ids;
			$conditions['StorageMaster.set_temperature'] = 'FALSE';
			$conditions['OR'] = array();
			
			if(empty($parent_temperature) && (!is_numeric($parent_temperature))) {
				$conditions['OR'][] = "StorageMaster.temperature IS NOT NULL";
			} else {
				$conditions['OR'][] = "StorageMaster.temperature IS NULL";				
				$conditions['OR'][] = "StorageMaster.temperature != '$parent_temperature'";				
			}
			
			if(empty($parent_temp_unit)) {
				$conditions['OR'][] = "StorageMaster.temp_unit IS NOT NULL";
				$conditions['OR'][] = "StorageMaster.temp_unit != ''";
			} else {
				$conditions['OR'][] = "StorageMaster.temp_unit IS NULL";				
				$conditions['OR'][] = "StorageMaster.temp_unit != '$parent_temp_unit'";				
			}

			$studied_parent_storage_ids = array();
			
			$children_storage_to_update = $this->StorageMaster->find('all', array('conditions' => $conditions, 'recursive' => '-1'));	
			
			foreach($children_storage_to_update as $new_children_to_update) {
				// New children to update
				$studied_children_id = $new_children_to_update['StorageMaster']['id'];
				
				$storage_data_to_update = array();
				$storage_data_to_update['StorageMaster']['temperature'] = $parent_temperature;
				$storage_data_to_update['StorageMaster']['temp_unit'] = $parent_temp_unit;
	
				$this->StorageMaster->id = $studied_children_id;					
				if(!$this->StorageMaster->save($storage_data_to_update)) { $this->redirect('/pages/err_sto_system_error', null, true); }		
	
				// Re-populate the list of parent storages to study
				$studied_parent_storage_ids[$studied_children_id] = $studied_children_id;
			}
		}

		return;
	}
	
	/**
	 * Get list of SOPs existing to build TMA.
	 * 
	 * Note: Function to allow bank to customize this function when they don't use 
	 * SOP module.
	 *
	 * @author N. Luc
	 * @since 2009-09-11
	 * @updated N. Luc
	 */
	 
	function getTmaSopList() {
		return $this->getSopList('tma');
	}
	
	/**
	 * Parses the data_array and updates it with the rcv_data array. Saves the modifications into the database and
	 * cleans it of the no longer related data. 
	 * @param data_array The data read from the database
	 * @param type The current type we are seeking
	 * @param x_key The name of the key for the x coordinate
	 * @param y_key The name of the key for the y coordinate
	 * @param $storage_parent_key The name of the key of the parent storage id
	 * @param rcv_data The data received from the user
	 * @param UpdaterObject The object to use to update the data
	 */
	function updateAndSaveDataArray(&$data_array, $type, $x_key, $y_key, $storage_parent_key, $rcv_data, $UpdaterObject){
		for($i = sizeof($data_array) - 1; $i >= 0; -- $i){
			if(isset($rcv_data[$type]) && isset($rcv_data[$type][$data_array[$i][$type]['id']])){
				$trash = false;
				//this is is a cell
				if($rcv_data[$type][$data_array[$i][$type]['id']]['x'] == 't'){
					//trash
					$data_array[$i][$type][$x_key] = null;
					$data_array[$i][$type][$y_key] = null;
					$data_array[$i][$type][$storage_parent_key] = null;
					$trash = true;
				}else if($rcv_data[$type][$data_array[$i][$type]['id']]['x'] == 'u'){
					//unclassified
					$data_array[$i][$type][$x_key] = null;
					$data_array[$i][$type][$y_key] = null;
				}else{
					//positioned
					$data_array[$i][$type][$x_key] = $rcv_data[$type][$data_array[$i][$type]['id']]['x'];
					$data_array[$i][$type][$y_key] = $rcv_data[$type][$data_array[$i][$type]['id']]['y'];
				}
				//clean the array asap to gain efficiency
				unset($rcv_data[$type][$data_array[$i][$type]['id']]);
				$UpdaterObject->save($data_array[$i]);
				if($trash){
					unset($data_array[$i]);
				}
			}
		}
		// Re-index
		$data_array = array_values($data_array);
		
	}
}

function buildChildrenArray(&$children_array, $type_key, $x_key, $y_key, $label_key, $coordinate_list){
	
	$children_array['DisplayData']['id'] = $children_array[$type_key]['id'];
	if($coordinate_list == null){
		$children_array['DisplayData']['x'] = $children_array[$type_key][$x_key];
	}else if(isset($coordinate_list[$children_array[$type_key][$x_key]])){
		$children_array['DisplayData']['x'] = $coordinate_list[$children_array[$type_key][$x_key]]['StorageCoordinate']['id'];
	}else{
		$children_array['DisplayData']['x'] = "";
	}
	$children_array['DisplayData']['y'] = $children_array[$type_key][$y_key];
	$children_array['DisplayData']['label'] = $children_array[$type_key][$label_key];
	$children_array['DisplayData']['type'] = $type_key;
	
}
?>