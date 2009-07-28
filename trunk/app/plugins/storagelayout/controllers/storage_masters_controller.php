<?php

class StorageMastersController extends StoragelayoutAppController {

	var $uses = array(
		'Storagelayout.StorageMaster',
		'Storagelayout.StorageControl',
		'Inventorymanagement.AliquotMaster',
		'Storagelayout.TmaSlides',
		'Storagelayout.StorageCoordinate'
	);
	var $paginate = array('StorageMaster'=>array('limit'=>10,'order'=>'StorageMaster.code DESC'));

	// List of coordinates that a storage can have.
	var $a_storage_coordinates = array('x', 'y');	

	/* --------------------------------------------------------------------------
	 * DISPLAY FUNCTIONS
	 * --------------------------------------------------------------------------
	 */
	 
	function index() {
		$_SESSION['ctrapp_core']['search'] = NULL; // clear SEARCH criteria
		
		// set variables to display on view
		$this->set('storage_list', $this->getStorageList());	
		
		//find all storage control types
		$this->set('storage_controls', $this->StorageControl->find('all'));
	}
			
	function search() {
		$this->set( 'atim_menu', $this->Menus->get('/storagelayout/storage_masters/index/') );
		
		if ( $this->data ) $_SESSION['ctrapp_core']['search']['criteria'] = $this->Structures->parse_search_conditions();
		
		$this->data = $this->paginate($this->StorageMaster, $_SESSION['ctrapp_core']['search']['criteria']);
		
		//find all storage control types
		$this->set('storage_controls', $this->StorageControl->find('all'));
		
		// if SEARCH form data, save number of RESULTS and URL
		$_SESSION['ctrapp_core']['search']['results'] = $this->params['paging']['StorageMaster']['count'];
		$_SESSION['ctrapp_core']['search']['url'] = '/storagelayout/storage_masters/search';
	}
	
	function detail($storage_master_id) {
		
		if ( !$storage_master_id ) { $this->redirect( '/pages/err_sto_no_stor_cont_data', NULL, TRUE ); }
		
		$this->data = array();
		$this->set( 'atim_menu_variables', array('StorageMaster.id'=>$storage_master_id));
		
		$storage_master_data = $this->StorageMaster->find('first',array('conditions'=>array('StorageMaster.id'=>$storage_master_id)));
		$storage_control_id = $storage_master_data['StorageMaster']['storage_control_id'];
		$storage_control_data = $this->StorageControl->find('first', array('conditions'=>array('StorageControl.id'=>$storage_control_id)));
		
		// Get the current menu object. Needed to disable menu options based on storage type
		$atim_menu = $this->Menus->get('/storagelayout/storage_masters/detail/%%StorageMaster.id%%');
		
		// Check storage for coordinates system. If not present, disable access to Coordinates menu option
		if(!$this->requestAction('/storagelayout/storage_coordinates/allowCustomCoordinates/'.$storage_control_id)) {
			foreach ($atim_menu as $menu_group_id => $menu_group) {
				foreach ($menu_group as $menu_id => $menu_data) {
					if ($menu_data['Menu']['use_link'] == '/storagelayout/storage_coordinates/listAll/') {
						$menu_data['Menu']['allowed'] = 0;
					}
				}
			}
		}
		
		// Check control data for an x-coordinate type, if present disable Storage Layout menu
		if(empty($storage_control_data['StorageControl']['coord_x_type'])) {
			foreach ($atim_menu as $menu_group_id => $menu_group) {
				foreach ($menu_group as $menu_id => $menu_data) {
					if ($menu_data['Menu']['use_link'] == '/storagelayout/storage_masters/seeStorageLayout/') {
						$menu_data['Menu']['allowed'] = 0;
					}
				}
			}				
		}
		
/* 		TODO: Part of TMA implementation. Have Nicolas review this section. Not sure
  		which form/menu should be displayed for TMA storage types.
  		
 		// This code sets the menu to a link that is /underdev/ 
		if(strcmp($storage_control_data['StorageControl']['is_tma_block'], 'TRUE') == 0) {
			$atim_menu[] = $this->Menus->tabs( 'sto_CAN_02', 'sto_CAN_07', $storage_master_id );
		}
*/		
		$this->setStorageCoordinateValues($storage_control_data);
		
		$parent_storage_id = $storage_master_data['StorageMaster']['parent_id'];
		$parent_code_from_id = array($parent_storage_id => '');
		if(!empty($parent_storage_id)){
			// Search parent data	
			$parent_storage_data = $this->StorageMaster->find('first',array('conditions'=>array('StorageMaster.id'=>$parent_storage_id)));
			
			if(empty($parent_storage_data)){
				$this->redirect('/pages/err_sto_no_stor_data'); 
				exit;
			}					
			
			$parent_code_from_id 
				= array($parent_storage_id 
					=> $parent_storage_data['StorageMaster']['code']);

			$this->set('parent_id', $parent_storage_id);			
		}
		$this->set('parent_code_from_id', $parent_code_from_id);	
		
		$storage_path = $this->getStoragePath($parent_storage_id);
		$this->set('storage_path', $storage_path[$parent_storage_id]);

/* 		TODO: TMA related code		
		if(strcmp($storage_control_data['StorageControl']['is_tma_block'], 'TRUE') == 0) {	
			$this->set('arr_tma_sop_title_from_id', 
				$this->getTmaSopsArray());
		}
*/		
		// Verify storage can be deleted
		$bool_allow_deletion = TRUE;
		if(!$this->allowStorageDeletion($storage_master_id)){
			$bool_allow_deletion = FALSE;	 	
		}
		$this->set('bool_allow_deletion', $bool_allow_deletion);		

		// Check if the storage container position can be set within the parent storage
		$bool_define_position = FALSE;
		if(!empty($parent_storage_data)) {
			
			// Read control type data of the parent storage
			$parent_storage_control_id = $parent_storage_data['StorageMaster']['storage_control_id'];
			
			$parent_storage_control_data =
				$this->StorageControl->find('first',array('conditions'=>array('StorageControl.id'=>$parent_storage_control_id)));	
			if(empty($parent_storage_control_data)) {
				$this->redirect('/pages/err_sto_no_stor_cont_data'); 
				exit;
			}
		
			if(!is_null($parent_storage_control_data['StorageControl']['form_alias_for_children_pos'])){
				// A storage position into the parent storage can be defined for the storage
				$bool_define_position = TRUE;

				// set structure alias				
				$this->set('atim_form_position',
					$this->Structures->get('form', $parent_storage_control_data['StorageControl']['form_alias_for_children_pos']) );
				
				// set data to display on view
				if(!empty($parent_storage_control_data['StorageControl']['coord_x_title'])) {
					$this->set('parent_coord_x_title', $parent_storage_control_data['StorageControl']['coord_x_title']);
				}
				if(!empty($parent_storage_control_data['StorageControl']['coord_y_title'])) {
					$this->set('parent_coord_y_title', $parent_storage_control_data['StorageControl']['coord_y_title']);
				}
		
		/*		TODO: Is it nessesary to build this list for the detail view?	
		 		// Build predefined list of positions
				$a_coord_x_list = $this->buildAllowedStoragePosition($parent_storage_id, $parent_storage_control_data, 'x');
				$a_coord_y_list = $this->buildAllowedStoragePosition($parent_storage_id, $parent_storage_control_data, 'y');
				if(!empty($a_coord_x_list)){
					$this->set('a_coord_x_list', $a_coord_x_list);
				}
				if(!empty($a_coord_y_list)){
					$this->set('a_coord_y_list', $a_coord_y_list);
				}	*/		
			}
			
		}	
		$this->set('bool_define_position', $bool_define_position);
		
		// Get all storage control types to build the ADD link
		$storage_controls = $this->StorageControl->find('all');
		$this->set('storage_controls', $storage_controls);
			
		$this->set( 'atim_menu', $atim_menu );
		$this->data = $storage_master_data;
		$this->data['StorageControl'] = $storage_control_data['StorageControl'];
		$this->set( 'atim_structure', $this->Structures->get('form', $storage_control_data['StorageControl']['form_alias']) );
	}
			
	function edit ($storage_master_id) {

		if ( !$storage_master_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('StorageMaster.id'=>$storage_master_id));
		$this_data = $this->StorageMaster->find('first',array('conditions'=>array('StorageMaster.id'=>$storage_master_id)));
		
		$this->set( 'atim_structure', $this->Structures->get('form',$this->data['StorageControl']['form_alias']) );
		
		if ( !empty($this->data) ) {
			$this->StorageMaster->id = $storage_master_id;
			if ( $this->StorageMaster->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/storagelayout/storage_masters/detail/'.$storage_master_id.'/');
			}
		} else {
			$this->data = $this_data;
		}
	}
	
/*	
	function edit($storage_master_id=null) {
				
		// ** Get the storage master id **
		if(isset($this->data['StorageMaster']['id'])) {
			//User clicked on the Submit button to modify the edited storage
			$storage_master_id = $this->data['StorageMaster']['id'];
		}
		
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($storage_master_id)) {
			$this->redirect('/pages/err_sto_no_stor_id'); 
			exit;
		}
		
		// ** set SUMMARY variable from plugin's COMPONENTS **
		$this->set( 'ctrapp_summary', $this->Summaries->build($storage_master_id) );
		
		// ** set SIDEBAR variable, for HELPER call on VIEW ** 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string 
		// that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray( 
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action'] ) );
			
		// ** get STROAGE MASTER info **
		$this->StorageMaster->id = $storage_master_id;
		$storage_master_data = $this->StorageMaster->read();
		
		if(empty($storage_master_data)) {
			$this->redirect('/pages/err_sto_no_stor_data'); 
			exit;
		}
		
		$storage_control_id = $storage_master_data['StorageMaster']['storage_control_id'];
		$this->StorageControl->id = $storage_control_id;
		$storage_control_data = $this->StorageControl->read();		
		
		if(empty($storage_control_data)) {
			$this->redirect('/pages/err_sto_no_stor_cont_data'); 
			exit;
		}
		
		// ** set MENU variable for echo on VIEW ** 
		$ctrapp_menu[] = $this->Menus->tabs( 'sto_CAN_01', 'sto_CAN_02', $storage_master_id ); 

		if(!$this->requestAction('/storagelayout/storage_coordinates/allowCustomCoordinates/'.$storage_control_id)) {
			//grey out 'Coordinates' tab
			 $ctrapp_menu['0']['sto_CAN_06']['allowed'] = false;	
		}
		if(empty($storage_control_data['StorageControl']['coord_x_type'])) {
			//grey out 'storage layout' tabe
			 $ctrapp_menu['0']['sto_CAN_05']['allowed'] = false;					
		}	
		if(strcmp($storage_control_data['StorageControl']['is_tma_block'], 'TRUE') == 0) {	
			$ctrapp_menu[] = $this->Menus->tabs( 'sto_CAN_02', 'sto_CAN_07', $storage_master_id );
		}
		
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// ** set FORM variable ** 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray($storage_control_data['StorageControl']['form_alias']));
		
		// ** set data to display on view **
		$this->setStorageCoordinateValues($storage_control_data);
		
		$this->set('available_parent_code_from_id', $this->getStoragesList($storage_master_id));
		
		if(strcmp($storage_control_data['StorageControl']['is_tma_block'], 'TRUE') == 0) {	
			$this->set('arr_tma_sop_title_from_id', 
				$this->getTmaSopsArray());
		}
		
		// ** get STROAGE Detail info **
		$storage_detail_data = array();	
		$bool_needs_details_table = FALSE;
		
		if(!is_null($storage_control_data['StorageControl']['detail_tablename'])){
			// This storage required specific data
			// Create new instance of StorageDetail model 
			$this->StorageDetail = new StorageDetail(false, $storage_control_data['StorageControl']['detail_tablename']);

			// read related STROAGE DETAIL row, whose ID should be same as STORAGE MASTER ID 
			$this->StorageDetail->id = $storage_master_id;
			$storage_detail_data = $this->StorageDetail->read();
			
			if(empty($storage_detail_data)){
				$this->redirect('/pages/err_sto_missing_stor_data'); 
				exit;
			}	
			
			$bool_needs_details_table = TRUE;				
			
		} else {
			$this->StorageDetail = NULL;			
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
				
			if(!empty($storage_detail_data)){
				// a storage detail is defined for the type or the storage
				// merge both datasets into a SINGLE dataset, set for VIEW 
				$this->data = array_merge($storage_master_data, $storage_detail_data);	
			} else {
				// all the storage data are recorded into the master table.
				$this->data = $storage_master_data;
			}	
			
			$this->set('data', $this->data);
			 
		} else {
			// ** SAVE DATA **
				
			// ** Set value that have not to be defined by the user **			
			
			// Manage Storage Path Code
			$this->data['StorageMaster']['selection_label']
				= $this->manageStoragePathcode($this->data['StorageMaster']);	
				
			// Manage Temperature
			if(strcmp($storage_master_data['StorageMaster']['set_temperature'], 'TRUE') == 0) {
				// The temperature has to be defined for this storage
				if((strcmp($storage_master_data['StorageMaster']['temperature'], $this->data['StorageMaster']['temperature']) != 0)
				||(strcmp($storage_master_data['StorageMaster']['temp_unit'], $this->data['StorageMaster']['temp_unit']) != 0)) {
					// The temperature (or temperature unit) of the storage has been changed: update the children storage temperatures.
					$this->updateChildrenSurroundingTemperature(
						$storage_master_data['StorageMaster']['id'], 
						$this->data['StorageMaster']['temperature'], 
						$this->data['StorageMaster']['temp_unit']);
				}	
			} else {
				// The temperature of the storage is defined by the parent storage
				if(strcmp($storage_master_data['StorageMaster']['parent_id'], $this->data['StorageMaster']['parent_id']) != 0) {
					// The parent of the storage has been changed 
					
					$parent_temp = NULL;
					$parent_temp_unit = NULL;
						
					if(!empty($this->data['StorageMaster']['parent_id'])){
						// A parent has been defined. 
						// Search parent temperature to record surrounding temperature		
						$criteria = 'StorageMaster.id ="' .$this->data['StorageMaster']['parent_id'].'"';	
						
						$parent_storage_data = $this->StorageMaster->find($criteria);
						
						if(empty($parent_storage_data)){
							$this->redirect('/pages/err_sto_no_stor_data'); 
							exit;
						}	
											
						$parent_temp = $parent_storage_data['StorageMaster']['temperature'];
						$parent_temp_unit = $parent_storage_data['StorageMaster']['temp_unit'];
					}
					
					$this->data['StorageMaster']['temperature'] = $parent_temp;							
					$this->data['StorageMaster']['temp_unit'] = $parent_temp_unit;
						
					if((strcmp($storage_master_data['StorageMaster']['temperature'], $parent_temp) != 0)
					||(strcmp($storage_master_data['StorageMaster']['temp_unit'], $parent_temp_unit) != 0)) {
						// The temperature (or temperature unit) of the storage has been changed: update the children storage temperature
						$this->updateChildrenSurroundingTemperature(
							$storage_master_data['StorageMaster']['id'], 
							$parent_temp, 
							$parent_temp_unit);				
					}	
				}
			}
			
			// ** Execute Validation **
						
			// setup MODEL(s) validation array(s) for displayed FORM 
			foreach ( $this->Forms->getValidateArray($storage_control_data['StorageControl']['form_alias']) as $validate_model=>$validate_rules ) {
				$this->{ $validate_model }->validate = $validate_rules;
			}
			
			// Save modified data
			$submitted_data_validates = TRUE;
			
			// Validates Fields of Master Table
			if(!$this->StorageMaster->validates($this->data['StorageMaster'])){
				$submitted_data_validates = FALSE;
			}
		
			if($bool_needs_details_table && (isset($this->data['StorageDetail']))){
				$this->cleanUpFields('StorageDetail');
				
				// Validates Fields of Details Table
				if(!$this->StorageDetail->validates($this->data['StorageDetail'])){
					$submitted_data_validates = FALSE;
				}		
			}
			
			// look for CUSTOM HOOKS, "validation"
			$custom_ctrapp_controller_hook 
				= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
				'controllers' . DS . 'hooks' . DS . 
				$this->params['controller'].'_'.$this->params['action'].'_validation.php';
			
			if (file_exists($custom_ctrapp_controller_hook)) {
				require($custom_ctrapp_controller_hook);
			}
					
			if ($submitted_data_validates) {
				
				// ** Save Data **
				
				$bool_save_done = TRUE;
					
				// Manage parent_storage_coord
				$new_parent_storages_id = $this->data['StorageMaster']['parent_id'];
				$last_parent_storages_id = $storage_master_data['StorageMaster']['parent_id'];
				// If parent storage has been changed, delete coordinate values
				if($new_parent_storages_id != $last_parent_storages_id){
						$this->data['StorageMaster']['parent_storage_coord_x'] = NULL;
						$this->data['StorageMaster']['parent_storage_coord_y'] = NULL;
				}
		
				// save SAMPLEMASTER data
				if(!$this->StorageMaster->save($this->data['StorageMaster'])){
					$bool_save_done = FALSE;
				}
					
				if($bool_save_done && $bool_needs_details_table && isset($this->data['StorageDetail'])){
					// Storage Specific data should be recorded
										
					// save SAMPLEDETAIL data 
					if(!$this->StorageDetail->save($this->data['StorageDetail'])){
						$bool_save_done = FALSE;
					}
				}
				
				if(!$bool_save_done){
					$this->redirect('/pages/err_sto_record_err'); 
					exit;
				} else {
					// Data has been recorded
					$this->flash('Your data has been updated.',
						'/storage_masters/editStoragePosition/'.$storage_master_id);				
				}				
				
			}
		}
	}
	*/
	
	function add( $sample_control_id=null ) {
		
		$this->set( 'atim_menu_variables', array('SampleControl.id'=>$sample_control_id) );
		$this_data = $this->SampleControl->find('first',array('conditions'=>array('SampleControl.id'=>$sample_control_id)));
		
		// set FORM ALIAS based off VALUE from CONTROL table
		$this->set( 'atim_structure', $this->Structures->get('form',$this_data['SampleControl']['form_alias']) );
		
		if ( !empty($this->data) ) {
			$this->data['SampleControl']['sample_control_id'] = $sample_control_id;
			if ( $this->SampleMaster->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/samplelayout/sample_masters/detail/'.$this->SampleMaster->getLastInsertId());
			} else {
				$this->data = $this_data;
			}
		} 		
	}

	/**
	 * Create a FORM to select storage postion into a parent storage.
	 * 
	 * @param $storage_master_id Storage master id of the storage that must be positionned.
	 * 
	 * @author N. Luc
	 * @since 2007-05-22
	 * @updated A. Suggitt
	 */
	 
	function editStoragePosition($storage_master_id=null) {
		
		// ** Get the storage master id **
		if(isset($this->data['StorageMaster']['id'])) {
			//User clicked on the Submit button to modify the edited storage
			$storage_master_id = $this->data['StorageMaster']['id'];
		}
		
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($storage_master_id)) {
			$this->redirect('/pages/err_sto_no_stor_id'); 
			exit;
		}
		
		// ** get STORAGE MASTER info **
		$storage_master_data = $this->StorageMaster->find('first',array('conditions'=>array('StorageMaster.id'=>$storage_master_id)));
		$this->set( 'atim_menu_variables', array('StorageMaster.id'=>$storage_master_id));
		
		if(empty($storage_master_data)) {
			$this->redirect('/pages/err_sto_no_stor_data'); 
			exit;
		}		
		
		// ** Get parent storage data and define if position values should be recorded**
		$parent_storage_id = $storage_master_data['StorageMaster']['parent_id'];
		$parent_storage_master_data = null;
		$parent_storage_control_data = null;
		$bool_define_position = FALSE;
		
		// Verify the storage can be positioned
		if(!empty($parent_storage_id)) {
			// Get the control type of the parent storage
			$parent_storage_master_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $parent_storage_id)));		
			
			if(empty($parent_storage_master_data)) {
				$this->redirect('/pages/err_sto_no_stor_data'); 
				exit;
			}
		
			$parent_storage_control_id 
				= $parent_storage_master_data['StorageMaster']['storage_control_id'];
			
			// Read control type data of the parent storage
			$parent_storage_control_data
				= $this->StorageControl->find('first', array('conditions' => array('StorageControl.id' => $parent_storage_control_id)));
					
			if(empty($parent_storage_control_data)) {
				$this->redirect('/pages/err_sto_no_stor_cont_data'); 
				exit;
			}
		
			if(!is_null($parent_storage_control_data['StorageControl']['form_alias_for_children_pos'])){
				// A storage position into the parent can be defined for the storage
				$bool_define_position = TRUE;
			}
		}
		
		if(!$bool_define_position) {
			// Display message for user
			$this->flash('The position cannot be set for this storage item',
				'/storagelayout/storage_masters/detail/'.$storage_master_id);
				exit;				
		}
			
		// ** 1- PREPARE FIRST FORM TO DISPLAY DETAIL DATA OF THE STORAGE **
				
		// Get the storage control information	
		$storage_control_id = $storage_master_data['StorageMaster']['storage_control_id'];
		$storage_control_data = $this->StorageControl->find('first', array('conditions'=>array('StorageControl.id'=>$storage_control_id)));
		
		if(empty($storage_control_data)) {
			$this->redirect('/pages/err_sto_no_stor_cont_data'); 
			exit;
		}
		
		// Get the current menu object. Needed to disable menu options based on storage type
		$atim_menu = $this->Menus->get('/storagelayout/storage_masters/detail/%%StorageMaster.id%%');
		
		// Check storage for coordinates system. If not present, disable access to Coordinates menu option
		if(!$this->requestAction('/storagelayout/storage_coordinates/allowCustomCoordinates/'.$storage_control_id)) {
			foreach ($atim_menu as $menu_group_id => $menu_group) {
				foreach ($menu_group as $menu_id => $menu_data) {
					if ($menu_data['Menu']['use_link'] == '/storagelayout/storage_coordinates/listAll/') {
						$menu_data['Menu']['allowed'] = 0;
					}
				}
			}
		}
		
		// Check control data for an x-coordinate type, if present disable Storage Layout menu
		if(empty($storage_control_data['StorageControl']['coord_x_type'])) {
			foreach ($atim_menu as $menu_group_id => $menu_group) {
				foreach ($menu_group as $menu_id => $menu_data) {
					if ($menu_data['Menu']['use_link'] == '/storagelayout/storage_masters/seeStorageLayout/') {
						$menu_data['Menu']['allowed'] = 0;
					}
				}
			}				
		}
		
/* 		TODO: Part of TMA implementation. Have Nicolas review this section. Not sure
  		which form/menu should be displayed for TMA storage types.
  		
 		// This code sets the menu to a link that is /underdev/ 
		if(strcmp($storage_control_data['StorageControl']['is_tma_block'], 'TRUE') == 0) {
			$atim_menu[] = $this->Menus->tabs( 'sto_CAN_02', 'sto_CAN_07', $storage_master_id );
		}
*/				
		$this->set( 'atim_menu', $atim_menu );
		$this->setStorageCoordinateValues($storage_control_data);
		
		$this->set( 'atim_structure', $this->Structures->get('form', $storage_control_data['StorageControl']['form_alias']) );		

		$parent_storage_id = $storage_master_data['StorageMaster']['parent_id'];
		$parent_code_from_id 
			= array($parent_storage_id 
				=> $parent_storage_master_data['StorageMaster']['code']);
				
		$this->set('parent_code_from_id', $parent_code_from_id);
		$this->set('parent_id', $parent_storage_id);

		$storage_path = $this->getStoragePath($parent_storage_id);
		$this->set('storage_path', $storage_path[$parent_storage_id]);
/*	
		TODO: TMA related code		
		if(strcmp($storage_control_data['StorageControl']['is_tma_block'], 'TRUE') == 0) {	
			$this->set('arr_tma_sop_title_from_id', 
				$this->getTmaSopsArray());
		}
*/					
		// ** 2- PREPARE SECOND FORM TO SELECT POSITION **

		// Set structure form edit position form				
		$this->set('atim_form_position',
		$this->Structures->get('form', $parent_storage_control_data['StorageControl']['form_alias_for_children_pos']) );

		// set data to display on view
		if(!empty($parent_storage_control_data['StorageControl']['coord_x_title'])) {
			$this->set('parent_coord_x_title', $parent_storage_control_data['StorageControl']['coord_x_title']);
		}
		if(!empty($parent_storage_control_data['StorageControl']['coord_y_title'])) {
			$this->set('parent_coord_y_title', $parent_storage_control_data['StorageControl']['coord_y_title']);
		}
		
/*		TODO: Is it nessesary to build this list for the detail view?	
 		// Build predefined list of positions
		$a_coord_x_list = $this->buildAllowedStoragePosition($parent_storage_id, $parent_storage_control_data, 'x');
		$a_coord_y_list = $this->buildAllowedStoragePosition($parent_storage_id, $parent_storage_control_data, 'y');
		if(!empty($a_coord_x_list)){
			$this->set('a_coord_x_list', $a_coord_x_list);
		}
		if(!empty($a_coord_y_list)){
			$this->set('a_coord_y_list', $a_coord_y_list);
		}		
 */
		if (empty($this->data)) {
			// All the storage data (including coord x and y) are recorded into the master table.
			$this->data = $storage_master_data;
		} else { 
			$bool_save_done = FALSE;
			
			if($this->StorageMaster->save($this->data['StorageMaster'])) {
				$bool_save_done = TRUE;
			}
				
			if(!$bool_save_done) {
				$this->redirect('/pages/err_sto_record_err'); 
				exit;
			} else {
				// Data has been recorded
				$this->flash('Your data has been updated.',
					'/storagelayout/storage_masters/detail/'.$storage_master_id);						
			}
		}
	} // function editStoragePosition

	/* --------------------------------------------------------------------------
	 * ADDITIONAL FUNCTIONS
	 * -------------------------------------------------------------------------- */		
	
	/**
	 * Set all variables to display storage coordinate properties to allocate postion 
	 * to an entity stored into this storage.
	 * 
	 * @param $storage_control_data Record of the STORAGE CONTROLE attached to the type
	 * of the storage.
	 * 
	 * @author N. Luc
	 * @since 2007-05-22
	 * @updated A. Suggitt
	 */
	function setStorageCoordinateValues($storage_control_data){

		$string_null_value = 'n/a';
		
		$this->set('coord_x_title', 
			isset($storage_control_data['StorageControl']['coord_x_title'])? 
				$storage_control_data['StorageControl']['coord_x_title']: 
				$string_null_value);
				
		$this->set('coord_x_type',  
			isset($storage_control_data['StorageControl']['coord_x_type'])? 
				$storage_control_data['StorageControl']['coord_x_type']: 
				$string_null_value);
			
		$this->set('coord_x_size',  
			isset($storage_control_data['StorageControl']['coord_x_size'])? 
				$storage_control_data['StorageControl']['coord_x_size']: 
				$string_null_value);

		$this->set('coord_y_title', 
			isset($storage_control_data['StorageControl']['coord_y_title'])? 
				$storage_control_data['StorageControl']['coord_y_title']: 
				$string_null_value);
				
		$this->set('coord_y_type',  					
			isset($storage_control_data['StorageControl']['coord_y_type'])? 
				$storage_control_data['StorageControl']['coord_y_type']: 
				$string_null_value);
				
		$this->set('coord_y_size',  
			isset($storage_control_data['StorageControl']['coord_y_size'])? 
				$storage_control_data['StorageControl']['coord_y_size']: 
				$string_null_value);	
				
	}

	/**
	 * Will build an array that contains the path to access storage.
	 * 
	 * @param $studied_storage_id ID of the studied storage.
	 * 
	 * @return An array that contains storage data and having the structure
	 * below.
	 * [storag_master_id] => path (ex:' /room1/freezer1')
	 * 
	 * @author N. Luc
	 * @since 2007-05-22
	 * @updated A. Suggitt
	 */ 
	 
	function getStoragePath($studied_storage_id = null){
		
		if(empty($studied_storage_id)){
			// studied storage is not stored
			return array('0' => '/', NULL=> '/');	
		}
	
		// Look for all storages
		$a_fields = array('id', 'parent_id', 'code', 'storage_type');
		$a_storages = $this->StorageMaster->findAll();

		if(empty($a_storages)){
			// No Storage exists in the system
			return array('0' => '/', NULL=> '/');	
		}

		// Sort storages into an array having structure:
		// [storage id]
		//   [parent storage id]
		//   [storage code]
		//   [storage type]
		$a_sorted_storages = array();	
		foreach($a_storages as $key => $storage){
			$stor_parent_id = $storage['StorageMaster']['parent_id'];
			$id = $storage['StorageMaster']['id'];
			$code = $storage['StorageMaster']['code'];
			$type = $storage['StorageMaster']['storage_type'];

			$a_sorted_storages[$id] = 
				array(
					'parent_id'=>$stor_parent_id, 
					'code'=>$code, 
					'storage_type'=>$type);			
		}	
		
		if(!isset($a_sorted_storages[$studied_storage_id])){
			// The Storage does not exist
			return array('0' => '/');	
		}
		
		$new_parent_id = $a_sorted_storages[$studied_storage_id]['parent_id'];
		$path = ' / '.$a_sorted_storages[$studied_storage_id]['code'];
		
		while(!empty($new_parent_id)){
			$storage_id = $new_parent_id;
			$new_parent_id = $a_sorted_storages[$storage_id]['parent_id'];
			$path = ' / '.$a_sorted_storages[$storage_id]['code'].$path;
		}			

		return array($studied_storage_id => $path);
	}

	/**
	 * Define if a storage can be deleted.
	 * 
	 * @param $storage_master_id Id of the studied storage.
	 * 
	 * @return Return TRUE if the storage can be deleted.
	 * 
	 * @author N. Luc
	 * @since 2007-08-16
	 * @updated A. Suggitt
	 */
	 
	function allowStorageDeletion($storage_master_id){
		
		// verify storage contains no chlidren storage
		$nbr_children_storages = $this->StorageMaster->find('count', array('conditions'=>array('StorageMaster.parent_id'=>$storage_master_id)));
		if($nbr_children_storages > 0) {
			return FALSE;
		}
		
		// verify storage contains no aliquots
		$nbr_storage_aliquots = $this->AliquotMaster->find('count', array('conditions'=>array('AliquotMaster.storage_master_id'=>$storage_master_id)));
		if($nbr_storage_aliquots > 0) {
			return FALSE;
		}
/*		
		TODO: TMA checks
		// verify storage is not attached to tma slide	
		$nbr_tma_slides = $this->TmaSlide->find('count', array('conditions'=>array('TmaSlide.std_tma_block_id'=>$storage_master_id)));
		if($nbr_tma_slides > 0) {
			return FALSE;
		}
		
		// verify storage is not attached to tma slide
		$nbr_tma_slides = $this->TmaSlide->find('count', array('conditions'=>array('TmaSlide.storage_master_id'=>$storage_master_id)));

		if($nbr_tma_slides > 0) {
			return FALSE;
		}
*/							
		return TRUE;
	}

	/**
	 * Build list of values that could be selected to define position coordinate (X or Y) of a children
	 * storage into a studied stroage. This list is based on the control data of the storage.
	 * 
	 * When:
	 *   - Type = 'alphabetical' and size is not null: System will build list 
	 *     of alphabetical values ('A' + 'B' + 'C' + etc). Number of values 
	 *     is defined by the size.
	 *  
	 *   - Type = 'integer' and size is not null: System will build list 
	 *     of integer values ('1' + '2' + '3' + etc). Number of values 
	 *     is defined by the size.
	 *  
	 *   - Type = 'liste' and size is null: System will search cutom coordinate values defined for 
	 *     the parent storage. (This list is uniquely supported for coordinate 'X').
	 * 
	 * @param $storage_master_id ID of the studied storage.
	 * @param $storage_control_data Data of the storage control attached to the type 
	 * of the storage.
	 * @param $coord Coordinate flag that should be studied ('x', 'y').
	 *
	 * @return Array of available values.
	 * 
	 * @author N. Luc
	 * @since 2007-05-22
	 * @updated A. Suggitt
	 */
	 
	function buildAllowedStoragePosition($storage_master_id, $storage_control_data, $coord){
		
		// Verify the coordinate is allowed
		if(!in_array($coord, $this->a_storage_coordinates)){
			$this->redirect('/pages/err_sto_system_error'); 
			exit;
		}

		// Build array
		$returned_array = array();
		
		if((!empty($storage_control_data['StorageControl']['coord_'.$coord.'_type']))
		&& (!empty($storage_control_data['StorageControl']['coord_'.$coord.'_size']))) {
			// Size and type are defined for the coordinate of the storage type
			// The system can build a list.
			
			$size = $storage_control_data['StorageControl']['coord_'.$coord.'_size'];
			
			if(!is_numeric($size)){
				$this->redirect('/pages/err_sto_system_error'); 
				exit;				
			}
			
			if(strcmp($storage_control_data['StorageControl']['coord_'.$coord.'_type'], 'alphabetical') == 0){
				// Alphabetical drop down list
				$a_alphab = array('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',
		            'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T',
		            'U', 'V', 'W', 'X', 'Y', 'Z');
				
				if($size > sizeof($a_alphab)){
					$this->redirect('/pages/err_sto_system_error'); 
					exit;
				}
				
				for($counter = 0; $counter < $size; $counter++) {
					$returned_array[$a_alphab[$counter]] = $a_alphab[$counter];
				}
				
			} else if(strcmp($storage_control_data['StorageControl']['coord_'.$coord.'_type'], 'integer') == 0){
				// Integer drop down list
				for($counter = 1; $counter <= $size; $counter++) {
					$returned_array[$counter] = $counter;
				}
				
			} else {
					$this->redirect('/pages/err_sto_system_error'); 
					exit;				
			}
			
		} else if((!empty($storage_control_data['StorageControl']['coord_'.$coord.'_type']))
		&& (empty($storage_control_data['StorageControl']['coord_'.$coord.'_size']))) {
			
			// Should be coordinate_x and a list of values defined by user
			if((strcmp($storage_control_data['StorageControl']['coord_'.$coord.'_type'], 'list') == 0) 
			&& (strcmp($coord, 'x') == 0)) {
				
				$tmp_coord_list = $this->StorageCoordinate->find('list',
					array('conditions' => array('StorageCoordinate.storage_master_id' => $storage_master_id, 'StorageCoordinate.dimension' => $coord),
					 'fields' => array('StorageCoordinate.coordinate_value'),
					 'order' => 'StorageCoordinate.order ASC')
				);				
				if(!empty($tmp_coord_list)) {
					$returned_array = $tmp_coord_list;
				}
			} else {
				$this->redirect('/pages/err_sto_system_error'); 
				exit;					
			}
			
		} else if(!(empty($storage_control_data['StorageControl']['coord_'.$coord.'_type'])
		&& empty($storage_control_data['StorageControl']['coord_'.$coord.'_size']))) {
			// The storage control defintion is not supported by the current system
			$this->redirect('/pages/err_sto_system_error'); 
			exit;			
		}
	
		return $returned_array;
	}	
	
	/**
	 * This function builds an array of storage records, except those of type TMA. When
	 * a storage master id is passed in arguments, that record plus all children records
	 * will be deleted from the array.
	 * 
	 * @param $excluded_storage_master_id ID of the storage record to exclude.
	 * 
	 * @return Array of storage records.
	 * [storage_master_id] => $storage_data (array())
	 * 
	 * @author N. Luc
	 * @since 2007-05-22
	 * @updated A. Suggitt on 2009-07-22
	*/
	
	function getStorageList($excluded_storage_master_id=null) {
		
		// Find control ID for all storages of type TMA. These will be excluded from the returned array
		$arr_tma_control_ids = $this->StorageControl->find('list', array('conditions' => array('StorageControl.is_tma_block' => 'TRUE')));
		
		// Get all storage records excluding those of type TMA
		$arr_storages_list_tmp = $this->StorageMaster->find('all', array('conditions' => array('NOT' => array('StorageMaster.storage_control_id' => $arr_tma_control_ids)), 'order' => array('StorageMaster.selection_label')));

		// Create a new, simplified storage array of just StorageMaster records 
		$arr_storages_list = array();
		foreach($arr_storages_list_tmp as $id_tmp => $storage_data) {
			$id = $storage_data['StorageMaster']['id'];
			$arr_storages_list[$id] = $storage_data['StorageMaster'];		
		}
					
		if((!empty($arr_storages_list)) && (!empty($excluded_storage_master_id))) {
			if(isset($arr_storages_list[$excluded_storage_master_id])) {
				// The defined storage plus all its childrens should be deleted
				$this->deleteChildrenFromTheList($excluded_storage_master_id, $arr_storages_list);
				unset($arr_storages_list[$excluded_storage_master_id]);
			}
		}
		
		if(empty($arr_storages_list)) {
			// No Storage exists in the system
			return array();	
		}					
		
		return $arr_storages_list;
	}
	
	/**
	 * Delete storage id of all direct and undirect children storages
	 * of a storage (having id passed in argument) from a storages list.
	 *
	 * @param $parent_storage_id ID of the parent storage having children that should be 
	 * deleted from the list.
	 * @param $arr_storages_list List of storages (passed by reference) having following 
	 * structure:
	 *    [storage_master_id] = storage code
	 * 
	 * @author N. Luc
	 * @since 2008-01-31
	 * @updated A. Suggitt on 2009-07-22
	 */
	 
	function deleteChildrenFromTheList($parent_storage_id, &$arr_storages_list) {
		// Find all children storage records to be removed from the list
		$children_storage_list = $this->StorageMaster->find('all', array('conditions'=>array('StorageMaster.parent_id'=>$parent_storage_id)));

		foreach($children_storage_list as $id => $children_storage_master_data) {
			// New children of the studied storage
			$studied_children_storage_id = $children_storage_master_data['StorageMaster']['id'];

			if((!empty($arr_storages_list)) && isset($arr_storages_list[$studied_children_storage_id])) {
				// The defined storage plus all its childrens should be deleted
				$this->deleteChildrenFromTheList($studied_children_storage_id, $arr_storages_list);
				unset($arr_storages_list[$studied_children_storage_id]);
			}				
		}
		return;
	} 
	
/*
	/* --------------------------------------------------------------------------
	 * CONSTANTS
	 * --------------------------------------------------------------------------
	
	// List of coordinates that a storage can have.
	var $a_storage_coordinates = array('x', 'y');
	
	/* --------------------------------------------------------------------------
	 * DISPLAY FUNCTIONS
	 * -------------------------------------------------------------------------- 	
/*	
	function beforeFilter() {
			
		// $auth_conf array hardcoded in oth_auth component, due to plugins compatibility 
		$this->othAuth->controller = &$this;
		$this->othAuth->init();
		$this->othAuth->check();
		
		// CakePHP function to re-combine dat/time select fields 
		$this->cleanUpFields();
			
	}
	
	/**
	 * Generate a FORM to realize a storage reasearch.
	 * 
	 * @author N. Luc
	 * @since 2007-05-22
	 
	function index() {
		
		// 1 - Create Search FORM
		
		// clear SEARCH criteria, for pagination bug 
		$_SESSION['ctrapp_core']['storage_layout']['search_criteria'] = NULL;
		
		// set MENU variable for echo on VIEW 
		$this->set('ctrapp_menu', array());
		
		// set SUMMARY variable from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build() );

		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string 
		// that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray( 
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action']));
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set('ctrapp_form', $this->Forms->getFormArray('storage_masters'));
			
		// set variables to display on view
		$this->set('storages_listes', $this->getStoragesList());
			
		// 2 - Create Storage Types list for the new storage creation action
		
		// Findall storage_type defined as 'active'
		$conditions = 'StorageControl.status=\'active\'';
		$order = 'StorageControl.storage_type ASC';
		
		$untranslated_storage_types =
			$this->StorageControl->generateList(
				$conditions, 
				$order, 
				null, 
				'{n}.StorageControl.id', 
				'{n}.StorageControl.storage_type');
												
		$this->set('untranslated_storage_types', $untranslated_storage_types);
		
		// 3 - look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
			
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
	}
	
	/**
	 * List the children storages of a parent storage.
	 * 
	 * @param $parent_storage_master_id Id of the parent.
	 * 
	 * @author N. Luc
	 * @since 2008-03-18
	 
	function listChildrenStorages($parent_storage_master_id) {
				
		// Look for parent storage control id	
		$conditions = "StorageMaster.id = ".$parent_storage_master_id;
		$storage_master_data = $this->StorageMaster->find($conditions);
	
		if(empty($storage_master_data)) {
			$this->redirect('/pages/err_sto_no_stor_data'); 
			exit;
		}
		
		$storage_control_id = $storage_master_data['StorageMaster']['storage_control_id'];
		
		// Look for storage controle data
		$this->StorageControl->id = $storage_control_id;
		$storage_control_data = $this->StorageControl->read();
		
		if(empty($storage_control_data)){
			$this->redirect('/pages/err_sto_no_stor_cont_data'); 
			exit;
		}
			
		// set MENU variable for echo on VIEW
		$ctrapp_menu[] = $this->Menus->tabs( 'sto_CAN_01', 'sto_CAN_03', $parent_storage_master_id ); 

		if(!$this->requestAction('/storagelayout/storage_coordinates/allowCustomCoordinates/'.$storage_control_id)) {
			//grey out 'Coordinates' tab
			 $ctrapp_menu['0']['sto_CAN_06']['allowed'] = false;	
		}
		if(empty($storage_control_data['StorageControl']['coord_x_type'])) {
			//grey out 'storage layout' tabe
			 $ctrapp_menu['0']['sto_CAN_05']['allowed'] = false;					
		}	
		
		$this->set( 'ctrapp_menu', $ctrapp_menu );
				
		// set SUMMARY variable from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build($parent_storage_master_id) );
		
		// set FORM variable, for HELPER call on VIEW 
		$ctrapp_form = $this->Forms->getFormArray('storage_masters');
		$this->set('ctrapp_form', $ctrapp_form);
			
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string 
		// that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', 
			$this->Sidebars->getColsArray( 
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action'] ) );
		
		// set PARENT_ID to start tree, and sort order
		$parent_id = $parent_storage_master_id;
		$sort = 'parent_id ASC';
		
		// find THREADED data
		$this->set('data', $this->StorageMaster->findAllThreaded(null, null, $sort, $parent_id));

	}	
	
	/**
	 * Create a FORM to display the results of a storage reasearch.
	 * 
	 * @param $parent_storage_master_id Id of the parent when we try to display all children
	 * storage of a parent storage.
	 * 
	 * @author N. Luc
	 * @since 2007-05-22
	 
	function search($parent_storage_master_id=null) {

		// set MENU variable for echo on VIEW 
		$this->set('ctrapp_menu', array());
				
		// set SUMMARY variable from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build() );
		
		// set FORM variable, for HELPER call on VIEW 
		$ctrapp_form = $this->Forms->getFormArray('storage_masters');
		$this->set('ctrapp_form', $ctrapp_form);
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string 
		// that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', 
			$this->Sidebars->getColsArray( 
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action']));
		
		// if SEARCH form data, parse and create conditions 
		if ($this->data) {
			$criteria = $this->Forms->getSearchConditions($this->data, $ctrapp_form);
			// save CRITERIA to session for pagination 
			$_SESSION['ctrapp_core']['storage_layout']['search_criteria'] = $criteria; 
		} else {
			// if no form data, use SESSION critera for PAGINATION bug 
			$criteria = $_SESSION['ctrapp_core']['storage_layout']['search_criteria']; 
		}
	
		$no_pagination_order = 'storage_type ASC, code ASC';
		
		list($order, $limit, $page) = $this->Pagination->init($criteria);
		$storage_listes = $this->StorageMaster->findAll($criteria, NULL, $no_pagination_order, $limit, $page, 0);
		
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
		$this->set('storage_listes', $storage_listes);
		
	}
	
	/**
	 * Create a FORM to create a new storage according to the type of the storage
	 * plus code to record the new new storage.
	 * 
	 * @author N. Luc
	 * @since 2007-05-22
	 
	function add() {
		
		// ** Get the storage control id **
		// This id corresponds to the type of the new storage to create.
		$storage_control_id = null;
		$specific_parent_storage_id = null;
		
		if(isset($this->params['form']['storage_control_id'])){
			// User clicked on the Add button of the 'index' screen
			// to create a new storage type
			$storage_control_id = $this->params['form']['storage_control_id'];
			
			$_SESSION['ctrapp_core']['storage_layout']['specific_parent_storage_id'] = NULL; 
			
			if(isset($this->params['form']['specific_parent_storage_id'])) {
				// User clicked on the Add button of the 'storage detail' screen 
				// to create a new storage type: the parent storage is known			
				$specific_parent_storage_id = $this->params['form']['specific_parent_storage_id'];
				$_SESSION['ctrapp_core']['storage_layout']['specific_parent_storage_id'] = $specific_parent_storage_id;
			}
			
		} else if(isset($this->data['StorageMaster']['storage_control_id'])) {
			//User clicked on the Submit button to create the new storage
			$storage_control_id = $this->data['StorageMaster']['storage_control_id'];	
			
			if(isset($_SESSION['ctrapp_core']['storage_layout']['specific_parent_storage_id'])
			&& (!empty($_SESSION['ctrapp_core']['storage_layout']['specific_parent_storage_id']))){
				$specific_parent_storage_id = $_SESSION['ctrapp_core']['storage_layout']['specific_parent_storage_id'];
			}
		}
		
		if(empty($storage_control_id)){
			$this->redirect('/pages/err_sto_no_stor_cont_id'); 
			exit;
		}
		
		// ** Load the storage control data from STORAGE CONTROLS table **
		$this->StorageControl->id = $storage_control_id;
		$storage_control_data = $this->StorageControl->read();
		
		if(empty($storage_control_data)){
			$this->redirect('/pages/err_sto_no_stor_cont_data'); 
			exit;
		}
		
		// ** set MENU variable for echo on VIEW **
		$this->set('ctrapp_menu', array());
		
		// ** set SUMMARY variable from plugin's COMPONENTS **
		$this->set( 'ctrapp_summary', $this->Summaries->build() );

		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string 
		// that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray( 
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action'] ) );
			
		// ** set FORM variable, for HELPER call on VIEW ** 
		$this->set( 'ctrapp_form', 
			$this->Forms->getFormArray($storage_control_data['StorageControl']['form_alias']));			

		// ** set DATA for echo on VIEW **
		$this->set('storage_control_id', $storage_control_id);
		$this->set('storage_type', $storage_control_data['StorageControl']['storage_type']);

		$this->setStorageCoordinateValues($storage_control_data);
	
		$storage_infrastructures = $this->getStoragesList();
		if(!is_null($specific_parent_storage_id)) {
			if(!isset($storage_infrastructures[$specific_parent_storage_id])){
				$this->redirect('/pages/err_sto_system_error'); 
				exit;
			}
			$storage_infrastructures 
				= array($specific_parent_storage_id => $storage_infrastructures[$specific_parent_storage_id]);
		}
		$this->set('storage_infrastructures', $storage_infrastructures);
		
		if(strcmp($storage_control_data['StorageControl']['is_tma_block'], 'TRUE') == 0) {	
			$this->set('arr_tma_sop_title_from_id', 
				$this->getTmaSopsArray());
		}
		
		// ** Initialize StorageDetail **
		$bool_needs_details_table = FALSE;
		
		if(!is_null($storage_control_data['StorageControl']['detail_tablename'])){
			// This storage required specific data
			// Create new instance of StorageDetail model 
			$this->StorageDetail = new StorageDetail(false, $storage_control_data['StorageControl']['detail_tablename']);
			$bool_needs_details_table = TRUE;
		} else {
			$this->StorageDetail = NULL;
		}
		
		// ** look for CUSTOM HOOKS, "format" **
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
			
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}	

		if (!empty($this->data)) {

			// ** Set value that have not to be defined by the user **			
			
			// Manage Storage Temperature
			$this->data['StorageMaster']['set_temperature'] = 
				$storage_control_data['StorageControl']['set_temperature'];
				
			if(!strcmp($storage_control_data['StorageControl']['set_temperature'], 'TRUE') == 0){
				// Temprature is not defined for this type of storage.
				// Search surrouding temperature.
				if(!empty($this->data['StorageMaster']['parent_id'])){
					// A parent has been defined. 
					// Search parent temperature to record surrounding temperature		
					$criteria = 'StorageMaster.id ="' .$this->data['StorageMaster']['parent_id'].'"';		
					
					$parent_storage_data = $this->StorageMaster->find($criteria);
		
					if(empty($parent_storage_data)){
						$this->redirect('/pages/err_sto_no_stor_data'); 
						exit;
					}
					
					$this->data['StorageMaster']['temperature'] = 
						$parent_storage_data['StorageMaster']['temperature'];
					$this->data['StorageMaster']['temp_unit'] = 
						$parent_storage_data['StorageMaster']['temp_unit'];
				}
			}				
			
			// Manage Storage Path Code
			$this->data['StorageMaster']['selection_label']
				= $this->manageStoragePathcode($this->data['StorageMaster']);	
			
			// ** Execute Validation **
						
			// setup MODEL(s) validation array(s) for displayed FORM 
			foreach ( $this->Forms->getValidateArray( $storage_control_data['StorageControl']['form_alias'] ) as $validate_model=>$validate_rules ) {
				$this->{ $validate_model }->validate = $validate_rules;
			}
			
			$submitted_data_validates = TRUE;
			
			// Verify barcode is not duplicated
			if(!empty($this->data['StorageMaster']['barcode'])) {
				if($this->IsDuplicatedStorageBarCode($this->data['StorageMaster'])){				
					$submitted_data_validates = FALSE;
					$this->AliquotMaster->validationErrors[]
						= 'storage barcode should be unique';				
				}
			}
			
			// Verify barcode lengh
			if(!empty($this->data['StorageMaster']['barcode'])) {
				if(strlen($this->data['StorageMaster']['barcode']) > $this->barcode_size_max) {			
					$submitted_data_validates = FALSE;
					$this->AliquotMaster->validationErrors[]
						= 'storage barcode size is limited';				
				}
			}			
			
			// Validates Fields of Master Table
			if(!$this->StorageMaster->validates($this->data['StorageMaster'])){
				$submitted_data_validates = FALSE;
			}
		
			if($bool_needs_details_table && isset($this->data['StorageDetail'])){
				$this->cleanUpFields('StorageDetail');
				
				// Validates Fields of Details Table
				if(!$this->StorageDetail->validates($this->data['StorageDetail'])){
					$submitted_data_validates = FALSE;
				}		
			}

			// look for CUSTOM HOOKS, "validation"
			$custom_ctrapp_controller_hook 
				= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
				'controllers' . DS . 'hooks' . DS . 
				$this->params['controller'].'_'.$this->params['action'].'_validation.php';
			
			if (file_exists($custom_ctrapp_controller_hook)) {
				require($custom_ctrapp_controller_hook);
			}
			
			if ($submitted_data_validates) {
				
				// ** Save Data **
							
				$bool_save_done = TRUE;
		
				// save StorageMaster data
				$storage_master_id = NULL;
				if($this->StorageMaster->save($this->data['StorageMaster'])){
					$storage_master_id = $this->StorageMaster->getLastInsertId();
				} else {
					$bool_save_done = FALSE;
				}
				
				// Update StorageMaster data that did not be known before storage creation
				if($bool_save_done){
					$this->data['StorageMaster']['id'] = $storage_master_id;					
					
					$this->data['StorageMaster']['code'] = 
						$this->createStorageCode($this->data['StorageMaster'], $storage_control_data['StorageControl']);
					
					if(!$this->StorageMaster->save($this->data['StorageMaster'])) {
						$bool_save_done = FALSE;
					}
					
				}	
				
				if($bool_save_done && $bool_needs_details_table && isset($this->data['StorageDetail'])){
					// Storage Details should be recorded
							
					// set ID fields based on SAMPLEMASTER
					$this->data['StorageDetail']['id'] = $storage_master_id;
					$this->data['StorageDetail']['storage_master_id'] = $storage_master_id;
					
					// save SAMPLEDETAIL data 
					if(!$this->StorageDetail->save($this->data['StorageDetail'])){
						$bool_save_done = FALSE;
					}
				}
				
				if(!$bool_save_done){
					$this->redirect('/pages/err_sto_record_err'); 
					exit;
				} else {
					// Data has been recorded
					$this->flash('Your data has been saved.',
						'/storage_masters/editStoragePosition/'.$storage_master_id);				
				}
											
			} // end action done after validation	
		} // end data save		
	} // function add

	/**
	 * Create a FORM to edit a storage 
	 * plus record the storage modification.
	 * 
	 * @param $storage_master_id Storage master id of the storage to edit.
	 * 
	 * @author N. Luc
	 * @since 2007-05-22
	 
	function edit($storage_master_id=null) {
				
		// ** Get the storage master id **
		if(isset($this->data['StorageMaster']['id'])) {
			//User clicked on the Submit button to modify the edited storage
			$storage_master_id = $this->data['StorageMaster']['id'];
		}
		
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($storage_master_id)) {
			$this->redirect('/pages/err_sto_no_stor_id'); 
			exit;
		}
		
		// ** set SUMMARY variable from plugin's COMPONENTS **
		$this->set( 'ctrapp_summary', $this->Summaries->build($storage_master_id) );
		
		// ** set SIDEBAR variable, for HELPER call on VIEW ** 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string 
		// that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray( 
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action'] ) );
			
		// ** get STROAGE MASTER info **
		$this->StorageMaster->id = $storage_master_id;
		$storage_master_data = $this->StorageMaster->read();
		
		if(empty($storage_master_data)) {
			$this->redirect('/pages/err_sto_no_stor_data'); 
			exit;
		}
		
		$storage_control_id = $storage_master_data['StorageMaster']['storage_control_id'];
		$this->StorageControl->id = $storage_control_id;
		$storage_control_data = $this->StorageControl->read();		
		
		if(empty($storage_control_data)) {
			$this->redirect('/pages/err_sto_no_stor_cont_data'); 
			exit;
		}
		
		// ** set MENU variable for echo on VIEW ** 
		$ctrapp_menu[] = $this->Menus->tabs( 'sto_CAN_01', 'sto_CAN_02', $storage_master_id ); 

		if(!$this->requestAction('/storagelayout/storage_coordinates/allowCustomCoordinates/'.$storage_control_id)) {
			//grey out 'Coordinates' tab
			 $ctrapp_menu['0']['sto_CAN_06']['allowed'] = false;	
		}
		if(empty($storage_control_data['StorageControl']['coord_x_type'])) {
			//grey out 'storage layout' tabe
			 $ctrapp_menu['0']['sto_CAN_05']['allowed'] = false;					
		}	
		if(strcmp($storage_control_data['StorageControl']['is_tma_block'], 'TRUE') == 0) {	
			$ctrapp_menu[] = $this->Menus->tabs( 'sto_CAN_02', 'sto_CAN_07', $storage_master_id );
		}
		
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// ** set FORM variable ** 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray($storage_control_data['StorageControl']['form_alias']));
		
		// ** set data to display on view **
		$this->setStorageCoordinateValues($storage_control_data);
		
		$this->set('available_parent_code_from_id', $this->getStoragesList($storage_master_id));
		
		if(strcmp($storage_control_data['StorageControl']['is_tma_block'], 'TRUE') == 0) {	
			$this->set('arr_tma_sop_title_from_id', 
				$this->getTmaSopsArray());
		}
		
		// ** get STROAGE Detail info **
		$storage_detail_data = array();	
		$bool_needs_details_table = FALSE;
		
		if(!is_null($storage_control_data['StorageControl']['detail_tablename'])){
			// This storage required specific data
			// Create new instance of StorageDetail model 
			$this->StorageDetail = new StorageDetail(false, $storage_control_data['StorageControl']['detail_tablename']);

			// read related STROAGE DETAIL row, whose ID should be same as STORAGE MASTER ID 
			$this->StorageDetail->id = $storage_master_id;
			$storage_detail_data = $this->StorageDetail->read();
			
			if(empty($storage_detail_data)){
				$this->redirect('/pages/err_sto_missing_stor_data'); 
				exit;
			}	
			
			$bool_needs_details_table = TRUE;				
			
		} else {
			$this->StorageDetail = NULL;			
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
				
			if(!empty($storage_detail_data)){
				// a storage detail is defined for the type or the storage
				// merge both datasets into a SINGLE dataset, set for VIEW 
				$this->data = array_merge($storage_master_data, $storage_detail_data);	
			} else {
				// all the storage data are recorded into the master table.
				$this->data = $storage_master_data;
			}	
			
			$this->set('data', $this->data);
			 
		} else {
			// ** SAVE DATA **
				
			// ** Set value that have not to be defined by the user **			
			
			// Manage Storage Path Code
			$this->data['StorageMaster']['selection_label']
				= $this->manageStoragePathcode($this->data['StorageMaster']);	
				
			// Manage Temperature
			if(strcmp($storage_master_data['StorageMaster']['set_temperature'], 'TRUE') == 0) {
				// The temperature has to be defined for this storage
				if((strcmp($storage_master_data['StorageMaster']['temperature'], $this->data['StorageMaster']['temperature']) != 0)
				||(strcmp($storage_master_data['StorageMaster']['temp_unit'], $this->data['StorageMaster']['temp_unit']) != 0)) {
					// The temperature (or temperature unit) of the storage has been changed: update the children storage temperatures.
					$this->updateChildrenSurroundingTemperature(
						$storage_master_data['StorageMaster']['id'], 
						$this->data['StorageMaster']['temperature'], 
						$this->data['StorageMaster']['temp_unit']);
				}	
			} else {
				// The temperature of the storage is defined by the parent storage
				if(strcmp($storage_master_data['StorageMaster']['parent_id'], $this->data['StorageMaster']['parent_id']) != 0) {
					// The parent of the storage has been changed 
					
					$parent_temp = NULL;
					$parent_temp_unit = NULL;
						
					if(!empty($this->data['StorageMaster']['parent_id'])){
						// A parent has been defined. 
						// Search parent temperature to record surrounding temperature		
						$criteria = 'StorageMaster.id ="' .$this->data['StorageMaster']['parent_id'].'"';	
						
						$parent_storage_data = $this->StorageMaster->find($criteria);
						
						if(empty($parent_storage_data)){
							$this->redirect('/pages/err_sto_no_stor_data'); 
							exit;
						}	
											
						$parent_temp = $parent_storage_data['StorageMaster']['temperature'];
						$parent_temp_unit = $parent_storage_data['StorageMaster']['temp_unit'];
					}
					
					$this->data['StorageMaster']['temperature'] = $parent_temp;							
					$this->data['StorageMaster']['temp_unit'] = $parent_temp_unit;
						
					if((strcmp($storage_master_data['StorageMaster']['temperature'], $parent_temp) != 0)
					||(strcmp($storage_master_data['StorageMaster']['temp_unit'], $parent_temp_unit) != 0)) {
						// The temperature (or temperature unit) of the storage has been changed: update the children storage temperature
						$this->updateChildrenSurroundingTemperature(
							$storage_master_data['StorageMaster']['id'], 
							$parent_temp, 
							$parent_temp_unit);				
					}	
				}
			}
			
			// ** Execute Validation **
						
			// setup MODEL(s) validation array(s) for displayed FORM 
			foreach ( $this->Forms->getValidateArray($storage_control_data['StorageControl']['form_alias']) as $validate_model=>$validate_rules ) {
				$this->{ $validate_model }->validate = $validate_rules;
			}
			
			// Save modified data
			$submitted_data_validates = TRUE;
			
			// Validates Fields of Master Table
			if(!$this->StorageMaster->validates($this->data['StorageMaster'])){
				$submitted_data_validates = FALSE;
			}
		
			if($bool_needs_details_table && (isset($this->data['StorageDetail']))){
				$this->cleanUpFields('StorageDetail');
				
				// Validates Fields of Details Table
				if(!$this->StorageDetail->validates($this->data['StorageDetail'])){
					$submitted_data_validates = FALSE;
				}		
			}
			
			// look for CUSTOM HOOKS, "validation"
			$custom_ctrapp_controller_hook 
				= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
				'controllers' . DS . 'hooks' . DS . 
				$this->params['controller'].'_'.$this->params['action'].'_validation.php';
			
			if (file_exists($custom_ctrapp_controller_hook)) {
				require($custom_ctrapp_controller_hook);
			}
					
			if ($submitted_data_validates) {
				
				// ** Save Data **
				
				$bool_save_done = TRUE;
					
				// Manage parent_storage_coord
				$new_parent_storages_id = $this->data['StorageMaster']['parent_id'];
				$last_parent_storages_id = $storage_master_data['StorageMaster']['parent_id'];
				// If parent storage has been changed, delete coordinate values
				if($new_parent_storages_id != $last_parent_storages_id){
						$this->data['StorageMaster']['parent_storage_coord_x'] = NULL;
						$this->data['StorageMaster']['parent_storage_coord_y'] = NULL;
				}
		
				// save SAMPLEMASTER data
				if(!$this->StorageMaster->save($this->data['StorageMaster'])){
					$bool_save_done = FALSE;
				}
					
				if($bool_save_done && $bool_needs_details_table && isset($this->data['StorageDetail'])){
					// Storage Specific data should be recorded
										
					// save SAMPLEDETAIL data 
					if(!$this->StorageDetail->save($this->data['StorageDetail'])){
						$bool_save_done = FALSE;
					}
				}
				
				if(!$bool_save_done){
					$this->redirect('/pages/err_sto_record_err'); 
					exit;
				} else {
					// Data has been recorded
					$this->flash('Your data has been updated.',
						'/storage_masters/editStoragePosition/'.$storage_master_id);				
				}				
				
			}
		}
	}
	
	/**
	 * Create a FORM to select storage postion into a parent storage.
	 * 
	 * @param $storage_master_id Storage master id of the storage that must be positionned.
	 * 
	 * @author N. Luc
	 * @since 2007-05-22
	 
	function editStoragePosition($storage_master_id=null) {
		
		// ** Get the storage master id **
		if(isset($this->data['StorageMaster']['id'])) {
			//User clicked on the Submit button to modify the edited storage
			$storage_master_id = $this->data['StorageMaster']['id'];
		}
		
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($storage_master_id)) {
			$this->redirect('/pages/err_sto_no_stor_id'); 
			exit;
		}
		
		// ** get STROAGE MASTER info **
		$this->StorageMaster->id = $storage_master_id;
		$storage_master_data = $this->StorageMaster->read();
		
		if(empty($storage_master_data)) {
			$this->redirect('/pages/err_sto_no_stor_data'); 
			exit;
		}
		
		// ** Get parent storage data and define if position values should be recorded**
		$parent_storage_id = $storage_master_data['StorageMaster']['parent_id'];
		$parent_storage_master_data = null;
		$parent_storage_control_data = null;
		
		$bool_define_position = FALSE;
		
		// Verify the storage can be positionned
		if(!empty($parent_storage_id)){
			// A parent storage has been defined
			
			// Get the control type of the parent storage
			$criteria = "StorageMaster.id = ". $parent_storage_id;
			$parent_storage_master_data = $this->StorageMaster->find($criteria);		
			
			if(empty($parent_storage_master_data)) {
				$this->redirect('/pages/err_sto_no_stor_data'); 
				exit;
			}
		
			$parent_storage_control_id 
				= $parent_storage_master_data['StorageMaster']['storage_control_id'];
			
			// Read control type data of the parent storage
			$criteria = "StorageControl.id = ". $parent_storage_control_id;
			$parent_storage_control_data = $this->StorageControl->find($criteria);
					
			if(empty($parent_storage_control_data)) {
				$this->redirect('/pages/err_sto_no_stor_cont_data'); 
				exit;
			}
		
			if(!is_null($parent_storage_control_data['StorageControl']['form_alias_for_children_pos'])){
				// A storage position into the parent storage
				// can be defined for the storage
	
				$bool_define_position = TRUE;
			}
		}
		
		if(!$bool_define_position) {
			// No Position has to be selected{
			$this->flash('No posiiton has to be defined.',
				'/storage_masters/detail/'.$storage_master_id);
				exit;				
		}
			
		// Position can be selected
			
		// ** 1- PREPARE FIRST FORM TO DISPLAY STORAGE OF THE STORAGE **
		
		// set SUMMARY variable from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build($storage_master_id) );
	
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string 
		// that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray( 
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action']));
				
		// get the storage control data of the storage
		$storage_control_id = $storage_master_data['StorageMaster']['storage_control_id'];
		$this->StorageControl->id = $storage_control_id;
		$storage_control_data = $this->StorageControl->read();		
			
		if(empty($storage_control_data)) {
			$this->redirect('/pages/err_sto_no_stor_cont_data'); 
			exit;
		}
		
		// set MENU variable for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'sto_CAN_01', 'sto_CAN_02', $storage_master_id ); 

		if(!$this->requestAction('/storagelayout/storage_coordinates/allowCustomCoordinates/'.$storage_control_id)) {
			//grey out 'Coordinates' tab
			 $ctrapp_menu['0']['sto_CAN_06']['allowed'] = false;	
		}
		if(empty($storage_control_data['StorageControl']['coord_x_type'])) {
			//grey out 'storage layout' tabe
			 $ctrapp_menu['0']['sto_CAN_05']['allowed'] = false;					
		}
		if(strcmp($storage_control_data['StorageControl']['is_tma_block'], 'TRUE') == 0) {	
			$ctrapp_menu[] = $this->Menus->tabs( 'sto_CAN_02', 'sto_CAN_07', $storage_master_id );
		}
		
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// get FORM alias, from STORAGE CONTROL 
		$this->set('ctrapp_form_storage', 
			$this->Forms->getFormArray( $storage_control_data['StorageControl']['form_alias'] ));
	
		// set data to display on view
		$this->setStorageCoordinateValues($storage_control_data);		
				
		$parent_code_from_id 
			= array($parent_storage_id 
				=> $parent_storage_master_data['StorageMaster']['code']);

		$this->set('parent_code_from_id', $parent_code_from_id);		
		$this->set('parent_id', $parent_storage_id);
		
		$a_storage_path = $this->getStoragePath($parent_storage_id);
		$this->set('storage_path', $a_storage_path[$parent_storage_id]);
		
		if(strcmp($storage_control_data['StorageControl']['is_tma_block'], 'TRUE') == 0) {	
			$this->set('arr_tma_sop_title_from_id', 
				$this->getTmaSopsArray());
		}	
		
		// set storage dat
		if(is_null($storage_control_data['StorageControl']['detail_tablename'])){
			// No detail required for this storage
			$this->StorageDetail = NULL;
			$this->set('data', $storage_master_data); 
		} else {
			// Details are required for this storage
			
			// start new instance of STORAGE DETAIL model, using TABLENAME from STORAGE CONTROL 
			$this->StorageDetail = 
				new StorageDetail(false, $storage_control_data['StorageControl']['detail_tablename']);
			
			// read related STORAGE DETAIL row, whose ID should be same as STORAGE MASTER ID 
			$this->StorageDetail->id = $storage_master_id;
			$storage_detail_data = $this->StorageDetail->read();
				
			if(empty($storage_detail_data)){
				$this->redirect('/pages/err_sto_missing_stor_data'); 
				exit;
			}					
			
			// merge both datasets into a SINGLE dataset, set for VIEW 
			$this->set('data', array_merge( $storage_master_data, $storage_detail_data)); 
		}
	
		// ** 2- PREPARE SECOND FORM TO SELECT POSITION **
		
		// set FORM alias
		$this->set('ctrapp_form_position', 
			$this->Forms->getFormArray($parent_storage_control_data['StorageControl']['form_alias_for_children_pos']));
		
		// set data to display on view
		if(!empty($parent_storage_control_data['StorageControl']['coord_x_title'])) {
			$this->set('parent_coord_x_title', $parent_storage_control_data['StorageControl']['coord_x_title']);
		}
		if(!empty($parent_storage_control_data['StorageControl']['coord_y_title'])) {
			$this->set('parent_coord_y_title', $parent_storage_control_data['StorageControl']['coord_y_title']);
		}
		
		// Build predefined list of positions
		$a_coord_x_liste = $this->buildAllowedStoragePosition($parent_storage_id, $parent_storage_control_data, 'x');
		$a_coord_y_liste = $this->buildAllowedStoragePosition($parent_storage_id, $parent_storage_control_data, 'y');
		if(!empty($a_coord_x_liste)){
			$this->set('a_coord_x_liste', $a_coord_x_liste);
		}
		if(!empty($a_coord_y_liste)){
			$this->set('a_coord_y_liste', $a_coord_y_liste);
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
			// All the storage data (including coord x and y) are recorded into the master table.
			$this->data = $storage_master_data;	 

		} else {
			
			// SAVE POSTION 
			
			// Execute Validation 
			
			// setup MODEL(s) validation array(s) for displayed FORM 
			foreach ($this->Forms->getValidateArray($parent_storage_control_data['StorageControl']['form_alias_for_children_pos']) as $validate_model=>$validate_rules) {
				$this->{$validate_model}->validate = $validate_rules;
			}
		
			// Set flag
			$submitted_data_validates = TRUE;

			// Validates Fields of Master Table
			if(!$this->StorageMaster->validates($this->data['StorageMaster'])){
				$submitted_data_validates = FALSE;
			}

			// look for CUSTOM HOOKS, "validation"
			$custom_ctrapp_controller_hook 
				= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
				'controllers' . DS . 'hooks' . DS . 
				$this->params['controller'].'_'.$this->params['action'].'_validation.php';
			
			if (file_exists($custom_ctrapp_controller_hook)) {
				require($custom_ctrapp_controller_hook);
			}
					
			if ($submitted_data_validates) {
				
				// save data
				
				$bool_save_done = FALSE;
				
				if($this->StorageMaster->save($this->data['StorageMaster'])){
					$bool_save_done = TRUE;
				}
				
				if(!$bool_save_done){
					$this->redirect('/pages/err_sto_record_err'); 
					exit;
				} else {
					// Data has been recorded
					$this->flash('Your data has been updated.',
						'/storage_masters/detail/'.$storage_master_id);						
				}

			}

		}

	} // function editStoragePosition
	
	/**
	 * Create a FORM to display detail of a specific storage.
	 * 
	 * @param $storage_master_id Id of the storage master record of the storage to display.
	 * 
	 * @author N. Luc
	 * @since 2007-05-22
	 
	
	
	/**
	 * Display the content of a storage into a layout (array).
	 * 
	 * @param $storage_master_id Id of the storage master that is studied.
	 * 
	 * @author N. Luc
	 * @since 2007-05-22
	 
	function seeStorageLayout($storage_master_id=null) {

		// ** Parameters check **
		if(empty($storage_master_id)){
			$this->redirect('/pages/err_sto_no_stor_id'); 
			exit;
		}
			
		// ** set SUMMARY variable from plugin's COMPONENTS **
		$this->set( 'ctrapp_summary', $this->Summaries->build($storage_master_id));
				
		// ** set SIDEBAR variable ** 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string 
		// that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray( 
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action']));
			
		// ** Get Storage Data **			
		$this->StorageMaster->id = $storage_master_id;
		$storage_master_data = $this->StorageMaster->read();
		
		if(empty($storage_master_data)){
			$this->redirect('/pages/err_sto_no_stor_data'); 
			exit;
		}					
			
		// get the storage control data of the storage
		$storage_control_id = $storage_master_data['StorageMaster']['storage_control_id'];
		$this->StorageControl->id = $storage_control_id;
		$storage_control_data = $this->StorageControl->read();
		
		if(empty($storage_control_data)){
			$this->redirect('/pages/err_sto_no_stor_cont_data'); 
			exit;
		}
		
		if(empty($storage_control_data['StorageControl']['coord_x_type'])) {
			$this->redirect('/pages/err_sto_no_stor_layout'); 
			exit;				
		}	
		
		// ** set MENU variable for echo on VIEW ** 
		$ctrapp_menu[] = $this->Menus->tabs( 'sto_CAN_01', 'sto_CAN_05', $storage_master_id ); 

		if(!$this->requestAction('/storagelayout/storage_coordinates/allowCustomCoordinates/'.$storage_control_id)) {
			//grey out 'Coordinates' tab
			 $ctrapp_menu['0']['sto_CAN_06']['allowed'] = false;	
		}	
		
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// ** Build the storage content array **
	
		// Sort information	into an array
		$arr_content = array(
			'type' => $storage_master_data['StorageMaster']['storage_type'],
			'code' => $storage_master_data['StorageMaster']['code'],
			'id' => $storage_master_data['StorageMaster']['id'],
			'x' => $storage_control_data['StorageControl']['coord_x_title'],
			'x_labels' => array(),
			'y' => $storage_control_data['StorageControl']['coord_y_title'],
			'y_labels' => array(),
			'data' => array(),
			'data_no_position' => array());
	
		$bool_y_coord = FALSE;
		if(!empty($storage_control_data['StorageControl']['coord_y_type'])){
			$bool_y_coord = TRUE;	
		}
		
		// Look for all storages contained into the storage master
		$conditions = ' StorageMaster.parent_id = \''.$storage_master_id.'\'';	
		$a_children_storages = $this->StorageMaster->findAll($conditions);
	
		foreach($a_children_storages as $key => $children_master_data){
			// New chidlren storage
			$coord_x = $children_master_data['StorageMaster']['parent_storage_coord_x'];
			$coord_y = $children_master_data['StorageMaster']['parent_storage_coord_y'];
			$id = $children_master_data['StorageMaster']['id'];
			$code = $children_master_data['StorageMaster']['code'];
			$storage_type = $children_master_data['StorageMaster']['storage_type'];
			$selection_label = $children_master_data['StorageMaster']['selection_label'];
			
			if((is_null($coord_x) || (strlen($coord_x)==0))
			|| ($bool_y_coord && (is_null($coord_y) || (strlen($coord_y)==0)))){
				// Coordinate X missing 
				// or system wait for corrdinate Y but this one is missing
				$arr_content['data_no_position'][] = 
					array('id' => $id, 
						'code' => $code, 
						'type' => 'storage', 
						'type_code' => $storage_type, 
						'additional_data' => array('selection_label' => $selection_label));					
			} else {			
				$arr_content['data'][$coord_x][$coord_y][] = 
					array('id' => $id, 
						'code' => $code, 
						'type' => 'storage', 
						'type_code' => $storage_type, 
						'additional_data' => array('selection_label' => $selection_label));	
			}	
		}
		
		// Look for all aliquots contained into the storage master
		$conditions = 'AliquotMaster.storage_master_id = \''.$storage_master_id.'\'';	
		$a_storage_aliquots = $this->AliquotMaster->findAll($conditions);
	
		foreach($a_storage_aliquots as $key => $aliquot_master_data){
			$coord_x = $aliquot_master_data['AliquotMaster']['storage_coord_x'];
			$coord_y = $aliquot_master_data['AliquotMaster']['storage_coord_y'];
			$id = $aliquot_master_data['AliquotMaster']['id'];
			$code = $aliquot_master_data['AliquotMaster']['barcode'];
			$aliquot_type = $aliquot_master_data['AliquotMaster']['aliquot_type'];
			
			if((is_null($coord_x) || (strlen($coord_x)==0))
			|| ($bool_y_coord && (is_null($coord_y) || (strlen($coord_y)==0)))){
				// Coordinate X missing 
				// or system wait for corrdinate Y but this one is missing
				$arr_content['data_no_position'][] = 
					array('id' => $id, 
						'code' => $code, 
						'type' => 'aliquot', 
						'type_code' => $aliquot_type,
						'additional_data' => array());					
			} else {			
				$arr_content['data'][$coord_x][$coord_y][] = 
					array('id' => $id, 
						'code' => $code, 
						'type' => 'aliquot', 
						'type_code' => $aliquot_type,
						'additional_data' => array());	
			}	
		}
		
		// Look for all tma slide contained into the storage master
		$conditions = 'TmaSlide.storage_master_id = \''.$storage_master_id.'\'';	
		$a_storage_tma_slides = $this->TmaSlide->findAll($conditions);
		
		foreach($a_storage_tma_slides as $key => $tma_slide_data){
			$coord_x = $tma_slide_data['TmaSlide']['storage_coord_x'];
			$coord_y = $tma_slide_data['TmaSlide']['storage_coord_y'];
			$id = $tma_slide_data['TmaSlide']['id'];
			$code = $tma_slide_data['TmaSlide']['barcode'];
			$tma_block_id = $tma_slide_data['TmaSlide']['std_tma_block_id'];
			
			if((is_null($coord_x) || (strlen($coord_x)==0))
			|| ($bool_y_coord && (is_null($coord_y) || (strlen($coord_y)==0)))){
				// Coordinate X missing 
				// or system wait for corrdinate Y but this one is missing
				$arr_content['data_no_position'][] = 
					array('id' => $id, 
						'code' => $code, 
						'type' => 'tma slide', 
						'type_code' => 'tma slide',
						'additional_data' => array('tma_block_id' => $tma_block_id));					
			} else {			
				$arr_content['data'][$coord_x][$coord_y][] = 
					array('id' => $id, 
						'code' => $code, 
						'type' => 'tma slide', 
						'type_code' => 'tma slide',
						'additional_data' => array('tma_block_id' => $tma_block_id));	
			}	
		}
		
		// Get coordinates values list
		$arr_content['x_labels'] 
			= $this->buildAllowedStoragePosition($storage_master_id, $storage_control_data, 'x');
		$arr_content['y_labels'] 
			= $this->buildAllowedStoragePosition($storage_master_id, $storage_control_data, 'y');
		
		$this->set('arr_content', $arr_content);

		// ** look for CUSTOM HOOKS, "format" **
		// No hook allowed
				
	}// function seeStorageLayout	
	
	/**
	 * Delete a storage.
	 * 
	 * @param $storage_master_id Id of the storage master that shoudl be deleted.
	 * 
	 * @author N. Luc
	 * @since 2007-05-22
	 
	function delete($storage_master_id=null){
				
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($storage_master_id)) {
			$this->redirect('/pages/err_sto_no_stor_id'); 
			exit;
		}
		
		// ** get STROAGE MASTER info **
		$this->StorageMaster->id = $storage_master_id;
		$storage_master_data = $this->StorageMaster->read();
		
		if(empty($storage_master_data)) {
			$this->redirect('/pages/err_sto_no_stor_data'); 
			exit;
		}

		// ** check if the storage can be deleted **
		if(!$this->allowStorageDeletion($storage_master_id)){
			// Content exists, the storage can not be deleted
			$this->redirect('/pages/err_sto_stor_del_forbid'); 
			exit;			
		} 
		 				
		//Look for storage detail table
		$this->StorageControl->id = $storage_master_data['StorageMaster']['storage_control_id'];
		$storage_control_data = $this->StorageControl->read();

		if(empty($storage_control_data)){
			$this->redirect('/pages/err_sto_no_stor_cont_data'); 
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
		$bool_delete_storage = TRUE;
		
		// Create has many relation to delete the storage coordinate
		$has_many_array 
			= array('hasMany' => 
				array(
					'StorageCoordinate' => array(
						'className' => 'StorageCoordinate',
						'foreignKey' => 'storage_master_id',
						'dependent' => true)));
		
		$this->StorageMaster->bindModel($has_many_array);	
		
		if(!$this->StorageMaster->del( $storage_master_id )){
			$bool_delete_storage = FALSE;		
		}	
		
		if($bool_delete_storage){
			if(!is_null($storage_control_data['StorageControl']['detail_tablename'])){
				// This storage has specific data
				$this->StorageDetail 
					= new StorageDetail(false, $storage_control_data['StorageControl']['detail_tablename']);

				if(!$this->StorageDetail->del( $storage_master_id )){
					$bool_delete_storage = FALSE;		
				}	
			}
		}
		
		if(!$bool_delete_storage){
			$this->redirect('/pages/err_sto_stor_del_err'); 
			exit;
		}
		
		$this->flash('Your data has been deleted.', '/storage_masters/index/');
		
	}
	
	/* --------------------------------------------------------------------------
	 * SPECIIFIC FUNCTIONS FOR CONTAINERS
	 * -------------------------------------------------------------------------- */	

	/**
	 * Create a FORM to display the results of a research that list all
	 * aliquots stored into a storage.
	 * 
	 * @param $storage_master_id Master Id of the storage that contains the aliquot
	 * to display.
	 * 
	 * @author N. Luc
	 * @since 2007-08-20
	 
	function searchStorageAliquots($storage_master_id=null) {
		
		// ** Parameters check **
		if(empty($storage_master_id)){
			$this->redirect('/pages/err_sto_no_stor_id'); 
			exit;
		}
		
		// ** set SUMMARY variable from plugin's COMPONENTS **
		$this->set( 'ctrapp_summary', $this->Summaries->build($storage_master_id));
				
		// ** set SIDEBAR variable ** 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string 
		// that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray( 
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action']));
			
		// ** Get Storage Data **			
		$this->StorageMaster->id = $storage_master_id;
		$storage_master_data = $this->StorageMaster->read();
		
		if(empty($storage_master_data)){
			$this->redirect('/pages/err_sto_no_stor_data'); 
			exit;
		}					
			
		// get the storage control data of the storage
		$storage_control_id = $storage_master_data['StorageMaster']['storage_control_id'];
		$this->StorageControl->id = $storage_control_id;
		$storage_control_data = $this->StorageControl->read();
		
		if(empty($storage_control_data)){
			$this->redirect('/pages/err_sto_no_stor_cont_data'); 
			exit;
		}					
			
		// ** set MENU variable for echo on VIEW ** 
		$ctrapp_menu[] = $this->Menus->tabs( 'sto_CAN_01', 'sto_CAN_04', $storage_master_id ); 

		if(!$this->requestAction('/storagelayout/storage_coordinates/allowCustomCoordinates/'.$storage_control_id)) {
			//grey out 'Coordinates' tab
			 $ctrapp_menu['0']['sto_CAN_06']['allowed'] = false;	
		}
		if(empty($storage_control_data['StorageControl']['coord_x_type'])) {
			//grey out 'storage layout' tabe
			 $ctrapp_menu['0']['sto_CAN_05']['allowed'] = false;					
		}	
		
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// ** set FORM variable, for HELPER call on VIEW **
		$ctrapp_form = $this->Forms->getFormArray('storage_aliquots_list');
		$this->set('ctrapp_form', $ctrapp_form);

		// ** set variable to echo on view or build link **
		$this->set('storage_master_id', $storage_master_id);
		
					
		// set variables to display on view	
		if(!empty($storage_control_data['StorageControl']['coord_x_title'])) {
			$this->set('storage_coord_x_title', $storage_control_data['StorageControl']['coord_x_title']);
		}
		if(!empty($storage_control_data['StorageControl']['coord_y_title'])) {
			$this->set('storage_coord_y_title', $storage_control_data['StorageControl']['coord_y_title']);
		}

		// ** Get Storage Aliquots Data **
		$criteria = array();
		$criteria['AliquotMaster']['storage_master_id'] = $storage_master_id;	
		$order = 'AliquotMaster.storage_coord_x ASC, AliquotMaster.storage_coord_y ASC';
		$storage_aliquots = $this->AliquotMaster->findAll($criteria, null, $order, null, null, 0);
		
		$this->set('storage_aliquots', $storage_aliquots);
		
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
	 * Create a FORM to select aliquot postion into a parent storage and/or define
	 * aliquot as taken off.
	 * 
	 * @param $source_page Allow to define the form that was displayed when the user 
	 * clicked on a button launching this function:
	 *   - 'StorageAliquotsList'
	 *   - 'AliquotDetail'
	 * @param $storage_aliquot_id Aliquot master id of the Aliquot that must be positionned.
	 * 
	 * @author N. Luc
	 * @since 2007-08-20
	 
	function editAliquotPosition($source_page='StorageAliquotsList', $aliquot_master_id=null) {
			
		// ** Get the storage master id **
		if(isset($this->data['AliquotMaster']['id'])) {
			//User clicked on the Submit button to modify the edited storage
			$aliquot_master_id = $this->data['AliquotMaster']['id'];
		}
		
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($source_page) || empty($aliquot_master_id)) {
			$this->redirect('/pages/err_sto_funct_param_missing'); 
			exit;
		}

		if(!in_array($source_page, array('StorageAliquotsList', 'AliquotDetail'))) {
			$this->redirect('/pages/err_sto_system_error'); 
			exit;
		}

		// ** Get the aliquot master data **
		$this->AliquotMaster->id = $aliquot_master_id;
		$aliquot_master_data = $this->AliquotMaster->read();
		
		if(empty($aliquot_master_data)){
			$this->redirect('/pages/err_sto_aliquot_no_data'); 
			exit;
		}
				
		// ** Search storage data **
		$aliquot_storage_master_id = $aliquot_master_data['AliquotMaster']['storage_master_id'];
		
		if(empty($aliquot_storage_master_id)){
			$this->redirect('/pages/err_sto_no_stor_id'); 
			exit;
		}	
		
		$this->StorageMaster->id = $aliquot_storage_master_id;
		$aliquot_storage_master_data = $this->StorageMaster->read();
		
		if(empty($aliquot_storage_master_data)){
			$this->redirect('/pages/err_sto_no_stor_data'); 
			exit;
		}					
			
		// get the storage control data of the storage
		$aliquot_storage_control_id = $aliquot_storage_master_data['StorageMaster']['storage_control_id'];
		$this->StorageControl->id = $aliquot_storage_control_id;
		$aliquot_storage_control_data = $this->StorageControl->read();
		
		if(empty($aliquot_storage_control_data)){
			$this->redirect('/pages/err_sto_no_stor_cont_data'); 
			exit;
		}	
		
		// ** set SUMMARY variable from plugin's COMPONENTS **
		$this->set( 'ctrapp_summary', $this->Summaries->build($aliquot_storage_master_id));
				
		// ** set SIDEBAR variable ** 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string 
		// that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray( 
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action']));		
		
		// ** set MENU variable for echo on VIEW ** 
		$ctrapp_menu[] = $this->Menus->tabs( 'sto_CAN_01', 'sto_CAN_04', $aliquot_storage_master_id ); 

		if(!$this->requestAction('/storagelayout/storage_coordinates/allowCustomCoordinates/'.$aliquot_storage_control_id)) {
			//grey ou$ctrapp_menuab
			 $ctrapp_menu['0']['sto_CAN_06']['allowed'] = false;	
		}
		if(empty($aliquot_storage_control_data['StorageControl']['coord_x_type'])) {
			//grey out 'storage layout' tabe
			 $ctrapp_menu['0']['sto_CAN_05']['allowed'] = false;					
		}	
		
		$this->set( 'ctrapp_menu', $ctrapp_menu );		
		
		// ** set FORM variable, for HELPER call on VIEW **
		$form_title = '';
		$boo_define_position = FALSE;
		
		// Verify a position can be defined into this storage
		if(is_null($aliquot_storage_control_data['StorageControl']['form_alias_for_children_pos'])){
			// No position to define. 
			$form_title = 'manage_storage_aliquots_without_position';		
		} else {
			$boo_define_position = TRUE;
			$form_title
				= $aliquot_storage_control_data['StorageControl']['form_alias_for_children_pos'].'_for_aliquot';
		}				
			
		$this->set('ctrapp_form_position', $this->Forms->getFormArray($form_title));

		// ** set variable to echo on view or build link **			
		$this->set('source_page', $source_page);
		$this->set('aliquot_master_id', $aliquot_master_id);
		$this->set('aliquot_storage_master_id', $aliquot_storage_master_id);
			
		if($boo_define_position) {	
			if(!empty($aliquot_storage_control_data['StorageControl']['coord_x_title'])) {
				$this->set('parent_coord_x_title', $aliquot_storage_control_data['StorageControl']['coord_x_title']);
			}
			if(!empty($aliquot_storage_control_data['StorageControl']['coord_y_title'])) {
				$this->set('parent_coord_y_title', $aliquot_storage_control_data['StorageControl']['coord_y_title']);
			}
			
			// Build predefined list of positions
			$a_coord_x_liste = $this->buildAllowedStoragePosition($aliquot_storage_master_id, $aliquot_storage_control_data, 'x');
			$a_coord_y_liste = $this->buildAllowedStoragePosition($aliquot_storage_master_id, $aliquot_storage_control_data, 'y');
			if(!empty($a_coord_x_liste)){
				$this->set('a_coord_x_liste', $a_coord_x_liste);
			}
			if(!empty($a_coord_y_liste)){
				$this->set('a_coord_y_liste', $a_coord_y_liste);
			}
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
			// ** Set data to display initial form view ** 
			$this->data = $aliquot_master_data;
			$this->set('data', $aliquot_master_data);
		
		} else {			
			// ** SAVE POSTION **
			
			// Execute Validation 
			
			// setup MODEL(s) validation array(s) for displayed FORM 
			foreach ($this->Forms->getValidateArray($form_title) as $validate_model=>$validate_rules) {
				$this->{$validate_model}->validate = $validate_rules;
			}
		
			$submitted_data_validates = TRUE;
			
			// Validates Fields of Aliquot Master Table
			if(!$this->AliquotMaster->validates($this->data['AliquotMaster'])){
				$submitted_data_validates = FALSE;
			}
			
			// look for CUSTOM HOOKS, "validation"
			$custom_ctrapp_controller_hook 
				= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
				'controllers' . DS . 'hooks' . DS . 
				$this->params['controller'].'_'.$this->params['action'].'_validation.php';
			
			if (file_exists($custom_ctrapp_controller_hook)) {
				require($custom_ctrapp_controller_hook);
			}
					
			if ($submitted_data_validates) {
				
				// Verify if the aliquot should be taken off
				if(strcmp($this->data['FunctionManagement']['additional_field_delete_of_storage'], 'yes') == 0){
					// User would like to delete postion data
					$this->data['AliquotMaster']['storage_master_id'] = null;
					$this->data['AliquotMaster']['storage_coord_x'] = null;
					$this->data['AliquotMaster']['storage_coord_y'] = null;
				}
				
				// save data
				
				$bool_save_done = FALSE;
					
				//TODO: Update only modified records
				$this->data['AliquotMaster']['modified'] = date('Y-m-d G:i');
				$this->data['AliquotMaster']['modified_by'] = $this->othAuth->user('id');	
				
				if($this->AliquotMaster->save($this->data['AliquotMaster'])){
					$bool_save_done = TRUE;
				}
				
				if(!$bool_save_done){
					$this->redirect('/pages/err_sto_aliquot_record_err'); 
					exit;
				} else {
					// Data has been recorded
					
					$redirection_url = '';		
					if(strcmp($source_page, 'AliquotDetail') == 0){
						// The user launch the aliquot position selection from 'aliquot detail' form
						$redirection_url 
							= '/../inventorymanagement/aliquot_masters/detailAliquotFromId/'.$aliquot_master_id;					 		
					} else {
						// The user launch the aliquot position selection from 'storage aliquots list' form
						$redirection_url 
							= '/storage_masters/searchStorageAliquots/'.$aliquot_storage_master_id;	
					}
					
					$this->flash('Your data has been updated.', $redirection_url);
					
				}
			}
		}			
	} // function editAliquotPosition
	
	/**
	 * Create a FORM to allow user to:
	 *  - take off any storage aliquots.
	 *  - or manage position of any storage aliquots.
	 * 
	 * @param $storage_master_id ID of the storage that contains the aliquots. 
	 * 
	 * @author N. Luc
	 * @since 2007-08-20
	 
	function editAliquotPositionInBatch($storage_master_id=null){

		// ** Parameters check **
		// Verify parameters have been set
		if(empty($storage_master_id)) {
			$this->redirect('/pages/err_sto_no_stor_id'); 
			exit;
		}

		// ** Search storage data **
		$this->StorageMaster->id = $storage_master_id;
		$storage_master_data = $this->StorageMaster->read();
		
		if(empty($storage_master_data)){
			$this->redirect('/pages/err_sto_no_stor_data'); 
			exit;
		}					
			
		// get the storage control data of the storage
		$storage_control_id = $storage_master_data['StorageMaster']['storage_control_id'];
		$this->StorageControl->id = $storage_control_id;
		$storage_control_data = $this->StorageControl->read();
		
		if(empty($storage_control_data)){
			$this->redirect('/pages/err_sto_no_stor_cont_data'); 
			exit;
		}	
		
		// ** set SUMMARY variable from plugin's COMPONENTS **
		$this->set( 'ctrapp_summary', $this->Summaries->build($storage_master_id));
				
		// ** set SIDEBAR variable ** 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string 
		// that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray( 
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action']));		
		
		// ** set MENU variable for echo on VIEW ** 
		$ctrapp_menu[] = $this->Menus->tabs( 'sto_CAN_01', 'sto_CAN_04', $storage_master_id ); 

		if(!$this->requestAction('/storagelayout/storage_coordinates/allowCustomCoordinates/'.$storage_control_id)) {
			//grey out 'Coordinates' tab
			 $ctrapp_menu['0']['sto_CAN_06']['allowed'] = false;	
		}
		if(empty($storage_control_data['StorageControl']['coord_x_type'])) {
			//grey out 'storage layout' tabe
			 $ctrapp_menu['0']['sto_CAN_05']['allowed'] = false;					
		}	
		
		$this->set( 'ctrapp_menu', $ctrapp_menu );		
	
		// ** set FORM variable, for HELPER call on VIEW **
		$form_title = '';
		$boo_define_position = FALSE;
		
		// Verify a position can be defined into this storage
		if(is_null($storage_control_data['StorageControl']['form_alias_for_children_pos'])){
			// No position to define. 
			$form_title = 'manage_storage_aliquots_without_position';		
		} else {
			$boo_define_position = TRUE;
			$form_title
				= $storage_control_data['StorageControl']['form_alias_for_children_pos'].'_for_aliquot';
		}				
			
		$this->set('ctrapp_form_position', $this->Forms->getFormArray($form_title));
		
		// ** set variable to echo on view or build link **			
		
		if($boo_define_position) {	
			if(!empty($storage_control_data['StorageControl']['coord_x_title'])) {
				$this->set('parent_coord_x_title', $storage_control_data['StorageControl']['coord_x_title']);
			}
			if(!empty($storage_control_data['StorageControl']['coord_y_title'])) {
				$this->set('parent_coord_y_title', $storage_control_data['StorageControl']['coord_y_title']);
			}
			
			// Build predefined list of positions
			$a_coord_x_liste = $this->buildAllowedStoragePosition($storage_master_id, $storage_control_data, 'x');
			$a_coord_y_liste = $this->buildAllowedStoragePosition($storage_master_id, $storage_control_data, 'y');
			if(!empty($a_coord_x_liste)){
				$this->set('a_coord_x_liste', $a_coord_x_liste);
			}
			if(!empty($a_coord_y_liste)){
				$this->set('a_coord_y_liste', $a_coord_y_liste);
			}
		}
		
		// ** Search Storage Aliquot List **
		$criteria = array();
		$criteria['AliquotMaster.storage_master_id'] = $storage_master_id;
		$criteria = array_filter($criteria);
				
		$order = 'AliquotMaster.storage_coord_x ASC, ' .
			'AliquotMaster.storage_coord_y ASC';

		$a_storage_aliquots = $this->AliquotMaster->findAll($criteria, null, $order, null, null, 0);		

		// ** look for CUSTOM HOOKS, "format" **
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
			
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}

		if(empty($this->data)){
			// ** Edit Data **
			$this->data = $a_storage_aliquots;
			$this->set('data', $this->data);
		
		} else {
			// ** Save Data **
			
			// setup MODEL(s) validation array(s) for displayed FORM 
			foreach ($this->Forms->getValidateArray($form_title) as $validate_model=>$validate_rules) {
				$this->{$validate_model}->validate = $validate_rules;
			}
			
			// set a FLAG
			$submitted_data_validates = TRUE;
			
			// Execute Validation 
			
			foreach ($this->data as $key=>$val) {
				if (!$this->AliquotMaster->validates($val)) {
					$submitted_data_validates = FALSE;
				}	
			}

			// look for CUSTOM HOOKS, "validation"
			$custom_ctrapp_controller_hook 
				= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
				'controllers' . DS . 'hooks' . DS . 
				$this->params['controller'].'_'.$this->params['action'].'_validation.php';
			
			if (file_exists($custom_ctrapp_controller_hook)) {
				require($custom_ctrapp_controller_hook);
			}
			
			if ($submitted_data_validates) {
				
				// Launch Save
				
				$bool_save_done = TRUE;
				
				// save each ROW
				foreach ($this->data as $key=>$val) {
					
					if(strcmp($val['FunctionManagement']['additional_field_delete_of_storage'], 'yes') == 0){
						// User would like to delete postion data
						$val['AliquotMaster']['storage_master_id'] = null;
						$val['AliquotMaster']['storage_coord_x'] = null;
						$val['AliquotMaster']['storage_coord_y'] = null;
					}
						
					//TODO: Update only modified records
					$val['AliquotMaster']['modified'] = date('Y-m-d G:i');
					$val['AliquotMaster']['modified_by'] = $this->othAuth->user('id');	
				
					if(!$this->AliquotMaster->save($val)){
						$bool_save_done = FALSE;
					}
					
					if(!$bool_save_done){
						break;
					}
				}
		
				if(!$bool_save_done){
					$this->redirect('/pages/err_sto_aliquot_record_err'); 
					exit;
				} else {
					$this->flash('Your data has been updated.',
						'/storage_masters/searchStorageAliquots/'.$storage_master_id );
				}		
			} // END SAVE
		} // END SUBMITTED DATA CONTROL
	}
	
	/* --------------------------------------------------------------------------
	 * ADDITIONAL FUNCTIONS
	 * -------------------------------------------------------------------------- */	
			
	/**
	 * Set all variables to display storage coordinate properties to allocate postion 
	 * to an entity stored into this storage.
	 * 
	 * @param $storage_control_data Record of the STORAGE CONTROLE attached to the type
	 * of the storage.
	 * 
	 * @author N. Luc
	 * @since 2007-05-22
	 
	function setStorageCoordinateValues($storage_control_data){

		$string_null_value = 'n/a';
		
		$this->set('coord_x_title', 
			isset($storage_control_data['StorageControl']['coord_x_title'])? 
				$storage_control_data['StorageControl']['coord_x_title']: 
				$string_null_value);
				
		$this->set('coord_x_type',  
			isset($storage_control_data['StorageControl']['coord_x_type'])? 
				$storage_control_data['StorageControl']['coord_x_type']: 
				$string_null_value);
			
		$this->set('coord_x_size',  
			isset($storage_control_data['StorageControl']['coord_x_size'])? 
				$storage_control_data['StorageControl']['coord_x_size']: 
				$string_null_value);

		$this->set('coord_y_title', 
			isset($storage_control_data['StorageControl']['coord_y_title'])? 
				$storage_control_data['StorageControl']['coord_y_title']: 
				$string_null_value);
				
		$this->set('coord_y_type',  					
			isset($storage_control_data['StorageControl']['coord_y_type'])? 
				$storage_control_data['StorageControl']['coord_y_type']: 
				$string_null_value);
				
		$this->set('coord_y_size',  
			isset($storage_control_data['StorageControl']['coord_y_size'])? 
				$storage_control_data['StorageControl']['coord_y_size']: 
				$string_null_value);	
				
	}
	
	/**
	 * Create Storage code of a created storage. 
	 * 
	 * @param $storage_master_data Array that contains storage master data 
	 * of the created storage (including 'id').
	 * @param $storage_control_data Array that contains storage control data 
	 * of the created storage.
	 * 
	 * @return The storage code of the created storage.
	 * 
	 * @author N. Luc
	 * @since 2008-01-31
	 
	function createStorageCode($storage_master_data, $storage_control_data){
		
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($storage_master_data) || empty($storage_control_data)
		|| (!isset($storage_master_data['id']))) {
			$this->redirect('/pages/err_sto_funct_param_missing'); 
			exit;
		}
		
		// ** build storage code **
		$storage_code = 
			$storage_control_data['storage_type_code'].
			' - '.
			$storage_master_data['id'];
		
		return $storage_code;
		
	}

	/**
	 * Verify that the new Storage BarCode of a storage does not already exists.
	 *
	 * @param $arr_storage_master Array that contains the storage master data.
	 *
	 * @return TRUE if the new barcode already exists.
	 * 
	 * @author N. Luc
	 * @since 2008-01-31
	 
	function IsDuplicatedStorageBarCode($arr_storage_master){
		
		// Look for all storages
		$a_fields = array('id');
		$conditions = ' StorageMaster.barcode = \''.$arr_storage_master['barcode'].'\'';
		$a_storages = $this->StorageMaster->findAll($conditions, $a_fields);
		
		if(empty($a_storages)){
			return FALSE;
		} else {
			if(!isset($arr_storage_master['id'])) {
				// Storage has not already been created
				return TRUE;
			} else if(strcmp($arr_storage_master['id'], $a_storages['0']['StorageMaster']['id']) != 0){
				// The storage having the same barcode is not the studied storage
				return TRUE;
			}
		}

		return FALSE;
	}

	/**
	 * Build the path code of the storage plus manage (including data record) the path codes 
	 * of all its children storages.
	 *
	 * @param $arr_storage_master Array that contains the storage master data.
	 * 
	 * @return The new storage path code.
	 * 
	 * @author N. Luc
	 * @since 2008-01-31
	 
	function manageStoragePathcode($arr_storage_master_data){
		
		// Check parameter
		if(empty($arr_storage_master_data) 
		|| (!isset($arr_storage_master_data['parent_id']))) {
			$this->redirect('/pages/err_sto_no_stor_data'); 
			exit;
		}
		
		// Launch path code management
		$new_storage_selection_label = '';
		
		// Verify parent storage exists and get its path code
		if(!empty($arr_storage_master_data['parent_id'])){
			// A parent has been defined. 
			
			// Search parent path code to build storage path code		
			$criteria = 'StorageMaster.id = "' . $arr_storage_master_data['parent_id'].'"';			
			$parent_storage_data = $this->StorageMaster->find($criteria);

			if(empty($parent_storage_data)){
				$this->redirect('/pages/err_sto_no_stor_data'); 
				exit;
			}
			
			$new_storage_selection_label = 
				$parent_storage_data['StorageMaster']['selection_label'].
				'-'.
				$arr_storage_master_data['short_label'];

		} else {
			// no path code : path code = short label
			$new_storage_selection_label = 
				$arr_storage_master_data['short_label'];			
		}
			
		// Manage path code of the children storages
		if(isset($arr_storage_master_data['id'])){

			// The storage already exists: Search existing childrens to update their path code			
			if(strcmp($arr_storage_master_data['selection_label'], $new_storage_selection_label) != 0) {
				// Path code has been changed: Update children storages path code
				$this->updateChildrenStoragePathcode($arr_storage_master_data['id'], $new_storage_selection_label);
			}
		}
		
		// return new path code
		return $new_storage_selection_label;
		
	}

	/**
	 * Manage the path code of the children storages of a parent storage.
	 *
	 * @param $parent_storage_id ID of the parent storage that should be studied
	 * to update the path codes of their children storages.
	 * @param $new_storage_selection_label New path code of the storage path code.
	 * 
	 * @author N. Luc
	 * @since 2008-01-31
	 
	function updateChildrenStoragePathcode($parent_storage_id, $parent_storage_selection_label){
		
		// Look for childrens of the storage
		$criteria = 'StorageMaster.parent_id = "'.$parent_storage_id.'"';
		$children_storage_list = $this->StorageMaster->findAll($criteria);
		
		foreach($children_storage_list as $id => $children_storage_master_data){
			// New children of the studied storage
			$new_children_storage_selection_label = 
				$parent_storage_selection_label.
				'-'.
				$children_storage_master_data['StorageMaster']['short_label'];
			
			$children_storage_master_data['StorageMaster']['selection_label']
				= $new_children_storage_selection_label;
			
			if(!$this->StorageMaster->save($children_storage_master_data['StorageMaster'])){
				$this->redirect('/pages/err_sto_record_err'); 
				exit;
			}
			
			// Update children storages path code of the studied children
			$this->updateChildrenStoragePathcode(
				$children_storage_master_data['StorageMaster']['id'], 
				$new_children_storage_selection_label);
							
		}
		
		return;			

	}

	/**
	 * Will build an array that contains the storage list except TMA. When a storage master id is passed
	 * in arguments, this storage plus all its direct and undirect children storages will be 
	 * deleted from this list.
	 * 
	 * @param $excluded_storage_master_id ID of the storage to exclude of the list.
	 * 
	 * @return An array that contains the list of storages.
	 * [storag_master_id] => $storage_data (array())
	 * 
	 * @author N. Luc
	 * @since 2007-05-22
	 
	function getStoragesList($excluded_storage_master_id=null){
		
		// Look for all storage_control_id of TMA
		$criteria = "`is_tma_block` LIKE 'TRUE'";
		$arr_tma_control_ids = 
			$this->StorageControl->generateList(
				$criteria, 
				NULL, 
				NULL,
				'{n}.StorageControl.id', 
				'{n}.StorageControl');;		
		
		// Look for all storages
		$criteria = array();
		if(!empty($arr_tma_control_ids)){
			// Exclude TMA
			$criteria = "`storage_control_id` NOT IN (".implode(",", array_keys($arr_tma_control_ids)).")";
		}
		$order = "StorageMaster.selection_label ASC";
		$arr_storages_list_tmp = 
			$this->StorageMaster->findAll($criteria, NULL, $order);
		
		// Build work list
		$arr_storages_list = array();
		foreach($arr_storages_list_tmp as $id_tmp => $storage_data) {
			$id = $storage_data['StorageMaster']['id'];
			$arr_storages_list[$id] = $storage_data['StorageMaster'];		
		}
														
		if((!empty($arr_storages_list)) && (!empty($excluded_storage_master_id))) {
			if(isset($arr_storages_list[$excluded_storage_master_id])) {
				// The defined storage plus all its childrens should be deleted
				$this->deleteChildrenFromTheList($excluded_storage_master_id, $arr_storages_list);
				unset($arr_storages_list[$excluded_storage_master_id]);
			}
		}
		
		if(empty($arr_storages_list)){
			// No Storage exists in the system
			return array();	
		}					
			
		return $arr_storages_list;
	}

	/**
	 * Delete storage id of all direct and undirect children storages
	 * of a storage (having id passed in argument) from a storages list.
	 *
	 * @param $parent_storage_id ID of the parent storage having children that should be 
	 * deleted from the list.
	 * @param $arr_storages_list List of storages (passed by reference) having following 
	 * structure:
	 *    [storage_master_id] = storage code
	 * 
	 * @author N. Luc
	 * @since 2008-01-31
	 
	function deleteChildrenFromTheList($parent_storage_id, &$arr_storages_list){
		
		// Look for childrens of the storage
		$criteria = 'StorageMaster.parent_id = "'.$parent_storage_id.'"';
		$children_storage_list = $this->StorageMaster->findAll($criteria);
		
		foreach($children_storage_list as $id => $children_storage_master_data){
			
			// New children of the studied storage
			$studied_children_storage_id = $children_storage_master_data['StorageMaster']['id'];

			if((!empty($arr_storages_list)) && isset($arr_storages_list[$studied_children_storage_id])) {
				// The defined storage plus all its childrens should be deleted
				$this->deleteChildrenFromTheList($studied_children_storage_id, $arr_storages_list);
				unset($arr_storages_list[$studied_children_storage_id]);

			}				
		}
			
		return;
		
	}

	/**
	 * Define if a storage can be deleted.
	 * 
	 * @param $storage_master_id Id of the studied storage.
	 * 
	 * @return Return TRUE if the storage can be deleted.
	 * 
	 * @author N. Luc
	 * @since 2007-08-16
	 
	function allowStorageDeletion($storage_master_id){
		
		// verify storage contains no chlidren storage
		$conditions = ' StorageMaster.parent_id = \''.$storage_master_id.'\'';	
		$nbr_children_storages = $this->StorageMaster->findCount($conditions);

		if($nbr_children_storages > 0){
			return FALSE;
		}
		
		// verify storage contains no aliquots
		$conditions = ' AliquotMaster.storage_master_id = \''.$storage_master_id.'\'';	
		$nbr_storage_aliquots = $this->AliquotMaster->findCount($conditions);

		if($nbr_storage_aliquots > 0){
			return FALSE;
		}
		
		// verify storage is not attached to tma slide
		$conditions = ' TmaSlide.std_tma_block_id = \''.$storage_master_id.'\'';	
		$nbr_tma_slides = $this->TmaSlide->findCount($conditions);

		if($nbr_tma_slides > 0){
			return FALSE;
		}
		
		// verify storage is not attached to tma slide
		$conditions = ' TmaSlide.storage_master_id = \''.$storage_master_id.'\'';	
		$nbr_tma_slides = $this->TmaSlide->findCount($conditions);

		if($nbr_tma_slides > 0){
			return FALSE;
		}
							
		return TRUE;
	}

	/**
	 * Build list of values that could be selected to define position coordinate (X or Y) of a children
	 * storage into a studied stroage. This list is based on the control data of the storage.
	 * 
	 * When:
	 *   - Type = 'alphabetical' and size is not null: System will build list 
	 *     of alphabetical values ('A' + 'B' + 'C' + etc). Number of values 
	 *     is defined by the size.
	 *  
	 *   - Type = 'integer' and size is not null: System will build list 
	 *     of integer values ('1' + '2' + '3' + etc). Number of values 
	 *     is defined by the size.
	 *  
	 *   - Type = 'liste' and size is null: System will search cutom coordinate values defined for 
	 *     the parent storage. (This list is uniquely supported for coordinate 'X').
	 * 
	 * @param $storage_master_id ID of the studied storage.
	 * @param $storage_control_data Data of the storage control attached to the type 
	 * of the storage.
	 * @param $coord Coordinate flag that should be studied ('x', 'y').
	 *
	 * @return Array of available values.
	 * 
	 * @author N. Luc
	 * @since 2007-05-22
	 
	function buildAllowedStoragePosition($storage_master_id, $storage_control_data, $coord){
		
		// Verify the coordinate is allowed
		if(!in_array($coord, $this->a_storage_coordinates)){
			$this->redirect('/pages/err_sto_system_error'); 
			exit;
		}

		// Build array
		$returned_array = array();
		
		if((!empty($storage_control_data['StorageControl']['coord_'.$coord.'_type']))
		&& (!empty($storage_control_data['StorageControl']['coord_'.$coord.'_size']))) {
			// Size and type are defined for the coordinate of the storage type
			// The system can build a list.
			
			$size = $storage_control_data['StorageControl']['coord_'.$coord.'_size'];
			
			if(!is_numeric($size)){
				$this->redirect('/pages/err_sto_system_error'); 
				exit;				
			}
			
			if(strcmp($storage_control_data['StorageControl']['coord_'.$coord.'_type'], 'alphabetical') == 0){
				// Alphabetical drop down list
				$a_alphab = array('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',
		            'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T',
		            'U', 'V', 'W', 'X', 'Y', 'Z');
				
				if($size > sizeof($a_alphab)){
					$this->redirect('/pages/err_sto_system_error'); 
					exit;
				}
				
				for($counter = 0; $counter < $size; $counter++) {
					$returned_array[$a_alphab[$counter]] = $a_alphab[$counter];
				}
				
			} else if(strcmp($storage_control_data['StorageControl']['coord_'.$coord.'_type'], 'integer') == 0){
				// Integer drop down list
				for($counter = 1; $counter <= $size; $counter++) {
					$returned_array[$counter] = $counter;
				}
				
			} else {
					$this->redirect('/pages/err_sto_system_error'); 
					exit;				
			}
			
		} else if((!empty($storage_control_data['StorageControl']['coord_'.$coord.'_type']))
		&& (empty($storage_control_data['StorageControl']['coord_'.$coord.'_size']))) {
			
			// Should be coordinate_x and a list of values defined by user
			if((strcmp($storage_control_data['StorageControl']['coord_'.$coord.'_type'], 'list') == 0) 
			&& (strcmp($coord, 'x') == 0)) {
				
				// Look for coordinate list defined by user
				$conditions = "StorageCoordinate.storage_master_id = '".$storage_master_id.
					"' AND StorageCoordinate.dimension = '".$coord."'";
				$order = "StorageCoordinate.order ASC";				
				
				$tmp_coord_list 
					=$this->StorageCoordinate->generateList(
						$conditions, 
						$order, 
						null, 
						'{n}.StorageCoordinate.coordinate_value', 
						'{n}.StorageCoordinate.coordinate_value');
										
				if(!empty($tmp_coord_list)){
					$returned_array = $tmp_coord_list;
				}
				
			} else {
				$this->redirect('/pages/err_sto_system_error'); 
				exit;					
			}
			
		} else if(!(empty($storage_control_data['StorageControl']['coord_'.$coord.'_type'])
		&& empty($storage_control_data['StorageControl']['coord_'.$coord.'_size']))) {
			// The storage control defintion is not supported by the current system
			$this->redirect('/pages/err_sto_system_error'); 
			exit;			
		}
	
		return $returned_array;
	}
	
	/**
	 * Will build an array that contains the path to access a storag.
	 * 
	 * @param $studied_storage_id Id of the studied storage.
	 * 
	 * @return An array that contains storage data and having the structure
	 * below.
	 * [storag_master_id] => path (ex:' /room1/freezer1')
	 * 
	 * @author N. Luc
	 * @since 2007-05-22
	 
	function getStoragePath($studied_storage_id = null){
		
		if(empty($studied_storage_id)){
			// studied storage is not stored
			return array('0' => '/', NULL=> '/');	
		}
	
		// Look for all storages
		$a_fields = array('id', 'parent_id', 'code', 'storage_type');
		$a_storages = $this->StorageMaster->findAll();

		if(empty($a_storages)){
			// No Storage exists in the system
			return array('0' => '/', NULL=> '/');	
		}

		// Sort storages into an array having structure:
		// [storage id]
		//   [parent storage id]
		//   [storage code]
		//   [storage type]
		$a_sorted_storages = array();	
		foreach($a_storages as $key => $storage){
			$stor_parent_id = $storage['StorageMaster']['parent_id'];
			$id = $storage['StorageMaster']['id'];
			$code = $storage['StorageMaster']['code'];
			$type = $storage['StorageMaster']['storage_type'];

			$a_sorted_storages[$id] = 
				array(
					'parent_id'=>$stor_parent_id, 
					'code'=>$code, 
					'storage_type'=>$type);			
		}	
		
		if(!isset($a_sorted_storages[$studied_storage_id])){
			// The Storage does not exist
			return array('0' => '/');	
		}
		
		$new_parent_id = $a_sorted_storages[$studied_storage_id]['parent_id'];
		$path = ' / '.$a_sorted_storages[$studied_storage_id]['code'];
		
		while(!empty($new_parent_id)){
			$storage_id = $new_parent_id;
			$new_parent_id = $a_sorted_storages[$storage_id]['parent_id'];
			$path = ' / '.$a_sorted_storages[$storage_id]['code'].$path;
		}			

		return array($studied_storage_id => $path);
	}

	/**
	 * Update the surrounding temperature and unit of children storages of a parent storage.
	 * Recursive function.
	 * 
	 * @param $parent_storage_master_id Id of the parent storage master. 
	 * @param $new_temperature New parent storage temperature.
	 * @param $new_temp_unit New parent storage temperature unit.
	 *
	 * @author N. Luc
	 * @since 2007-05-22
	 
	function updateChildrenSurroundingTemperature($parent_storage_master_id, $new_temperature, $new_temp_unit){
	
		// Look for children of the storage
		$criteria = 'StorageMaster.parent_id ="'.$parent_storage_master_id.'"';		
		$fields = 'StorageMaster.id, StorageMaster.set_temperature';
			
		$children_aliquot_list = $this->StorageMaster->findAll($criteria, $fields);
		
		foreach($children_aliquot_list as $id => $storage_master_data){
			if(strcmp($storage_master_data['StorageMaster']['set_temperature'], 'FALSE') == 0){

				// The surrounding temperature of this storage has to be recorded		
				$storage_master_data['StorageMaster']['temperature'] = $new_temperature;
				$storage_master_data['StorageMaster']['temp_unit'] = $new_temp_unit;

				if(!$this->StorageMaster->save($storage_master_data)){
					$this->redirect('/pages/err_sto_record_err'); 
					exit;
				}
				
				// Launch function on the children of the storage
				$this->updateChildrenSurroundingTemperature(
					$storage_master_data['StorageMaster']['id'], 
					$new_temperature, 
					$new_temp_unit);	
				
			}
		}
		
		return;			
	}		
	/**
	 * Define if a position can be recorded to store an entity into a 
	 * specific storage according to the storage type.
	 *
	 * @param $storage_master_id Id of the storage in which we try to store 
	 * an entity (aliquot, children storage, etc).
	 *
	 * @return TRUE if position can be selected.
	 * 
	 * @author N. Luc
	 * @since 2007-05-22
	 
	function isPositionSelectionAvailable($storage_master_id) {
		
		// Verify parameters have been set
		if(empty($storage_master_id)) {
			$this->redirect('/pages/err_sto_no_stor_id'); 
			exit;
		}
		
		// ** get STROAGE info **
		
		// Get the storage master data
		$conditions = 'StorageMaster.id = '.$storage_master_id;
		$storage_master_data =	$this->StorageMaster->find($conditions, null, null, 0);		
		
		if (empty($storage_master_data)) {
			$this->redirect('/pages/err_sto_no_stor_data'); 
			exit;
		} 
		
		// Get the storage controle
		$storage_control_id = $storage_master_data['StorageMaster']['storage_control_id'];
		$conditions = 'StorageControl.id = '.$storage_control_id;
		$storage_control_data = $this->StorageControl->find($conditions, null, null, 0);	
	
		if (empty($storage_control_data)) {
			$this->redirect('/pages/err_sto_no_stor_cont_data'); 
			exit;
		}
		
		if(!is_null($storage_control_data['StorageControl']['form_alias_for_children_pos'])){
			// A storage position into the storage
			// can be defined to store an entity
			return TRUE;
		}
		
		return FALSE;
	}
	
	/**
	 * Define if the coordinates set to define storage postion of an entity (children storage
	 * or aliquot) into a parent storage match the coordinate properties of the parent storage.
	 * 
	 * @param $storage_master_id Id of the parent storage.
	 * @param $coord_x Coordinate X define to store the entity into the parent storage.
	 * Note: The studied value should always be concatened to 'x_' ('x_'.studied_value)
	 * to manage empty studied_value.
	 * @param $coord_y Coordinate Y define to store the entity into the parent storage.
	 * Note: The studied value should always be concatened to 'y_' ('y_'.studied_value)
	 * to manage empty studied_value.
	 * @return Return an array that contains coordinates validation.
	 * 
	 * 	[storage code]
	 * 		[coord_x] 
	 * 			[validated] = Boolean	// Will be set to TRUE if the coordinate X is validated
	 * 			[to upercase] = Boolean	// Will be set to TRUE if the coordinate X must be changed to upercase
	 * 		[coord_y]
	 * 			[validated] = Boolean	// Will be set to TRUE if the coordinate Y is validated
	 * 			[to upercase] = Boolean	// Will be set to TRUE if the coordinate Y must be changed to upercase
	 * 
	 * @author N. Luc
	 * @since 2007-08-16
	 
	function validateStoragePosition($storage_master_id, $coord_x, $coord_y){

		// Check variable 'a_storage_coordinates' to see if function is supported
		// by the current object
		if((strcmp($this->a_storage_coordinates[0], 'x') != 0) 
		|| (strcmp($this->a_storage_coordinates[1], 'y') != 0)) {
			$this->redirect('/pages/err_sto_system_error'); 
			exit;
		}
		
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($storage_master_id) || empty($coord_x) || empty($coord_y)) {
			$this->redirect('/pages/err_sto_funct_param_missing'); 
			exit;
		}

		// Manage coordinates X: When we call function, add 'x_' or 'y_' before the
		// coordinate value to manage empty value.
		if((strcmp(substr($coord_x, 0, 2), 'x_') != 0) 
		|| (strcmp(substr($coord_y, 0, 2), 'y_') != 0)){
			$this->redirect('/pages/err_sto_system_error'); 
			exit;
		}
		
		$coord_x = substr($coord_x, 2);
		$coord_y = substr($coord_y, 2);

		// ** Get control type **

		// Get the storage master data
		$conditions = 'StorageMaster.id = '.$storage_master_id;
		$storage_data =	$this->StorageMaster->find($conditions, null, null, 0);		
		
		if (empty($storage_data)) {
			$this->redirect('/pages/err_sto_no_stor_data'); 
			exit;
		} 
		
		// Get the storage controle
		$storage_control_id = $storage_data['StorageMaster']['storage_control_id'];
		$conditions = 'StorageControl.id = '.$storage_control_id;
		$storage_control_data = $this->StorageControl->find($conditions, null, null, 0);	
		
		if (empty($storage_control_data)) {
			$this->redirect('/pages/err_sto_no_stor_cont_data'); 
			exit;
		} 
		
		// ** Validation **
		
		// Validate coordinate X
		$a_validation_array = array(
			'coord_x' => array('validated' => FALSE, 'to_uppercase' => FALSE), 
			'coord_y' => array('validated' => FALSE, 'to_uppercase' => FALSE));
				
		foreach($this->a_storage_coordinates as $value){
			// Realise validation for coordinate x and then coordinate y
			
			// Define studied coordinate
			$coord_to_test =  (strcmp($value, 'x') == 0)? $coord_x : $coord_y; 
			
			if((!is_null($coord_to_test))&&(strcmp($coord_to_test, '') != 0)){
				// A value has been recorded
	
				if((!empty($storage_control_data['StorageControl']['coord_'.$value.'_type']))
				&& (!empty($storage_control_data['StorageControl']['coord_'.$value.'_size']))) {
					// Size and type are defined for the coordinate
					// Type should be allowed alphabetical or integer values
					
					$size = $storage_control_data['StorageControl']['coord_'.$value.'_size'];
					if(!is_numeric($size)){
						$this->redirect('/pages/err_sto_system_error'); 
						exit;				
					}
					
					$is_alphanum = FALSE;
					
					// Define array of allowed values
					$a_allowed_values = array();
					
					if(strcmp($storage_control_data['StorageControl']['coord_'.$value.'_type'], 'alphabetical') == 0){
						// Alphabetical coordinate
						$a_alphab = array('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',
				            'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T',
				            'U', 'V', 'W', 'X', 'Y', 'Z');
						
						$a_allowed_values = array_slice ($a_alphab, 0, $size);
												
						$is_alphanum = TRUE;
						
					} else if(strcmp($storage_control_data['StorageControl']['coord_'.$value.'_type'], 'integer') == 0) {
						// Integer coordinate
						for($counter = 1; $counter <= $size; $counter++) {
							$a_allowed_values[$counter] = $counter;
						}
					} else {
						$this->redirect('/pages/err_sto_system_error'); 
						exit;				
					}
					
					if($is_alphanum) {
						// When the type is alphanumeric:
						// Change coordinate to uppercase and verify coordinate is validated this way.
						
						if(in_array(strtoupper($coord_to_test), $a_allowed_values)) {
							// The coordinate is validated but must be change to uppercase
							$a_validation_array['coord_'.$value]['validated'] = TRUE;	
							$a_validation_array['coord_'.$value]['to_uppercase'] = TRUE;
						}
					} else {
						// Should be Integer value
						if(isset($a_allowed_values[$coord_to_test])) {
							// Coordinate has been validated
							$a_validation_array['coord_'.$value.'']['validated'] = TRUE;
						}			
					}
					
				} else if((!empty($storage_control_data['StorageControl']['coord_'.$value.'_type']))
				&& (empty($storage_control_data['StorageControl']['coord_'.$value.'_size']))) {
					
					// Should be coordinate_x and a list of values defined by user
					if((strcmp($storage_control_data['StorageControl']['coord_'.$value.'_type'], 'list') == 0) 
					&& (strcmp($value, 'x') == 0)) {
						
						// Look for coordinate list defined by user
						$conditions = "StorageCoordinate.storage_master_id = '".$storage_master_id.
							"' AND StorageCoordinate.dimension = '".$value."'";
						$order = "StorageCoordinate.order ASC";				
						
						$tmp_coord_list 
							=$this->StorageCoordinate->generateList(
								$conditions, 
								$order, 
								null, 
								'{n}.StorageCoordinate.coordinate_value', 
								'{n}.StorageCoordinate.coordinate_value');
												
						if(empty($tmp_coord_list)){
							// No defined coordinate
							$a_validation_array['coord_'.$value]['validated'] = FALSE;	
						} else {
							if(isset($tmp_coord_list[$coord_to_test])) {
								// Coordinate has been validated
								$a_validation_array['coord_'.$value.'']['validated'] = TRUE;								
							}							
						}
						
					} else {
						$this->redirect('/pages/err_sto_system_error'); 
						exit;					
					}
					
				} else if(empty($storage_control_data['StorageControl']['coord_'.$value.'_type'])
				&& empty($storage_control_data['StorageControl']['coord_'.$value.'_size'])) {
					// No coordinate should be recorded
					$a_validation_array['coord_'.$value]['validated'] = FALSE;					
				} else {
					// The storage control defintion is not supported by the current system
					$this->redirect('/pages/err_sto_system_error'); 
					exit;			
				}
									
			} else {
				// Empty coordinate: Nothing to control
				$a_validation_array['coord_'.$value]['validated'] = TRUE;
			}
		}
				
		return $a_validation_array;
	}
	
	/**
	 * Return an array that contains all storage data matching a storage selection label 
	 * 
	 * @param $studied_selection_label Studied selection label.
	 * 
	 * @return Return an array that contains all storage data matching a storage selection label  
	 * 	[storage_master_id] = $storage_data (array())
	 * 
	 * @author N. Luc
	 * @since 2008-02-08
	 
	function getStorageMatchingSelectLabel($studied_selection_label = '') {

		$conditions = "StorageMaster.selection_label = '".$studied_selection_label."'";
		$order = "StorageMaster.selection_label ASC";

		$arr_storages_list_tmp = 
			$this->StorageMaster->findAll($conditions, NULL, $order);
			
		// Build work list
		$arr_storages_list = array();
		foreach($arr_storages_list_tmp as $id_tmp => $storage_data) {
			$id = $storage_data['StorageMaster']['id'];
			$arr_storages_list[$id] = $storage_data['StorageMaster'];		
		}
														
		return $arr_storages_list;
		
	}
	
	/**
	 * Return the storage code of a storage.
	 * 
	 * @param $storage_master_id ID of the studied storage.
	 * 
	 * @return Return the storage code
	 * 
	 * @author N. Luc
	 * @since 2008-02-08
	 
	function getStorageCode($storage_master_id) {
		
		// ** Verify parameters have been set **
		if(empty($storage_master_id)) {
			return '';
		}
		
		// ** get STROAGE info **
		
		// Get the storage master data
		$conditions = 'StorageMaster.id = '.$storage_master_id;
		$storage_master_data =	$this->StorageMaster->find($conditions, null, null, 0);		
		
		if (empty($storage_master_data)) {
			$this->redirect('/pages/err_sto_no_stor_data'); 
			exit;
		} 
		
		// ** return the code **
		
		return $storage_master_data['StorageMaster']['code'];
		
	}
	
	
	
	/**
	 * Return the data of a storage.
	 * 
	 * @param $storage_master_id ID of the studied storage.
	 * 
	 * @return Return the storage data
	 * 
	 * @author N. Luc
	 * @since 2008-02-08
	 
	function getStorageData($storage_master_id) {
		
		// ** Verify parameters have been set **
		if(empty($storage_master_id)) {
			return array();
		}
		
		// ** get STROAGE info **
		
		// Get the storage master data
		$conditions = 'StorageMaster.id = '.$storage_master_id;
		$storage_master_data =	$this->StorageMaster->find($conditions, null, null, 0);		
		
		if (empty($storage_master_data)) {
			$this->redirect('/pages/err_sto_no_stor_data'); 
			exit;
		} 
		
		// ** return the code **
		
		return $storage_master_data['StorageMaster'];
		
	}
	
	function getTmaSopsArray(){
		//TODO getTmaSopsArray()		
		return array('0' => 'n/a');
		
	}
*/
}
?>
