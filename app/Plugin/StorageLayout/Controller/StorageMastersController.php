<?php

class StorageMastersController extends StorageLayoutAppController {

	var $components = array();
	
	var $uses = array(
		'StorageLayout.StorageMaster',
		'StorageLayout.StorageTreeView',
		'StorageLayout.StorageControl',
		'StorageLayout.StorageCoordinate',
		'StorageLayout.TmaSlide',
		'StorageLayout.StorageCoordinate',
		
		'InventoryManagement.AliquotMaster'
	);
	
	var $paginate = array('StorageMaster' => array('limit' => pagination_amount, 'order' => 'StorageMaster.selection_label ASC'));

	function search($search_id = 0, $from_layout_page = false){
		if($from_layout_page){
			$top_row_storage_id = $this->request->data['current_storage_id'];
			unset($this->request->data['current_storage_id']);
			$this->searchHandler($search_id, $this->StorageMaster, 'storagemasters,storage_w_spaces', '/StorageLayout/StorageMasters/search', false, 21);
			if(count($this->request->data) > 20){
				$this->request->data = array();
				$this->set('overflow', true);
			}else{
				$warn = false;
				foreach($this->request->data as $key => $data){
					if($data['StorageControl']['coord_x_type'] == null){
						unset($this->request->data[$key]);
						$warn = true;
					}else if($data['StorageControl']['coord_x_type'] == 'list' && !$this->StorageCoordinate->find('count', array('conditions' => array('StorageCoordinate.storage_master_id' => $data['StorageMaster']['id']), 'recursive' => '-1'))){
						unset($this->request->data[$key]);
						$warn = true;
					}else if($data['StorageMaster']['id'] == $top_row_storage_id){
						unset($this->request->data[$key]);
						AppController::addInfoMsg(__('the storage you are already working on has been removed from the results'));	
					}
				}
				if($warn){
					AppController::addInfoMsg(__('storages without layout have been removed from the results'));
				}
			}
		}else{
			$this->searchHandler($search_id, $this->StorageMaster, 'storagemasters,storage_w_spaces', '/StorageLayout/StorageMasters/search');
		}
		$this->set('from_layout_page', $from_layout_page);
		$this->Structures->set('storagemasters,storage_w_spaces');
		
		//find all storage control types to build add button
		$this->set('storage_types_from_id', $this->StorageControl->getStorageTypePermissibleValues());
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
		
		if(empty($search_id)){
			if($this->request->is('ajax')) {
				$this->set('is_ajax', true);
			}
			//index
			$this->render('index');
		}
	}
	
	function detail($storage_master_id, $is_from_tree_view_or_layout = 0, $storage_category = null) {
		// $is_from_tree_view_or_layout : 0-Normal, 1-Tree view, 2-Stoarge layout
		
		// Note: The $storage_category variable is not really used.
		//       Just added to parameters list to be consistent with use_link set into menu table
		//       for TMA.
		
		// MANAGE DATA
		
		// Get the storage data
		$data = $this->StorageMaster->getOrRedirect($storage_master_id);
		
		$data['StorageMaster']['layout_description'] = $this->StorageControl->getStorageLayoutDescription(array('StorageControl' => $data['StorageControl']));
		
		// Get parent storage information
		$parent_storage_id = $data['StorageMaster']['parent_id'];
		$parent_storage_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $parent_storage_id)));
		if(!empty($parent_storage_id) && empty($parent_storage_data)) { 
			$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		}	
		
		$this->set('parent_storage_id', $parent_storage_id);		
		$data['Generated']['path'] =  $this->StorageMaster->getStoragePath($parent_storage_id);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Get the current menu object. Needed to disable menu options based on storage type
		
		$atim_menu = $this->Menus->get('/StorageLayout/StorageMasters/detail/%%StorageMaster.id%%');
		$display_layout = true;
		if(!$this->StorageControl->allowCustomCoordinates($data['StorageControl']['id'], array('StorageControl' => $data['StorageControl']))) {
			// Check storage supports custom coordinates and disable access to coordinates menu option if required
			$atim_menu = $this->inactivateStorageCoordinateMenu($atim_menu);
		} else {
			if(!$this->StorageCoordinate->find('count', array('conditions' => array('StorageCoordinate.storage_master_id' => $storage_master_id), 'recursive' => '-1'))) {
				if(!$is_from_tree_view_or_layout) AppController::addWarningMsg(__('no layout exists - add coordinates first'));
				$display_layout = false;
			}
		}
		if(empty($data['StorageControl']['coord_x_type'])) {
			// Check storage supports coordinates and disable access to storage layout menu option if required
			$atim_menu = $this->inactivateStorageLayoutMenu($atim_menu);
			$display_layout = false;
		} 
		if(!$is_from_tree_view_or_layout && $display_layout) {
			if(empty($data['StorageControl']['coord_y_type'])) {
				if($this->StorageMaster->find('count', array('conditions' => array('StorageMaster.parent_id' => $storage_master_id, 'StorageMaster.parent_storage_coord_x' => '')))
				|| $this->AliquotMaster->find('count', array('conditions' => array('AliquotMaster.storage_master_id' => $storage_master_id, 'AliquotMaster.storage_coord_x' => '')))) {
					AppController::addWarningMsg(__('at least one stored element is not displayed in layout'));
				}
			} else {
				if($this->StorageMaster->find('count', array('conditions' => array('StorageMaster.parent_id' => $storage_master_id, 'OR' => array('StorageMaster.parent_storage_coord_x' => '','StorageMaster.parent_storage_coord_y' => ''))))
				|| $this->AliquotMaster->find('count', array('conditions' => array('AliquotMaster.storage_master_id' => $storage_master_id, 'OR' => array('AliquotMaster.storage_coord_x' => '', 'AliquotMaster.storage_coord_y' => ''))))) {
					AppController::addWarningMsg(__('at least one stored element is not displayed in layout'));
				}
			}
		}
		$this->set('display_layout', $display_layout);
		
		$this->set('atim_menu', $atim_menu);
		$this->set('atim_menu_variables', array('StorageMaster.id' => $storage_master_id));

		// Set structure				
		$this->Structures->set($data['StorageControl']['form_alias']);

		// Set boolean
		$this->set('is_tma', $data['StorageControl']['is_tma_block']? true : false);		

		// Define if this detail form is displayed into the children storage tree view, storage layout, etc
		$this->set('is_from_tree_view_or_layout', $is_from_tree_view_or_layout);
		
		// Get all storage control types to build the add to selected button
		$this->set('storage_types_from_id', $this->StorageControl->getStorageTypePermissibleValues());
		
		$this->request->data = $data;

		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
	}	
	
	function add($storage_control_id, $predefined_parent_storage_id = null) {
		// MANAGE DATA
		$storage_control_data = $this->StorageControl->getOrRedirect($storage_control_id);
		$this->set('storage_control_id', $storage_control_data['StorageControl']['id']);
		$this->set('layout_description', $this->StorageControl->getStorageLayoutDescription($storage_control_data));
		
		$url_to_cancel = '/StorageLayout/StorageMasters/search/';
		if(isset($this->request->data['url_to_cancel'])) $url_to_cancel = $this->request->data['url_to_cancel'];
		unset($this->request->data['url_to_cancel']);
		
		// Set predefined parent storage
		if(!is_null($predefined_parent_storage_id)) {
			$predefined_parent_storage_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $predefined_parent_storage_id, 'StorageControl.is_tma_block' => '0')));
			if(empty($predefined_parent_storage_data)) { 
				$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
			}		
			$this->set('predefined_parent_storage_selection_label', $this->StorageMaster->getStorageLabelAndCodeForDisplay($predefined_parent_storage_data));	
			$url_to_cancel = '/StorageLayout/StorageMasters/detail/'.$predefined_parent_storage_id;
		}
		
		$this->set('url_to_cancel',$url_to_cancel);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Set menu
		$atim_menu = $this->Menus->get('/StorageLayout/StorageMasters/search/');		
		$this->set('atim_menu', $atim_menu);
		$this->set('atim_menu_variables', array('StorageControl.id' => $storage_control_id));
		
		// set structure alias based on VALUE from CONTROL table
		$this->Structures->set($storage_control_data['StorageControl']['form_alias'].($storage_control_data['StorageControl']['set_temperature']? ',storage_temperature' : ''));
	
		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
			
		if(!empty($this->request->data)) {			
			
			// Set control ID en type
			$this->request->data['StorageMaster']['storage_control_id'] = $storage_control_data['StorageControl']['id'];
			
			// Validates and set additional data
			$submitted_data_validates = true;
			
			$this->StorageMaster->set($this->request->data);
			if(!$this->StorageMaster->validates()){
				$submitted_data_validates = false;
			}
			
			// Reste data to get position data
			$this->request->data = $this->StorageMaster->data;
		
			if($submitted_data_validates) {
				// Set selection label
				$this->request->data['StorageMaster']['selection_label'] = $this->StorageMaster->getSelectionLabel($this->request->data);	
		
				// Set storage temperature information
				$this->StorageMaster->manageTemperature($this->request->data, $storage_control_data);		
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
				$this->StorageMaster->addWritableField(array('storage_control_id', 'parent_id', 'selection_label', 'temperature', 'temp_unit'));
				
				if($this->StorageMaster->save($this->request->data, false)) {
					$storage_master_id = $this->StorageMaster->getLastInsertId();
				} else {
					$bool_save_done = false;
				}
				
				// Create storage code
				if($bool_save_done) {
					$this->StorageMaster->tryCatchQuery("UPDATE storage_masters SET storage_masters.code = storage_masters.id WHERE storage_masters.id = $storage_master_id;"); 
					$this->StorageMaster->tryCatchQuery("UPDATE storage_masters_revs SET storage_masters_revs.code = storage_masters_revs.id WHERE storage_masters_revs.id = $storage_master_id;");
				}
				
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) {
					require($hook_link);
				}
					
				if($bool_save_done) {
					$this->atimFlash('your data has been saved', '/StorageLayout/StorageMasters/detail/' . $storage_master_id);				
				}					
			}
		}		
	}
			
	function edit($storage_master_id) {
		// MANAGE DATA
		// Get the storage data
		$storage_data = $this->StorageMaster->getOrRedirect($storage_master_id);
		$storage_data['StorageMaster']['layout_description'] = $this->StorageControl->getStorageLayoutDescription(array('StorageControl' => $storage_data['StorageControl']));

		// Set predefined parent storage
		if(!empty($storage_data['StorageMaster']['parent_id'])) {
			$predefined_parent_storage_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $storage_data['StorageMaster']['parent_id'], 'StorageControl.is_tma_block' => '0')));
			if(empty($predefined_parent_storage_data)) { 
				$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
			}		
			$this->set('predefined_parent_storage_selection_label', $this->StorageMaster->getStorageLabelAndCodeForDisplay($predefined_parent_storage_data));	
		}		
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Get the current menu object. Needed to disable menu options based on storage type
		$atim_menu = $this->Menus->get('/StorageLayout/StorageMasters/detail/%%StorageMaster.id%%');
		
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
		$this->Structures->set($storage_data['StorageControl']['form_alias'].($storage_data['StorageControl']['set_temperature']? ',storage_temperature' : ''));
	
		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
					
		if(empty($this->request->data)) {
			$this->request->data = $storage_data;	
			
		} else {
			// Validates and set additional data
			$submitted_data_validates = true;
			
			$this->request->data['StorageMaster']['id'] = $storage_master_id;
			$this->StorageMaster->data = array();
			$this->StorageMaster->set($this->request->data);
			if(!$this->StorageMaster->validates()){
				$submitted_data_validates = false;
			}
			
			// Reste data to get position data
			$this->request->data = $this->StorageMaster->data;
		
			if($submitted_data_validates) {
				// Set selection label
				$this->request->data['StorageMaster']['selection_label'] = $this->StorageMaster->getSelectionLabel($this->request->data);	
			
				// Set storage temperature information
				$this->StorageMaster->manageTemperature($this->request->data, array('StorageControl' => $storage_data['StorageControl']));
			}
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}		
			
			if($submitted_data_validates) {
				$this->StorageMaster->addWritableField(array('storage_control_id', 'parent_id', 'selection_label', 'temperature', 'temp_unit'));
				
				// Save storage data
				$this->StorageMaster->id = $storage_master_id;		
				if($this->StorageMaster->save($this->request->data, false)) {
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) {
						require($hook_link);
					}
					
					// Manage children temperature
					$storage_temperature = (array_key_exists('temperature', $this->request->data['StorageMaster']))? $this->request->data['StorageMaster']['temperature'] : $storage_data['StorageMaster']['temperature'];
					$storage_temp_unit = (array_key_exists('temp_unit', $this->request->data['StorageMaster']))? $this->request->data['StorageMaster']['temp_unit'] : $storage_data['StorageMaster']['temp_unit'];
					$this->StorageMaster->updateChildrenSurroundingTemperature($storage_master_id, $storage_temperature, $storage_temp_unit);
					
					// Manage children selection label
					if(strcmp($this->request->data['StorageMaster']['selection_label'], $storage_data['StorageMaster']['selection_label']) != 0) {	
						$this->StorageMaster->updateChildrenStorageSelectionLabel($storage_master_id, $this->request->data);
					}		
					$this->atimFlash('your data has been updated', '/StorageLayout/StorageMasters/detail/' . $storage_master_id); 
				}
					
			}
		}
	}
	
	function delete($storage_master_id) {
		// Get the storage data
		$storage_data = $this->StorageMaster->getOrRedirect($storage_master_id);

		// Check deletion is allowed
		$arr_allow_deletion = $this->StorageMaster->allowDeletion($storage_master_id);

		// CUSTOM CODE
		
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }		
				
		if($arr_allow_deletion['allow_deletion']) {
			// First remove storage from tree
			$this->StorageMaster->id = $storage_master_id;	
			$this->StorageMaster->data = array();	
			$cleaned_storage_data = array('StorageMaster' => array('parent_id' => ''));
			$this->StorageMaster->addWritableField(array('parent_id'));
			if(!$this->StorageMaster->save($cleaned_storage_data, false)) { 
				$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
			}
			
			// Create has many relation to delete the storage coordinate
			$this->StorageMaster->bindModel(array('hasMany' => array('StorageCoordinate' => array('className' => 'StorageCoordinate', 'foreignKey' => 'storage_master_id', 'dependent' => true))), false);	

			// Delete storage
			$message = '';
			$atim_flash = null;
			if($this->StorageMaster->atimDelete($storage_master_id, true)) {
				$atim_flash = true;
			} else {
				$atim_flash = false;
			}
			
			$this->StorageMaster->bindModel(array('hasMany' => array('StorageCoordinate')), false);
			if($atim_flash){
				$this->atimFlash('your data has been deleted', '/StorageLayout/StorageMasters/search/');
			}else{
				$this->flash('error deleting data - contact administrator', '/StorageLayout/StorageMasters/search/');
			}
		} else {
			$this->flash($arr_allow_deletion['msg'], '/StorageLayout/StorageMasters/detail/' . $storage_master_id);
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
			$storage_data = $this->StorageMaster->getOrRedirect($storage_master_id);
			$tree_data = $this->StorageMaster->find('all', array('conditions' => array('StorageMaster.parent_id' => $storage_master_id), 'recursive' => '0'));
			$aliquots = $this->AliquotMaster->find('all', array('conditions' => array('AliquotMaster.storage_master_id' => $storage_master_id), 'recursive' => '0'));
			$tree_data = array_merge($tree_data, $aliquots);
			$tma_slides = $this->TmaSlide->find('all', array('conditions' => array('TmaSlide.storage_master_id' => $storage_master_id), 'recursive' => '0'));
			$tree_data = array_merge($tree_data, $tma_slides);
			$atim_menu = $this->Menus->get('/StorageLayout/StorageMasters/contentTreeView/%%StorageMaster.id%%');
			if(!$is_ajax && !$storage_data['StorageControl']['is_tma_block']) {			
				// Get all storage control types to build the add to selected button
				$this->set('storage_types_from_id', $this->StorageControl->getStorageTypePermissibleValues());
			}
		}else{
			$tree_data = $this->StorageMaster->find('all', array('conditions' => array('StorageMaster.parent_id IS NULL'), 'order' => 'CAST(StorageMaster.parent_storage_coord_x AS signed), CAST(StorageMaster.parent_storage_coord_y AS signed)', 'recursive' => '0'));
			$atim_menu = $this->Menus->get('/StorageLayout/StorageMasters/search');
			$this->set("search", true);
			$this->set('storage_types_from_id', $this->StorageControl->getStorageTypePermissibleValues());
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
			$data_unit['children'] = isset($data_unit['StorageMaster']) && !isset($data_unit['TmaSlide']) && !isset($data_unit['AliquotMaster']) && array_key_exists($data_unit['StorageMaster']['id'], $ids);
		}
			
		$this->request->data = $tree_data;
						
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
	 * @param $is_ajax: Tells wheter the request has to be treated as ajax 
	 * query (required to counter issues in Chrome 15 back/forward button on the
	 * page and Opera 11.51 first ajax query that is not recognized as such)
	 * 
	 * @author N. Luc
	 * @since 2007-05-22
	 */
	 
	function storageLayout($storage_master_id, $is_ajax = false){
		// MANAGE STORAGE DATA
		
		// Get the storage data
		$storage_data = $this->StorageMaster->getOrRedirect($storage_master_id); 

		$coordinate_list = array();
		if($storage_data['StorageControl']['coord_x_type'] == "list"){
			$coordinate_tmp = $this->StorageCoordinate->find('all', array('conditions' => array('StorageCoordinate.storage_master_id' => $storage_master_id), 'recursive' => '-1', 'order' => 'StorageCoordinate.order ASC'));
			foreach($coordinate_tmp as $key => $value){
				$coordinate_list[$value['StorageCoordinate']['id']]['StorageCoordinate'] = $value['StorageCoordinate'];
			} 
			if(empty($coordinate_list)) {
				if($is_ajax){
					echo json_encode(array('valid' => 0));
					exit;
				}else{
					$this->flash('no layout exists - add coordinates first', '/StorageLayout/StorageMasters/detail/' . $storage_master_id);
					return;
				}
			}
		}
		
		// Storage layout not allowed for this type of storage
		if(empty($storage_data['StorageControl']['coord_x_type'])) {
			if($is_ajax){
				echo json_encode(array('valid' => 0));
				exit;	
			}else{
				$this->flash('no storage layout is defined for this storage type', '/StorageLayout/StorageMasters/detail/' . $storage_master_id);	
				return;
			} 
		}
		if(!empty($this->request->data)){	
		
			$data = array();
			$unclassified = array();
			
			$json = (json_decode($this->request->data));
			
			$second_storage_id = null;
			foreach($json as $element){
				if((int)$element->s && $element->s != $storage_master_id){
					if($second_storage_id == null){
						$second_storage_id = $element->s; 
					}else if($second_storage_id != $element->s){
						//more than 2 storages
						$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
					}
				}
			}
			
			$storage_data = array($storage_data);
			if($second_storage_id){
				$storage_data[] = $this->StorageMaster->getOrRedirect($second_storage_id);
			}
			$storage_data = AppController::defineArrayKey($storage_data, 'StorageMaster', 'id', true);
			
			
			//have cells with id as key
			for($i = sizeof($json) - 1; $i >= 0; -- $i){
				//builds a $cell[type][id] array
				$data[$json[$i]->{'type'}][$json[$i]->{'id'}] = (array)$json[$i]; 
			}

			foreach($storage_data as $storage_id => $storage_data_unit){
				if($storage_data_unit['StorageControl']['coord_x_type'] == "list"){
					foreach($data as &$data_model){
						foreach($data_model as &$value){
							if(is_numeric($value['x']) && $value['s'] = $storage_id){
								$value['x'] = $coordinate_list[$value['x']]['StorageCoordinate']['coordinate_value'];
							}
						}
					}
				}
			}
			
			$storages_initial_data = isset($data['StorageMaster']) ? $this->StorageMaster->find('all', array('conditions' => array('StorageMaster.id' => array_keys($data['StorageMaster'])))) : array();
			$aliquots_initial_data = isset($data['AliquotMaster']) ? $this->AliquotMaster->find('all', array('conditions' => array('AliquotMaster.id' => array_keys($data['AliquotMaster'])))) : array();
			$tmas_initial_data = isset($data['TmaSlide']) ? $this->TmaSlide->find('all', array('conditions' => array('TmaSlide.id' => array_keys($data['TmaSlide'])))) : array();
			
			//manual validate/alteration of positions based on position conflict checks
			$storage_config = array();
			$conflicts_found = $this->StorageMaster->checkBatchLayoutConflicts($data, 'StorageMaster', 'selection_label', $storage_config);
			$conflicts_found = $this->StorageMaster->checkBatchLayoutConflicts($data, 'AliquotMaster', 'barcode', $storage_config) || $conflicts_found;
			$conflicts_found = $this->StorageMaster->checkBatchLayoutConflicts($data, 'TmaSlide', 'barcode', $storage_config) || $conflicts_found;
			$err = $this->StorageMaster->validationErrors;
			
			//update StorageMaster
			$this->StorageMaster->check_writable_fields = false;
			$this->StorageMaster->updateAndSaveDataArray($storages_initial_data, "StorageMaster", "parent_storage_coord_x", "parent_storage_coord_y", "parent_id", $data, $this->StorageMaster, $storage_data);
			
			//Update AliquotMaster
			$this->AliquotMaster->check_writable_fields = false;
			$this->StorageMaster->updateAndSaveDataArray($aliquots_initial_data, "AliquotMaster", "storage_coord_x", "storage_coord_y", "storage_master_id", $data, $this->AliquotMaster, $storage_data);
			
			//Update TmaSlide
			$this->TmaSlide->check_writable_fields = false;
			$this->StorageMaster->updateAndSaveDataArray($tmas_initial_data, "TmaSlide", "storage_coord_x", "storage_coord_y", "storage_master_id", $data, $this->TmaSlide, $storage_data);

			if($conflicts_found){
				AppController::addWarningMsg(__('your data has been saved'));
				$this->StorageMaster->validationErrors = $err;
				$storage_data = $storage_data[$storage_master_id];
			}else{
				$this->atimFlash('your data has been saved', '/StorageLayout/StorageMasters/storageLayout/' . $storage_master_id);
				return;
			}
		}
		$this->request->data = array();
		
		$storage_master_c = $this->StorageMaster->find('all', array('conditions' => array('StorageMaster.parent_id' => $storage_master_id)));
		$aliquot_master_c = $this->AliquotMaster->find('all', array('conditions' => array('AliquotMaster.storage_master_id' => $storage_master_id), 'recursive' => '-1'));
		$tma_slide_c = $this->TmaSlide->find('all', array('conditions' => array('TmaSlide.storage_master_id' => $storage_master_id), 'recursive' => '-1'));
					
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Get the current menu object. Needed to disable menu options based on storage type
		$atim_menu = $this->Menus->get('/StorageLayout/StorageMasters/storageLayout/%%StorageMaster.id%%');
	
		if(!$this->StorageControl->allowCustomCoordinates($storage_data['StorageControl']['id'], array('StorageControl' => $storage_data['StorageControl']))) {
			// Check storage supports custom coordinates and disable access to coordinates menu option if required
			$atim_menu = $this->inactivateStorageCoordinateMenu($atim_menu);
		}
		
		// Get all storage control types to build the add to selected button
		$storage_types_from_id = $this->StorageControl->getStorageTypePermissibleValues();
		if(!$storage_data['StorageControl']['is_tma_block']) $this->set('storage_types_from_id', $storage_types_from_id);
		
		// Add translated storage type to main storage and chidlren storage
		$storage_control_id = $storage_data['StorageControl']['id'];
		$storage_data['StorageControl']['translated_storage_type'] = isset($storage_types_from_id[$storage_control_id])? $storage_types_from_id[$storage_control_id] : $storage_data['StorageControl']['storage_type'];
		foreach($storage_master_c as &$new_children_storage) {
			$children_storage_control_id = $new_children_storage['StorageControl']['id'];
			$new_children_storage['StorageControl']['translated_storage_type'] = isset($storage_types_from_id[$children_storage_control_id])? $storage_types_from_id[$children_storage_control_id] : $new_children_storage['StorageControl']['storage_type'];
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
				$link = $this->request->webroot."/StorageLayout/StorageMasters/detail/".$children_array["StorageMaster"]['id']."/2";
				$this->StorageMaster->buildChildrenArray($children_array, "StorageMaster", "parent_storage_coord_x", "parent_storage_coord_y", "selection_label", $rkey_coordinate_list, $link, "storage");
			}else if(isset($children_array['AliquotMaster'])){
				$link = $this->request->webroot."/InventoryManagement/AliquotMasters/detail/".$children_array["AliquotMaster"]["collection_id"]."/".$children_array["AliquotMaster"]["sample_master_id"]."/".$children_array["AliquotMaster"]["id"]."/2";
				$this->StorageMaster->buildChildrenArray($children_array, "AliquotMaster", "storage_coord_x", "storage_coord_y", "barcode", $rkey_coordinate_list, $link, "aliquot");
			}else if(isset($children_array['TmaSlide'])){
				$link = $this->request->webroot."/StorageLayout/TmaSlides/detail/".$children_array["TmaSlide"]['tma_block_storage_master_id']."/".$children_array["TmaSlide"]['id']."/2";
				$this->StorageMaster->buildChildrenArray($children_array, "TmaSlide", "storage_coord_x", "storage_coord_y", "barcode", $rkey_coordinate_list, $link, "slide");
			}
		}
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}		
		
		$this->set('data', $data);
		$this->Structures->set('empty', 'empty_structure');
		if($is_ajax){
			$this->render('storage_layout_html');
		}
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
			'fields' => array('StorageMaster.selection_label', 'StorageMaster.code', 'StorageControl.storage_type', 'StorageControl.id'),
			'order' => array('StorageMaster.selection_label ASC, StorageMaster.code ASC'),
			'recursive' => 0,
			'limit' => 10
		));
		
		$storage_types_from_id = $this->StorageControl->getStorageTypePermissibleValues();
		
		//build javascript textual array
		$result = "";
		$count = 0;
		foreach($storage_masters as $storage_master){
			$storage_control_id = $storage_master['StorageControl']['id'];
			$result .= '"'.$storage_master['StorageMaster']['selection_label'].' ['.$storage_master['StorageMaster']['code'].'] / '.
				(isset($storage_types_from_id[$storage_control_id])? $storage_types_from_id[$storage_control_id] : $storage_master['StorageControl']['storage_type']).'", ';			
			++ $count;
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
