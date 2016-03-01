<?php

class TmaSlidesController extends StorageLayoutAppController {
	
	var $components = array();
	
	var $uses = array(
		'StorageLayout.StorageMaster',
		'StorageLayout.TmaSlide',
		'StorageLayout.StorageCoordinate',
		'StorageLayout.StorageControl');
	
	var $paginate = array('TmaSlide' => array('order' => 'TmaSlide.barcode DESC'));

	/* --------------------------------------------------------------------------
	 * DISPLAY FUNCTIONS
	 * -------------------------------------------------------------------------- */	
		
	function listAll($tma_block_storage_master_id) {
		// MANAGE DATA

		// Get the storage data
		$storage_data = $this->StorageMaster->getOrRedirect($tma_block_storage_master_id);
		
		// Verify storage is tma block
		if(!$storage_data['StorageControl']['is_tma_block']) { 
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
		}

		// Get TMA slide liste
		$this->request->data = $this->paginate($this->TmaSlide, array('TmaSlide.tma_block_storage_master_id' => $tma_block_storage_master_id));
		
		// MANAGE FORM, MENU AND ACTION BUTTONS

		// Get the current menu object. Needed to disable menu options based on storage type		
		$atim_menu = $this->Menus->get('/StorageLayout/StorageMasters/detail/%%StorageMaster.id%%');
		
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
	
	function add($tma_block_storage_master_id = null){
		//GET DATA
		
		$initial_display = false;
		$tma_block_ids = array();
		
		$url_to_cancel = 'javascript:history.go(-1)';
		if(isset($this->request->data['url_to_cancel'])) {
			$url_to_cancel = $this->request->data['url_to_cancel'];
			if(preg_match('/^javascript:history.go\((-?[0-9]*)\)$/', $url_to_cancel, $matches)){
				$back = empty($matches[1]) ? -1 : $matches[1] - 1;
				$url_to_cancel = 'javascript:history.go('.$back.')';
			}
		}
		unset($this->request->data['url_to_cancel']);
				
		if($tma_block_storage_master_id != null){
			// User is workning on a tma block
			$tma_block_ids = array($tma_block_storage_master_id);
			if(empty($this->request->data)) $initial_display = true;
		} else if(isset($this->request->data['ViewStorageMaster']['id'])){
			// User launched an action from the DataBrowser or a Report Form
			if($this->request->data['ViewStorageMaster']['id'] == 'all' && isset($this->request->data['node'])) {
				//The displayed elements number was higher than the databrowser_and_report_results_display_limit
				$this->BrowsingResult = AppModel::getInstance('Datamart', 'BrowsingResult', true);
				$browsing_result = $this->BrowsingResult->find('first', array('conditions' => array('BrowsingResult.id' => $this->request->data['node']['id'])));
				$this->request->data['ViewStorageMaster']['id'] = explode(",", $browsing_result['BrowsingResult']['id_csv']);
			}
			$tma_block_ids = array_filter($this->request->data['ViewStorageMaster']['id']);
			$initial_display = true;
		}else if(!empty($this->request->data)) {
			// User submit data of the TmaSlide.add() form
			$tma_block_ids = array_keys($this->request->data);
		} else {
			$this->flash((__('you have been redirected automatically').' (#'.__LINE__.')'), $url_to_cancel, 5);
			return;
		}
		
		// Get TMA Blocks data
		
		$tma_blocks = $this->StorageMaster->find('all', array('conditions' => array('StorageMaster.id' => $tma_block_ids), 'recursive' => '0'));
		$this->StorageMaster->sortForDisplay($tma_blocks, $tma_block_ids);
		$tma_blocks_from_id = array();
		$real_storage_selected = false;		// Different than TMA block
		foreach($tma_blocks as &$tma_block_data) {
			$tma_block_data = array_merge(array('Block' => $tma_block_data['StorageMaster']), $tma_block_data);
			$tma_blocks_from_id[$tma_block_data['StorageMaster']['id']] = $tma_block_data;
			if(!$tma_block_data['StorageControl']['is_tma_block']) $real_storage_selected = true;
		}	
		if($real_storage_selected) {
			$this->flash((__('at least one selected item is not a tma block')), $url_to_cancel, 5);
		}
		$display_limit = Configure::read('TmaSlideCreation_processed_items_limit');
		if(sizeof($tma_blocks_from_id) > $display_limit) {
			$this->flash(__("batch init - number of submitted records too big")." (>$display_limit)", $url_to_cancel, 5);
		}
		if(sizeof($tma_blocks_from_id) != sizeof($tma_block_ids)) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);

		// SET MENU AND STRUCTURE DATA
		
		$this->set('url_to_cancel', $url_to_cancel);
		$this->set('tma_block_storage_master_id', $tma_block_storage_master_id);
		
		// Set menu
		if($tma_block_storage_master_id != null) {
			// Get the current menu object. Needed to disable menu options based on storage type
			$atim_menu = $this->Menus->get('/StorageLayout/StorageMasters/detail/%%StorageMaster.id%%');
			// Inactivate Storage Coordinate Menu (unpossible for TMA type)
			$this->set('atim_menu', $this->inactivateStorageCoordinateMenu($atim_menu));
			// Variables	
			$this->set('atim_menu_variables', array('StorageMaster.id' => $tma_block_storage_master_id));
		} else {
			$this->set('atim_menu', $this->Menus->get('/StorageLayout/StorageMasters/search/'));
			$this->set('atim_menu_variables', array());
		}
		
		// Set structure
		$this->Structures->set('tma_slides');
		$this->Structures->set('tma_blocks_for_slide_creation', 'tma_blocks_atim_structure');
		
		//MANAGE DATA
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
		
		if($initial_display){
			
			$this->request->data = array();
			foreach($tma_blocks as $block_data_unit){
				$this->request->data[] = array('parent' => $block_data_unit, 'children' => array());
			}
			
			$hook_link = $this->hook('initial_display');
			if($hook_link){
				require($hook_link);
			}
			
		} else {
			$previous_data = $this->request->data;
			$this->request->data = array();
			
			//validate
			$errors = array();
			$tma_slides_to_create = array();
			$line = 0;
			
			$record_counter = 0;
			foreach($previous_data as $key_block_storage_master_id => $data_unit){			
				$record_counter++;
				
				if(!array_key_exists($key_block_storage_master_id, $tma_blocks_from_id)) $this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true);
				$tma_block_data = $tma_blocks_from_id[$key_block_storage_master_id];
				
				unset($data_unit['Block']);
				
				if(empty($data_unit)){
					$errors['']['you must create at least one slide for each tma'][$record_counter] = $record_counter;
				}
				foreach($data_unit as &$use_data_unit){
					$use_data_unit['TmaSlide']['tma_block_storage_master_id'] = $key_block_storage_master_id;
					$this->TmaSlide->data = null;
					$this->TmaSlide->set($use_data_unit);
					if(!$this->TmaSlide->validates()){
						foreach($this->TmaSlide->validationErrors as $field => $msgs) {
							$msgs = is_array($msgs)? $msgs : array($msgs);
							foreach($msgs as $msg) $errors[$field][$msg][$record_counter] = $record_counter;
						}
					}
					$use_data_unit = $this->TmaSlide->data;
				}
				$tma_slides_to_create = array_merge($tma_slides_to_create, $data_unit);
				
				$this->request->data[] = array('parent' => $tma_block_data, 'children' => $data_unit);
			}
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}
			
			if(empty($errors)){
				
				AppModel::acquireBatchViewsUpdateLock();
				
				//saving
				$this->TmaSlide->addWritableField(array('tma_block_storage_master_id','storage_master_id'));
				$this->TmaSlide->writable_fields_mode = 'addgrid';
				$this->TmaSlide->saveAll($tma_slides_to_create, array('validate' => false));
				
				$hook_link = $this->hook('postsave_process');
				if($hook_link){
					require($hook_link);
				}
				
				AppModel::releaseBatchViewsUpdateLock();
				
				if($tma_block_storage_master_id != null){
					$this->atimFlash(__('your data has been saved'), '/StorageLayout/StorageMasters/detail/'.$tma_block_storage_master_id);
				}else{
					//batch
					$last_id = $this->TmaSlide->getLastInsertId();
					$batch_ids = range($last_id - count($tma_slides_to_create) + 1, $last_id);			
					$datamart_structure = AppModel::getInstance("Datamart", "DatamartStructure", true);
					$batch_set_model = AppModel::getInstance('Datamart', 'BatchSet', true);
					$batch_set_data = array('BatchSet' => array(
						'datamart_structure_id' => $datamart_structure->getIdByModelName('TmaSlide'),
						'flag_tmp' => true
					));
					$batch_set_model->check_writable_fields = false;
					$batch_set_model->saveWithIds($batch_set_data, $batch_ids);
					$this->atimFlash(__('your data has been saved'), '/Datamart/BatchSets/listall/'.$batch_set_model->getLastInsertId());
				}
			}else{
				$this->TmaSlide->validationErrors = array();
				foreach($errors as $field => $msg_and_lines) {
					foreach($msg_and_lines as $msg => $lines) {
						$this->TmaSlide->validationErrors[$field][] = __($msg) .(($record_counter != 1)? ' - ' . str_replace('%s', implode(",", $lines), __('see # %s')) : '');
					}
				}
			}
		}
	}
	
	function detail($tma_block_storage_master_id, $tma_slide_id, $is_from_tree_view_or_layout = 0) {
		// $is_from_tree_view_or_layout : 0-Normal, 1-Tree view, 2-Stoarge layout
		
		// MANAGE DATA

		// Get the storage data
		$storage_data = $this->StorageMaster->getOrRedirect($tma_block_storage_master_id);

		// Verify storage is tma block
		if(!$storage_data['StorageControl']['is_tma_block']) { 
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
		}
		
		// Get the tma slide data
		$tma_slide_data = $this->TmaSlide->find('first', array('conditions' => array('TmaSlide.id' => $tma_slide_id, 'TmaSlide.tma_block_storage_master_id' => $tma_block_storage_master_id)));
		if(empty($tma_slide_data)) { 
			$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		}		
		$this->request->data = $tma_slide_data; 
		
		// Define if this detail form is displayed into the children storage tree view
		$this->set('is_from_tree_view_or_layout', $is_from_tree_view_or_layout);
			
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Get the current menu object. Needed to disable menu options based on storage type		
		$atim_menu = $this->Menus->get('/StorageLayout/StorageMasters/detail/%%StorageMaster.id%%');
		
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
		// MANAGE DATA

		// Get the storage data
		$storage_data = $this->StorageMaster->getOrRedirect($tma_block_storage_master_id);

		// Verify storage is tma block
		if(!$storage_data['StorageControl']['is_tma_block']) { 
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
		}
		
		// Get the tma slide data
		$tma_slide_data = $this->TmaSlide->find('first', array('conditions' => array('TmaSlide.id' => $tma_slide_id, 'TmaSlide.tma_block_storage_master_id' => $tma_block_storage_master_id)));
		if(empty($tma_slide_data)) { 
			$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		}		

		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Get the current menu object. Needed to disable menu options based on storage type		
		$atim_menu = $this->Menus->get('/StorageLayout/StorageMasters/detail/%%StorageMaster.id%%');
		
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
		
		if(empty($this->request->data)) {
			$tma_slide_data['FunctionManagement']['recorded_storage_selection_label'] = $this->StorageMaster->getStorageLabelAndCodeForDisplay(array('StorageMaster' => $tma_slide_data['StorageMaster']));
			$this->request->data = $tma_slide_data;
			
		} else {
			//Update data
			
			// Validates data
			$submitted_data_validates = true;
			
			$this->request->data['TmaSlide']['id'] = $tma_slide_id;
			$this->TmaSlide->set($this->request->data);
			if(!$this->TmaSlide->validates()){
				$submitted_data_validates = false;
			}
			
			// Reste data to get position data
			$this->request->data = $this->TmaSlide->data;
						
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}		

			if($submitted_data_validates) {
				// Save tma slide data
				$this->TmaSlide->addWritableField(array('storage_master_id'));
				$this->TmaSlide->id = $tma_slide_id;		
				if($this->TmaSlide->save($this->request->data, false)) {
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) {
						require($hook_link);
					}
					$this->atimFlash(__('your data has been updated'), '/StorageLayout/TmaSlides/detail/' . $tma_block_storage_master_id . '/' . $tma_slide_id); 
				}
			}	
		}
	}
	
	function editInBatch($tma_block_storage_master_id = null) {
		// MANAGE DATA
				
		$initial_display = false;
		
		$url_to_cancel = 'javascript:history.go(-1)';
		if(isset($this->request->data['url_to_cancel'])) {
			$url_to_cancel = $this->request->data['url_to_cancel'];
			if(preg_match('/^javascript:history.go\((-?[0-9]*)\)$/', $url_to_cancel, $matches)){
				$back = empty($matches[1]) ? -1 : $matches[1] - 1;
				$url_to_cancel = 'javascript:history.go('.$back.')';
			}
		}
		unset($this->request->data['url_to_cancel']);
		
		$criteria = array('TmaSlide.id' => '-1');
		$tma_slide_ids_for_sorting = array();
		if($tma_block_storage_master_id != null){
			// User is workning on a tma block
			$this->StorageMaster->getOrRedirect($tma_block_storage_master_id);
			$criteria = array('TmaSlide.tma_block_storage_master_id' => $tma_block_storage_master_id);
			if(empty($this->request->data)) $initial_display = true;
		} else if(isset($this->request->data['TmaSlide']['id'])){
			// User launched an action from the DataBrowser or a Report Form
			if($this->request->data['TmaSlide']['id'] == 'all' && isset($this->request->data['node'])) {
				//The displayed elements number was higher than the databrowser_and_report_results_display_limit
				$this->BrowsingResult = AppModel::getInstance('Datamart', 'BrowsingResult', true);
				$browsing_result = $this->BrowsingResult->find('first', array('conditions' => array('BrowsingResult.id' => $this->request->data['node']['id'])));
				$this->request->data['TmaSlide']['id'] = explode(",", $browsing_result['BrowsingResult']['id_csv']);
			}
			$tma_slide_ids_for_sorting = array_filter($this->request->data['TmaSlide']['id']);
			$criteria = array('TmaSlide.id' => $tma_slide_ids_for_sorting);
			$initial_display = true;
		} else if(!empty($this->request->data)) {
			// User submit data of the TmaSlide.editInBatch() form
			$tma_slide_ids_for_sorting = explode(',',$this->request->data['tma_slide_ids_for_sorting']);
			$criteria = array('TmaSlide.id' => $tma_slide_ids_for_sorting);
		} else {
			$this->flash((__('you have been redirected automatically').' (#'.__LINE__.')'), $url_to_cancel, 5);
			return;
		}
		unset($this->request->data['tma_slide_ids_for_sorting']);
		
		$slides_data = $this->TmaSlide->find('all', array('conditions' => $criteria, 'order' => 'TmaSlide.barcode ASC'));
		if(empty($slides_data)) {
			$this->flash(__('no slide to update'), $url_to_cancel);
		}
		if($tma_slide_ids_for_sorting) $this->TmaSlide->sortForDisplay($slides_data, $tma_slide_ids_for_sorting);
		$display_limit = Configure::read('TmaSlideCreation_processed_items_limit');
		if(sizeof($slides_data) > $display_limit) {
			$this->flash(__("batch init - number of submitted records too big")." (>$display_limit)", $url_to_cancel, 5);
		}
		
		// Set array to get id from barcode
		$slide_id_by_barcode = array();
		foreach($slides_data as $tmp_data){
			$slide_id_by_barcode[$tmp_data['TmaSlide']['barcode']] = $tmp_data['TmaSlide']['id'];
		}
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('url_to_cancel', $url_to_cancel);
		$this->set('tma_block_storage_master_id', $tma_block_storage_master_id);
		$this->set('tma_slide_ids_for_sorting', implode(',',$tma_slide_ids_for_sorting));
		
		// Set menu
		if($tma_block_storage_master_id != null) {
			// Get the current menu object. Needed to disable menu options based on storage type
			$atim_menu = $this->Menus->get('/StorageLayout/StorageMasters/detail/%%StorageMaster.id%%');
			// Inactivate Storage Coordinate Menu (unpossible for TMA type)
			$this->set('atim_menu', $this->inactivateStorageCoordinateMenu($atim_menu));
			// Variables
			$this->set('atim_menu_variables', array('StorageMaster.id' => $tma_block_storage_master_id));
		} else {
			$this->set('atim_menu', $this->Menus->get('/StorageLayout/StorageMasters/search/'));
			$this->set('atim_menu_variables', array());
		}
		
		// Set structure
		$this->Structures->set('tma_slides'.($tma_block_storage_master_id? '': ',tma_blocks_for_slide_creation'));
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
		
		// SAVE DATA
		
		if($initial_display) {
			$this->request->data = $slides_data;
			foreach($this->request->data as &$new_slides_data){
				$new_slides_data['FunctionManagement']['recorded_storage_selection_label'] = $this->StorageMaster->getStorageLabelAndCodeForDisplay(array('StorageMaster' => $new_slides_data['StorageMaster']));
			}
				
			$hook_link = $this->hook('initial_display');
			if($hook_link){
				require($hook_link);
			}
			
		} else {
			
			// Launch validation
			$submitted_data_validates = true;	
			
			$errors = array();	
			$record_counter = 0;
			foreach($this->request->data as $key => $new_studied_tma){
				$record_counter++;
				// Get id
				if(!isset($slide_id_by_barcode[$new_studied_tma['TmaSlide']['barcode']])) { $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); }
				$new_studied_tma['TmaSlide']['id'] = $slide_id_by_barcode[$new_studied_tma['TmaSlide']['barcode']];
				// Launch Slide validation
				$this->TmaSlide->set($new_studied_tma);
				$submitted_data_validates = ($this->TmaSlide->validates()) ? $submitted_data_validates : false;
				$new_studied_tma = $this->TmaSlide->data;
				foreach($this->TmaSlide->validationErrors as $field => $msgs) {
					$msgs = is_array($msgs)? $msgs : array($msgs);
					foreach($msgs as $msg) $errors['TmaSlide'][$field][$msg][]= $record_counter;
				}
				// Reset data
				$this->request->data[$key] = $new_studied_tma;				
			}						
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}
		
			if ($submitted_data_validates) {
				
				AppModel::acquireBatchViewsUpdateLock();
				
				// Launch save process
				$this->TmaSlide->addWritableField(array('storage_master_id'));
				$this->TmaSlide->writable_fields_mode = 'editgrid';
				foreach($this->request->data as $tma_data){
					// Save data
					$this->TmaSlide->data = array();
					$this->TmaSlide->id = $tma_data['TmaSlide']['id'];
					if(!$this->TmaSlide->save($tma_data['TmaSlide'], false)) { 
						$this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true); 
					}
				}
				
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) { 
					require($hook_link); 
				}
				
				// Redirect
				
				AppModel::releaseBatchViewsUpdateLock();
				
				if($tma_block_storage_master_id != null){
					$this->atimFlash(__('your data has been saved'), '/StorageLayout/StorageMasters/detail/'.$tma_block_storage_master_id);
				}else{
					//batch
					$batch_ids = $tma_slide_ids_for_sorting;
					$datamart_structure = AppModel::getInstance("Datamart", "DatamartStructure", true);
					$batch_set_model = AppModel::getInstance('Datamart', 'BatchSet', true);
					$batch_set_data = array('BatchSet' => array(
						'datamart_structure_id' => $datamart_structure->getIdByModelName('TmaSlide'),
						'flag_tmp' => true
					));
					$batch_set_model->check_writable_fields = false;
					$batch_set_model->saveWithIds($batch_set_data, $batch_ids);
					$this->atimFlash(__('your data has been saved'), '/Datamart/BatchSets/listall/'.$batch_set_model->getLastInsertId());
				}
				
			} else {	
				// Set error message			
				foreach($errors as $model => $field_messages) {
					$this->{$model}->validationErrors = array();
					foreach($field_messages as $field => $messages) {
						foreach($messages as $message => $lines_nbr) {
							if(!array_key_exists($field, $this->{$model}->validationErrors)) {
								$this->{$model}->validationErrors[$field][] = __($message).' - ' . str_replace('%s', implode(',',$lines_nbr), __('see line %s'));
							} else {
								$this->{$model}->validationErrors[][] =  __($message).' - ' . str_replace('%s', implode(',',$lines_nbr), __('see line %s'));
							}
						}
					}
				}
			}
		}
	}
	
	function delete($tma_block_storage_master_id, $tma_slide_id) {
		// MANAGE DATA

		// Get the storage data
		$storage_data = $this->StorageMaster->getOrRedirect($tma_block_storage_master_id);

		// Verify storage is tma block
		if(!$storage_data['StorageControl']['is_tma_block']) { 
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
		}
		
		// Get the tma slide data
		$tma_slide_data = $this->TmaSlide->find('first', array('conditions' => array('TmaSlide.id' => $tma_slide_id, 'TmaSlide.tma_block_storage_master_id' => $tma_block_storage_master_id)));
		if(empty($tma_slide_data)) { 
			$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		}

		// Check deletion is allowed
		$arr_allow_deletion = $this->TmaSlide->allowDeletion($tma_slide_id);
		
		// CUSTOM CODE
		
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }
		
		if($arr_allow_deletion['allow_deletion']) {
			// Delete tma slide
			if($this->TmaSlide->atimDelete($tma_slide_id)) {
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) { 
					require($hook_link); 
				}
				$this->atimFlash(__('your data has been deleted'), '/StorageLayout/StorageMasters/detail/' . $tma_block_storage_master_id);
			} else {
				$this->flash(__('error deleting data - contact administrator'), '/StorageLayout/TmaSlides/detail/' . $tma_block_storage_master_id . '/' . $tma_slide_id);
			}		
		} else {
			$this->flash(__($arr_allow_deletion['msg']), '/StorageLayout/TmaSlides/detail/' . $tma_block_storage_master_id . '/' . $tma_slide_id);
		}		
	}
}

?>
