<?php

class StorageMastersController extends StoragelayoutAppController {

	var $components = array();
	
	var $uses = array(
		'Storagelayout.StorageMaster',
		'Storagelayout.StorageTreeView',
		'Storagelayout.StorageControl',
		'Storagelayout.StorageCoordinate',
		'Storagelayout.TmaSlide',
		'Storagelayout.StorageCoordinate',
		
		'Inventorymanagement.AliquotMaster');
	
	var $paginate = array('StorageMaster' => array('limit' => pagination_amount, 'order' => 'StorageMaster.selection_label ASC'));

	/* --------------------------------------------------------------------------
	 * DISPLAY FUNCTIONS
	 * -------------------------------------------------------------------------- */
	 
	function index() {
		// clear SEARCH criteria
		$_SESSION['ctrapp_core']['search'] = null; 
		
		//find all storage control types to build add button
		$this->set('storage_controls_list', $this->StorageControl->find('all', array('conditions' => array('StorageControl.flag_active' => '1'))));
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}
		
	function search() {
		$this->set('atim_menu', $this->Menus->get('/storagelayout/storage_masters/index/'));
		
		if(!empty($this->data)){
			$_SESSION['ctrapp_core']['search']['criteria'] = $this->Structures->parse_search_conditions();
		}
		
		$this->data = $this->paginate($this->StorageMaster, $_SESSION['ctrapp_core']['search']['criteria']);
		
		//find all storage control types to build add button
		$this->set('storage_controls_list', $this->StorageControl->find('all', array('conditions' => array('StorageControl.flag_active' => '1'))));
		
		// if SEARCH form data, save number of RESULTS and URL
		$_SESSION['ctrapp_core']['search']['results'] = $this->params['paging']['StorageMaster']['count'];
		$_SESSION['ctrapp_core']['search']['url'] = '/storagelayout/storage_masters/search';

		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}
	
	function detail($storage_master_id, $is_from_tree_view_or_layout = 0, $storage_category = null) {
		// $is_from_tree_view_or_layout : 0-Normal, 1-Tree view, 2-Stoarge layout
		
		// Note: The $storage_category variable is not really used.
		//       Just added to parameters list to be consistent with use_link set into menu table
		//       for TMA.
		
		if(!$storage_master_id) { $this->redirect('/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); }
		
		// MANAGE DATA
		
		// Get the storage data
		$storage_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $storage_master_id)));
		if(empty($storage_data)) { $this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); }		
		$this->data = $storage_data;
		
		$this->data['StorageMaster']['layout_description'] = $this->StorageControl->getStorageLayoutDescription(array('StorageControl' => $storage_data['StorageControl']));
		
		// Get parent storage information
		$parent_storage_id = $storage_data['StorageMaster']['parent_id'];
		$parent_storage_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $parent_storage_id)));
		if(!empty($parent_storage_id) && empty($parent_storage_data)) { $this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); }	
		
		$this->set('parent_storage_id', $parent_storage_id);		
		$this->data['Generated']['path'] =  $this->StorageMaster->getStoragePath($parent_storage_id);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Get the current menu object. Needed to disable menu options based on storage type
		$atim_menu = null;
		$is_tma = false;
		if(strcmp($storage_data['StorageControl']['is_tma_block'], 'TRUE') == 0) {
			// TMA menu
			$atim_menu = $this->Menus->get('/storagelayout/storage_masters/detail/%%StorageMaster.id%%/0/TMA');
			$is_tma = true;
		} else {
			$atim_menu = $this->Menus->get('/storagelayout/storage_masters/detail/%%StorageMaster.id%%');
		}
		
		if(!$this->StorageControl->allowCustomCoordinates($storage_data['StorageControl']['id'], array('StorageControl' => $storage_data['StorageControl']))) {
			// Check storage supports custom coordinates and disable access to coordinates menu option if required
			$atim_menu = $this->inactivateStorageCoordinateMenu($atim_menu);
		}
					
		if(empty($storage_data['StorageControl']['coord_x_type'])) {
			// Check storage supports coordinates and disable access to storage layout menu option if required
			$atim_menu = $this->inactivateStorageLayoutMenu($atim_menu);
		}
		
		$this->set('atim_menu', $atim_menu);
		$this->set('atim_menu_variables', array('StorageMaster.id' => $storage_master_id));

		// Set structure				
		$this->Structures->set($storage_data['StorageControl']['form_alias']);

		// Set boolean
		$this->set('is_tma', $is_tma);		

		// Define if this detail form is displayed into the children storage tree view, storage layout, etc
		$this->set('is_from_tree_view_or_layout', $is_from_tree_view_or_layout);
		
		// Get all storage control types to build the add to selected button
		$this->set('storage_controls_list', $this->StorageControl->find('all', array('conditions' => array('StorageControl.flag_active' => '1'))));

		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}	
	
	function add($storage_control_id, $predefined_parent_storage_id = null) {
		if(!$storage_control_id) { $this->redirect('/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); }
		
		// MANAGE DATA
		
		$storage_control_data = $this->StorageControl->find('first', array('conditions' => array('StorageControl.id' => $storage_control_id)));
		if(empty($storage_control_data)) { $this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); }	
		
		$this->set('storage_control_id', $storage_control_data['StorageControl']['id']);
		$this->set('layout_description', $this->StorageControl->getStorageLayoutDescription($storage_control_data));
		
		// Set predefined parent storage
		if(!is_null($predefined_parent_storage_id)) {
			$predefined_parent_storage_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $predefined_parent_storage_id, 'StorageControl.is_tma_block' => 'FALSE')));
			if(empty($predefined_parent_storage_data)) { $this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); }		
			$this->set('predefined_parent_storage_selection_label', $this->StorageMaster->getStorageLabelAndCodeForDisplay($predefined_parent_storage_data));	
		}
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Set menu
		$atim_menu = $this->Menus->get('/storagelayout/storage_masters/index/');		
		$this->set('atim_menu', $atim_menu);
		$this->set('atim_menu_variables', array('StorageControl.id' => $storage_control_id));
		
		// set structure alias based on VALUE from CONTROL table
		$this->Structures->set($storage_control_data['StorageControl']['form_alias']);
	
		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
			
		if(!empty($this->data)) {			
			
			// Set control ID en type
			$this->data['StorageMaster']['storage_control_id'] = $storage_control_data['StorageControl']['id'];
			$this->data['StorageMaster']['storage_type'] = $storage_control_data['StorageControl']['storage_type'];			
			
			// Validates and set additional data
			$submitted_data_validates = true;
			
			$this->StorageMaster->set($this->data);
			if(!$this->StorageMaster->validates()){
				$submitted_data_validates = false;
			}
			
			// Reste data to get position data
			$this->data = $this->StorageMaster->data;
		
			if($submitted_data_validates) {
				// Set selection label
				$this->data['StorageMaster']['selection_label'] = $this->StorageMaster->getSelectionLabel($this->data);	
		
				// Set storage temperature information
				$this->data['StorageMaster']['set_temperature'] = $storage_control_data['StorageControl']['set_temperature'];
				$this->StorageMaster->manageTemperature($this->data);		
			}	
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}		
						
			if($submitted_data_validates) {
				// Save storage data
				$bool_save_done = true;

				$storage_master_id = null;
				if($this->StorageMaster->save($this->data, false)) {
					$storage_master_id = $this->StorageMaster->getLastInsertId();
				} else {
					$bool_save_done = false;
				}
				
				// Create storage code
				if($bool_save_done) {
					$storage_data_to_update = array();
					$storage_data_to_update['StorageMaster']['code'] = $this->StorageMaster->createCode($storage_master_id, $this->data, $storage_control_data);

					$this->StorageMaster->id = $storage_master_id;					
					if(!$this->StorageMaster->save($storage_data_to_update, false)) {
						$bool_save_done = false;
					}
				}
				
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) {
					require($hook_link);
				}
					
				if($bool_save_done) {
					$this->atimFlash('your data has been saved', '/storagelayout/storage_masters/detail/' . $storage_master_id);				
				}					
			}
		}		
	}
			
	function edit($storage_master_id) {
		if(!$storage_master_id) { $this->redirect('/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); }
		
		// MANAGE DATA

		// Get the storage data
		$storage_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $storage_master_id)));
		if(empty($storage_data)) { $this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); }
		$storage_data['StorageMaster']['layout_description'] = $this->StorageControl->getStorageLayoutDescription(array('StorageControl' => $storage_data['StorageControl']));

		// Set predefined parent storage
		if(!empty($storage_data['StorageMaster']['parent_id'])) {
			$predefined_parent_storage_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $storage_data['StorageMaster']['parent_id'], 'StorageControl.is_tma_block' => 'FALSE')));
			if(empty($predefined_parent_storage_data)) { $this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); }		
			$this->set('predefined_parent_storage_selection_label', $this->StorageMaster->getStorageLabelAndCodeForDisplay($predefined_parent_storage_data));	
		}		
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Get the current menu object. Needed to disable menu options based on storage type
		$atim_menu = null;
		if(strcmp($storage_data['StorageControl']['is_tma_block'], 'TRUE') == 0) {
			// TMA menu
			$atim_menu = $this->Menus->get('/storagelayout/storage_masters/detail/%%StorageMaster.id%%/0/TMA');
		} else {
			$atim_menu = $this->Menus->get('/storagelayout/storage_masters/detail/%%StorageMaster.id%%');
		}
		
		if(!$this->StorageControl->allowCustomCoordinates($storage_data['StorageControl']['id'], array('StorageControl' => $storage_data['StorageControl']))) {
			// Check storage supports custom coordinates and disable access to coordinates menu option if required
			$atim_menu = $this->inactivateStorageCoordinateMenu($atim_menu);
		}
					
		if(empty($storage_data['StorageControl']['coord_x_type'])) {
			// Check storage supports coordinates and disable access to storage layout menu option if required
			$atim_menu = $this->inactivateStorageLayoutMenu($atim_menu);
		}

		$this->set('atim_menu', $atim_menu);
		$this->set('atim_menu_variables', array('StorageMaster.id' => $storage_master_id));

		// Set structure				
		$this->Structures->set($storage_data['StorageControl']['form_alias']);
	
		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
					
		if(empty($this->data)) {
			$this->data = $storage_data;	
			
		} else {
			// Validates and set additional data
			$submitted_data_validates = true;
			
			$this->data['StorageMaster']['id'] = $storage_master_id;
			$this->StorageMaster->set($this->data);
			if(!$this->StorageMaster->validates()){
				$submitted_data_validates = false;
			}
			
			// Reste data to get position data
			$this->data = $this->StorageMaster->data;
		
			if($submitted_data_validates) {
				// Set selection label
				$this->data['StorageMaster']['selection_label'] = $this->StorageMaster->getSelectionLabel($this->data);	
			
				// Set storage temperature information
				$this->data['StorageMaster']['set_temperature'] = $storage_data['StorageControl']['set_temperature'];
				$this->StorageMaster->manageTemperature($this->data);
			}
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}		
			
			if($submitted_data_validates) {
				// Save storage data
				$this->StorageMaster->id = $storage_master_id;		
				if($this->StorageMaster->save($this->data, false)) {
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) {
						require($hook_link);
					}
					
					// Manage children temperature
					$storage_temperature = (array_key_exists('temperature', $this->data['StorageMaster']))? $this->data['StorageMaster']['temperature'] : $storage_data['StorageMaster']['temperature'];
					$storage_temp_unit = (array_key_exists('temp_unit', $this->data['StorageMaster']))? $this->data['StorageMaster']['temp_unit'] : $storage_data['StorageMaster']['temp_unit'];
					$this->StorageMaster->updateChildrenSurroundingTemperature($storage_master_id, $storage_temperature, $storage_temp_unit);
					
					// Manage children selection label
					if(strcmp($this->data['StorageMaster']['selection_label'], $storage_data['StorageMaster']['selection_label']) != 0) {	
						$this->StorageMaster->updateChildrenStorageSelectionLabel($storage_master_id, $this->data);
					}		
					$this->atimFlash('your data has been updated', '/storagelayout/storage_masters/detail/' . $storage_master_id); 
				}
					
			}
		}
	}
	
	function delete($storage_master_id) {
		if(!$storage_master_id) { $this->redirect('/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); }
		
		// Get the storage data
		$storage_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $storage_master_id), 'recursive' => '-1'));
		if(empty($storage_data)) { $this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); }		

		// Check deletion is allowed
		$arr_allow_deletion = $this->StorageMaster->allowDeletion($storage_master_id);

		// CUSTOM CODE
		
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }		
				
		if($arr_allow_deletion['allow_deletion']) {
			// First remove storage from tree
			$this->StorageMaster->id = $storage_master_id;	
			$cleaned_storage_data = array('StorageMaster' => array('parent_id' => ''));
			if(!$this->StorageMaster->save($cleaned_storage_data, false)) { 
				$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
			}
			
			
			// Create has many relation to delete the storage coordinate
			$this->StorageMaster->bindModel(array('hasMany' => array('StorageCoordinate' => array('className' => 'StorageCoordinate', 'foreignKey' => 'storage_master_id', 'dependent' => true))), false);	

			// Delete storage
			$message = '';
			$atim_flash = null;
			if($this->StorageMaster->atim_delete($storage_master_id, true)) {
				$atim_flash = true;
			} else {
				$atim_flash = false;
			}
			
			$this->StorageMaster->bindModel(array('hasMany' => array('StorageCoordinate')), false);
			if($atim_flash){
				$this->atimFlash('your data has been deleted', '/storagelayout/storage_masters/index/');
			}else{
				$this->flash('error deleting data - contact administrator', '/storagelayout/storage_masters/index/');
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
	 * @param int $is_ajax
	 * 
	 * @author N. Luc
	 * @since 2007-05-22
	 * @updated A. Suggitt
	 */
	 
	function contentTreeView($storage_master_id = 0, $is_ajax = false){
		if($is_ajax){
			$this->layout = 'ajax';
			Configure::write('debug', 0);
		}
		$this->set("is_ajax", $is_ajax);
		
		// MANAGE STORAGE DATA
		// Get the storage data
		$storage_data = null;
		$atim_menu = array();
		if($storage_master_id){
			$storage_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $storage_master_id)));
			if(empty($storage_data)) { $this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); }
			$tree_data = $this->StorageMaster->find('all', array('conditions' => array('StorageMaster.parent_id' => $storage_master_id), 'recursive' => '-1'));
			$aliquots = $this->AliquotMaster->find('all', array('conditions' => array('AliquotMaster.storage_master_id' => $storage_master_id), 'recursive' => '-1'));
			$tree_data = array_merge($tree_data, $aliquots);
			$tma_slides = $this->TmaSlide->find('all', array('conditions' => array('TmaSlide.storage_master_id' => $storage_master_id), 'recursive' => '-1'));
			$tree_data = array_merge($tree_data, $tma_slides);
			$atim_menu = $this->Menus->get('/storagelayout/storage_masters/contentTreeView/%%StorageMaster.id%%');
		}else{
			$tree_data = $this->StorageMaster->find('all', array('conditions' => array('StorageMaster.parent_id IS NULL'), 'order' => 'CAST(StorageMaster.parent_storage_coord_x AS signed), CAST(StorageMaster.parent_storage_coord_y AS signed)', 'recursive' => '0'));
			$atim_menu = $this->Menus->get('/storagelayout/storage_masters/index');
			$this->set("search", true);
			$this->set('storage_controls_list', $this->StorageControl->find('all', array('conditions' => array('StorageControl.flag_active' => '1'))));
		}
		$ids = array();
		foreach($tree_data as $data_unit){
			if(isset($data_unit['StorageMaster'])){
				$ids[] = $data_unit['StorageMaster']['id'];
			}
		}
		$ids = array_flip($this->StorageMaster->hasChild($ids));//array_key_exists is faster than in_array
		foreach($tree_data as &$data_unit){
			//only storages child interrests us here
			$data_unit['children'] = isset($data_unit['StorageMaster']) && array_key_exists($data_unit['StorageMaster']['id'], $ids);
		}
		$this->data = $tree_data;
						
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Get the current menu object. Needed to disable menu options based on storage type
		if(!empty($storage_data)) {
			if(!$this->StorageControl->allowCustomCoordinates($storage_data['StorageControl']['id'], array('StorageControl' => $storage_data['StorageControl']))) {
				// Check storage supports custom coordinates and disable access to coordinates menu option if required
				$atim_menu = $this->inactivateStorageCoordinateMenu($atim_menu);
			}
							
			if(empty($storage_data['StorageControl']['coord_x_type'])) {
				// Check storage supports coordinates and disable access to storage layout menu option if required
				$atim_menu = $this->inactivateStorageLayoutMenu($atim_menu);
			}			
		}

		$this->set('atim_menu', $atim_menu);
		$this->set('atim_menu_variables', array('StorageMaster.id' => $storage_master_id));

		// Set structure				
		$atim_structure = array();
		$atim_structure['StorageMaster']	= $this->Structures->get('form','storage_masters_for_storage_tree_view');
		$atim_structure['AliquotMaster']	= $this->Structures->get('form','aliquot_masters_for_storage_tree_view');
		$atim_structure['TmaSlide']	= $this->Structures->get('form','tma_slides_for_storage_tree_view');
		$this->set('atim_structure', $atim_structure);	
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if($hook_link){ 
			require($hook_link);
		}				
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
			$this->redirect('/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); 
		}
		
		// MANAGE STORAGE DATA
		
		// Get the storage data
		$storage_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $storage_master_id)));
		if(empty($storage_data)) { 
			$this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		}
		
		$coordinate_list = array();
		if($storage_data['StorageControl']['coord_x_type'] == "list"){
			$coordinate_tmp = $this->StorageCoordinate->find('all', array('conditions' => array('StorageCoordinate.storage_master_id' => $storage_master_id), 'recursive' => '-1', 'order' => 'StorageCoordinate.order ASC'));
			foreach($coordinate_tmp as $key => $value){
				$coordinate_list[$value['StorageCoordinate']['id']]['StorageCoordinate'] = $value['StorageCoordinate'];
			} 
		}
		
		// Storage layout not allowed for this type of storage
		if(empty($storage_data['StorageControl']['coord_x_type'])) { 
			$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
		}
		
		$storage_master_c = $this->StorageMaster->find('all', array('conditions' => array('StorageMaster.parent_id' => $storage_master_id)));
		$aliquot_master_c = $this->AliquotMaster->find('all', array('conditions' => array('AliquotMaster.storage_master_id' => $storage_master_id), 'recursive' => '-1'));
		$tma_slide_c = $this->TmaSlide->find('all', array('conditions' => array('TmaSlide.storage_master_id' => $storage_master_id), 'recursive' => '-1'));

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
				foreach($data as &$data_model){
					foreach($data_model as &$value){
						if(is_numeric($value['x'])){
							$value['x'] = $coordinate_list[$value['x']]['StorageCoordinate']['coordinate_value'];
						}
					}
				}
			}
			
			//update StorageMaster
			$this->StorageMaster->updateAndSaveDataArray($storage_master_c, "StorageMaster", "parent_storage_coord_x", "parent_storage_coord_y", "parent_id", $data, $this->StorageMaster, $storage_data['StorageControl']);
			
			//Update AliquotMaster
			$this->StorageMaster->updateAndSaveDataArray($aliquot_master_c, "AliquotMaster", "storage_coord_x", "storage_coord_y", "storage_master_id", $data, $this->AliquotMaster, $storage_data['StorageControl']);
			
			//Update TmaSlide
			$this->StorageMaster->updateAndSaveDataArray($tma_slide_c, "TmaSlide", "storage_coord_x", "storage_coord_y", "storage_master_id", $data, $this->TmaSlide, $storage_data['StorageControl']);
		}
					
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Get the current menu object. Needed to disable menu options based on storage type
		$atim_menu = $this->Menus->get('/storagelayout/storage_masters/storageLayout/%%StorageMaster.id%%');
	
		if(!$this->StorageControl->allowCustomCoordinates($storage_data['StorageControl']['id'], array('StorageControl' => $storage_data['StorageControl']))) {
			// Check storage supports custom coordinates and disable access to coordinates menu option if required
			$atim_menu = $this->inactivateStorageCoordinateMenu($atim_menu);
		}

		$this->set('atim_menu', $atim_menu);
		$this->set('atim_menu_variables', array('StorageMaster.id' => $storage_master_id));

		// Set structure				
		$this->Structures->set('storagemasters');
	
		$data['parent'] = $storage_data;
		if(isset($coordinate_list)){
			$data['parent']['list'] = $coordinate_list;
			$rkey_coordinate_list = array();
			foreach($coordinate_list as $values){
				$rkey_coordinate_list[$values['StorageCoordinate']['coordinate_value']] = $values;
			}
		}else{
			$rkey_coordinate_list = null;
		}
		$data['children'] = $storage_master_c;
		$data['children'] = array_merge($data['children'], $aliquot_master_c);
		$data['children'] = array_merge($data['children'], $tma_slide_c);

		
		foreach($data['children'] as &$children_array){
			if(isset($children_array['StorageMaster'])){
				$link = $this->webroot."/storagelayout/storage_masters/detail/".$children_array["StorageMaster"]['id']."/2";
				$this->StorageMaster->buildChildrenArray($children_array, "StorageMaster", "parent_storage_coord_x", "parent_storage_coord_y", "selection_label", $rkey_coordinate_list, $link, "storage");
			}else if(isset($children_array['AliquotMaster'])){
				$link = $this->webroot."/inventorymanagement/aliquot_masters/detail/".$children_array["AliquotMaster"]["collection_id"]."/".$children_array["AliquotMaster"]["sample_master_id"]."/".$children_array["AliquotMaster"]["id"]."/2";
				$this->StorageMaster->buildChildrenArray($children_array, "AliquotMaster", "storage_coord_x", "storage_coord_y", "barcode", $rkey_coordinate_list, $link, "aliquot");
			}else if(isset($children_array['TmaSlide'])){
				$link = $this->webroot."/storagelayout/tma_slides/detail/".$children_array["TmaSlide"]['tma_block_storage_master_id']."/".$children_array["TmaSlide"]['id']."/2";
				$this->StorageMaster->buildChildrenArray($children_array, "TmaSlide", "storage_coord_x", "storage_coord_y", "barcode", $rkey_coordinate_list, $link, "slide");
			}
		}
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }		
		
		$this->set('data', $data);
	}

	function autocompleteLabel(){
		
		//-- NOTE ----------------------------------------------------------
		//
		// This function is linked to functions of the StorageMaster model 
		// called getStorageDataFromStorageLabelAndCode() and
		// getStorageLabelAndCodeForDisplay().
		//
		// When you override the autocompleteLabel() function, check 
		// if you need to override these functions.
		//  
		//------------------------------------------------------------------
		
		//layout = ajax to avoid printing layout
		$this->layout = 'ajax';
		//debug = 0 to avoid printing debug queries that would break the javascript array
		Configure::write('debug', 0);
		//query the database
		$term = trim(str_replace('_', '\_', str_replace('%', '\%', $_GET['term'])));
		$conditions = array(
			'StorageMaster.Selection_label LIKE' => $term.'%'
			);
		$rpos = strripos($term, "[");
		if($rpos){
			$term2a = substr($term, 0, $rpos - 1);
			$term2b = substr($term, $rpos + 1);
			if($term2b[strlen($term2b) - 1] == "]"){
				$term2b = substr($term2b, -1);
			}
			$tmp_condition = $conditions;
			$conditions = array();
			$conditions['or'][] = $tmp_condition;
			$conditions['or'][] = array('StorageMaster.Selection_label LIKE' => $term2a, 'StorageMaster.code LIKE' => $term2b.'%');
		}
		$storage_masters = $this->StorageMaster->find('all', array(
			'conditions' => $conditions,
			'fields' => array('StorageMaster.selection_label', 'GROUP_CONCAT(StorageMaster.code) AS codes'),
			'group' => array('StorageMaster.selection_label'),
			'recursive' => -1,
			'limit' => 10
		));
		//build javascript textual array
		$result = "";
		$count = 0;
		foreach($storage_masters as $storage_master){
			$codes = explode(",", $storage_master[0]['codes']);
			foreach($codes as $code){
				$result .= '"'.$storage_master['StorageMaster']['selection_label'].' ['.$code.']", ';
				++ $count;
				if($count > 9){
					break;
				}
			}
			if($count > 9){
				break;
			}
		}
		if(sizeof($result) > 0){
			$result = substr($result, 0, -2);
		}
		$this->set('result', "[".$result."]");
	}
	
	
}
?>