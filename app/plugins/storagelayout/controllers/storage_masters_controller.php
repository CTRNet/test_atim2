<?php

class StorageMastersController extends StoragelayoutAppController {

	var $components = array('Storages');
	
	var $uses = array(
		'Storagelayout.StorageMaster',
		'Storagelayout.StorageControl',
		'Inventorymanagement.AliquotMaster',
//		'Storagelayout.TmaSlides',
		'Storagelayout.StorageCoordinate'
	);
	var $paginate = array('StorageMaster'=>array('limit' => 10,'order' => 'StorageMaster.storage_type DESC, StorageMaster.short_label DESC'));

	/* --------------------------------------------------------------------------
	 * DISPLAY FUNCTIONS
	 * --------------------------------------------------------------------------
	 */
	 
	function index() {
		// clear SEARCH criteria
		$_SESSION['ctrapp_core']['search'] = NULL; 
		
		// set variables to display on view
		$this->set('storage_list', $this->Storages->getStorageList());	
		
		//find all storage control types to build add button
		$this->set('storage_controls_list', $this->StorageControl->find('all', array('conditions' => array('StorageControl.status' => 'active'))));
	}
		
	function search() {
		$this->set('atim_menu', $this->Menus->get('/storagelayout/storage_masters/index/'));
		
		if ($this->data) $_SESSION['ctrapp_core']['search']['criteria'] = $this->Structures->parse_search_conditions();
		
		$this->data = $this->paginate($this->StorageMaster, $_SESSION['ctrapp_core']['search']['criteria']);
		
		//find all storage control types to build add button
		$this->set('storage_controls_list', $this->StorageControl->find('all', array('conditions' => array('StorageControl.status' => 'active'))));
		
		// if SEARCH form data, save number of RESULTS and URL
		$_SESSION['ctrapp_core']['search']['results'] = $this->params['paging']['StorageMaster']['count'];
		$_SESSION['ctrapp_core']['search']['url'] = '/storagelayout/storage_masters/search';
	}
	
	function detail($storage_master_id) {
		if (!$storage_master_id) { $this->redirect('/pages/err_sto_no_stor_id', NULL, TRUE); }
		
		// MANAGE DATA
		
		// Get the storage data
		$storage_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $storage_master_id)));
		if(empty($storage_data)) { $this->redirect('/pages/err_sto_no_stor_data', NULL, TRUE); }
		$storage_control_data = array('StorageControl' => $storage_data['StorageControl']);	

		$this->data = $storage_data;
		$this->setStorageCoordinateValues($storage_control_data);

		// Get parent storage information
		$parent_storage_id = $storage_data['StorageMaster']['parent_id'];
		$parent_storage_data = $this->StorageMaster->find('first',array('conditions'=>array('StorageMaster.id'=>$parent_storage_id)));
		if(!empty($parent_storage_id) && empty($parent_storage_data)) { $this->redirect('/pages/err_sto_no_stor_data', NULL, TRUE); }
		$this->set('parent_storage_id', $parent_storage_id);		
		$this->set('parent_storage_data', $parent_storage_data);	

		$storage_path_data = $this->Storages->getStoragePathData($parent_storage_id);
		$this->set('storage_path_data', $storage_path_data);

		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Get the current menu object. Needed to disable menu options based on storage type
		$atim_menu = $this->Menus->get('/storagelayout/storage_masters/detail/%%StorageMaster.id%%');
		
		$this->set('atim_menu_variables', array('StorageMaster.id' => $storage_master_id));
		
		if(!$this->Storages->allowCustomCoordinates($storage_control_data['StorageControl']['id'], $storage_control_data)) {
			// Check storage supports custom coordinates and disable access to coordinates menu option if required
			$atim_menu = $this->Storages->inactivateStorageCoordinateMenu($atim_menu);
		}
					
		if(empty($storage_control_data['StorageControl']['coord_x_type'])) {
			// Check storage supports coordinates and disable access to storage layout menu option if required
			$atim_menu = $this->Storages->inactivateStorageLayoutMenu($atim_menu);
		}
			
/* 		TODO: Part of TMA implementation. Have Nicolas review this section. Not sure
  		which form/menu should be displayed for TMA storage types.
  		
 		// This code sets the menu to a link that is /underdev/ 
		if(strcmp($storage_control_data['StorageControl']['is_tma_block'], 'TRUE') == 0) {
			$atim_menu[] = $this->Menus->tabs( 'sto_CAN_02', 'sto_CAN_07', $storage_master_id );
		}
*/		

/* 		TODO: TMA related code		
		if(strcmp($storage_control_data['StorageControl']['is_tma_block'], 'TRUE') == 0) {	
			$this->set('arr_tma_sop_title_from_id', 
				$this->getTmaSopsArray());
		}
*/			
		
		// Check storage can be deleted
		$bool_allow_deletion = TRUE;
		if(!$this->allowStorageDeletion($storage_master_id)) { $bool_allow_deletion = FALSE; }
		$this->set('bool_allow_deletion', $bool_allow_deletion);		

		// Get all storage control types to build the add to selected button
		$this->set('storage_controls_list', $this->StorageControl->find('all', array('conditions' => array('StorageControl.status' => 'active'))));

		$this->set('atim_menu', $atim_menu );

		// set structure				
		$this->set('atim_structure', $this->Structures->get('form', $storage_control_data['StorageControl']['form_alias']));

		// DEFINITION OF STORAGE POSITION INTO PARENT (SECOND FORM)
		
		$bool_define_position = FALSE;
		if((!empty($parent_storage_id)) && (!is_null($parent_storage_data['StorageControl']['form_alias_for_children_pos']))) {
			// storage position can be set within the parent storage
			$bool_define_position = TRUE;

			// set structure				
			$this->set('atim_structure_for_position', $this->Structures->get('form', $parent_storage_data['StorageControl']['form_alias_for_children_pos']));
			
			// set data to display on view
			if(!empty($parent_storage_data['StorageControl']['coord_x_title'])) { $this->set('parent_coord_x_title', $parent_storage_data['StorageControl']['coord_x_title']); }
			if(!empty($parent_storage_data['StorageControl']['coord_y_title'])) { $this->set('parent_coord_y_title', $parent_storage_data['StorageControl']['coord_y_title']); }	
		}
			
		$this->set('bool_define_position', $bool_define_position);
	}	
	
	function add($storage_control_id = null, $predefined_parent_storage_id = null) {
		if(empty($storage_control_id)) { $this->redirect('/pages/err_sto_no_stor_cont_id', NULL, TRUE); }
		
		// MANAGE DATA
		
		$storage_control_data = $this->StorageControl->find('first', array('conditions' => array('StorageControl.id' => $storage_control_id)));
		if(empty($storage_control_data)) { $this->redirect('/pages/err_sto_no_stor_cont_data', NULL, TRUE); }	
		
		$this->set('storage_type', $storage_control_data['StorageControl']['storage_type']);		
		$this->setStorageCoordinateValues($storage_control_data);
		
		// Set parent storage list for selection
		$available_parent_storage_list = array(); 
		if(is_null($predefined_parent_storage_id)) { 
			$available_parent_storage_list = $this->Storages->getStorageList();
		} else {
			$predefined_parent_storage_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $predefined_parent_storage_id, 'StorageControl.is_tma_block' => 'FALSE')));
			if(empty($predefined_parent_storage_data)) { $this->redirect('/pages/err_sto_no_stor_data', NULL, TRUE); }		
			$available_parent_storage_list[] = $predefined_parent_storage_data;
		}
		$this->set('available_parent_storage_list', $available_parent_storage_list);	

/* 	TODO: TMA Related
		if(strcmp($storage_control_data['StorageControl']['is_tma_block'], 'TRUE') == 0) {	
			$this->set('arr_tma_sop_title_from_id', 
				$this->getTmaSopsArray());
		}*/

		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Set menu
		$atim_menu = $this->Menus->get('/storagelayout/storage_masters/index/');		
		$this->set('atim_menu', $atim_menu);
		$this->set('atim_menu_variables', array('StorageControl.id' => $storage_control_id));
		
		// set structure alias based on VALUE from CONTROL table
		$this->set('atim_structure', $this->Structures->get('form', $storage_control_data['StorageControl']['form_alias']));
	
		// MANAGE DATA RECORD
			
		if (!empty($this->data)) {	
			// Set control ID
			$this->data['StorageMaster']['storage_control_id'] = $storage_control_id;

			// Set storage temperature information
			$this->data['StorageMaster']['set_temperature'] = $storage_control_data['StorageControl']['set_temperature'];
				
			if((strcmp($storage_control_data['StorageControl']['set_temperature'], 'FALSE') == 0) && (!empty($this->data['StorageMaster']['parent_id']))) {
				// Define storage surrounding temperature based on selected parent temperature
				$parent_storage_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $this->data['StorageMaster']['parent_id'])));
				if(empty($parent_storage_data)) { $this->redirect('/pages/err_sto_no_stor_data', NULL, TRUE); }	
				$this->data['StorageMaster']['temperature'] = $parent_storage_data['StorageMaster']['temperature'];
				$this->data['StorageMaster']['temp_unit'] = $parent_storage_data['StorageMaster']['temp_unit'];
			}				
			
			// Set selection label
			$this->data['StorageMaster']['selection_label'] = $this->getSelectionLabel($this->data);	

			// Validates data
			$submitted_data_validates = TRUE;

			if($this->IsDuplicatedStorageBarCode($this->data)) { $submitted_data_validates = FALSE; }
			
			if ($submitted_data_validates) {
				$bool_save_done = TRUE;
		
				// save StorageMaster data
				$storage_master_id = NULL;
				if($this->StorageMaster->save($this->data)) {
					$storage_master_id = $this->StorageMaster->getLastInsertId();
				} else {
					$bool_save_done = FALSE;
				}
				
				// Update StorageMaster record with code from control record
				if($bool_save_done) {
					$this->data['StorageMaster']['id'] = $storage_master_id;					
					$this->data['StorageMaster']['code'] = 
						$this->createStorageCode($this->data['StorageMaster'], $storage_control_data['StorageControl']);
					
					if(!$this->StorageMaster->save($this->data)) {
						$bool_save_done = FALSE;
					}
				}	
				
			// The storage already exists: Search existing childrens to update their path code			
//			if(strcmp($arr_storage_master_data['selection_label'], $new_storage_selection_label) != 0) {
//				// Path code has been changed: Update children storages path code
//				$this->updateChildrenStoragePathcode($arr_storage_master_data['id'], $new_storage_selection_label);
				
				if(!$bool_save_done) {
//					$this->redirect('/pages/err_sto_record_err'); 
//					exit;
pr($this->StorageMaster->invalidFields());

				} else {
					// Data has been recorded
					$this->flash('Your data has been saved.',
						'/storagelayout/storage_masters/detail/'.$storage_master_id);				
				}						
			} // end action done after validation	
		} // end data save		
	} // function add		
	
	
	
	
	
	
	
			
	function edit ($storage_master_id) {

		if ( !$storage_master_id ) {
			$this->redirect( '/pages/err_sto_no_stor_id', NULL, TRUE );
		}

		$this->set( 'atim_menu_variables', array('StorageMaster.id'=>$storage_master_id));
		
		$storage_master_data = $this->StorageMaster->find('first',array('conditions'=>array('StorageMaster.id'=>$storage_master_id)));
		if(empty($storage_master_data)) {
			$this->redirect('/pages/err_sto_no_stor_data'); 
			exit;
		}
		
		$storage_control_id = $storage_master_data['StorageMaster']['storage_control_id'];
		$storage_control_data = $this->StorageControl->find('first', array('conditions'=>array('StorageControl.id'=>$storage_control_id)));
		if(empty($storage_control_data)) {
			$this->redirect('/pages/err_sto_no_stor_cont_data'); 
			exit;
		}

		// Get the current menu object. Needed to disable menu options based on storage type
		$atim_menu = $this->Menus->get('/storagelayout/storage_masters/detail/%%StorageMaster.id%%');
		
		// Check storage supports custom coordinates and disable access to coordinates menu option if required
		if(!$this->Storages->allowCustomCoordinates($storage_control_id, $storage_control_data)) {
			$atim_menu = $this->Storages->inactivateStorageCoordinateMenu($atim_menu);
		}
		
		// Check storage supports coordinates and disable access to storage layout menu option if required
		if(empty($storage_control_data['StorageControl']['coord_x_type'])) {
			$atim_menu = $this->Storages->inactivateStorageLayoutMenu($atim_menu);
		}
		
/* 		TODO: Part of TMA implementation. Have Nicolas review this section. Not sure
  		which form/menu should be displayed for TMA storage types.
  		
 		// This code sets the menu to a link that is /underdev/ 
		if(strcmp($storage_control_data['StorageControl']['is_tma_block'], 'TRUE') == 0) {
			$atim_menu[] = $this->Menus->tabs( 'sto_CAN_02', 'sto_CAN_07', $storage_master_id );
		}
*/		
		$this->setStorageCoordinateValues($storage_control_data=null);
		$this->set('available_parent_code_from_id', $this->Storages->getStorageList($storage_master_id));

/* 		TODO: TMA related code	
		if(strcmp($storage_control_data['StorageControl']['is_tma_block'], 'TRUE') == 0) {	
			$this->set('arr_tma_sop_title_from_id', 
				$this->getTmaSopsArray());
		}
*/
		$this->set( 'atim_menu', $atim_menu );
		$this->set( 'atim_structure', $this->Structures->get('form', $storage_master_data['StorageControl']['form_alias']) );
	
		if (empty($this->data)) {
				$this->data = $storage_master_data;	
		} else {
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
						$parent_storage_data = 
							$this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $this->data['StorageMaster']['parent_id'])));
						
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
			} // end manage temperature
			
			// Manage parent_storage_coord
			$new_parent_storages_id = $this->data['StorageMaster']['parent_id'];
			$last_parent_storages_id = $storage_master_data['StorageMaster']['parent_id'];
			// If parent storage has been changed, delete coordinate values
			if($new_parent_storages_id != $last_parent_storages_id){
				$this->data['StorageMaster']['parent_storage_coord_x'] = NULL;
				$this->data['StorageMaster']['parent_storage_coord_y'] = NULL;
			}

			// Set and save sample data
			$this->StorageMaster->id = $storage_master_id;			
			if($this->StorageMaster->save($this->data['StorageMaster'])) {
				$this->flash('Your data has been updated.',
					'/storagelayout/storage_masters/detail/'.$storage_master_id);	
			} else {
				$this->redirect('/pages/err_sto_record_err'); 
				exit;
			}					
		}
	}  // end Edit function
//TODO ici	
	function delete($storage_master_id=null) {
				
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
	
		$storage_control_data = $storage_master_data['StorageControl'];

		if(empty($storage_control_data)){
			$this->redirect('/pages/err_sto_no_stor_cont_data'); 
			exit;
		}	
		
		// Create has many relation to delete the storage coordinate
		$has_many_array 
			= array('hasMany' => 
				array(
					'StorageCoordinate' => array(
						'className' => 'StorageCoordinate',
						'foreignKey' => 'storage_master_id',
						'dependent' => true)));
		
		$this->StorageMaster->bindModel($has_many_array);	

		//Delete storage
		$bool_delete_storage = TRUE;		
		if(!$this->StorageMaster->del( $storage_master_id )) {
			$bool_delete_storage = FALSE;		
		}	
		
		if(!$bool_delete_storage){
			$this->redirect('/pages/err_sto_stor_del_err'); 
			exit;
		}
		
		$this->flash('Your data has been deleted.', '/storagelayout/storage_masters/index/');	
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
	 
	function allowStorageDeletion($storage_master_id) {	
		// verify storage contains no chlidren storage
		$nbr_children_storages = $this->StorageMaster->find('count', array('conditions'=>array('StorageMaster.parent_id'=>$storage_master_id)));
		if($nbr_children_storages > 0) { return FALSE; }
		
		// verify storage contains no aliquots
		$nbr_storage_aliquots = $this->AliquotMaster->find('count', array('conditions'=>array('AliquotMaster.storage_master_id'=>$storage_master_id)));
		if($nbr_storage_aliquots > 0) { return FALSE; }
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
	 * Get the selection label of a storage.
	 *
	 * @param $storage_data Storage data including storage master, storage control, etc.
	 * 
	 * @return The new storage selection label.
	 * 
	 * @author N. Luc
	 * @since 2009-09-13
	 */
	 
	function getSelectionLabel($storage_data) {
		if(empty($storage_data['StorageMaster']['parent_id'])) {
			// No parent exists: Selection Label equals short label
			return $storage_data['StorageMaster']['short_label'];
		
		}
		
		// Set selection label according to the parent selection label		
		$parent_storage_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $storage_data['StorageMaster']['parent_id'])));
		if(empty($parent_storage_data)) { $this->redirect('/pages/err_sto_no_stor_data', NULL, TRUE); }
		
		return ($parent_storage_data['StorageMaster']['selection_label'] . '-' . $storage_data['StorageMaster']['short_label']);
	}	
	
	/**
	 * Check the new storage barcode does not already exists and set error if not.
	 *
	 * @param $storage_data Storage data including storage master, storage control, etc.
	 *
	 * @return TRUE if the new barcode already exists.
	 * 
	 * @author N. Luc
	 * @since 2008-01-31
	 * @updated A. Suggitt
	 */
	 
	function IsDuplicatedStorageBarCode($storage_data) {
		if(empty($storage_data['StorageMaster']['barcode'])) {
			return FALSE;
		}
		
		// Build list of storage having the same barcode
		$duplicated_storage_barcodes = $this->StorageMaster->find('list', array('conditions' => array('StorageMaster.barcode' => $storage_data['StorageMaster']['barcode'])));

		if(empty($duplicated_storage_barcodes)) {
			// The new barcode does not exist into the db
			return FALSE;
		} else if(isset($storage_data['StorageMaster']['id']) && isset($duplicated_storage_barcodes[$storage_data['StorageMaster']['id']]) && (size_of($duplicated_storage_barcodes) == 1)) {
			// Storage has been created therefore and the recorded barcode is the barcode of the studied storage
			return FALSE;			
		}
		
		// The same barcode exists for at least one storage different than the studied one
		$this->StorageMaster->validationErrors['barcode']	= 'storage barcode should be unique';
		
		return TRUE;			
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
	 * @updated A. Suggitt
	 */
	 
	function createStorageCode($storage_master_data, $storage_control_data) {
		
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
	 * Update the surrounding temperature and unit of children storages of a parent storage.
	 * Recursive function.
	 * 
	 * @param $parent_storage_master_id Id of the parent storage master. 
	 * @param $new_temperature New parent storage temperature.
	 * @param $new_temp_unit New parent storage temperature unit.
	 *
	 * @author N. Luc
	 * @since 2007-05-22
	 * @updated A. Suggitt
	 */
	 
	function updateChildrenSurroundingTemperature($parent_storage_master_id, $new_temperature, $new_temp_unit) {
	
	 // Look for children of the storage
		$children_aliquot_list = 
			$this->StorageMaster->find('all', array('conditions'=>array('StorageMaster.parent_id'=>$parent_storage_master_id), 'fields'=>array('StorageMaster.id', 'StorageMaster.set_temperature')));
		
		foreach($children_aliquot_list as $id => $storage_master_data) {
			if(strcmp($storage_master_data['StorageMaster']['set_temperature'], 'FALSE') == 0) {

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
	 * Manage the path code of the children storages of a parent storage.
	 *
	 * @param $parent_storage_id ID of the parent storage that should be studied
	 * to update the path codes of their children storages.
	 * @param $new_storage_selection_label New path code of the storage path code.
	 * 
	 * @author N. Luc
	 * @since 2008-01-31
	 * @updated A. Suggitt
	 */
	 
	function updateChildrenStoragePathcode($parent_storage_id, $parent_storage_selection_label){
		
		// Look for childrens of the storage
		$children_storage_list =
			$this->StorageMaster->find('all', array('conditions' => array('StorageMaster.parent_id' => $parent_storage_id)));
		
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
		if(!$this->Storages->allowCustomCoordinates($storage_control_id)) {
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
		
 		// Build predefined list of positions
		$a_coord_x_list = $this->buildAllowedStoragePosition($parent_storage_id, $parent_storage_control_data, 'x');
		$a_coord_y_list = $this->buildAllowedStoragePosition($parent_storage_id, $parent_storage_control_data, 'y');
		if(!empty($a_coord_x_list)){
			$this->set('a_coord_x_list', $a_coord_x_list);
		}
		if(!empty($a_coord_y_list)){
			$this->set('a_coord_y_list', $a_coord_y_list);
		}	

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
	 
	function buildAllowedStoragePosition($storage_master_id, $storage_control_data, $coord) {
		
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
	
}

?>