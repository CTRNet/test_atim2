<?php

class SampleMastersController extends InventorymanagementAppController {

	var $components = array();

	var $uses = array(
		'Inventorymanagement.Collection',
		
		'Inventorymanagement.SampleControl',

		'Inventorymanagement.SampleMaster',
		'Inventorymanagement.ViewSample',
		'Inventorymanagement.SampleDetail',
	 	'Inventorymanagement.SpecimenDetail',		
		'Inventorymanagement.DerivativeDetail',		
		
		'Inventorymanagement.ParentToDerivativeSampleControl',
		
		'Inventorymanagement.AliquotControl',
		'Inventorymanagement.AliquotMaster',
		
		'Inventorymanagement.SourceAliquot',
		'Inventorymanagement.QualityCtrl',
		'Inventorymanagement.SpecimenReviewMaster',
		
		'Inventorymanagement.SampleToAliquotControl');
	
	var $paginate = array(
		'SampleMaster' => array('limit' => pagination_amount, 'order' => 'SampleMaster.sample_code DESC'),
		'ViewSample' => array('limit' =>pagination_amount , 'order' => 'ViewSample.sample_code DESC'), 
		'AliquotMaster' => array('limit' =>pagination_amount , 'order' => 'AliquotMaster.barcode DESC'));

	/* --------------------------------------------------------------------------
	 * DISPLAY FUNCTIONS
	 * -------------------------------------------------------------------------- */

	function index() {
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/collections/index'));
						
		$_SESSION['ctrapp_core']['search'] = null; // clear SEARCH criteria
		$this->unsetInventorySessionData();
		
		$this->Structures->set('view_sample_joined_to_collection');
				
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link); 
		}
	}
	
	function search() {
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/collections/index'));

		$view_sample = $this->Structures->get('form', 'view_sample_joined_to_collection');
		$this->set('atim_structure', $view_sample);
		if ($this->data) $_SESSION['ctrapp_core']['search']['criteria'] = $this->Structures->parse_search_conditions($view_sample);
		
		$this->set('samples_data', $this->paginate($this->ViewSample, $_SESSION['ctrapp_core']['search']['criteria']));
		$this->data = array();
		
		// if SEARCH form data, save number of RESULTS and URL
		$_SESSION['ctrapp_core']['search']['results'] = $this->params['paging']['ViewSample']['count'];
		$_SESSION['ctrapp_core']['search']['url'] = '/inventorymanagement/sample_masters/search';
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link); 
		}
	}
	
	function contentTreeView($collection_id, $filter_option = null) {
		if(!$collection_id) { 
			$this->redirect('/pages/err_inv_funct_param_missing', null, true); 
		}
		
		$display_aliquots = true;
		$studied_specimen_sample_control_id = null;
		
		// MANAGE DATA

		// Manage filter data
		if(is_null($filter_option)) {
			if(isset($_SESSION['InventoryManagement']['treeView']['Filter'])) {
				$filter_option = $_SESSION['InventoryManagement']['treeView']['Filter'];
			}
		} else {
			if($filter_option == '-1') {
				// User unactived filter
				$filter_option = null;
				unset($_SESSION['InventoryManagement']['treeView']['Filter']);
			} else {
				$_SESSION['InventoryManagement']['treeView']['Filter'] = $filter_option;
			}
		}
		if(!is_null($filter_option)) {	
			$option_for_tree_view = explode("|", $filter_option);			
			if(sizeof($option_for_tree_view) != 2)  { $this->redirect('/pages/err_inv_system_error', null, true); }
			
			$display_aliquots = $option_for_tree_view[0];
			$studied_specimen_sample_control_id = empty($option_for_tree_view[1])? null : $option_for_tree_view[1];
		}
					
		// Get formatted collection samples data to display
		$this->data = $this->SampleMaster->buildCollectionContentForTreeView($collection_id, $display_aliquots, $studied_specimen_sample_control_id);
		// MANAGE FORM, MENU AND ACTION BUTTONS	
			 	
		$atim_structure = array();
		$atim_structure['SampleMaster']	= $this->Structures->get('form','sample_masters_for_collection_tree_view');
		$atim_structure['AliquotMaster']	= $this->Structures->get('form','aliquot_masters_for_collection_tree_view');
		$this->set('atim_structure', $atim_structure);

		// Get all sample control types to build the add to selected button
		$specimen_sample_controls_list = $this->SampleControl->getPermissibleSamplesArray(null);
		$this->set('specimen_sample_controls_list', $specimen_sample_controls_list);

		// Get all collection specimen type list to build the filter button
		$specimen_type_list = array();
		$specimen_type_list_temp = $this->SampleMaster->find('all', array('fields' => 'DISTINCT SampleMaster.sample_type, SampleMaster.sample_control_id', 'conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.sample_category' => 'specimen'), 'order' => 'SampleMaster.sample_type ASC', 'recursive' => '-1'));
		foreach($specimen_type_list_temp as $new_specimen_type) {
			$sample_control_id = $new_specimen_type['SampleMaster']['sample_control_id'];
			$sample_type = $new_specimen_type['SampleMaster']['sample_type'];
			$specimen_type_list[$sample_type] = $sample_control_id;
		}
		$this->set('specimen_type_list', $specimen_type_list);

		// Set filter value to build filter button
		$this->set('display_aliquots_filter_value', $display_aliquots);
		$this->set('studied_specimen_sample_control_id_filter_value', $studied_specimen_sample_control_id);
		
		// Set filter value
		$filter_value = '';
		if($studied_specimen_sample_control_id) {
			$sample_control_data = $this->SampleControl->find('first', array('conditions' => array('id' => $studied_specimen_sample_control_id)));
			if(empty($sample_control_data)) { 
				unset($_SESSION['InventoryManagement']['treeView']['Filter']);
				$this->redirect('/pages/err_inv_system_error', null, true); 
			}
			$filter_value = __($sample_control_data['SampleControl']['sample_type'], true);
		}
		if(!$display_aliquots) $filter_value .= (empty($filter_value)? '' : ' - ') . __('no aliquot displayed', true);
		$this->set('filter_value', (empty($filter_value)? 'no filter' : $filter_value));
		
		// Get the current menu object. 
		$atim_menu = $this->Menus->get('/inventorymanagement/sample_masters/contentTreeView/%%Collection.id%%');
		$this->set('atim_menu', $atim_menu);

		// Set menu variables
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id));		
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link); 
		}
	}
	
	function listAll($collection_id, $initial_specimen_sample_id, $filter_option = null) {
		if((!$collection_id) || (!$initial_specimen_sample_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }

		// MANAGE FILTER OPTION
		
		$is_collection_sample_list = ($initial_specimen_sample_id == '-1')? true: false;
		
		$model_to_use = null;
		$form_alias = null;
		$sample_search_criteria = array();
		$menu_variables = array();
		
		$filter_value = 'no filter';
		
		if($is_collection_sample_list) {
			//---------------------------------------------------
			// A- User is working on collection samples list
			//---------------------------------------------------
			
			// A.1- Manage filter option
			if(is_null($filter_option)) {
				if(isset($_SESSION['InventoryManagement']['CollectionSamples']['Filter'])) { 
					// Get existing filter
					$filter_option = $_SESSION['InventoryManagement']['CollectionSamples']['Filter']; 
				}
			} else if($filter_option == '-1') {
				// User inactived filter
				$filter_option = null;
				unset($_SESSION['InventoryManagement']['CollectionSamples']['Filter']);
			}
			
			// A.2- Set Model, Alias, Menu Criteria and Search Criteria to use
			if(is_null($filter_option)) {
				// No filter
				$model_to_use = 'ViewSample';
				$form_alias = 'view_sample_joined_to_parent';
				
			} else  {
				// Get filter options
				$option_for_list_all = explode("|", $filter_option);			
				if(sizeof($option_for_list_all) != 2)  { $this->redirect('/pages/err_inv_system_error', null, true); }
	
				switch($option_for_list_all[0]) {
					case 'CATEGORY':
						// list all collection samples according to sample category: Either specimen or derivative
						$model_to_use = 'ViewSample';
						$form_alias = 'view_sample_joined_to_parent';
						
						$sample_category = $option_for_list_all[1];
						$sample_search_criteria['ViewSample.sample_category'] = $sample_category;
						$filter_value = $sample_category;
						break;
						
					case 'SAMP_CONT_ID':
						// list all collection samples according to sample type
						$model_to_use = 'SampleMaster';
						
						$sample_control_id = $option_for_list_all[1];
						$sample_search_criteria['SampleMaster.sample_control_id'] = $sample_control_id; 
						
						$sample_control_data = $this->SampleControl->find('first', array('conditions' => array('SampleControl.id' => $sample_control_id)));
						if(empty($sample_control_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }	
										
						$form_alias = $sample_control_data['SampleControl']['form_alias'];
						$filter_value = $sample_control_data['SampleControl']['sample_type'];
						break;
						
					default:
						$this->redirect('/pages/err_inv_funct_param_missing', null, true);								
				}
				
				// Set filter option in session
				$_SESSION['InventoryManagement']['CollectionSamples']['Filter'] = $filter_option;
			}			
			
		} else {
			//---------------------------------------------------
			// B- User is working on specimen derivatives list	
			//---------------------------------------------------
			
			$is_existing_specimen = $this->SampleMaster->find('count', array('conditions' => array('SampleMaster.initial_specimen_sample_id' => $initial_specimen_sample_id)));
			if(!$is_existing_specimen) { $this->redirect('/pages/err_inv_no_data', null, true); }
			
			$menu_variables['SampleMaster.id'] = $initial_specimen_sample_id;
			$menu_variables['SampleMaster.initial_specimen_sample_id'] = $initial_specimen_sample_id;
					
			// B.1- Manage filter option
			if(is_null($filter_option)) {
				// Get existing filter
				if(isset($_SESSION['InventoryManagement']['SpecimenDerivatives']['Filter'])) { 
					if($_SESSION['InventoryManagement']['SpecimenDerivatives']['Filter']['InitialSpecimenSampleId'] != $initial_specimen_sample_id) {
						// New studied specimen: clear filter option
						$filter_option = null;
						unset($_SESSION['InventoryManagement']['SpecimenDerivatives']['Filter']);						
						
					} else {
						// Get existing filter
						$filter_option = $_SESSION['InventoryManagement']['SpecimenDerivatives']['Filter']['Option']; 
					}
				}
			} else if($filter_option == '-1') {
				// User inactived filter
				$filter_option = null;
				unset($_SESSION['InventoryManagement']['SpecimenDerivatives']['Filter']);
			}
			
			// B.2- Set Model, Alias, Menu Criteria and Search Criteria to use
			if(is_null($filter_option)) {	
				// No filter
				$model_to_use = 'ViewSample';
				$form_alias = 'view_sample_joined_to_parent';
						
				$sample_search_criteria['ViewSample.initial_specimen_sample_id'] = $initial_specimen_sample_id; 
				$sample_search_criteria['ViewSample.sample_category'] = 'derivative'; 
			
			} else {	
				// Get filter options
				$model_to_use = 'SampleMaster';
						
				$sample_search_criteria['SampleMaster.initial_specimen_sample_id'] = $initial_specimen_sample_id; 
				$sample_search_criteria['SampleMaster.sample_category'] = 'derivative'; 
			
				$option_for_list_all = explode("|", $filter_option);			
				if(sizeof($option_for_list_all) != 2)  { $this->redirect('/pages/err_inv_system_error', null, true); }
	
				switch($option_for_list_all[0]) {
					case 'SAMP_CONT_ID':
						// list all derivatives samples according to sample type
						$sample_control_id = $option_for_list_all[1];
						$sample_search_criteria['SampleMaster.sample_control_id'] = $sample_control_id; 
						
						$sample_control_data = $this->SampleControl->find('first', array('conditions' => array('SampleControl.id' => $sample_control_id)));
						if(empty($sample_control_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }	
										
						$form_alias = $sample_control_data['SampleControl']['form_alias'];
						$filter_value = $sample_control_data['SampleControl']['sample_type'];
						break;
						
					default:
						$this->redirect('/pages/err_inv_funct_param_missing', null, true);								
				}
				
				// Set filter option in session
				$_SESSION['InventoryManagement']['SpecimenDerivatives']['Filter'] = array(
					'InitialSpecimenSampleId' => $initial_specimen_sample_id,
					'Option' => $filter_option);
			}		
		}

		// MANAGE DATA
		
		// Search data to display
		$samples_data = array();
		switch($model_to_use) {
			case 'ViewSample': 
				// Get data
				$samples_data = $this->paginate($this->ViewSample, array_merge(array('ViewSample.collection_id' => $collection_id), $sample_search_criteria));
				break;
				
			case 'SampleMaster':		
				// Get data (User would like to list sample data fo a specific sample type)
				$belongs_to_details = array(
					'belongsTo' => array('GeneratedParentSample' => array(
						'className' => 'Inventorymanagement.SampleMaster',
						'foreignKey' => 'parent_id')));
				
				$this->SampleMaster->bindModel($belongs_to_details, false);			
				$samples_data = $this->paginate($this->SampleMaster, array_merge(array('SampleMaster.collection_id' => $collection_id), $sample_search_criteria));
				$this->SampleMaster->unbindModel(array('belongsTo' => array('GeneratedParentSample')), false);
				break;
				
			default:
				$this->redirect('/pages/err_inv_system_error', null, true);
		}
		
		$this->set('model_to_use', $model_to_use);
		$this->set('samples_data', $samples_data);
		$this->data = array();
		
		// MANAGE FORM, MENU AND ACTION BUTTONS	
		
		if(is_null($form_alias)) { $this->redirect('/pages/err_inv_system_error', null, true); }
		$this->Structures->set($form_alias);		
		
		// Get all sample control types to build the add to selected button (only for collection samples form)
		$specimen_sample_controls_list = array();
		if($is_collection_sample_list) {
			$specimen_sample_controls_list = $this->SampleControl->getPermissibleSamplesArray(null); 
		}
		$this->set('specimen_sample_controls_list', $specimen_sample_controls_list);
		
		// Get all collection / derivative sample type list to build the filter button
		$sample_type_list = array();
		if($is_collection_sample_list) {
			$tmp_sample_type_list = $this->SampleMaster->find('all', array('fields' => 'DISTINCT SampleMaster.sample_type, SampleMaster.sample_control_id', 'conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.sample_category' => 'specimen'), 'order' => 'SampleMaster.sample_type ASC', 'recursive' => '-1'));
			foreach($tmp_sample_type_list as $new_sample_type) {
				$sample_control_id = $new_sample_type['SampleMaster']['sample_control_id'];
				$sample_type = $new_sample_type['SampleMaster']['sample_type'];
				$sample_type_list[$sample_type] = $sample_control_id;
			}
		}
		$this->set('existing_specimen_sample_types', $sample_type_list);

		$sample_type_list = array();
		$criteria = array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.sample_category' => 'derivative');
		if(!$is_collection_sample_list) { $criteria['SampleMaster.initial_specimen_sample_id'] = $initial_specimen_sample_id; }
		$tmp_sample_type_list = $this->SampleMaster->find('all', array('fields' => 'DISTINCT SampleMaster.sample_type, SampleMaster.sample_control_id', 'conditions' => $criteria, 'order' => 'SampleMaster.sample_type ASC', 'recursive' => '-1'));
		foreach($tmp_sample_type_list as $new_sample_type) {
			$sample_control_id = $new_sample_type['SampleMaster']['sample_control_id'];
			$sample_type = $new_sample_type['SampleMaster']['sample_type'];
			$sample_type_list[$sample_type] = $sample_control_id;
		}
		$this->set('existing_derivative_sample_types', $sample_type_list);
		
		// Get the current menu object. 
		$menu_link = '/inventorymanagement/sample_masters/listAll/%%Collection.id%%/' . (($is_collection_sample_list)? '-1': '%%SampleMaster.initial_specimen_sample_id%%');
		$this->set('atim_menu', $this->Menus->get($menu_link));
		
		// Set menu variables
		$atim_menu_variables = array_merge(array('Collection.id' => $collection_id), $menu_variables);
		$this->set('atim_menu_variables', $atim_menu_variables);
		
		$this->set('filter_value', $filter_value);
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link); 
		}
	}
	
	function detail($collection_id, $sample_master_id, $is_tree_view_detail_form = false, $is_inventory_plugin_form = true) {
		if((!$collection_id) || (!$sample_master_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }		
		// MANAGE DATA

		// Get the sample data
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id)));
		if(empty($sample_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }		
		
		$bool_is_specimen = true;
		switch($sample_data['SampleControl']['sample_category']) {
			case 'specimen':
				// Displayed sample is a specimen
				$bool_is_specimen = true;
				unset($sample_data['DerivativeDetail']);
				break;
				
			case 'derivative':
				// Displayed sample is a derivative
				$bool_is_specimen = false;
				unset($sample_data['SpecimenDetail']);
				break;
				
			default:
				$this->redirect('/pages/err_inv_system_error', null, true);
		}

		// Get parent sample information
		$parent_sample_master_id = $sample_data['SampleMaster']['parent_id'];
		$parent_sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $parent_sample_master_id), 'recursive' => '-1'));
		if(!empty($parent_sample_master_id) && empty($parent_sample_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }	
		
		$this->set('parent_sample_data_for_display', $this->formatParentSampleDataForDisplay($parent_sample_data));	
		$this->set('parent_sample_master_id', $parent_sample_master_id);	
	
		// Calulate spent time between:
		if($bool_is_specimen){
			// -> specimen collection and specimen reception
			$sample_data['Generated']['coll_to_rec_spent_time_msg'] = $this->manageSpentTimeDataDisplay($this->getSpentTime($sample_data['Collection']['collection_datetime'], $sample_data['SpecimenDetail']['reception_datetime']));
		} else {
			// -> specimen collection and derivative creation
			$sample_data['Generated']['coll_to_creation_spent_time_msg'] = $this->manageSpentTimeDataDisplay($this->getSpentTime($sample_data['Collection']['collection_datetime'], $sample_data['DerivativeDetail']['creation_datetime']));
		}
		
		// Set sample data
		$this->set('sample_master_data', $sample_data);
		$this->data = array();
					
		// Set sample aliquot list
		if(!$is_tree_view_detail_form) { 		
			$this->set('aliquots_data', $this->getAliquotsListData(array('AliquotMaster.collection_id' => $collection_id, 'AliquotMaster.sample_master_id' => $sample_master_id))); 
		}
		
		// MANAGE FORM, MENU AND ACTION BUTTONS

		// Get the current menu object.
		$atim_menu_link = '/inventorymanagement/sample_masters/detail/%%Collection.id%%/';
		$atim_menu = $bool_is_specimen?  $this->Menus->get($atim_menu_link . '%%SampleMaster.initial_specimen_sample_id%%') : $this->Menus->get($atim_menu_link . '%%SampleMaster.id%%');
		$this->set('atim_menu', $atim_menu);
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id, 'SampleMaster.id' => $sample_master_id, 'SampleMaster.initial_specimen_sample_id' => $sample_data['SampleMaster']['initial_specimen_sample_id']));
		
		// Set structure
		$this->Structures->set($sample_data['SampleControl']['form_alias']);	
		if(!$is_tree_view_detail_form) { 
			$this->Structures->set('aliquotmasters', 'aliquots_listall_structure');	
		}

		// Define if this detail form is displayed into the collection content tree view
		$this->set('is_tree_view_detail_form', $is_tree_view_detail_form);
		
		// Define if this detail form is displayed into a form of the inventory plugin
		$this->set('is_inventory_plugin_form', $is_inventory_plugin_form);
		
		// Get all sample control types to build the add to selected button
		$this->set('allowed_derivative_type', $this->SampleControl->getPermissibleSamplesArray($sample_data['SampleControl']['id']));

		// Get all aliquot control types to build the add to selected button
		$this->set('allowed_aliquot_type', $this->AliquotControl->getPermissibleAliquotsArray($sample_data['SampleControl']['id']));

		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
	}
	
	function add($collection_id, $sample_control_id, $parent_sample_master_id = null) {
		if((!$collection_id) || (!$sample_control_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }		
			
		// MANAGE DATA
		
		$bool_is_specimen = null;
		$sample_control_data = array();
		$parent_sample_data = array();
		
		if(empty($parent_sample_master_id)) {
			// Created sample is a specimen
			$bool_is_specimen = true;
			
			// Get Control Data
			$sample_control_data = $this->SampleControl->find('first', array('conditions' => array('SampleControl.id' => $sample_control_id)));
			if(empty($sample_control_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }	
			
			// Check collection id
			$collection_data = $this->Collection->find('first', array('conditions' => array('Collection.id' => $collection_id), 'recursive' => '-1'));
			if(empty($collection_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }			
			
		} else {
			// Created sample is a derivative: Get parent sample information
			$bool_is_specimen = false;
			
			// Get parent data
			$parent_sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $parent_sample_master_id), 'recursive' => '-1'));
			if(empty($parent_sample_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }
			
			// Get Control Data
			$criteria = array(
				'ParentSampleControl.id' => $parent_sample_data['SampleMaster']['sample_control_id'],
				'ParentToDerivativeSampleControl.flag_active' => '1',
				'DerivativeControl.id' => $sample_control_id);
			$parent_to_derivative_sample_control = $this->ParentToDerivativeSampleControl->find('first', array('conditions' => $criteria));	
			if(empty($parent_to_derivative_sample_control)) { $this->redirect('/pages/err_inv_no_data', null, true); }
			$sample_control_data['SampleControl'] = $parent_to_derivative_sample_control['DerivativeControl'];
		}
		
		// Set parent data
		$this->set('parent_sample_data_for_display', $this->formatParentSampleDataForDisplay($parent_sample_data));	
		$this->set('parent_sample_master_id', $parent_sample_master_id);
		
		// Set new sample control information
		$this->set('sample_control_data', $sample_control_data);	
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Set menu
		$atim_menu_link = '/inventorymanagement/sample_masters/listAll/%%Collection.id%%';
		$atim_menu_link .= ($bool_is_specimen? '/-1': '/%%SampleMaster.initial_specimen_sample_id%%');
		$this->set('atim_menu', $this->Menus->get($atim_menu_link));
		
		$atim_menu_variables = (empty($parent_sample_data)? array('Collection.id' => $collection_id) : array('Collection.id' => $collection_id, 'SampleMaster.initial_specimen_sample_id' => $parent_sample_data['SampleMaster']['initial_specimen_sample_id']));
		
		$this->set('atim_menu_variables', $atim_menu_variables);
		
		// set structure alias based on VALUE from CONTROL table
		$this->Structures->set($sample_control_data['SampleControl']['form_alias']);
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}	
		
		// MANAGE DATA RECORD
		
		if(empty($this->data)) {
			$this->data = array();
			$this->data['SampleMaster']['sample_type'] = $sample_control_data['SampleControl']['sample_type'];
			$this->data['SampleMaster']['sample_category'] = $sample_control_data['SampleControl']['sample_category'];
	
			//Set default reception date
			if($bool_is_specimen){
				$default_reception_datetime = null;
				$default_reception_datetime_accuracy = null;
				if($this->SampleMaster->find('count', array('conditions' => array('SampleMaster.collection_id' => $collection_id))) == 0){
					$collection = $this->Collection->find('first', array('conditions' => array('Collection.id' => $collection_id)));
					$default_reception_datetime = $collection['Collection']['collection_datetime'];
					$default_reception_datetime_accuracy = $collection['Collection']['collection_datetime_accuracy'];
				}else{
					$sample = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id), 'order by' => array('SpecimenDetail.reception_datetime')));
					$default_reception_datetime = $sample['SpecimenDetail']['reception_datetime'];
					$default_reception_datetime_accuracy = $sample['SpecimenDetail']['reception_datetime_accuracy'];
				}
				$this->data['SpecimenDetail']['reception_datetime'] = $default_reception_datetime;
				$this->data['SpecimenDetail']['reception_datetime_accuracy'] = $default_reception_datetime_accuracy;
			}
		
		} else {
			// Set additional data
			$this->data['SampleMaster']['collection_id'] = $collection_id;
			$this->data['SampleMaster']['sample_control_id'] = $sample_control_data['SampleControl']['id'];
			$this->data['SampleMaster']['sample_type'] = $sample_control_data['SampleControl']['sample_type'];			
			$this->data['SampleMaster']['sample_category'] = $sample_control_data['SampleControl']['sample_category'];	
			
			// Set either specimen or derivative additional data
			if($bool_is_specimen){
				// The created sample is a specimen
				if(isset($this->data['SampleMaster']['parent_id'])) { $this->redirect('/pages/err_inv_system_error', null, true); }
				$this->data['SampleMaster']['initial_specimen_sample_type'] = $this->data['SampleMaster']['sample_type'];
				$this->data['SampleMaster']['initial_specimen_sample_id'] = null; 	// ID will be known after sample creation
			} else {
				// The created sample is a derivative
				$this->data['SampleMaster']['parent_id'] = $parent_sample_data['SampleMaster']['id'];
				$this->data['SampleMaster']['initial_specimen_sample_type'] = $parent_sample_data['SampleMaster']['initial_specimen_sample_type'];
				$this->data['SampleMaster']['initial_specimen_sample_id'] = $parent_sample_data['SampleMaster']['initial_specimen_sample_id'];
			}
  	  			  	
			// Validates data
			
			$submitted_data_validates = true;
			
			$this->SampleMaster->set($this->data);
			$submitted_data_validates = ($this->SampleMaster->validates())? $submitted_data_validates: false;
			
			//for error field highlight in detail
			$this->SampleDetail->validationErrors = $this->SampleMaster->validationErrors;
			
			if($bool_is_specimen) { 
				$this->SpecimenDetail->set($this->data);
				$submitted_data_validates = ($this->SpecimenDetail->validates())? $submitted_data_validates: false; 
			} else { 
				$this->DerivativeDetail->set($this->data);
				$submitted_data_validates = ($this->DerivativeDetail->validates())? $submitted_data_validates: false; 
			}
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}
				
			if($submitted_data_validates) {
				// Save sample data
				$sample_master_id = null;
				if($this->SampleMaster->save($this->data, false)) {
					$sample_master_id = $this->SampleMaster->getLastInsertId();
				
					// Record additional sample data
					$sample_data_to_update = array();
					$sample_data_to_update['SampleMaster']['sample_code'] = $this->createSampleCode($sample_master_id, $this->data, $sample_control_data);
					if($bool_is_specimen) { $sample_data_to_update['SampleMaster']['initial_specimen_sample_id'] = $sample_master_id; }
					
					$this->SampleMaster->id = $sample_master_id;					
					if(!$this->SampleMaster->save($sample_data_to_update, false)) { $this->redirect('/pages/err_inv_system_error', null, true); }
					
					// Save either specimen or derivative detail
					if($bool_is_specimen){
						// SpecimenDetail
						$this->data['SpecimenDetail']['sample_master_id'] = $sample_master_id;
						if(!$this->SpecimenDetail->save($this->data['SpecimenDetail'], false)) { $this->redirect('/pages/err_inv_system_error', null, true); }
					} else {
						// DerivativeDetail
						$this->data['DerivativeDetail']['sample_master_id'] = $sample_master_id;
						if(!$this->DerivativeDetail->save($this->data['DerivativeDetail'], false)) { $this->redirect('/pages/err_inv_system_error', null, true); }
					}						
					
					$this->atimFlash('your data has been saved', '/inventorymanagement/sample_masters/detail/' . $collection_id . '/' . $sample_master_id);	
				}					
			}			
		}
	}
	
	function edit($collection_id, $sample_master_id) {
		if((!$collection_id) || (!$sample_master_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }		
		
		// MANAGE DATA

		// Get the sample data
		
		$this->SampleMaster->unbindModel(array('hasMany' => array('AliquotMaster')));		
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id)));
		if(empty($sample_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }		

		$bool_is_specimen = true;
		switch($sample_data['SampleControl']['sample_category']) {
			case 'specimen':
				// Displayed sample is a specimen
				$bool_is_specimen = true;
				unset($sample_data['DerivativeDetail']);
				break;
				
			case 'derivative':
				// Displayed sample is a derivative
				$bool_is_specimen = false;
				unset($sample_data['SpecimenDetail']);
				break;
				
			default:
				$this->redirect('/pages/err_inv_system_error', null, true);
		}

		// Get parent sample information
		$parent_sample_master_id = $sample_data['SampleMaster']['parent_id'];
		$parent_sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $parent_sample_master_id), 'recursive' => '-1'));
		if(!empty($parent_sample_master_id) && empty($parent_sample_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }	

		$this->set('parent_sample_data_for_display', $this->formatParentSampleDataForDisplay($parent_sample_data));	
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Get the current menu object. Needed to disable menu options based on sample category
		$atim_menu_link = '/inventorymanagement/sample_masters/detail/%%Collection.id%%/';
		$atim_menu = $bool_is_specimen?  $this->Menus->get($atim_menu_link . '%%SampleMaster.initial_specimen_sample_id%%') : $this->Menus->get($atim_menu_link . '%%SampleMaster.id%%');
		$this->set('atim_menu', $atim_menu);
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id, 'SampleMaster.id' => $sample_master_id, 'SampleMaster.initial_specimen_sample_id' => $sample_data['SampleMaster']['initial_specimen_sample_id']));
		
		// Set structure	
		$this->Structures->set($sample_data['SampleControl']['form_alias']);	
		
		// MANAGE DATA RECORD
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
		
		if(empty($this->data)) {
			$this->data = $sample_data;

		} else {
			//Update data	
			if(isset($this->data['SampleMaster']['parent_id']) && ($sample_data['SampleMaster']['parent_id'] !== $this->data['SampleMaster']['parent_id'])) { $this->redirect('/pages/err_inv_system_error', null, true); }

			// Validates data
			
			$submitted_data_validates = true;
			
			$this->SampleMaster->set($this->data);
			$this->SampleMaster->id = $sample_master_id;
			$submitted_data_validates = ($this->SampleMaster->validates())? $submitted_data_validates: false;
			
			//for error field highlight in detail
			$this->SampleDetail->validationErrors = $this->SampleMaster->validationErrors;
			
			if($bool_is_specimen) { 
				$this->SpecimenDetail->set($this->data);
				$submitted_data_validates = ($this->SpecimenDetail->validates())? $submitted_data_validates: false; 
			} else { 
				$this->DerivativeDetail->set($this->data);
				$submitted_data_validates = ($this->DerivativeDetail->validates())? $submitted_data_validates: false; 
			}
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}
				
			if($submitted_data_validates) {
				// Save sample data
				if($this->SampleMaster->save($this->data, false)) {				
					//Save either Specimen or Derivative Details
					if($bool_is_specimen){
						// SpecimenDetail
						$this->SpecimenDetail->id = $sample_data['SpecimenDetail']['id'];
						if(!$this->SpecimenDetail->save($this->data['SpecimenDetail'], false)) { $this->redirect('/pages/err_inv_system_error', null, true); }
					} else {
						// DerivativeDetail
						$this->DerivativeDetail->id = $sample_data['DerivativeDetail']['id'];
						if(!$this->DerivativeDetail->save($this->data['DerivativeDetail'], false)) { $this->redirect('/pages/err_inv_system_error', null, true); }
					}

					$this->atimFlash('your data has been updated', '/inventorymanagement/sample_masters/detail/' . $collection_id . '/' . $sample_master_id);		
				}				
			}
		}
	}
	
	function delete($collection_id, $sample_master_id) {
		if((!$collection_id) || (!$sample_master_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }		
		
		// Get the sample data
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id), 'recursive' => '0'));
		if(empty($sample_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }		
		
		$bool_is_specimen = true;
		switch($sample_data['SampleMaster']['sample_category']) {
			case 'specimen':
				// Displayed sample is a specimen
				$bool_is_specimen = true;
				break;
				
			case 'derivative':
				// Displayed sample is a derivative
				$bool_is_specimen = false;
				break;
				
			default:
				$this->redirect('/pages/err_inv_system_error', null, true);
		}
				
		// Check deletion is allowed
		$arr_allow_deletion = $this->allowSampleDeletion($sample_master_id);
		
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }		
		
		if($arr_allow_deletion['allow_deletion']) {
			$deletion_done = true;
			
			if(!$this->SampleMaster->atim_delete($sample_master_id)) { $deletion_done = false; }
			
			if($deletion_done) {
				if($bool_is_specimen) {
					if(!$this->SpecimenDetail->atim_delete($sample_data['SpecimenDetail']['id'])) { $deletion_done = false; }
				} else {
					if(!$this->DerivativeDetail->atim_delete($sample_data['DerivativeDetail']['id'])) { $deletion_done = false; }
				}	
			}
			
			if($deletion_done) {
				$this->atimFlash('your data has been deleted', '/inventorymanagement/sample_masters/contentTreeView/' . $collection_id);
			} else {
				$this->flash('error deleting data - contact administrator', '/inventorymanagement/sample_masters/contentTreeView/' . $collection_id);
			}
			
		} else {
			$this->flash($arr_allow_deletion['msg'], '/inventorymanagement/sample_masters/detail/' . $collection_id . '/' . $sample_master_id);
		}		
	}
	
	/* --------------------------------------------------------------------------
	 * ADDITIONAL FUNCTIONS
	 * -------------------------------------------------------------------------- */
	
	/**
	 * Create Sample code of a created sample. 
	 * 
	 * @param $sample_master_id Id of the created sample.
	 * @param $sample_master_data Array that contains sample master data of the created sample.
	 * @param $sample_control_data Array that contains sample control data of the created sample.
	 * 
	 * @return The sample code of the created sample.
	 * 
	 * @author N. Luc
	 * @since 2007-06-20
	 */
	 
	function createSampleCode($sample_master_id, $sample_master_data, $sample_control_data){	
		$sample_code = $sample_control_data['SampleControl']['sample_type_code'] . ' - '. $sample_master_id;		
		return $sample_code;		
	}

	/**
	 * Check if a sample can be deleted.
	 * 
	 * @param $sample_master_id Id of the studied sample.
	 * 
	 * @return Return results as array:
	 * 	['allow_deletion'] = true/false
	 * 	['msg'] = message to display when previous field equals false
	 * 
	 * @author N. Luc
	 * @since 2007-10-16
	 */
	 
	function allowSampleDeletion($sample_master_id){
		// Check sample has no chidlren	
		$returned_nbr = $this->SampleMaster->find('count', array('conditions' => array('SampleMaster.parent_id' => $sample_master_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'derivative exists for the deleted sample'); }
	
		// Check sample is not linked to aliquot	
		$returned_nbr = $this->AliquotMaster->find('count', array('conditions' => array('AliquotMaster.sample_master_id' => $sample_master_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'aliquot exists for the deleted sample'); }

		// Verify this sample has not been used.
		// Note: Not necessary because we can not delete a sample aliquot 
		// when this one has been used at least once.
		
		// Verify that no parent sample aliquot is attached to the sample list  
		// 'used aliquot' that allows to display all source aliquots used to create 
		// the studied sample.
		$returned_nbr = $this->SourceAliquot->find('count', array('conditions' => array('SourceAliquot.sample_master_id' => $sample_master_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'an aliquot of the parent sample is defined as source aliquot'); }

		// Check sample is not linked to qc	
		$returned_nbr = $this->QualityCtrl->find('count', array('conditions' => array('QualityCtrl.sample_master_id' => $sample_master_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'quality control exists for the deleted sample'); }

		// Check sample has not been linked to review	
		$returned_nbr = $this->SpecimenReviewMaster->find('count', array('conditions' => array('SpecimenReviewMaster.sample_master_id' => $sample_master_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'review exists for the deleted sample'); }

		return array('allow_deletion' => true, 'msg' => '');
	}
	
	/**
	 * Format parent sample data array for display.
	 * 
	 * @param $parent_sample_data Parent sample data
	 * 
	 * @return Parent sample list into array having following structure: 
	 * 	array($parent_sample_master_id => $sample_title_built_by_function)
	 *
	 * @author N. Luc
	 * @since 2009-09-11
	 */	
	 
	function formatParentSampleDataForDisplay($parent_sample_data) {
		$formatted_data = array();
		if(!empty($parent_sample_data) && isset($parent_sample_data['SampleMaster'])) {
			$formatted_data[$parent_sample_data['SampleMaster']['id']] = $parent_sample_data['SampleMaster']['sample_code'] . ' [' . __($parent_sample_data['SampleMaster']['sample_type'], TRUE) . ']';
		}
		
		return $formatted_data;
	}
	
	function batchDerivativeInit(){
		$init_data = $this->batchInit(
			$this->SampleMaster, 
			"ViewSample", 
			"sample_master_id", 
			"sample_control_id", 
			$this->ParentToDerivativeSampleControl, 
			"parent_sample_control_id",
			__("you cannot create derivatives for this sample type", true));
		
		foreach($init_data['possibilities'] as $possibility){
			SampleMaster::$derivatives_dropdown[$possibility['DerivativeControl']['id']] = __($possibility['DerivativeControl']['sample_type'], true);
		}
		
		$this->Structures->set('derivative_init');
		$this->set('ids', $init_data['ids']);
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/'));
	}
	
	function batchDerivative(){
		if(empty($this->data)){
			$this->redirect('/pages/err_inv_system_error', null, true);
		}
		if(!isset($this->data['SampleMaster']['sample_control_id']) || $this->data['SampleMaster']['sample_control_id'] == ''){
			$this->flash(__("you must select a derivative type", true), "javascript:history.back();", 5);
		}
		$control = $this->SampleControl->findById($this->data['SampleMaster']['sample_control_id']);
		$this->Structures->set($control['SampleControl']['form_alias']);
		$this->set('control', $control);
		if(isset($this->data['SampleMaster']['ids'])){
			//first access
			$samples = $this->SampleMaster->find('all', array('conditions' => array('SampleMaster.id' => explode(",", $this->data['SampleMaster']['ids'])), 'recursive' => -1));
			$this->data = array();
			foreach($samples as $sample){
				$this->data[] = array('parent' => $sample, 'children' => array());
			}
		}else{
			//save/post access
			$control_id = $control['SampleControl']['id'];
			$control_type = $control['SampleControl']['sample_type'];
			$errors = array();
			unset($this->data['SampleMaster']);
			$prev_data = $this->data;
			$this->data = array();
			foreach($prev_data as $parent_id => &$children){
				$parent = $this->SampleMaster->findById($parent_id);
				foreach($children as &$child){
					$child['SampleMaster']['sample_control_id'] = $control_id;
					$child['SampleMaster']['collection_id'] = $parent['SampleMaster']['collection_id'];
					$child['SampleMaster']['initial_specimen_sample_id'] = $parent['SampleMaster']['initial_specimen_sample_id'];
					$child['SampleMaster']['initial_specimen_sample_type'] = $parent['SampleMaster']['initial_specimen_sample_type'];
					$this->SampleMaster->set($child);
					if(!$this->SampleMaster->validates()){
						$errors = array_merge($errors, $this->SampleMaster->validationErrors);
					}
				}
				$this->data[] = array('parent' => $parent, 'children' => $children);//prep data in case validation fails
			}
			if(empty($errors)){
				//save
				$_SESSION['tmp_batch_set']['BatchId'] = array();
				foreach($prev_data as $parent_id => &$children){
					foreach($children as &$child){
						$this->SampleMaster->id = null;
						$this->SampleMaster->set($child);
						$this->SampleMaster->save();
						$_SESSION['tmp_batch_set']['BatchId'][] = $this->SampleMaster->id; 
						$child['SampleMaster']['sample_code'] = $this->createSampleCode($this->SampleMaster->id, $child, $control);
						$this->SampleMaster->set($child);
						$this->SampleMaster->save();
					}
				}
				$datamart_structure = AppModel::atimNew("datamart", "DatamartStructure", true);
				$_SESSION['tmp_batch_set']['datamart_structure_id'] = $datamart_structure->getIdByModelName('ViewSample');
				$this->flash('your data has been saved', '/datamart/batch_sets/listall/0');
			}else{
				$this->SampleMaster->validationErrors = $errors;
			}
		}
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/'));
	}
}
	
?>
