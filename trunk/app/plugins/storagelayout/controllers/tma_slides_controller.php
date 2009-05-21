<?php

class TmaSlidesController extends StoragelayoutAppController {
	
	var $name = 'TmaSlides';
	
	var $uses 
		= array('StorageControl',
			'StorageMaster',
			'TmaSlide');
	
	var $useDbConfig = 'default';
	
	var $components = array('Summaries');
	
	var $helpers = array('Summaries');

	/* --------------------------------------------------------------------------
	 * DISPLAY FUNCTIONS
	 * -------------------------------------------------------------------------- */	
	
	function beforeFilter() {
		
		// $auth_conf array hardcoded in oth_auth component, due to plugins compatibility 
		$this->othAuth->controller = &$this;
		$this->othAuth->init();
		$this->othAuth->check();
		
		// CakePHP function to re-combine dat/time select fields 
		$this->cleanUpFields();
		
	}
	
	/**
	 * List all TMA block slide.
	 * 
	 * @param $std_tma_block_master_id ID of the studied tma block.
	 * 
	 * @author N. Luc
	 * @since 2008-06-02
	 * 
	 */
	 function listAll($std_tma_block_master_id = null) {
		
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($std_tma_block_master_id)) {
			$this->redirect('/pages/err_sto_no_stor_id'); 
			exit;
		}
		
		// ** get STORAGE info **
		$this->StorageMaster->id = $std_tma_block_master_id;
		$storage_master_data = $this->StorageMaster->read();
		
		if(empty($storage_master_data)) {
			$this->redirect('/pages/err_sto_no_stor_data'); 
			exit;
		}

		//Look for storage control
		$this->StorageControl->id = $storage_master_data['StorageMaster']['storage_control_id'];
		$storage_control_data = $this->StorageControl->read();

		if(empty($storage_control_data)){
			$this->redirect('/pages/err_sto_no_stor_cont_data'); 
			exit;
		}	
		
		// Verify storage is tma block
		if(strcmp($storage_control_data['StorageControl']['is_tma_block'], 'TRUE') != 0) {
			$this->redirect('/pages/err_sto_not_a_tma_block'); 
			exit;			
		}
		
		// ** set MENU variable for echo on VIEW **
		$ctrapp_menu[] = $this->Menus->tabs( 'sto_CAN_01', 'sto_CAN_02', $std_tma_block_master_id ); 
		$ctrapp_menu[] = $this->Menus->tabs( 'sto_CAN_02', 'sto_CAN_08', $std_tma_block_master_id );
		if(!$this->requestAction('/storagelayout/storage_coordinates/allowCustomCoordinates/'.$storage_control_data['StorageControl']['id'])) {
			//grey out 'Coordinates' tab
			 $ctrapp_menu['0']['sto_CAN_06']['allowed'] = false;	
		}
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// ** set SUMMARY variable from plugin's COMPONENTS ** 
		$this->set('ctrapp_summary', $this->Summaries->build($std_tma_block_master_id));
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string 
		// that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray(
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action']));
				
		// ** set FORM variable, for HELPER call on VIEW  **	
		$this->set('ctrapp_form', $this->Forms->getFormArray('tma_slides'));

		// ** set DATA for echo on VIEW or to build link **
		$this->set('std_tma_block_master_id', $std_tma_block_master_id);
					
		// ** Search storage coordinate values **

		$criteria = array();
		$criteria['TmaSlide.std_tma_block_id'] = $std_tma_block_master_id;
		$criteria = array_filter($criteria);
			
		list($order, $limit, $page) = $this->Pagination->init($criteria);
		$tma_slide_list = $this->TmaSlide->findAll($criteria, NULL, $order, $limit, $page, 1);

		$this->set('tma_slide_list', $tma_slide_list);
		
		// ** look for CUSTOM HOOKS, "format" **
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
			
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
	} // End ListAll function
	
	/**
	 * Add a TMA slide.
	 * 
	 * @param $std_tma_block_master_id ID of the studied TMA block.
	 * 
	 * @author N. Luc
	 * @since 2008-06-02
	 * 
	 */
	 function add($std_tma_block_master_id = null) {
		
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($std_tma_block_master_id)) {
			$this->redirect('/pages/err_sto_no_stor_id'); 
			exit;
		}
		
		// ** get STORAGE info **
		$this->StorageMaster->id = $std_tma_block_master_id;
		$storage_master_data = $this->StorageMaster->read();
		
		if(empty($storage_master_data)) {
			$this->redirect('/pages/err_sto_no_stor_data'); 
			exit;
		}

		//Look for storage control
		$this->StorageControl->id = $storage_master_data['StorageMaster']['storage_control_id'];
		$storage_control_data = $this->StorageControl->read();

		if(empty($storage_control_data)){
			$this->redirect('/pages/err_sto_no_stor_cont_data'); 
			exit;
		}	
		
		// Verify storage is tma block
		if(strcmp($storage_control_data['StorageControl']['is_tma_block'], 'TRUE') != 0) {
			$this->redirect('/pages/err_sto_not_a_tma_block'); 
			exit;			
		}
		
		// ** set MENU variable for echo on VIEW **
		$ctrapp_menu[] = $this->Menus->tabs( 'sto_CAN_01', 'sto_CAN_02', $std_tma_block_master_id ); 
		$ctrapp_menu[] = $this->Menus->tabs( 'sto_CAN_02', 'sto_CAN_08', $std_tma_block_master_id );
		if(!$this->requestAction('/storagelayout/storage_coordinates/allowCustomCoordinates/'.$storage_control_data['StorageControl']['id'])) {
			//grey out 'Coordinates' tab
			 $ctrapp_menu['0']['sto_CAN_06']['allowed'] = false;
		}
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// ** set SUMMARY variable from plugin's COMPONENTS ** 
		$this->set('ctrapp_summary', $this->Summaries->build($std_tma_block_master_id));
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string 
		// that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray(
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action']));
				
		// ** set FORM variable, for HELPER call on VIEW  **	
		$this->set('ctrapp_form', $this->Forms->getFormArray('tma_slides'));

		// ** set DATA for echo on VIEW or to build link **
		$this->set('std_tma_block_master_id', $std_tma_block_master_id);
		
		$this->set('arr_tma_slide_sop_title_from_id', $this->getTmaSlideSopsArray());		
		
		// ** look for CUSTOM HOOKS, "format" **
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
		if(empty($this->data)) {
			// The storage list will be empty to force user to enter first a storage selection label
			$this->set('arr_storage_list', array());
			
		} else {
			
			// ** Search defined aliquot storage **
			$recorded_selection_label = $this->data['FunctionManagement']['storage_selection_label'];
			$returned_storage_id = $this->data['TmaSlide']['storage_master_id'];
				
			$problem_in_the_storage_defintion = FALSE;
			$arr_storage_list = array();
			
			if(!empty($recorded_selection_label)) {
				// A storage selection label has been recorded
				
				// Look for storage matching the storage selection label 
				$arr_storage_list 
					= $this->requestAction(
						'/storagelayout/storage_masters/getStorageMatchingSelectLabel/'.$recorded_selection_label);
				
				if(empty($returned_storage_id)) {	
					// No storage id has been selected:
					//    User expects to find the storage using selection label
										
					if(empty($arr_storage_list)) {
						// No storage matches	
						$problem_in_the_storage_defintion = TRUE;
						$this->TmaSlide->validationErrors[] 
							= 'no storage matches (at least one of) the selection label(s)';
																
					} else if(sizeof($arr_storage_list) > 1) {
						// More than one storage matche this storage selection label
						$problem_in_the_storage_defintion = TRUE;
						$this->TmaSlide->validationErrors[] 
							= 'more than one storages matche (at least one of) the selection label(s)';
											
					} else {
						// The selection label match only one storage
						$this->data['TmaSlide']['storage_master_id'] 
							= key($arr_storage_list);
					}
				
				} else {
					// A storage id has been selected
					//    Verify that this one matches one record of the $arr_storage_list;
					if(!array_key_exists($returned_storage_id, $arr_storage_list)) {

						// Set error
						$problem_in_the_storage_defintion = TRUE;
						$this->TmaSlide->validationErrors[] 
							= '(at least one of) the selected id does not match a selection label';						
						
						// Add the storage to the array
						$arr_storage_list[$returned_storage_id] 
							= $this->requestAction(
								'/storagelayout/storage_masters/getStorageData/'.$returned_storage_id);				
						
					}	
				}
			
			} else if(!empty($returned_storage_id)) {
				// Only  storage id has been selected:
				//    Be sure to add this one in $arr_storage_list if an error is displayed

				$arr_storage_list 
					= array($returned_storage_id 
						=> $this->requestAction('/storagelayout/storage_masters/getStorageData/'.$returned_storage_id));				
						
			} // else if $returned_storage_id and $recorded_selection_label empty: Nothing to do						

			$this->set('arr_storage_list', $arr_storage_list);	
			
			// ** Verify set aliquot coordinates into storage **
			
			if(empty($this->data['TmaSlide']['storage_master_id'])){
				
				if(!$problem_in_the_storage_defintion) {
					// No storage selected: no coordinate should be set
					$bool_display_error_msg = FALSE;
					
					if(!empty($this->data['TmaSlide']['storage_coord_x'])){
						$this->data['TmaSlide']['storage_coord_x'] = 'err!';
						$bool_display_error_msg = TRUE;
					}
					
					if(!empty($this->data['TmaSlide']['storage_coord_y'])){
						$this->data['TmaSlide']['storage_coord_y'] = 'err!';
						$bool_display_error_msg = TRUE;		
					}
					
					if($bool_display_error_msg) {
						// Display error message
						$this->TmaSlide->validationErrors[] 
							= 'no postion has to be recorded when no storage is selected';
					}
				}
					
			} else {
				// Verify coordinates
				$a_coord_valid = 
					$this->requestAction('/storagelayout/storage_masters/validateStoragePosition/'.
						$this->data['TmaSlide']['storage_master_id'].'/'.
						// Add 'x_' before coord to support empty value
						'x_'.$this->data['TmaSlide']['storage_coord_x'].'/'.
						'y_'.$this->data['TmaSlide']['storage_coord_y'].'/');
						
				$bool_display_error_msg = FALSE;
			
				// Manage coordinate x
				if(!$a_coord_valid['coord_x']['validated']) {
					$this->data['TmaSlide']['storage_coord_x'] = 'err!';
					$bool_display_error_msg = TRUE;
				} else if($a_coord_valid['coord_x']['to_uppercase']) {
					$this->data['TmaSlide']['storage_coord_x'] =
						strtoupper($this->data['TmaSlide']['storage_coord_x']);
				}
				
				// Manage coordinate y
				if(!$a_coord_valid['coord_y']['validated']) {
					$this->data['TmaSlide']['storage_coord_y'] = 'err!';
					$bool_display_error_msg = TRUE;
				} else if($a_coord_valid['coord_y']['to_uppercase']) {
					$this->data['TmaSlide']['storage_coord_y'] =
						strtoupper($this->data['TmaSlide']['storage_coord_y']);
				}
				
				if($bool_display_error_msg) {
				// Display error message
					$this->TmaSlide->validationErrors[] 
						= 'at least one position value does not match format';					
				}

			}
			
			// ** SAVE DATA **
			
			// setup MODEL(s) validation array(s) for displayed FORM 
			foreach ($this->Forms->getValidateArray('tma_slides') as $validate_model=>$validate_rules) {
				$this->{ $validate_model }->validate = $validate_rules;
			}
			
			// set a FLAG
			$submitted_data_validates = TRUE;
			
			if($problem_in_the_storage_defintion) {
				// The aliquot storage has not been correclty defined
				$submitted_data_validates = FALSE;				
			}
			
			if($this->isDuplicatedTmaSlideBarcode($this->data['TmaSlide']['barcode'])) {
				$this->data['TmaSlide']['barcode'] = '';
			}
				
			// VALIDATE submitted data
			if (!$this->TmaSlide->validates($this->data['TmaSlide'])) {
				$submitted_data_validates = false;
			}
			
			// look for CUSTOM HOOKS, "validation"
			$custom_ctrapp_controller_hook 
				= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
				'controllers' . DS . 'hooks' . DS . 
				$this->params['controller'].'_'.$this->params['action'].'_validation.php';
			
			if (file_exists($custom_ctrapp_controller_hook)) {
				require($custom_ctrapp_controller_hook);
			}
			
			// if data VALIDATE, then save data
			if ($submitted_data_validates) {		
				if ($this->TmaSlide->save($this->data['TmaSlide'])) {
					$this->flash('Your data has been saved.', 
						'/tma_slides/listAll/'.$std_tma_block_master_id);				
				} else {
					$this->redirect('/pages/err_tma_slide_record_err'); 
					exit;
				}
				
			}
			
		}
		
	} // End Add function

	/**
	 * Detail a TMA slide.
	 * 
	 * @param $std_tma_block_master_id ID of the studied TMA block.
	 * @param $tma_slide_id ID of the TMA slide.
	 * 
	 * @author N. Luc
	 * @since 2008-06-02
	 * 
	 */
	function detail($std_tma_block_master_id=null, $tma_slide_id=null) {
		
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($std_tma_block_master_id)) {
			$this->redirect('/pages/err_sto_no_stor_id'); 
			exit;
		}
		
		// ** get STORAGE info **
		$this->StorageMaster->id = $std_tma_block_master_id;
		$storage_master_data = $this->StorageMaster->read();
		
		if(empty($storage_master_data)) {
			$this->redirect('/pages/err_sto_no_stor_data'); 
			exit;
		}

		//Look for storage control
		$this->StorageControl->id = $storage_master_data['StorageMaster']['storage_control_id'];
		$storage_control_data = $this->StorageControl->read();

		if(empty($storage_control_data)){
			$this->redirect('/pages/err_sto_no_stor_cont_data'); 
			exit;
		}	
		
		// Verify storage is tma block
		if(strcmp($storage_control_data['StorageControl']['is_tma_block'], 'TRUE') != 0) {
			$this->redirect('/pages/err_sto_not_a_tma_block'); 
			exit;			
		}
		
		// ** set MENU variable for echo on VIEW **
		$ctrapp_menu[] = $this->Menus->tabs( 'sto_CAN_01', 'sto_CAN_02', $std_tma_block_master_id ); 
		$ctrapp_menu[] = $this->Menus->tabs( 'sto_CAN_02', 'sto_CAN_08', $std_tma_block_master_id );
		if(!$this->requestAction('/storagelayout/storage_coordinates/allowCustomCoordinates/'.$storage_control_data['StorageControl']['id'])) {
			//grey out 'Coordinates' tab
			 $ctrapp_menu['0']['sto_CAN_06']['allowed'] = false;
		}
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// ** set SUMMARY variable from plugin's COMPONENTS ** 
		$this->set('ctrapp_summary', $this->Summaries->build($std_tma_block_master_id));
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string 
		// that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray(
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action']));
				
		// ** set FORM variable, for HELPER call on VIEW  **	
		$this->set('ctrapp_form', $this->Forms->getFormArray('tma_slides'));
		
		// ** set DATA for echo on VIEW or to build link **
		$this->set('std_tma_block_master_id', $std_tma_block_master_id);
		$this->set('tma_slide_id', $tma_slide_id);
		
		$this->set('arr_tma_slide_sop_title_from_id', $this->getTmaSlideSopsArray());	
				
		// ** Get Storage Coordinate Data **			
		$this->TmaSlide->id = $tma_slide_id;
		$tma_slide_data = $this->TmaSlide->read();
		
		if(empty($tma_slide_data)){
			$this->redirect('/pages/err_sto_no_tma_slide_data'); 
			exit;
		}
		
		if(strcmp($tma_slide_data['TmaSlide']['std_tma_block_id'], $std_tma_block_master_id) != 0) {
			$this->redirect('/pages/err_sto_no_tma_slide_data'); 
			exit;
		}
		
		$this->set('data', $tma_slide_data); 
		
		// ** look for CUSTOM HOOKS, "format" **
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
	}
	
	/**
	 * Edit a TMA slide.
	 * 
	 * @param $std_tma_block_master_id ID of the studied TMA block.
	 * @param $tma_slide_id ID of the TMA slide.
	 * 
	 * @author N. Luc
	 * @since 2008-06-02
	 * 
	 */
	function edit($std_tma_block_master_id=null, $tma_slide_id=null) {
		
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($std_tma_block_master_id)) {
			$this->redirect('/pages/err_sto_no_stor_id'); 
			exit;
		}
		
		// ** get STORAGE info **
		$this->StorageMaster->id = $std_tma_block_master_id;
		$storage_master_data = $this->StorageMaster->read();
		
		if(empty($storage_master_data)) {
			$this->redirect('/pages/err_sto_no_stor_data'); 
			exit;
		}

		//Look for storage control
		$this->StorageControl->id = $storage_master_data['StorageMaster']['storage_control_id'];
		$storage_control_data = $this->StorageControl->read();

		if(empty($storage_control_data)){
			$this->redirect('/pages/err_sto_no_stor_cont_data'); 
			exit;
		}	
		
		// Verify storage is tma block
		if(strcmp($storage_control_data['StorageControl']['is_tma_block'], 'TRUE') != 0) {
			$this->redirect('/pages/err_sto_not_a_tma_block'); 
			exit;			
		}
		
		// ** set MENU variable for echo on VIEW **
		$ctrapp_menu[] = $this->Menus->tabs( 'sto_CAN_01', 'sto_CAN_02', $std_tma_block_master_id ); 
		$ctrapp_menu[] = $this->Menus->tabs( 'sto_CAN_02', 'sto_CAN_08', $std_tma_block_master_id );
		if(!$this->requestAction('/storagelayout/storage_coordinates/allowCustomCoordinates/'.$storage_control_data['StorageControl']['id'])) {
			//grey out 'Coordinates' tab
			 $ctrapp_menu['0']['sto_CAN_06']['allowed'] = false;
		}
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// ** set SUMMARY variable from plugin's COMPONENTS ** 
		$this->set('ctrapp_summary', $this->Summaries->build($std_tma_block_master_id));
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string 
		// that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray(
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action']));
				
		// ** set FORM variable, for HELPER call on VIEW  **	
		$this->set('ctrapp_form', $this->Forms->getFormArray('tma_slides'));
		
		// ** set DATA for echo on VIEW or to build link **
		$this->set('std_tma_block_master_id', $std_tma_block_master_id);
		$this->set('tma_slide_id', $tma_slide_id);
		
		$this->set('arr_tma_slide_sop_title_from_id', $this->getTmaSlideSopsArray());	
				
		// ** Get Storage Coordinate Data **			
		$this->TmaSlide->id = $tma_slide_id;
		$tma_slide_data = $this->TmaSlide->read();
		
		if(empty($tma_slide_data)){
			$this->redirect('/pages/err_sto_no_tma_slide_data'); 
			exit;
		}
		
		if(strcmp($tma_slide_data['TmaSlide']['std_tma_block_id'], $std_tma_block_master_id) != 0) {
			$this->redirect('/pages/err_sto_no_tma_slide_data'); 
			exit;
		}
		
		// ** look for CUSTOM HOOKS, "format" **
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
		if (empty($this->data)) {
			// ** EDIT DATA **	
			
			$this->data = $tma_slide_data;
			$this->set('data', $this->data);
			
			// Build the list of storage to select
			$aliquot_storage_id = $tma_slide_data['TmaSlide']['storage_master_id'];
			
			$arr_storage_list = array();
			if(!empty($aliquot_storage_id)){
				$arr_storage_list 
					= array($aliquot_storage_id 
						=> $this->requestAction('/storagelayout/storage_masters/getStorageData/'.$aliquot_storage_id));	
			}
				
			$this->set('arr_storage_list', $arr_storage_list);	
			
		} else {
				
			// ** Search defined aliquot storage **
			$recorded_selection_label = $this->data['FunctionManagement']['storage_selection_label'];
			$returned_storage_id = $this->data['TmaSlide']['storage_master_id'];
				
			$problem_in_the_storage_defintion = FALSE;
			$arr_storage_list = array();
			
			if(!empty($recorded_selection_label)) {
				// A storage selection label has been recorded
				
				// Look for storage matching the storage selection label 
				$arr_storage_list 
					= $this->requestAction(
						'/storagelayout/storage_masters/getStorageMatchingSelectLabel/'.$recorded_selection_label);
				
				if(empty($returned_storage_id)) {	
					// No storage id has been selected:
					//    User expects to find the storage using selection label
										
					if(empty($arr_storage_list)) {
						// No storage matches	
						$problem_in_the_storage_defintion = TRUE;
						$this->TmaSlide->validationErrors[] 
							= 'no storage matches (at least one of) the selection label(s)';
																
					} else if(sizeof($arr_storage_list) > 1) {
						// More than one storage matche this storage selection label
						$problem_in_the_storage_defintion = TRUE;
						$this->TmaSlide->validationErrors[] 
							= 'more than one storages matche (at least one of) the selection label(s)';
											
					} else {
						// The selection label match only one storage
						$this->data['TmaSlide']['storage_master_id'] 
							= key($arr_storage_list);
					}
				
				} else {
					// A storage id has been selected
					//    Verify that this one matches one record of the $arr_storage_list;
					if(!array_key_exists($returned_storage_id, $arr_storage_list)) {

						// Set error
						$problem_in_the_storage_defintion = TRUE;
						$this->TmaSlide->validationErrors[] 
							= '(at least one of) the selected id does not match a selection label';						
						
						// Add the storage to the array
						$arr_storage_list[$returned_storage_id] 
							= $this->requestAction(
								'/storagelayout/storage_masters/getStorageData/'.$returned_storage_id);
														
					}	
				}
			
			} else if(!empty($returned_storage_id)) {
				// Only  storage id has been selected:
				//    Be sure to add this one in $arr_storage_list if an error is displayed

				$arr_storage_list 
					= array($returned_storage_id 
						=> $this->requestAction('/storagelayout/storage_masters/getStorageData/'.$returned_storage_id));
					
			} // else if $returned_storage_id and $recorded_selection_label empty: Nothing to do						

			$this->set('arr_storage_list', $arr_storage_list);	
			
			// ** Verify set Coordinates **
			if(empty($this->data['TmaSlide']['storage_master_id'])){
				// No storage selected: no coordinate should be set
				$bool_display_error_msg = FALSE;
				
				if(!empty($this->data['TmaSlide']['storage_coord_x'])){
					$this->data['TmaSlide']['storage_coord_x'] = 'err!';
					$bool_display_error_msg = TRUE;					
				}
				
				if(!empty($this->data['TmaSlide']['storage_coord_y'])){
					$this->data['TmaSlide']['storage_coord_y'] = 'err!';
					$bool_display_error_msg = TRUE;		
				}
				
				if($bool_display_error_msg) {
					// Display error message
					$this->TmaSlide->validationErrors[] 
						= 'no postion has to be recorded when no storage is selected';
				}
				
			} else {
				// Verify coordinates
				$a_coord_valid = 
					$this->requestAction('/storagelayout/storage_masters/validateStoragePosition/'.
						$this->data['TmaSlide']['storage_master_id'].'/'.
						// Add 'x_' before coord to support empty value
						'x_'.$this->data['TmaSlide']['storage_coord_x'].'/'.
						'y_'.$this->data['TmaSlide']['storage_coord_y'].'/');
						
				$bool_display_error_msg = FALSE;
			
				// Manage coordinate x
				if(!$a_coord_valid['coord_x']['validated']) {
					$this->data['TmaSlide']['storage_coord_x'] = 'err!';
					$bool_display_error_msg = TRUE;
				} else if($a_coord_valid['coord_x']['to_uppercase']) {
					$this->data['TmaSlide']['storage_coord_x'] =
						strtoupper($this->data['TmaSlide']['storage_coord_x']);
				}
				
				// Manage coordinate y
				if(!$a_coord_valid['coord_y']['validated']) {
					$this->data['TmaSlide']['storage_coord_y'] = 'err!';
					$bool_display_error_msg = TRUE;
				} else if($a_coord_valid['coord_y']['to_uppercase']) {
					$this->data['TmaSlide']['storage_coord_y'] =
						strtoupper($this->data['TmaSlide']['storage_coord_y']);
				}
				
				if($bool_display_error_msg) {
				// Display error message
					$this->TmaSlide->validationErrors[] 
						= 'at least one position value does not match format';					
				}
					
			}
			
			// ** SAVE DATA **
			
			// setup MODEL(s) validation array(s) for displayed FORM 
			foreach ($this->Forms->getValidateArray('tma_slides') as $validate_model=>$validate_rules) {
				$this->{ $validate_model }->validate = $validate_rules;
			}
			
			// set a FLAG
			$submitted_data_validates = true;	

			if($problem_in_the_storage_defintion) {
				// The aliquot storage has not been correclty defined
				$submitted_data_validates = FALSE;				
			}
			
			// VALIDATE submitted data
			if (!$this->TmaSlide->validates($this->data['TmaSlide'])) {
				$submitted_data_validates = false;
			}
			
			// look for CUSTOM HOOKS, "validation"
			$custom_ctrapp_controller_hook 
				= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
				'controllers' . DS . 'hooks' . DS . 
				$this->params['controller'].'_'.$this->params['action'].'_validation.php';
			
			if (file_exists($custom_ctrapp_controller_hook)) {
				require($custom_ctrapp_controller_hook);
			}
			
			// if data VALIDATE, then save data
			if ($submitted_data_validates) {		
				if ($this->TmaSlide->save($this->data['TmaSlide'])) {
					$this->flash('Your data has been saved.', 
						'/tma_slides/listAll/'.$std_tma_block_master_id);				
				} else {
					$this->redirect('/pages/err_tma_slide_record_err'); 
					exit;
				}
				
			}
			
		}
	}

	/**
	 * Delete a TMA slide.
	 * 
	 * @param $std_tma_block_master_id ID of the studied TMA block.
	 * @param $tma_slide_id ID of the TMA slide.
	 * 
	 * @author N. Luc
	 * @since 2008-06-02
	 * 
	 */
	function delete($std_tma_block_master_id=null, $tma_slide_id=null) {
		
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($std_tma_block_master_id)) {
			$this->redirect('/pages/err_sto_no_stor_id'); 
			exit;
		}
		
		// ** get STORAGE info **
		$this->StorageMaster->id = $std_tma_block_master_id;
		$storage_master_data = $this->StorageMaster->read();
		
		if(empty($storage_master_data)) {
			$this->redirect('/pages/err_sto_no_stor_data'); 
			exit;
		}

		// ** Get Storage Coordinate Data **			
		$this->TmaSlide->id = $tma_slide_id;
		$tma_slide_data = $this->TmaSlide->read();
		
		if(empty($tma_slide_data)){
			$this->redirect('/pages/err_sto_no_tma_slide_data'); 
			exit;
		}
		
		if(strcmp($tma_slide_data['TmaSlide']['std_tma_block_id'], $std_tma_block_master_id) != 0) {
			$this->redirect('/pages/err_sto_no_tma_slide_data'); 
			exit;
		}

		// look for CUSTOM HOOKS, "validation"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_validation.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
		//Delete storage
		$bool_delete_storage_coord = TRUE;
		
		if(!$this->TmaSlide->del( $tma_slide_id )){
			$bool_delete_storage_coord = FALSE;		
		}	
		
		if(!$bool_delete_storage_coord){
			$this->redirect('/pages/err_sto_tma_slide_del_err'); 
			exit;
		}
		
		$this->flash('Your data has been deleted.', 
			'/tma_slides/listAll/'.$std_tma_block_master_id.'/');
		
	}

	/* --------------------------------------------------------------------------
	 * ADDITIONAL FUNCTIONS
	 * -------------------------------------------------------------------------- */	
	
	/**
	 * Verify the tma slide barcode does not already exist.
	 * 
	 * @param $storage_master_id new barcode.
	 * 
	 * @return Return TRUE if barcode has already been set.
	 * 
	 * @author N. Luc
	 * @since 2008-02-04
	 */
	function isDuplicatedTmaSlideBarcode($new_barcode_value) {
		
		// verify storage contains no aliquots
		$conditions = " TmaSlide.barcode = '".$new_barcode_value."' ";				
		$nbr_coord_values = $this->TmaSlide->findCount($conditions);

		if($nbr_coord_values > 0){
			return TRUE;
		}
					
		return FALSE;		
		
	}
	
	function getTmaSlideSopsArray($product_type = NULL, $aliquot_type = NULL){
		//TODO getTmaSlideSopsArray()
		return array('0' => 'n/a');
		
	}
	
}

?>
