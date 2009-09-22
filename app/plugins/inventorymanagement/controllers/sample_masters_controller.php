<?php

class SampleMastersController extends InventorymanagementAppController {

	var $uses = array(
		'Inventorymanagement.Collection',
		
		'Inventorymanagement.SampleMaster',
		'Inventorymanagement.SampleControl',
	 	'Inventorymanagement.SpecimenDetail',		
		'Inventorymanagement.DerivativeDetail',		
		
		'Inventorymanagement.ParentToDerivativeSampleControl',
		
		'Inventorymanagement.AliquotControl', 
		'Inventorymanagement.AliquotMaster');
	
	var $paginate = array('SampleMaster' => array('limit' => 10, 'order' => 'SampleMaster.sample_code DESC'));

	/* --------------------------------------------------------------------------
	 * DISPLAY FUNCTIONS
	 * -------------------------------------------------------------------------- */
	
	function index() {
		// MANAGE (FIRST) FORM TO DEFINE SEARCH TYPE 

		// Set structure 				
		$this->set('atim_structure_for_search_type', $this->Structures->get('form', 'collection_search_type'));
		
		// MANAGE INDEX FORM

		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/collections/index'));
						
		$_SESSION['ctrapp_core']['search'] = NULL; // clear SEARCH criteria
		
		// Set list of banks
		$this->set('banks', $this->getBankList());	
	}
	
	function search() {
		// MANAGE (FIRST) FORM TO DEFINE SEARCH TYPE 

		// Set structure 				
		$this->set('atim_structure_for_search_type', $this->Structures->get('form', 'collection_search_type'));
		
		// MANAGE INDEX FORM
		
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/collections/index'));
		
		if ($this->data) $_SESSION['ctrapp_core']['search']['criteria'] = $this->Structures->parse_search_conditions();
		
		$this->data = $this->paginate($this->SampleMaster, $_SESSION['ctrapp_core']['search']['criteria']);
				
		// if SEARCH form data, save number of RESULTS and URL
		$_SESSION['ctrapp_core']['search']['results'] = $this->params['paging']['SampleMaster']['count'];
		$_SESSION['ctrapp_core']['search']['url'] = '/inventorymanagement/sample_masters/search';
		
		// Set list of banks
		$this->set('banks', $this->getBankList());
	}

	function contentTreeView($collection_id, $studied_specimen_sample_control_id = null) {
		if(!$collection_id) { $this->redirect('/pages/err_inv_coll_no_id', NULL, TRUE); }

		// MANAGE DATA

		// set FILTER
		if(!$studied_specimen_sample_control_id) {
			if(isset($_SESSION['InventoryManagement']['Filter'])) {
				$studied_specimen_sample_control_id = $_SESSION['InventoryManagement']['Filter'];
			}
		} else {
			if($studied_specimen_sample_control_id == '-1') {
				// User unactived filter
				$studied_specimen_sample_control_id = null;
				unset($_SESSION['InventoryManagement']['Filter']);
			} else {
				$_SESSION['InventoryManagement']['Filter'] = $studied_specimen_sample_control_id;
			}
		}
		
		// Search data to display		
		$criteria = array();
		if($studied_specimen_sample_control_id) { 
			// Limit display to specific specimen type plus derivative
			$specimen_criteria['SampleMaster.sample_control_id'] = $studied_specimen_sample_control_id; 
			$specimen_criteria['SampleMaster.collection_id'] = $collection_id;
			$studied_collection_specimens = $this->SampleMaster->atim_list(array('conditions' => $specimen_criteria, 'recursive' => '-1'));
			$criteria['SampleMaster.initial_specimen_sample_id'] = array_keys($studied_collection_specimens);	
		}
		$criteria['SampleMaster.collection_id'] = $collection_id;
		$collection_content = $this->SampleMaster->find('threaded', array('conditions' => $criteria, 'order' => 'SampleMaster.sample_type DESC, SampleMaster.sample_code DESC', 'recursive' => '-1'));
	 	$collection_content = $this->completeCollectionContent($collection_content);
	 	$this->data = $this->completeCollectionContent($collection_content);
				
		// MANAGE FORM, MENU AND ACTION BUTTONS	
			 	
		$atim_structure = array();
		$atim_structure['SampleMaster']	= $this->Structures->get('form','sample_masters_for_tree_view');
		$atim_structure['AliquotMaster']	= $this->Structures->get('form','aliquot_masters_for_tree_view');
		$this->set('atim_structure', $atim_structure);

		// Get all sample control types to build the add to selected button
		$specimen_sample_controls_list = $this->SampleControl->atim_list(array('conditions' => array('SampleControl.status' => 'active', 'SampleControl.sample_category' => 'specimen'), 'order' => 'SampleControl.sample_type ASC'));
		$this->set('specimen_sample_controls_list', $specimen_sample_controls_list);

		// Get all collection specimen type list to build the filter button
		$specimen_type_list = array();
		$collection_specimen_list = $this->SampleMaster->find('all', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.sample_category' => 'specimen'), 'order' => 'SampleMaster.sample_type ASC', 'recursive' => '-1'));
		foreach($collection_specimen_list as $new_specimen) {
			$sample_control_id = $new_specimen['SampleMaster']['sample_control_id'];
			$sample_type = $new_specimen['SampleMaster']['sample_type'];
			$specimen_type_list[$sample_type] = $sample_control_id;
		}
		$this->set('specimen_type_list', $specimen_type_list);

		// Set filter value
		$filter_value = null;
		if($studied_specimen_sample_control_id) {
			if(!isset($specimen_sample_controls_list[$studied_specimen_sample_control_id])) { 
				unset($_SESSION['InventoryManagement']['Filter']);
				$this->redirect('/pages/err_inv_system_error', NULL, TRUE); 
			}
			$filter_value = $specimen_sample_controls_list[$studied_specimen_sample_control_id]['SampleControl']['sample_type'];
		}
		
		// Get the current menu object. Needed to disable menu options based on storage type
		$atim_menu = $this->Menus->get('/inventorymanagement/sample_masters/contentTreeView/%%Collection.id%%');
		$this->set('atim_menu', $atim_menu);
				
		// Set menu variables
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id, 'filter_value' => $filter_value));		
	}
	
	/**
	 * Parsing a nested array gathering collection samples, the funtion will add
	 * aliquots data to each sample.
	 * 
	 * @param $collection_content Nested array gathering collection samples.
	 * 
	 * @return The completed nested array
	 * 
	 * @author N. Luc
	 * @since 2009-09-13
	 */
	
	function completeCollectionContent($collection_content) {
		foreach ($collection_content as $key => $new_sample) {
			// recursive first on existing MODEL CHILDREN
			if (isset($new_sample['children']) && count($new_sample['children'])) {
				$new_sample['children'] = $this->completeCollectionContent($new_sample['children']);
			}
			
			// get OUTSIDE MODEL data and append as CHILDREN: Add sample aliquots
			$sample_aliquots = $this->AliquotMaster->find('all', array('conditions' => array('AliquotMaster.sample_master_id' => $new_sample['SampleMaster']['id']), 'order' => 'AliquotMaster.storage_coord_x ASC, AliquotMaster.storage_coord_y ASC', 'recursive' => '-1'));
			foreach ($sample_aliquots as $aliquot) { $new_sample['children'][] = $aliquot; }
						
			$collection_content[$key] = $new_sample;
		}
		
		return $collection_content;
	}
	
	function detail($collection_id, $sample_master_id, $is_tree_view_detail_form = 0) {
		if((!$collection_id) || (!$sample_master_id)) { $this->redirect('/pages/err_inv_funct_param_missing', NULL, TRUE); }		
		
		// MANAGE DATA

		// Get the storage data
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id)));
		if(empty($sample_data)) { $this->redirect('/pages/err_inv_samp_no_data', NULL, TRUE); }		

		switch($sample_data['SampleControl']['sample_category']) {
			case 'specimen':
				// Displayed sample is a specimen
				unset($sample_data['DerivativeDetail']);
				break;
				
			case 'derivative':
				// Displayed sample is a derivative
				unset($sample_data['SpecimenDetail']);
				break;
				
			default:
				$this->redirect('/pages/err_inv_system_error', NULL, TRUE);
		}

		$this->data = $sample_data;

		// Get parent sample information
		$parent_sample_master_id = $sample_data['SampleMaster']['parent_id'];
		$parent_sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $parent_sample_master_id), 'recursive' => '-1'));
		if(!empty($parent_sample_master_id) && empty($parent_sample_data)) { $this->redirect('/pages/err_inv_samp_no_data', NULL, TRUE); }	
		$this->set('parent_sample_data', $parent_sample_data);	

		// Set list of available SOPs to create sample
		$this->set('arr_sample_sops', $this->getSampleSopList($sample_data['SampleMaster']['sample_type']));	
		
		// Calulate spent time between specimen collection and derivative creation
		$arr_spent_time = null;
		if(isset($sample_data['DerivativeDetail'])) {
			$arr_spent_time = $this->getSpentTime($sample_data['Collection']['collection_datetime'], $sample_data['DerivativeDetail']['creation_datetime']);
		}
		$this->set('col_to_creation_spent_time', $arr_spent_time);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS

		// Get the current menu object. Needed to disable menu options based on sample category
		$atim_menu = $this->Menus->get('/inventorymanagement/sample_masters/detail/%%Collection.id%%/%%SampleMaster.id%%');
		
		$this->set('atim_menu', $atim_menu);
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id, 'SampleMaster.id' => $sample_master_id, 'SampleMaster.initial_specimen_sample_id' => $sample_data['SampleMaster']['initial_specimen_sample_id']));
		
		// Set structure	
		$this->set('atim_structure', $this->Structures->get('form', $sample_data['SampleControl']['form_alias']));

		// Define if this detail form is displayed into the collection content tree view
		$this->set('is_tree_view_detail_form', $is_tree_view_detail_form);

		// Get all sample control types to build the add to selected button
		$criteria = array(
			'ParentSampleControl.id' => $sample_data['SampleControl']['id'],
			'ParentToDerivativeSampleControl.status' => 'active',
			'DerivativeControl.status' => 'active');
		$allowed_derivative_type_temp = $this->ParentToDerivativeSampleControl->find('all', array('conditions' => $criteria, 'order' => 'DerivativeControl.sample_type ASC'));

		$allowed_derivative_type = array();
		foreach($allowed_derivative_type_temp as $new_link) {
			$allowed_derivative_type[$new_link['DerivativeControl']['id']]['SampleControl'] = $new_link['DerivativeControl'];
		}
		
		$this->set('allowed_derivative_type', $allowed_derivative_type);
	}

	function add($collection_id, $sample_control_id, $parent_sample_master_id = null) {
		if((!$collection_id) || (!$sample_control_id)) { $this->redirect('/pages/err_inv_funct_param_missing', NULL, TRUE); }		
		
		// MANAGE DATA
		
		$sample_control_data = $this->SampleControl->find('first', array('conditions' => array('SampleControl.id' => $sample_control_id)));
		if(empty($sample_control_data)) { $this->redirect('/pages/err_inv_no_samp_cont_data', NULL, TRUE); }	
	
		$this->set('sample_type', $sample_control_data['SampleControl']['sample_type']);		
	
		switch($sample_control_data['SampleControl']['sample_category']) {
			case 'specimen':
				// Created sample is a specimen
				if(!empty($parent_sample_master_id)) { $this->redirect('/pages/err_inv_system_error', NULL, TRUE); }
				
				// Check collection
				$collection_data = $this->Collection->find('first', array('conditions' => array('Collection.id' => $collection_id)));
				if(empty($collection_data)) { $this->redirect('/pages/err_inv_coll_no_data', NULL, TRUE); }					
				break;
				
			case 'derivative':
				// Created sample is a derivative: Get parent sample information
				$parent_sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $parent_sample_master_id), 'recursive' => '-1'));
				if(empty($parent_sample_data)) { $this->redirect('/pages/err_inv_samp_no_data', NULL, TRUE); }	
				$this->set('parent_sample_data', $parent_sample_data);
				break;
				
			default:
				$this->redirect('/pages/err_inv_system_error', NULL, TRUE);
		}

		// Set list of available SOPs to create sample
		$this->set('arr_sample_sops', $this->getSampleSopList($sample_control_data['SampleControl']['sample_type']));

		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Set menu
		$atim_menu = $this->Menus->get('/inventorymanagement/sample_masters/listAll/...');		
		$this->set('atim_menu', $atim_menu);
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id));
		
		// set structure alias based on VALUE from CONTROL table
		$this->set('atim_structure', $this->Structures->get('form', $sample_control_data['SampleControl']['form_alias']));
	
		// MANAGE DATA RECORD
			
		if(!empty($this->data)) {	
			
			//Get Parent Data
			$parent_storage_data = null;
			if(!empty($this->data['StorageMaster']['parent_id'])) {
				$parent_storage_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $this->data['StorageMaster']['parent_id'])));
				if(empty($parent_storage_data)) { $this->redirect('/pages/err_sto_no_stor_data', NULL, TRUE); }	
			}
			
			// Set control ID en type
			$this->data['StorageMaster']['storage_control_id'] = $storage_control_id;
			// TODO Confirm why we should do that
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
			$submitted_data_validates = TRUE;

			if($this->IsDuplicatedStorageBarCode($this->data)) { $submitted_data_validates = FALSE; }
			
			if($submitted_data_validates) {
				// Save storage data
				$bool_save_done = TRUE;
				
				$storage_master_id = NULL;
				if($this->StorageMaster->save($this->data)) {
					$storage_master_id = $this->StorageMaster->getLastInsertId();
				} else {
					$bool_save_done = FALSE;
				}
				
				// Create storage code
				if($bool_save_done) {
					$storage_data_to_update = array();
					$storage_data_to_update['StorageMaster']['code'] = $this->createStorageCode($storage_master_id, $this->data, $storage_control_data);

					$this->StorageMaster->id = $storage_master_id;					
					if(!$this->StorageMaster->save($storage_data_to_update)) {
						$bool_save_done = FALSE;
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
					$this->flash('Your data has been saved.', $link);				
				}						
			}
		}		
	}




	function addObsolete($specimen_group_menu_id=NULL, $group_specimen_type=NULL,
	$collection_id=null, $specimen_sample_master_id = null) {


		
		// Verify collection data exists
		$criteria = 'Collection.id = "'.$collection_id.'" ';		
		$collection_data = $this->Collection->find($criteria);
		
		if(empty($collection_data)) {
			$this->redirect('/pages/err_inv_coll_no_data'); 
			exit;
		}
		
		// ** Get the sample control id **
		// This id corresponds to the type of the new sample to create.
		$sample_control_id = null;
		$sample_control_data = null;
		$specific_parent_sample_id = null;
		
		if(isset($this->params['form']['sample_control_id'])){
			// User clicked on the Add button of the 'listall' derivative screen
			// or 'sample detail' screen to create a derivative
			$sample_control_id = $this->params['form']['sample_control_id'];
			
			$_SESSION['ctrapp_core']['inventory_management']['specific_parent_sample_id'] = NULL; 
			
			if(isset($this->params['form']['specific_parent_sample_id'])) {
				// User clicked on the Add button of the 'sample detail' screen 
				// to create a new sample type: the parent sample is known			
				$specific_parent_sample_id = $this->params['form']['specific_parent_sample_id'];
				$_SESSION['ctrapp_core']['inventory_management']['specific_parent_sample_id'] = $specific_parent_sample_id;
			}
						
		} else if(isset($this->data['SampleMaster']['sample_control_id'])) {
			//User clicked on the Submit button to create the new sample
			$sample_control_id = $this->data['SampleMaster']['sample_control_id'];	
			
			if(isset($_SESSION['ctrapp_core']['inventory_management']['specific_parent_sample_id'])
			&& (!empty($_SESSION['ctrapp_core']['inventory_management']['specific_parent_sample_id']))){
				$specific_parent_sample_id = $_SESSION['ctrapp_core']['inventory_management']['specific_parent_sample_id'];
			}
		
		} else {
			// User clicked on the add button of the specimen list form
			$criteria = array();
			$criteria['SampleControl']['sample_type'] = $group_specimen_type;
			$criteria['SampleControl']['sample_category'] = 'specimen';
			$sample_control_data = $this->SampleControl->find($criteria);
			if(empty($sample_control_data)){
				$this->redirect('/pages/err_inv_no_samp_cont_data'); 
				exit;
			}
			
			$sample_control_id = $sample_control_data['SampleControl']['id'];
			$_SESSION['ctrapp_core']['inventory_management']['specific_parent_sample_id'] = NULL; 
						
		}
		
		if(empty($sample_control_id)){
			$this->redirect('/pages/err_inv_no_samp_cont_id'); 
			exit;
		}
		
		// ** Load the sample type data from SAMPLE CONTROLS table **
		if(is_null($sample_control_data)) {
			$this->SampleControl->id = $sample_control_id;
			$sample_control_data = $this->SampleControl->read();
			if(empty($sample_control_data)){
				$this->redirect('/pages/err_inv_no_samp_cont_data'); 
				exit;
			}
		}
		$sample_category = $sample_control_data['SampleControl']['sample_category'];
		
		// ** set MENU variable for echo on VIEW ** 
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_00', 'inv_CAN_10', $collection_id);
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_10', $specimen_group_menu_id, $collection_id);
		
		switch($sample_category) {
			case "specimen":
				// Manage specimen detail menu
				break;

			case "derivative":				
				// Manage derivative detail menu			
				if(is_null($specimen_sample_master_id)) {
					$this->redirect('/pages/err_inv_funct_param_missing'); 
					exit;
				}
				
				$sample_menu_id = $specimen_group_menu_id.'-sa_der';
				$specimen_grp_menu_lists = $this->getSpecimenGroupMenu($specimen_group_menu_id);
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $sample_menu_id, $specimen_group_menu_id);
				
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $sample_menu_id, $collection_id.'/'.$specimen_sample_master_id.'/');
				break;
				
			default:
				$this->redirect('/pages/err_inv_menu_definition'); 
				exit;				
		}		
		
		$this->set('ctrapp_menu', $ctrapp_menu );

		// ** set FORM variable, for HELPER call on VIEW  **
		$this->set('ctrapp_form', $this->Forms->getFormArray($sample_control_data['SampleControl']['form_alias']));
		

		
		$this->set('arr_sop_title_from_id', 
			$this->getInventoryProductSopsArray($sample_control_data['SampleControl']['sample_type']));

		// ** set SUMMARY variable from plugin's COMPONENTS **
		$this->set('ctrapp_summary', $this->Summaries->build($collection_id));

		// ** set SIDEBAR variable **
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray( 
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action']));

		// ** Define collection group samples that could be used as parent of the created derivative **
		// Plus set boolean to define if it's a specimen
		$bool_is_specimen = TRUE;
		
		if(strcmp($sample_category, 'derivative') == 0) {
			// User is trying to create a derivative
			$bool_is_specimen = FALSE;
					
			// Look for sample_control_ids matching types of samples that could be used as parent.
			$criteria = array();
			$criteria['derived_sample_control_id'] = $sample_control_id;
			$criteria['status'] = 'active';
			$criteria = array_filter($criteria);

			$allowed_source_sample_ctrl_id
				= $this->DerivedSampleLink->generateList(
					$criteria, 
					null, 
					null, 
					'{n}.DerivedSampleLink.source_sample_control_id', 
					'{n}.DerivedSampleLink.source_sample_control_id');	
											
			if(!empty($allowed_source_sample_ctrl_id)){
				// Look for all samples of the collection group having 
				//   - Types that could be used as parent.
				$criteria = array();
				$criteria['collection_id'] = $collection_id;
				$criteria['sample_control_id'] = array_values ($allowed_source_sample_ctrl_id);
				$criteria['initial_specimen_sample_type'] = $group_specimen_type;
				$criteria['initial_specimen_sample_id'] = $specimen_sample_master_id;
				$criteria = array_filter($criteria);
				$order = 'SampleMaster.sample_code ASC';
				 
				$available_parent_to_create_derivative 
					= $this->SampleMaster->generateList(
						$criteria, 
						$order, 
						null, 
						'{n}.SampleMaster.id', 
						'{n}.SampleMaster');
														
				$temp_available_parent_to_create_derivative = array();
				foreach($available_parent_to_create_derivative as $sample_master_id => $samp_data){
					$temp_available_parent_to_create_derivative[$sample_master_id] = $samp_data['sample_code'];
				}										
				$available_parent_to_create_derivative	= $temp_available_parent_to_create_derivative;							
				
				if(empty($available_parent_to_create_derivative)){		
					$this->redirect('/pages/err_inv_pb_in_src_sple_list_def'); 
					exit;	
				}
				
				if(!is_null($specific_parent_sample_id)) {
					// The parent sample is known: just display this one in the list
					if(!isset($available_parent_to_create_derivative[$specific_parent_sample_id])){
						$this->redirect('/pages/err_inv_pb_in_src_sple_list_def'); 
						exit;							
					}
					$data_to_display_in_drop_down_list = $available_parent_to_create_derivative[$specific_parent_sample_id];
					$available_parent_to_create_derivative 
						= array($specific_parent_sample_id => $data_to_display_in_drop_down_list);
				}
													
				$this->set('available_parent_to_create_derivative', $available_parent_to_create_derivative);

			} else {
				$this->redirect('/pages/err_inv_pb_in_src_sple_list_def'); 
				exit;	
			}								
			
		}
		
		// ** Initialize SampleDetail **
		// Plus set boolean to define if details must be recorded in database
		$bool_needs_details_table = FALSE;
		
		if(!is_null($sample_control_data['SampleControl']['detail_tablename'])){
			// This sample type has a specific details table
			$bool_needs_details_table = TRUE;
			
			// Create new instance of SampleDetail model 
			$this->SampleDetail = 
				new SampleDetail(false, $sample_control_data['SampleControl']['detail_tablename']);
		} else {
			// This sample type doesn't need a specific details table
			$this->SampleDetail = NULL;
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
			
			// Set initial specimen data for your specimen or your derivative
			if($bool_is_specimen){
				// The created sample is a specimen
				
				if(isset($this->data['SampleMaster']['parent_id'])
				&& (!empty($this->data['SampleMaster']['parent_id']))){
					// Form fields defintion error: a specimen should not have parent
					$this->redirect('/pages/err_inv_no_parent_allow_for_spec'); 
					exit;					
				}				
				
				// Create initial specimen data copying sample (specimen) data
				$this->data['SampleMaster']['initial_specimen_sample_type']
					= $this->data['SampleMaster']['sample_type'];
				$this->data['SampleMaster']['initial_specimen_sample_id']
					= NULL; // ID will be known after sample creation
			
			} else {
				// The created sample is a derivative
				
				if(!isset($this->data['SampleMaster']['parent_id'])
				|| (empty($this->data['SampleMaster']['parent_id']))){
					// Form fields defintion error or code error: a derivative should have parent
					$this->redirect('/pages/err_inv_parent_required_for_deriv'); 
					exit;
				}
				
				// Look for parent sample data
				$criteria = 'SampleMaster.id ="'.$this->data['SampleMaster']['parent_id'].'"';
				$parent_sample_master = $this->SampleMaster->find($criteria, null, null, 0);
		
				if(empty($parent_sample_master)){
					$this->redirect('/pages/err_inv_no_parent_data'); 
					exit;
				}				
				
				// Create initial specimen data copying intial specimen data of the parent
				$this->data['SampleMaster']['initial_specimen_sample_type']
					= $parent_sample_master['SampleMaster']['initial_specimen_sample_type'];
				$this->data['SampleMaster']['initial_specimen_sample_id']
					= $parent_sample_master['SampleMaster']['initial_specimen_sample_id'];
			}
		
			// ** Execute Validation **
						
			// setup MODEL(s) validation array(s) for displayed FORM 
			foreach ( $this->Forms->getValidateArray( $sample_control_data['SampleControl']['form_alias'] ) as $validate_model=>$validate_rules ) {
				$this->{ $validate_model }->validate = $validate_rules;
			}
			
			$submitted_data_validates = TRUE;
			
			// Validates Fields of Master Table
			if(!$this->SampleMaster->validates($this->data['SampleMaster'])){
				$submitted_data_validates = FALSE;
			}
			
			// Validates Fields of Specimen or Derivative Details Table
			if($bool_is_specimen && isset($this->data['SpecimenDetail'])){
				$this->cleanUpFields('SpecimenDetail');
			
				// Validates Fields of Specimen Details Table
				if(!$this->SpecimenDetail->validates($this->data['SpecimenDetail'])){
					$submitted_data_validates = FALSE;
				}		
			} else if((!$bool_is_specimen) && isset($this->data['DerivativeDetail'])){
				$this->cleanUpFields('DerivativeDetail');
			
				// Validates Fields of Specimen Details Table
				if(!$this->DerivativeDetail->validates($this->data['DerivativeDetail'])){
					$submitted_data_validates = FALSE;
				}		
			}
		
			// Validates Fields of Details Table
			if($bool_needs_details_table && isset($this->data['SampleDetail'])){
				$this->cleanUpFields('SampleDetail');
				
				// Validates Fields of Details Table
				if(!$this->SampleDetail->validates($this->data['SampleDetail'])){
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
		
				// Save SAMPLEMASTER data
				$sample_master_id = NULL;
				
				if($this->SampleMaster->save($this->data['SampleMaster'])){
					$sample_master_id = $this->SampleMaster->getLastInsertId();
				} else {
					$bool_save_done = FALSE;
				}
				
				if($bool_save_done){
					// Update SAMPLEMASTER data that did not be known before sample creation

					$this->data['SampleMaster']['id'] = $sample_master_id;					
					
					$this->data['SampleMaster']['sample_code'] = 
						$this->createSampleCode($this->data['SampleMaster'], $sample_control_data['SampleControl']);
					
					if($bool_is_specimen) {
						// System is right now able to record initial_specimen_sample_id for the specimen
						$this->data['SampleMaster']['initial_specimen_sample_id'] = $sample_master_id;					
					}
					
					if(!$this->SampleMaster->save($this->data['SampleMaster'])) {
						$bool_save_done = FALSE;
					}
					
				}	
				
				//Save Specimen or Derivative Data
				if($bool_save_done) {
					if($bool_is_specimen){
						// Sample Specimen Data should be recorded
								
						// set ID fields based on SAMPLEMASTER
						$this->data['SpecimenDetail']['id'] = $sample_master_id;
						$this->data['SpecimenDetail']['sample_master_id'] = $sample_master_id;
					
						// save SPECIMENDETAIL data 
						if(!$this->SpecimenDetail->save($this->data['SpecimenDetail'])){
							$bool_save_done = FALSE;
						}
						
					} else {
						// Sample Derivative Data should be recorded
								
						// set ID fields based on SAMPLEMASTER
						$this->data['DerivativeDetail']['id'] = $sample_master_id;
						$this->data['DerivativeDetail']['sample_master_id'] = $sample_master_id;
					
						// save DerivativeDetail data 
						if(!$this->DerivativeDetail->save($this->data['DerivativeDetail'])){
							$bool_save_done = FALSE;
						}
						
					}
				}
				
				if($bool_save_done && $bool_needs_details_table){
					// Sample Detail should be recorded
					
					// Set ID fields based on SAMPLEMASTER
					$this->data['SampleDetail']['id'] = $sample_master_id;
					$this->data['SampleDetail']['sample_master_id'] = $sample_master_id;
					
					// Save SAMPLEDETAIL data 
					if(!$this->SampleDetail->save($this->data['SampleDetail'])){
						$bool_save_done = FALSE;
					}
				}
				
				if(!$bool_save_done){
					$this->redirect('/pages/err_inv_sample_record_err'); 
					exit;
				} else {
					// Data has been recorded
					$this->flash('Your data has been saved.', 
						"/sample_masters/detail/$specimen_group_menu_id/" .
						"$group_specimen_type/$sample_category/$collection_id/$sample_master_id/");				
				}
											
			} // end action done after validation	
		} // end data save	 		
	
	} // function add
	
	
	
	/* --------------------------------------------------------------------------
	 * ADDITIONAL FUNCTIONS
	 * -------------------------------------------------------------------------- */
	
	/**
	 * Get list of SOPs existing to build sample.
	 * 
	 * Note: Function to allow bank to customize this function when they don't use 
	 * SOP module.
	 *
	 *	@param $sample_type Sample Type
	 *
	 * @author N. Luc
	 * @since 2009-09-11
	 * @updated N. Luc
	 */
	 
	function getSampleSopList($sample_type) {
		return $this->getSopList('sample');
	}






// --------------------------------------------------------------------------------------------------------
// --------------------------------------------------------------------------------------------------------




	
	function edit($collection_id=null, $sample_master_id=null) {
		$this->set( 'atim_menu_variables', array('Collection.id'=>$collection_id, 'SampleMaster.id'=>$sample_master_id) );
		
		$this_data = $this->SampleMaster->find('first',array('conditions'=>array('SampleMaster.id'=>$sample_master_id)));
		
		// set FORM ALIAS based off VALUE from MASTER table
		$this->set( 'atim_structure', $this->Structures->get('form',$this_data['SampleControl']['form_alias']) );
		
		if ( !empty($this->data) ) {
			$this->SampleMaster->id = $sample_master_id;
			if ( $this->SampleMaster->save($this->data) ) $this->flash( 'Your data has been updated.','/inventorymanagement/sample_masters/detail/'.$collection_id.'/'.$sample_master_id);
		} else {
			$this->data = $this_data;
		}
	
	}
	
/*
	var $uses = array(
		'Inventorymanagement.AliquotMaster', 
		'Inventorymanagement.AliquotUse',
		'Inventorymanagement.Collection',
		'Inventorymanagement.DerivativeDetail',
		'Inventorymanagement.DerivedSampleLink',
		'Inventorymanagement.Menu',
		'Inventorymanagement.PathCollectionReview', 
		'Inventorymanagement.QualityControl',
		'Inventorymanagement.ReviewMaster', 
		'Inventorymanagement.SampleControl', 
		'Inventorymanagement.SampleDetail', 
		'Inventorymanagement.SampleMaster',
		'Inventorymanagement.SopMaster', 
		'Inventorymanagement.SourceAliquot', 
		'Inventorymanagement.SpecimenDetail'
	);
	var $paginate = array('SampleMaster'=>array('limit'=>10,'order'=>'SampleMaster.sample_category ASC')); 
	
	/* --------------------------------------------------------------------------
	 * DISPLAY FUNCTIONS
	 * -------------------------------------------------------------------------- 
		
	function index() {
		// nothing...
	}
	
	/**
	 * Allow to display the results list of a sample research based on sample code. 
	 * 
	 * @author N. Luc
	 * @date 2007-08-22
	 
	function search() {
/*		
		// set MENU varible for echo on VIEW 
		$this->set('ctrapp_menu', array());
		
		// set FORM variable, for HELPER call on VIEW 
		$ctrapp_form = $this->Forms->getFormArray('sample_masters_for_search_result');
		$this->set('ctrapp_form', $ctrapp_form);
			
		// set SUMMARY variable from plugin's COMPONENTS 
		$this->set('ctrapp_summary', $this->Summaries->build());
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray( 
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action']));
		
		// if SEARCH form data, parse and create conditions 
		if ($this->data) {
			$criteria = $this->Forms->getSearchConditions($this->data, $ctrapp_form);
			// save CRITERIA to session for pagination 			
			$_SESSION['ctrapp_core']['inventory_management']['sample_search_criteria'] = $criteria; 
		} else {
			// if no form data, use SESSION critera for PAGINATION bug 
			$criteria = $_SESSION['ctrapp_core']['inventory_management']['sample_search_criteria']; 
		}
			
		// look for sample data
		
		$belongs_array 
			= array('belongsTo' => 
				array(
					'Collection' => array(
					'className' => 'Collection',
					'conditions' => '',
					'order'      => '',
					'foreignKey' => 'collection_id')));
		
		$this->SampleMaster->bindModel($belongs_array);	
			
		$no_pagination_order = NULL;
					
		list($order, $limit, $page) = $this->Pagination->init($criteria);
		
		$this->SampleMaster->bindModel($belongs_array);
		
		$sample_data = $this->SampleMaster->findAll($criteria, NULL, $no_pagination_order, $limit, $page, 0);
			
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
		$this->set('samples', $sample_data);
	
	}
	
	function tree($collection_id=null) {
/*		
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($collection_id)) {
			$this->redirect('/pages/err_inv_funct_param_missing'); 
			exit;
		}
		
		// Verify collection data exists
		$criteria = 'Collection.id = "'.$collection_id.'" ';		
		$collection_data = $this->Collection->find($criteria);
		
		if(empty($collection_data)) {
			$this->redirect('/pages/err_inv_coll_no_data'); 
			exit;
		}
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_00', 'inv_CAN_10', $collection_id);
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_10', 'inv_CAN_21', $collection_id);
		$this->set('ctrapp_menu', $ctrapp_menu);	
		
		// set FORM variable, for HELPER call on VIEW 
		$ctrapp_form = $this->Forms->getFormArray('sample_masters_for_tree_view');
		$this->set('ctrapp_form', $ctrapp_form);
		
		// Set SUMMARY variable from plugin's COMPONENTS
		$this->set('ctrapp_summary', $this->Summaries->build($collection_id));
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray( 
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action']));
		
		//TODO: add filter to display samples tree view of a specific product type (ex: only urine and derivatives)
		$criteria = array();
		$criteria['SampleMaster.collection_id'] = $collection_id;
		$criteria = array_filter($criteria);
		
		// list( $order, $limit, $page ) = $this->Pagination->init( $criteria ); <-- no need for this, as Tree Views do not use Pagination
		
		$fields = null;
		$sort = 'sample_category ASC, sample_code ASC';
		$root = 0; // this is the parent_id you want to START to get all the children of...
		
		$sample_data = $this->SampleMaster->findAllThreaded($criteria, $fields, $sort, $root);
		
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
		$this->set('data', $sample_data);
		
	}
	
	/**
	 * Will change the format of the sample list displayed by the listall()
	 * function plus launch the listall() function.
	 * 
	 * @param $specimen_group_menu_id Menu id that corresponds to the tab clicked to 
	 * display the samples of the collection group (Ascite, Blood, Tissue, etc).
	 * @param $group_specimen_type Type of the source specimens of the group.
	 * @param $sample_category Sample Category
	 * @param $collcetion_id Id of the studied collection.
	 * @param $sample_list_type Define if the list should contains aliquots or
	 * just samples. Allowed values are ('sample only', 'include aliquot').
	 * @param $specimen_sample_master_id Sample master id of the specimen 
	 * when we display derivatives of a specimen.
	 * 
	 * @author N. Luc
	 * @date 2007-06-20
	 
	function changeSampleListFormat($specimen_group_menu_id=NULL, $group_specimen_type=NULL, $sample_category = null, 
	$collection_id=null, $sample_list_type = NULL, $specimen_sample_master_id = null){
/*		
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($specimen_group_menu_id) || empty($group_specimen_type) || empty($sample_category)  
		|| empty($collection_id) || empty($sample_list_type)) {
			$this->redirect('/pages/err_inv_funct_param_missing'); 
			exit;
		}
			
		// ** Type of list definition **
		// Define which type of list should be displayed when user clicks on a collection group tab:
		//    - only sample list
		//    - list including sample and aliquot data
		if(strcmp($sample_list_type, 'sample only') == 0){
			$_SESSION['ctrapp_core']['inventory_management']['sample_list_type'] = 'sample only';
			$bool_include_aliquot = FALSE;
		} else if(strcmp($sample_list_type, 'include aliquot') == 0){
			$_SESSION['ctrapp_core']['inventory_management']['sample_list_type'] = 'include aliquot';
			$bool_include_aliquot = TRUE;
		} else {
			$this->redirect('/pages/err_inv_unknown_sample_list_type'); 
			exit;
		}
		
		$this->redirect('/inventorymanagement/sample_masters/listall/'.
			$specimen_group_menu_id.'/'.$group_specimen_type.'/'.$sample_category.
			'/'.$collection_id.'/'.$specimen_sample_master_id.'/');
		
		exit;
		
	}
	
	/**
	 * List all specimens having the same type and attached to the same collection,
	 * plus all derivatives created from one of these specimens or one derivative
	 * of this group. All this samples (specimens plus derivatives) will be attached 
	 * to the same 'Collection Group' labelled by the type of the source specimens. 
	 * 
	 * According to session data, the list 
	 * will display also sample aliquot data.
	 * 
	 * @param $specimen_group_menu_id Menu id that corresponds to the tab clicked to 
	 * display the samples of the collection group (Ascite, Blood, Tissue, etc).
	 * @param $group_specimen_type Type of the source specimens of the group.
	 * @param $sample_category Sample Category
	 * @param $collcetion_id Id of the studied collection.
	 * @param $specimen_sample_master_id Sample master id of the specimen 
	 * when we display derivatives.
	 * 
	 * @author N. Luc
	 * @date 2007-06-20
	 
	function listall($specimen_group_menu_id=NULL, $group_specimen_type=NULL, $sample_category = null, 
	$collection_id=null, $specimen_sample_master_id=null) {
			
		switch($sample_category) {
			case "specimen":
				break;
				
			case "derivative":
				$derivative_menu_id = $specimen_group_menu_id.'-sa_der';
				$specimen_grp_menu_lists = $this->getSpecimenGroupMenu($specimen_group_menu_id);
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $derivative_menu_id, $specimen_group_menu_id);
							
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $derivative_menu_id, $collection_id.'/'.$specimen_sample_master_id);	
				break;
			
			default:
				$this->redirect('/pages/err_inv_menu_definition'); 
				exit;
		}
		
		// ** Build array that allows to know sample code from the sample id **
		// Use for parent sample code display.

		$arr_sample_code_from_id =
			$this->SampleMaster->find('list', array('conditions'=>array('SampleMaster.id'=>$consent_id), 'fields'=>array(SampleMaster.sample_code)));
		$this->set('arr_sample_code_from_id', $arr_sample_code_from_id);		
	
		// ** set DATA for echo on VIEW or for link build **
		$this->set( 'atim_menu_variables',
				    array(
						'specimen_group_menu_id'=>$specimen_group_menu_id,
				    	'group_specimen_type'=>$group_specimen_type,
				    	'sample_category'=>$sample_category,
				    	'Collection.id'=>$collection_id
				     ));

		$this->set('specimen_sample_master_id', $specimen_sample_master_id );
		
		// Display only sample data
/*				
		// ** Search samples (specimens + derivatives) to display in the list **
		$criteria = array();
		$criteria['SampleMaster.collection_id'] = $collection_id;
		$criteria['SampleMaster.initial_specimen_sample_type'] = $group_specimen_type;
		$criteria['SampleMaster.sample_category'] = $sample_category;
		if((!is_null($specimen_sample_master_id)) && (strcmp("derivative", $sample_category) == 0)) {
			$criteria['SampleMaster.initial_specimen_sample_id'] = $specimen_sample_master_id;
		}
		$criteria = array_filter($criteria);				
				
		list($order, $limit, $page) = $this->Pagination->init($criteria);
		$sample_masters = $this->SampleMaster->findAll($criteria, null, $order, $limit, $page, 1);
			
		// Calculate the number of available aliquots
		foreach($sample_masters as $id => $new_sample_master){
			$aliquot_nbr = sizeof($new_sample_master['AliquotMaster']);
			if($aliquot_nbr == 0){
				$sample_masters[$id]['Generated']['generated_field_aliquot_number'] = '0 / 0';
			} else {
				$available_aliquot_nbr = 0;
				foreach($new_sample_master['AliquotMaster'] as $id_cont => $new_aliquot){
					if(strcmp($new_aliquot['status'], 'available') == 0){
						$available_aliquot_nbr++;
					}
				}
				$sample_masters[$id]['Generated']['generated_field_aliquot_number']  
					= $available_aliquot_nbr.' / '.$aliquot_nbr;
			}
		}
		$this->set('sample_masters', $sample_masters);
*/
		// ** Build list of derivative sample types that could be built from existing collection group samples **
		
		// Search all distinct sample_control_ids (defining sample type) attached 
		// to at least one sample of the group.
/*		
		if(strcmp("derivative", $sample_category) == 0) {
			
			$allowed_derived_types = array();
			
			$criteria = array();
			$criteria['collection_id'] = $collection_id;
			$criteria['initial_specimen_sample_type'] = $group_specimen_type;
			$criteria['initial_specimen_sample_id'] = $specimen_sample_master_id;
			$criteria = array_filter($criteria);
			 
			$arr_group_control_ids =  
				$this->SampleMaster->generateList(
					$criteria, 
					null, 
					null, 
					'{n}.SampleMaster.sample_control_id', 
					'{n}.SampleMaster.sample_control_id');					
			
			if(!empty($arr_group_control_ids)){
				// At least one derivative type can be created
				
				// Look for sample_control_ids matching types of samples 
				// that could be created from one sample of the group.
				$criteria = array();
				$criteria['source_sample_control_id'] = array_values ($arr_group_control_ids);
				$criteria['status'] = 'active';
				$criteria = array_filter($criteria);
	
				$allowed_derived_sample_ctrl_id
					= $this->DerivedSampleLink->generateList(
						$criteria, 
						null, 
						null, 
						'{n}.DerivedSampleLink.derived_sample_control_id', 
						'{n}.DerivedSampleLink.derived_sample_control_id');	
				
				$final_criteria = array();
				$final_criteria['id'] = array_values($allowed_derived_sample_ctrl_id);	
				
				$final_criteria['status'] = 'active';
				$final_criteria = array_filter($final_criteria);
			
				$allowed_derived_types
					= $this->SampleControl->generateList(
						$final_criteria, 
						'SampleControl.sample_category DESC, SampleControl.sample_type ASC', 
						null, 
						'{n}.SampleControl.id', 
						'{n}.SampleControl.sample_type');
						
				if(empty($allowed_derived_types)) {
					$allowed_derived_types = array();
				}
													
			}
			
			$this->set('allowed_derived_types', $allowed_derived_types);

		} */
		
	} // End ListAll()
	



	/**
	 * Allow to display the sample details form when we just have the 
	 * sample_master_id.
	 * 
	 * This function will look for the different menu items to display.
	 * 
	 * Note: This function is a temporary function and should be replaced by a 
	 * core function.
	 * 
	 * @param $aliquot_master_id Master Id of the aliquot. 
	 * 
	 * @author N. Luc
	 * @date 2007-08-15
	 
	function detailSampleFromId($sample_master_id=null){
		
		//** Verify sample_master_id has been defined. **
		if (empty($sample_master_id)) {
			$this->redirect('/pages/err_inv_samp_no_id'); 
			exit;
		} 
		
		// Get sample data
		$this->SampleMaster->id = $sample_master_id;
		$sample_master_data = $this->SampleMaster->read();
		
		if(empty($sample_master_data)){
			$this->redirect('/pages/err_inv_samp_no_data'); 
			exit;
		}
		
		//** Set URL parameters ** 
		$specimen_group_menu_id=NULL;
		$group_specimen_type=$sample_master_data['SampleMaster']['initial_specimen_sample_type'];
		$sample_category=$sample_master_data['SampleMaster']['sample_category'];
		$collection_id=$sample_master_data['SampleMaster']['collection_id'];
		
		// Set $specimen_group_menu_id
		$a_fields = array('id');
		$conditions = ' Menu.parent_id = \'inv_CAN_10\'' .
				' AND Menu.use_link LIKE \'%/sample_masters/listall/%/'.$group_specimen_type.'/specimen/\'';
		$a_menus = $this->Menu->find($conditions, $a_fields);
				
		if(empty($a_menus)){
			$this->redirect('/pages/err_inv_menu_definition'); 
			exit;
		}
		
		$specimen_group_menu_id = $a_menus['Menu']['id'];
		
		//** Redirect to **
		$this->redirect('/inventorymanagement/sample_masters/detail/'.
			$specimen_group_menu_id.'/'.$group_specimen_type.'/'.$sample_category.
			'/'.$collection_id.'/'.$sample_master_id.'/');				

	}
		
	/**
	 * Allow to display data of a specimen or a derivative of a collection group. 
	 * 
	 * @param $specimen_group_menu_id Menu id that corresponds to the tab clicked to 
	 * display the samples of the collection group (Ascite, Blood, Tissue, etc).
	 * @param $group_specimen_type Type of the source specimens of the group.
	 * @param $sample_category Sample category.
	 * @param $collcetion_id Id of the studied collection.
	 * @param $sample_master_id Id of the sample to display. 
	 * 
	 * @author N. Luc
	 * @date 2007-06-20
	 
	function detail($specimen_group_menu_id=NULL, $group_specimen_type=NULL, $sample_category=null, 
	$collection_id=null, $sample_master_id=null ) {
		
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($specimen_group_menu_id) || empty($group_specimen_type) || empty($sample_category) || 
		empty($collection_id) || empty($sample_master_id)) {
			$this->redirect('/pages/err_inv_funct_param_missing'); 
			exit;
		}
		
		// ** set SUMMARY variable from plugin's COMPONENTS **
		$this->set('ctrapp_summary', $this->Summaries->build($collection_id, $sample_master_id));
		
		// ** set SIDEBAR variable **
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray( 
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action']));
		
		// ** set DATA for echo on view ** 
		
		$sample_master_data = array();
		$sample_detail_data = array();
		$specimen_or_derivative_data = array();
		
		// read SAMPLE MASTER info 
		$this->SampleMaster->id = $sample_master_id;
		$sample_master_data = $this->SampleMaster->read();
		
		if(empty($sample_master_data)){
			$this->redirect('/pages/err_inv_samp_no_data'); 
			exit;			
		}
		
		if(strcmp($sample_master_data['SampleMaster']['collection_id'], $collection_id) != 0) {
			$this->redirect('/pages/err_inv_no_coll_id_map'); 
			exit;			
		}
		
		$sample_type = $sample_master_data['SampleMaster']['sample_type'];
		
		// get the sample control data of the sample
		$sample_control_id = $sample_master_data['SampleMaster']['sample_control_id'];
		$this->SampleControl->id = $sample_control_id;
		$sample_control_data = $this->SampleControl->read();	
		
		if(empty($sample_control_data)){
			$this->redirect('/pages/err_inv_no_samp_cont_data'); 
			exit;
		}
		
		// get FORM alias, from SAMPLE CONTROL 
		$this->set('ctrapp_form', 
			$this->Forms->getFormArray($sample_control_data['SampleControl']['form_alias']));
		
		// Set gerenated data or manage displayed value for either specimen data or derivative data
		$sample_parent_id = NULL;
		$sample_parent_category = NULL;
		
		if(strcmp($sample_control_data['SampleControl']['sample_category'], 'specimen') == 0) {
			// Displayed sample is a specimen: Get Specimen Details
			$this->SpecimenDetail->id = $sample_master_id;
			$specimen_or_derivative_data = $this->SpecimenDetail->read(); 
			
			if(empty($specimen_or_derivative_data)){
				$this->redirect('/pages/err_inv_missing_samp_data'); 
				exit;
			}
		
		} else if(strcmp($sample_control_data['SampleControl']['sample_category'], 'derivative') == 0){
			// Displayed sample is a derivative: Get Derivative Details
			$this->DerivativeDetail->id = $sample_master_id;
			$specimen_or_derivative_data = $this->DerivativeDetail->read(); 
			
			if(empty($specimen_or_derivative_data)){
				$this->redirect('/pages/err_inv_missing_samp_data'); 
				exit;
			}
			
			// Set 'parent' sample
			$sample_parent_id = $sample_master_data['SampleMaster']['parent_id'];
			
			// Create array to display parent code instead of id
			$criteria = array();
			$criteria['SampleMaster.id'] = array($sample_parent_id);
			$criteria = array_filter($criteria);
			
			$sample_parent_data_from_id = 
				$this->SampleMaster->generateList(
					$criteria, 
					null, 
					null, 
					'{n}.SampleMaster.id', 
					'{n}.SampleMaster');		
			
			$sample_parent_code = $sample_parent_data_from_id[$sample_parent_id]['sample_code'];
			$sample_parent_category = $sample_parent_data_from_id[$sample_parent_id]['sample_category'];	
			
			$this->set('sample_parent_code_from_id', array($sample_parent_id => $sample_parent_code));	
					
		} else {
			$this->redirect('/pages/err_inv_system_error'); 
			exit;			
		}
		
		// Read SAMPLE DETAILS info
		if(!is_null($sample_control_data['SampleControl']['detail_tablename'])){
			// Details are required for this sample
			
			// start new instance of SAMPLE DETAIL model, using TABLENAME from SAMPLE CONTROL 
			$this->SampleDetail = 
				new SampleDetail(false, $sample_control_data['SampleControl']['detail_tablename']);
			
			// read related SAMPLE DETAIL row, whose ID should be same as SAMPLE MASTER ID 
			$this->SampleDetail->id = $sample_master_id;
			$sample_detail_data = $this->SampleDetail->read();
			
			if(empty($sample_detail_data)){
				$this->redirect('/pages/err_inv_missing_samp_data'); 
				exit;
			}
				
		}
							
		// Set additional fields for blood derivatives
		$type_requiring_time_since_collection = array ('blood cell', 'pbmc', 'plasma', 'serum');
			
		if (in_array($sample_type, $type_requiring_time_since_collection)) {
			
			$criteria = array();
			$criteria['Collection.id'] = $sample_master_data['SampleMaster']['collection_id'];
			$criteria = array_filter($criteria);
				
			$collection_data = $this->Collection->find($criteria, null, null, 1);
			
			if(empty($collection_data)) {
				$this->redirect('/pages/err_inv_coll_no_data'); 
				exit;
			}
			
			// Calulate the spent time since intial specimen collection and derivative creation
			$creation_date = NULL;
			if(isset($specimen_or_derivative_data['DerivativeDetail']['creation_datetime'])){
				$creation_date = $specimen_or_derivative_data['DerivativeDetail']['creation_datetime'];
			}
			
			$arr_spent_time = 
				$this->getSpentTime($collection_data['Collection']['collection_datetime'], $creation_date);
									
			$this->set('time_spent_since_collection_msg', $arr_spent_time['message']); // To be translate in .thtml
			$sample_detail_data['Generated']['time_spent_since_collection_days'] = $arr_spent_time['days'];
			$sample_detail_data['Generated']['time_spent_since_collection_hours'] = $arr_spent_time['hours'];
			$sample_detail_data['Generated']['time_spent_since_collection_minutes'] = $arr_spent_time['minutes'];
							
		}
		
		// merge all sample data (the types of all variables should be an array at this level)
		if(!(is_array($sample_master_data) && is_array($sample_detail_data) && is_array($specimen_or_derivative_data))) {
			$this->redirect('/pages/err_inv_system_error'); 
			exit;
		}
		$this->set('data', array_merge(
			array_merge($sample_master_data, $sample_detail_data), 
			$specimen_or_derivative_data)); 

		$this->set('specimen_group_menu_id', $specimen_group_menu_id);
		$this->set('group_specimen_type', $group_specimen_type);
		$this->set('sample_category', $sample_category);
		$this->set('collection_id', $collection_id);
		
		$this->set('sample_master_id', $sample_master_id);
		$this->set('sample_parent_id', $sample_parent_id);
		$this->set('sample_parent_category', $sample_parent_category);
		
		$initial_specimen_sample_id = NULL;
		switch($sample_category) {
			case "specimen":
				$initial_specimen_sample_id = $sample_master_id;		
				break;
				
			case "derivative":	
				$initial_specimen_sample_id = $sample_master_data['SampleMaster']['initial_specimen_sample_id'];		
				break;	
					
			default:
				$this->redirect('/pages/err_inv_menu_definition'); 
				exit;
		}					
		$this->set('initial_specimen_sample_id', $initial_specimen_sample_id);
		
		$this->set('arr_sop_title_from_id', 
			$this->getInventoryProductSopsArray($sample_control_data['SampleControl']['sample_type']));

		// ** set MENU varible for echo on VIEW **
		
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_00', 'inv_CAN_10', $collection_id);
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_10', $specimen_group_menu_id, $collection_id);
		
		switch($sample_category) {
			case "specimen":
				// Manage specimen detail menu
				$sample_menu_id = $specimen_group_menu_id.'-sa_de';
				$specimen_grp_menu_lists = $this->getSpecimenGroupMenu($specimen_group_menu_id);
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $sample_menu_id, $specimen_group_menu_id);
	
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $sample_menu_id, $collection_id.'/'.$sample_master_id);
				break;
				
			case "derivative":
				// Manage derivative detail menu
				$sample_menu_id = $specimen_group_menu_id.'-sa_der';
				$derivative_menu_id = $specimen_group_menu_id.'-der_de';
				$specimen_grp_menu_lists = $this->getSpecimenGroupMenu($specimen_group_menu_id);
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $sample_menu_id, $specimen_group_menu_id);
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $derivative_menu_id, $sample_menu_id);
				
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $sample_menu_id, $collection_id.'/'.$initial_specimen_sample_id);
				$ctrapp_menu[] = $this->Menus->tabs($sample_menu_id, $derivative_menu_id, $collection_id.'/'.$sample_master_id);
				break;
			
		}
		
		$this->set('ctrapp_menu', $ctrapp_menu);
					
		// ** Manage button display ** 
		
		// -> Delete button
		$allow_sample_deletion = FALSE;
		if($this->allowSampleDeletion($sample_master_id)){
			$allow_sample_deletion = TRUE;
		}
		$this->set('allow_sample_deletion', $allow_sample_deletion);
		
		// -> Parent Sample Button
		$allow_parent_display = FALSE;
		if(!empty($sample_parent_id)){
			$allow_parent_display = TRUE;
		}
		$this->set('allow_parent_display', $allow_parent_display);
		
		// -> Create derivative button
		
		$allowed_derived_types = array();
			
		// Look for sample_control_ids matching types of samples 
		// that could be created from one sample of the group.
		$criteria = array();
		$criteria['source_sample_control_id'] = $sample_control_id;
		$criteria['status'] = 'active';
		$criteria = array_filter($criteria);

		$allowed_derived_sample_ctrl_id
			= $this->DerivedSampleLink->generateList(
				$criteria, 
				null, 
				null, 
				'{n}.DerivedSampleLink.derived_sample_control_id', 
				'{n}.DerivedSampleLink.derived_sample_control_id');	
		
		if(!empty($allowed_derived_sample_ctrl_id)){
			$final_criteria['id'] = array_values($allowed_derived_sample_ctrl_id);	
										
			// Look for types matching the allowed sample_control_id
			$final_criteria['status'] = 'active';
			$final_criteria = array_filter($final_criteria);
		
			$allowed_derived_types
				= $this->SampleControl->generateList(
					$final_criteria, 
					'SampleControl.sample_category DESC, SampleControl.sample_type ASC', 
					null, 
					'{n}.SampleControl.id', 
					'{n}.SampleControl.sample_type');
		}
	
		$this->set('allowed_derived_types', $allowed_derived_types);
		
		// ** look for CUSTOM HOOKS, "format" **
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}	
		
	} // function detail

	/**
	 * Allow to edit a specimen or a derivative of a collection group. 
	 * 
	 * @param $specimen_group_menu_id Menu id that corresponds to the tab clicked to 
	 * display the samples of the collection group (Ascite, Blood, Tissue, etc).
	* @param $group_specimen_type Type of the source specimens of the group.
	 * @param $collcetion_id Id of the studied collection.
	 * @param $sample_master_id Id of the sample to edit. 
	 * 
	 * @author N. Luc
	 * @date 2007-06-20
	 
	function edit($specimen_group_menu_id=NULL,  $group_specimen_type=NULL, $sample_category=null, 
	$collection_id=null, $sample_master_id=null) {

		// ** Get the sample master id **
		if(isset($this->data['SampleMaster']['id'])) {
			//User clicked on the Submit button to modify the edited collection
			$sample_master_id = $this->data['SampleMaster']['id'];
		}
		
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($specimen_group_menu_id) || empty($group_specimen_type) || empty($sample_category) 
		|| empty($collection_id) || empty($sample_master_id)) {
			$this->redirect('/pages/err_inv_funct_param_missing'); 
			exit;
		}

		// ** set SUMMARY varible from plugin's COMPONENTS **
		$this->set('ctrapp_summary', $this->Summaries->build($collection_id, $sample_master_id));

		// ** set SIDEBAR variable **
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray( 
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action']));
												
		// ** set DATA for echo on view ** 
				
		// Initialize Sample Data Array
		$sample_master_data = array();
		$sample_detail_data = array();
		$specimen_or_derivative_data = array();

		// Load  SAMPLE MASTER info
		$this->SampleMaster->id = $sample_master_id;
		$sample_master_data = $this->SampleMaster->read();
				
		if(empty($sample_master_data)){
			$this->redirect('/pages/err_inv_samp_no_data'); 
			exit;			
		}		
		
		if(strcmp($sample_master_data['SampleMaster']['collection_id'], $collection_id) != 0) {
			$this->redirect('/pages/err_inv_no_coll_id_map'); 
			exit;			
		}
		
		// Load the sample type data from SAMPLE CONTROLS table
		$this->SampleControl->id = $sample_master_data['SampleMaster']['sample_control_id'];
		$sample_control_data = $this->SampleControl->read();
		if(empty($sample_control_data)){
			$this->redirect('/pages/err_inv_no_samp_cont_data'); 
			exit;
		}	
			
		// set FORM variable
		$this->set('ctrapp_form', $this->Forms->getFormArray($sample_control_data['SampleControl']['form_alias']));

		// set other data
		$this->set('specimen_group_menu_id', $specimen_group_menu_id);
		$this->set('group_specimen_type', $group_specimen_type);
		$this->set('sample_category', $sample_category);
		$this->set('collection_id', $collection_id);
		
		$this->set('arr_sop_title_from_id', 
			$this->getInventoryProductSopsArray($sample_control_data['SampleControl']['sample_type']));
				
		// Set Derivative or Specimen data
		// plus Parent code for derivative
		// plus set boolean to define if it's a specimen
		$bool_is_specimen = TRUE;
		
		if(strcmp($sample_control_data['SampleControl']['sample_category'], 'derivative') == 0) {
			// User is trying to edit a derivative
			$bool_is_specimen = FALSE;
			
			// Get Derivative Details
			$this->DerivativeDetail->id = $sample_master_id;
			$specimen_or_derivative_data = $this->DerivativeDetail->read(); 

			if(empty($specimen_or_derivative_data)){
				$this->redirect('/pages/err_inv_missing_samp_data'); 
				exit;
			}
						
			// Create array to display parent code instead of id
			$criteria = array();
			$criteria['SampleMaster.id'] = $sample_master_data['SampleMaster']['parent_id'];
			$criteria = array_filter($criteria);
			
			$sample_parent_code_from_id = 
				$this->SampleMaster->generateList(
					$criteria, 
					null, 
					null, 
					'{n}.SampleMaster.id', 
					'{n}.SampleMaster.sample_code');		

			$this->set('sample_parent_code_from_id', $sample_parent_code_from_id);	

		} else {
			// Get Specimen Details
			$this->SpecimenDetail->id = $sample_master_id;
			$specimen_or_derivative_data = $this->SpecimenDetail->read(); 
			
			if(empty($specimen_or_derivative_data)){
				$this->redirect('/pages/err_inv_missing_samp_data'); 
				exit;
			}
			
		}		
		
		// ** Initialize SampleDetail **
		// Plus set boolean to define if details must be recorded in database
		$bool_needs_details_table = FALSE;
		
		if(!is_null($sample_control_data['SampleControl']['detail_tablename'])){
			// This sample type has a specific details table
			$bool_needs_details_table = TRUE;
			
			// Create new instance of SampleDetail model 
			$this->SampleDetail = 
				new SampleDetail(false, $sample_control_data['SampleControl']['detail_tablename']);

			// Load related SAMPLE DETAIL row, whose ID should be the same as SAMPLE MASTER ID
			$this->SampleDetail->id = $sample_master_id;
			$sample_detail_data = $this->SampleDetail->read();
			
			if(empty($sample_detail_data)){
				$this->redirect('/pages/err_inv_missing_samp_data'); 
				exit;
			}			 			

		} else {
			// This sample type doesn't need a specific details table
			$this->SampleDetail = NULL;
		}
		
		// ** set MENU variable for echo on VIEW **
		
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_00', 'inv_CAN_10', $collection_id);
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_10', $specimen_group_menu_id, $collection_id);
		
		switch($sample_category) {
			case "specimen":
				// Manage specimen detail menu
				$sample_menu_id = $specimen_group_menu_id.'-sa_de';
				$specimen_grp_menu_lists = $this->getSpecimenGroupMenu($specimen_group_menu_id);
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $sample_menu_id, $specimen_group_menu_id);
				
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $sample_menu_id, $collection_id.'/'.$sample_master_id);
				break;
				
			case "derivative":
				// Manage derivative detail menu
				$initial_specimen_sample_id = $sample_master_data['SampleMaster']['initial_specimen_sample_id'];
				
				$sample_menu_id = $specimen_group_menu_id.'-sa_der';
				$derivative_menu_id = $specimen_group_menu_id.'-der_de';
				$specimen_grp_menu_lists = $this->getSpecimenGroupMenu($specimen_group_menu_id);
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $sample_menu_id, $specimen_group_menu_id);
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $derivative_menu_id, $sample_menu_id);
				
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $sample_menu_id, $collection_id.'/'.$initial_specimen_sample_id);
				$ctrapp_menu[] = $this->Menus->tabs($sample_menu_id, $derivative_menu_id, $collection_id.'/'.$sample_master_id);
				break;
				
			default:
				$this->redirect('/pages/err_inv_menu_definition'); 
				exit;							

		}
		
		$this->set('ctrapp_menu', $ctrapp_menu);
		
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
			
			// merge all sample data (the types of all variables should be an array at this level)
			if(!(is_array($sample_master_data) && is_array($sample_detail_data) && is_array($specimen_or_derivative_data))) {
				$this->redirect('/pages/err_inv_system_error'); 
				exit;
			}
			
			$this->data = array_merge(array_merge($sample_master_data, $sample_detail_data), $specimen_or_derivative_data); 
			$this->set('data', $this->data);
			 
		} else {
			// ** SAVE DATA **
			
			// ** Execute Validation **
						
			// setup MODEL(s) validation array(s) for displayed FORM 
			foreach ($this->Forms->getValidateArray($sample_control_data['SampleControl']['form_alias']) as $validate_model=>$validate_rules) {
				$this->{ $validate_model }->validate = $validate_rules;
			}
			
			// set flag 	
			$submitted_data_validates = TRUE;
			
			// Validates Fields of Master Table
			if(!$this->SampleMaster->validates($this->data['SampleMaster'])){
				$submitted_data_validates = FALSE;
			}
			
			// Validates Fields of Derivative or Specimen Details Table
			if($bool_is_specimen && isset($this->data['SpecimenDetail'])){
				$this->cleanUpFields('SpecimenDetail');
			
				// Validates Fields of Specimen Details Table
				if(!$this->SpecimenDetail->validates($this->data['SpecimenDetail'])){
					$submitted_data_validates = FALSE;
				}		
			} else if((!$bool_is_specimen) && isset($this->data['DerivativeDetail'])){
				$this->cleanUpFields('DerivativeDetail');
			
				// Validates Fields of Derivative Details Table
				if(!$this->DerivativeDetail->validates($this->data['DerivativeDetail'])){
					$submitted_data_validates = FALSE;
				}		
			}
		
			// Validates Fields of Sample Details Table
			if($bool_needs_details_table && isset($this->data['SampleDetail'])){
				$this->cleanUpFields('SampleDetail');
				
				// Validates Fields of Details Table
				if(!$this->SampleDetail->validates($this->data['SampleDetail'])){
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
		
				// Save SAMPLEMASTER data
				if(!$this->SampleMaster->save($this->data['SampleMaster'])){
					$bool_save_done = FALSE;
				}
				
				// Save Specimen or Derivative data
				if($bool_save_done) {
					if($bool_is_specimen && isset($this->data['SpecimenDetail'])){
						// Sample Specimen Data should be recorded: save SPECIMENDETAIL data 
						if(!$this->SpecimenDetail->save($this->data['SpecimenDetail'])){
							$bool_save_done = FALSE;
						}
						
					} else if((!$bool_is_specimen) && isset($this->data['DerivativeDetail'])){
						// Sample Derivative Data should be recorded: save DerivativeDetail data 
						if(!$this->DerivativeDetail->save($this->data['DerivativeDetail'])){
							$bool_save_done = FALSE;
						}
						
					}
				}
				
				if($bool_save_done && $bool_needs_details_table && isset($this->data['SampleDetail'])){
					// Sample Detail should be recorded: Save SAMPLEDETAIL data 
					if(!$this->SampleDetail->save($this->data['SampleDetail'])){
						$bool_save_done = FALSE;
					}
				}
					
				if(!$bool_save_done){	
					$this->redirect('/pages/err_inv_sample_record_err'); 
					exit;
					
				} else {
					
					// Data has been updated
					
					// update source aliquots use data
					if((!$bool_is_specimen) && isset($this->data['DerivativeDetail'])){
						$old_derivative_creation_date = $specimen_or_derivative_data['DerivativeDetail']['creation_datetime'];
						$new_derivative_creation_date = $this->data['DerivativeDetail']['creation_datetime'];
						if(strcmp($old_derivative_creation_date,$new_derivative_creation_date)!=0) {
							$this->updateSourceAliquotUses($sample_master_id, $sample_master_data['SampleMaster']['sample_code'], $new_derivative_creation_date);
						}
					}
					
					$this->flash('Your data has been updated.',
						"/sample_masters/detail/$specimen_group_menu_id" .
						"/$group_specimen_type/$sample_category/$collection_id/$sample_master_id");				
				}
											
			} // end action done after validation	
		} // end data save	 		
	
	} // function edit
	
	/**
	 * Allow to delete a sample of a collection.
	 * 
	 * @param $specimen_group_menu_id Menu id that corresponds to the tab clicked to 
	 * display the samples of the collection group (Ascite, Blood, Tissue, etc).
	 * @param $group_specimen_type Type of the source specimens of the group.
	 * @param $collcetion_id Id of the studied collection.
	 * @param $sample_master_id Id of the sample to delete. 
	 * 
	 * @author N. Luc
	 * @date 2007-06-20
	 
	function delete($specimen_group_menu_id=NULL, $group_specimen_type=NULL, 
	$sample_category=null, $collection_id=null, $sample_master_id=null) {
			
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($specimen_group_menu_id) || empty($group_specimen_type) || 
		empty($sample_category) || empty($collection_id) || empty($sample_master_id)) {
			$this->redirect('/pages/err_inv_funct_param_missing'); 
			exit;
		}
		
		// read SAMPLE MASTER info
		$this->SampleMaster->id = $sample_master_id;
		$sample_master_data = $this->SampleMaster->read();
		
		if(empty($sample_master_data)){
			$this->redirect('/pages/err_inv_samp_no_data'); 
			exit;			
		}	
		
		if(strcmp($sample_master_data['SampleMaster']['collection_id'], $collection_id) != 0) {
			$this->redirect('/pages/err_inv_no_coll_id_map'); 
			exit;			
		}
		
		$specimen_sample_master_id = $sample_master_data['SampleMaster']['initial_specimen_sample_id'];
		
		// Verify sample can be deleted
		if(!$this->allowSampleDeletion($sample_master_id)){
			$this->redirect('/pages/err_inv_samp_del_forbid'); 
			exit;	
		}

		//Look for sample control table
		$this->SampleControl->id = $sample_master_data['SampleMaster']['sample_control_id'];
		$sample_control_data = $this->SampleControl->read();
		
		if(empty($sample_control_data)){
			$this->redirect('/pages/err_inv_no_samp_cont_data'); 
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
		
		// Delete Sample
		
		// set flag
		$bool_delete_sample = TRUE;
		
		//Delete Derivative or Specimen Detail
		if($bool_delete_sample){
			if(strcmp($sample_control_data['SampleControl']['sample_category'], 'specimen') == 0){
				// This sample is specimen
				if(!$this->SpecimenDetail->del($sample_master_id)){
					$bool_delete_sample = FALSE;		
				}		
			} else if(strcmp($sample_control_data['SampleControl']['sample_category'], 'derivative') == 0){
				if(!$this->DerivativeDetail->del($sample_master_id)){
					$bool_delete_sample = FALSE;		
				}
			} else {
				$this->redirect('/pages/err_inv_system_error'); 
				exit;
			}
		}
		
		//Delete Sample Detail
		if($bool_delete_sample){
			if(!is_null($sample_control_data['SampleControl']['detail_tablename'])){
				// This sample has specific data
				$this->SampleDetail 
					= new SampleDetail(false, $sample_control_data['SampleControl']['detail_tablename']);
				
				if(!$this->SampleDetail->del($sample_master_id)){
					$bool_delete_sample = FALSE;		
				}
			}			
		}
		
		if($bool_delete_sample){
			//Delete sample Master Data
			if(!$this->SampleMaster->del($sample_master_id)){
				$bool_delete_sample = FALSE;		
			}	
		}
		
		if(!$bool_delete_sample){exit;
			$this->redirect('/pages/err_inv_samp_del_err'); 
			exit;
		}
		
		$this->flash('Your data has been deleted.',
				"/sample_masters/listall/$specimen_group_menu_id/" .
				"$group_specimen_type/$sample_category/$collection_id/$specimen_sample_master_id");
	
	} //end delete
		
	/* --------------------------------------------------------------------------
	 * ADDITIONAL FUNCTIONS
	 * -------------------------------------------------------------------------- */	
	
	/**
	 * Create Sample code of a created sample. 
	 * 
	 * @param $sample_master_data Array that contains sample master data 
	 * of the created sample.
	 * @param $sample_control_data Array that contains sample control data 
	 * of the created sample.
	 * 
	 * @return The sample code of the created sample.
	 * 
	 * @author N. Luc
	 * @since 2007-06-20
	 
	function createSampleCode($sample_master_data, $sample_control_data){
		
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($sample_master_data) || empty($sample_control_data)) {
			$this->redirect('/pages/err_inv_funct_param_missing'); 
			exit;
		}
		
		// ** build sample code **
		$sample_code = 
			$sample_control_data['sample_type_code'].
			' - '.
			$sample_master_data['id'];
		
		return $sample_code;
		
	}

	/**
	 * Define if a sample can be deleted.
	 * 
	 * @param $sample_master_id Id of the studied sample.
	 * 
	 * @return Return TRUE if the sample can be deleted.
	 * 
	 * @author N. Luc
	 * @since 2007-06-20
	 
	function allowSampleDeletion($sample_master_id){
		
		// Verify that this sample has no chidlren	
		$criteria = 'SampleMaster.parent_id ="' .$sample_master_id.'"';			 
		$sample_children_nbr = $this->SampleMaster->findCount($criteria);
		
		if($sample_children_nbr > 0){
			return FALSE;
		}
		
		// Verify that this sample has no aliquot
		$criteria = 'AliquotMaster.sample_master_id ="' .$sample_master_id.'"';			 
		$sample_aliquot_nbr = $this->AliquotMaster->findCount($criteria);
		
		if($sample_aliquot_nbr > 0){
			return FALSE;
		}
		
		// Verify this sample has not been used.
		// Note: Not necessary because we can not delete a sample aliquot 
		// when this one has been used at least once.
		
		// Verify that no parent sample aliquot is attached to the sample list  
		// 'used aliquot' that allows to display all source aliquots used to create 
		// the studied sample.
		$criteria = 'SourceAliquot.sample_master_id ="' .$sample_master_id.'"';			 
		$sample_source_aliquot_nbr = $this->SourceAliquot->findCount($criteria);

		if($sample_source_aliquot_nbr > 0){
			return FALSE;
		}
		
		// Verify this sample has not been used for review
		$criteria = 'PathCollectionReview.sample_master_id ="' .$sample_master_id.'"';			 
		$aliquot_path_review_nbr = $this->PathCollectionReview->findCount($criteria);

		if($aliquot_path_review_nbr > 0){
			return FALSE;
		}
		
		$criteria = 'ReviewMaster.sample_master_id ="' .$sample_master_id.'"';			 
		$aliquot_review_nbr = $this->ReviewMaster->findCount($criteria);

		if($aliquot_review_nbr > 0){
			return FALSE;
		}
		
		// Verify no qc has been attached to this sample
		$criteria = 'QualityControl.sample_master_id ="' .$sample_master_id.'"';			 
		$aliquot_qc_nbr = $this->QualityControl->findCount($criteria);

		if($aliquot_qc_nbr > 0){
			return FALSE;
		}
		
		return TRUE;
	}
	
	function updateSourceAliquotUses($sample_master_id, $use_details, $use_date) {
		
		$this->SourceAliquot->bindModel(array('belongsTo' => 
			array('AliquotUse' => array(
					'className' => 'AliquotUse',
					'conditions' => '',
					'order'      => '',
					'foreignKey' => 'aliquot_use_id'))));
		
		$criteria = array();
		$criteria['SourceAliquot.sample_master_id'] = $sample_master_id;
		$criteria = array_filter($criteria);
		
		$aliquot_uses = $this->SourceAliquot->findAll($criteria, null, null, null, 1);
		
		if(!empty($aliquot_uses)) {
			foreach($aliquot_uses as $tmp => $tested_aliquot_use_data) {
				$this->updateAliquotUseDetailAndDate($tested_aliquot_use_data['AliquotUse']['id'], 
					$tested_aliquot_use_data['AliquotUse']['aliquot_master_id'], 
					$use_details, 
					$use_date);
			}
		}	
	
	}
	
	
	
	
	
	
	
	
	
	
	
}
*/
?>