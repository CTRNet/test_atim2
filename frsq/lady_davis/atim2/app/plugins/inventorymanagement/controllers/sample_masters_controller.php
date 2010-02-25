<?php

class SampleMastersController extends InventorymanagementAppController {

	var $components = array(
		'Inventorymanagement.Collections', 
		'Inventorymanagement.Samples', 
		'Inventorymanagement.Aliquots', 

		'Administrate.Administrates',
		'Sop.Sops');

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
		'Inventorymanagement.AliquotUse',
		'Inventorymanagement.QualityCtrl',
		'Inventorymanagement.PathCollectionReview',
		'Inventorymanagement.ReviewMaster',
		
		'Inventorymanagement.SampleToAliquotControl',
		
		'Administrate.Bank',
		'Sop.SopMaster',
		
		'Codingicd10.CodingIcd10');
	
	var $paginate = array(
		'SampleMaster' => array('limit' => 10, 'order' => 'SampleMaster.sample_code DESC'),
		'AliquotMaster' => array('limit' =>10 , 'order' => 'AliquotMaster.barcode DESC'));

	/* --------------------------------------------------------------------------
	 * DISPLAY FUNCTIONS
	 * -------------------------------------------------------------------------- */

	function index() {
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/collections/index'));
						
		$_SESSION['ctrapp_core']['search'] = null; // clear SEARCH criteria
		$this->unsetInventorySessionData();
		
		// Set list of banks
		$this->set('bank_list', $this->Collections->getBankList());

		$this->Structures->set('view_samplemasters');
				
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link); 
		}
	}
	
	function search() {
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/collections/index'));

		$view_sample = $this->Structures->get('form', 'view_samplemasters');
		$this->set('atim_structure', $view_sample);
		if ($this->data) $_SESSION['ctrapp_core']['search']['criteria'] = $this->Structures->parse_search_conditions($view_sample);
		
		$this->set('samples_data', $this->paginate($this->ViewSample, $_SESSION['ctrapp_core']['search']['criteria']));
		$this->data = array();
		
		// Set list of banks
		$this->set('bank_list', $this->Collections->getBankList());
				
		// if SEARCH form data, save number of RESULTS and URL
		$_SESSION['ctrapp_core']['search']['results'] = $this->params['paging']['ViewSample']['count'];
		$_SESSION['ctrapp_core']['search']['url'] = '/inventorymanagement/sample_masters/search';
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link); 
		}
	}
	
	function contentTreeView($collection_id, $studied_specimen_sample_control_id = null) {
		if(!$collection_id) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }

		// MANAGE DATA

		// Set filter
		if(!$studied_specimen_sample_control_id) {
			if(isset($_SESSION['InventoryManagement']['treeView']['Filter'])) {
				$studied_specimen_sample_control_id = $_SESSION['InventoryManagement']['treeView']['Filter'];
			}
		} else {
			if($studied_specimen_sample_control_id == '-1') {
				// User unactived filter
				$studied_specimen_sample_control_id = null;
				unset($_SESSION['InventoryManagement']['treeView']['Filter']);
			} else {
				$_SESSION['InventoryManagement']['treeView']['Filter'] = $studied_specimen_sample_control_id;
			}
		}
		
		// Get formatted collection samples data to display
		$this->data = $this->Samples->buildCollectionContentForTreeView($collection_id, $studied_specimen_sample_control_id);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS	
			 	
		$atim_structure = array();
		$atim_structure['SampleMaster']	= $this->Structures->get('form','sample_masters_for_collection_tree_view');
		$atim_structure['AliquotMaster']	= $this->Structures->get('form','aliquot_masters_for_collection_tree_view');
		$this->set('atim_structure', $atim_structure);

		// Get all sample control types to build the add to selected button
		$specimen_sample_controls_list = $this->SampleControl->atim_list(array('conditions' => array('SampleControl.status' => 'active', 'SampleControl.sample_category' => 'specimen'), 'order' => 'SampleControl.sample_type ASC'));
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

		// Set filter value
		$filter_value = null;
		if($studied_specimen_sample_control_id) {
			$sample_control_data = $this->SampleControl->find('first', array('conditions' => array('id' => $studied_specimen_sample_control_id)));
			if(empty($sample_control_data)) { 
				unset($_SESSION['InventoryManagement']['treeView']['Filter']);
				$this->redirect('/pages/err_inv_system_error', null, true); 
			}
			$filter_value = $sample_control_data['SampleControl']['sample_type'];
		}
		
		// Get the current menu object. 
		$atim_menu = $this->Menus->get('/inventorymanagement/sample_masters/contentTreeView/%%Collection.id%%');
		$this->set('atim_menu', $atim_menu);

		// Set menu variables
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id, 'FilterLevel' => 'collection', 'SampleTypeForFilter' => $filter_value));		
		
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
			$menu_variables['FilterLevel'] = 'collection';
			
			if(is_null($filter_option)) {
				// No filter
				$model_to_use = 'ViewSample';
				$form_alias = 'view_collection_samplemasters';
				
			} else  {
				// Get filter options
				$option_for_list_all = explode("|", $filter_option);			
				if(sizeof($option_for_list_all) != 2)  { $this->redirect('/pages/err_inv_system_error', null, true); }
	
				switch($option_for_list_all[0]) {
					case 'CATEGORY':
						// list all collection samples according to sample category: Either specimen or derivative
						$model_to_use = 'ViewSample';
						$form_alias = 'view_collection_samplemasters';
						
						$sample_category = $option_for_list_all[1];
						$sample_search_criteria['ViewSample.sample_category'] = $sample_category;
						$menu_variables['SampleTypeForFilter'] = $sample_category;
						break;
						
					case 'SAMP_CONT_ID':
						// list all collection samples according to sample type
						$model_to_use = 'SampleMaster';
						
						$sample_control_id = $option_for_list_all[1];
						$sample_search_criteria['SampleMaster.sample_control_id'] = $sample_control_id; 
						
						$sample_control_data = $this->SampleControl->find('first', array('conditions' => array('SampleControl.id' => $sample_control_id)));
						if(empty($sample_control_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }	
										
						$form_alias = $sample_control_data['SampleControl']['form_alias'];
						$menu_variables['SampleTypeForFilter'] = $sample_control_data['SampleControl']['sample_type'];
						
						// Set list of tissue sources
						if($sample_control_data['SampleControl']['sample_type'] == 'tissue') {
							$this->set('arr_tissue_sources', $this->getTissueSourceList());
						}
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
			$menu_variables['FilterLevel'] = 'sample';
			
			if(is_null($filter_option)) {	
				// No filter
				$model_to_use = 'ViewSample';
				$form_alias = 'view_collection_samplemasters';
						
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
						$menu_variables['SampleTypeForFilter'] = $sample_control_data['SampleControl']['sample_type'];
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
				
				// Set list of banks
				$this->set('bank_list', $this->Collections->getBankList());	
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
		if($is_collection_sample_list) { $specimen_sample_controls_list = $this->SampleControl->atim_list(array('conditions' => array('SampleControl.status' => 'active', 'SampleControl.sample_category' => 'specimen'), 'order' => 'SampleControl.sample_type ASC')); }
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
		$this->set('parent_sample_data', $parent_sample_data);	

		// Set list of available SOPs to create sample
		$this->set('sample_sop_list', $this->Samples->getSampleSopList($sample_data['SampleMaster']['sample_type']));	
		
		// Set list of tissue sources
		if($sample_data['SampleControl']['sample_type'] == 'tissue') {
			$this->set('arr_tissue_sources', $this->getTissueSourceList());
		}
	
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
		if(!$is_tree_view_detail_form) { $this->setDataForAliquotsList(array('AliquotMaster.collection_id' => $collection_id, 'AliquotMaster.sample_master_id' => $sample_master_id)); }
		
		// MANAGE FORM, MENU AND ACTION BUTTONS

		// Get the current menu object.
		$atim_menu_link = '/inventorymanagement/sample_masters/detail/%%Collection.id%%/';
		$atim_menu = $bool_is_specimen?  $this->Menus->get($atim_menu_link . '%%SampleMaster.initial_specimen_sample_id%%') : $this->Menus->get($atim_menu_link . '%%SampleMaster.id%%');
		$this->set('atim_menu', $atim_menu);
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id, 'SampleMaster.id' => $sample_master_id, 'SampleMaster.initial_specimen_sample_id' => $sample_data['SampleMaster']['initial_specimen_sample_id']));
		
		// Set structure
		$this->Structures->set($sample_data['SampleControl']['form_alias']);	
		if(!$is_tree_view_detail_form) { $this->Structures->set('aliquotmasters_for_sample_details', 'aliquots_listall_structure');	}

		// Define if this detail form is displayed into the collection content tree view
		$this->set('is_tree_view_detail_form', $is_tree_view_detail_form);
		
		// Define if this detail form is displayed into a form of the inventory plugin
		$this->set('is_inventory_plugin_form', $is_inventory_plugin_form);
		
		// Get all sample control types to build the add to selected button
		$this->set('allowed_derivative_type', $this->getAllowedDerivativeTypes($sample_data['SampleControl']['id']));

		// Get all aliquot control types to build the add to selected button
		$this->set('allowed_aliquot_type', $this->getAllowedAliquotTypes($sample_data['SampleControl']['id']));

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
				'ParentToDerivativeSampleControl.status' => 'active',
				'DerivativeControl.status' => 'active',
				'DerivativeControl.id' => $sample_control_id);
			$parent_to_derivative_sample_control = $this->ParentToDerivativeSampleControl->find('first', array('conditions' => $criteria));	
			if(empty($parent_to_derivative_sample_control)) { $this->redirect('/pages/err_inv_no_data', null, true); }
			$sample_control_data['SampleControl'] = $parent_to_derivative_sample_control['DerivativeControl'];
		}
		
		// Set parent data
		$this->set('parent_sample_data', $parent_sample_data);
		
		// Set new sample control information
		$this->set('sample_control_data', $sample_control_data);	
		
		// Set list of available SOPs to create sample
		$this->set('sample_sop_list', $this->Samples->getSampleSopList($sample_control_data['SampleControl']['sample_type']));
		
		// Set list of tissue sources
		if($sample_control_data['SampleControl']['sample_type'] == 'tissue') {
			$this->set('arr_tissue_sources', $this->getTissueSourceList());
		}
	
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
		
			//Set default reception date
			if($bool_is_specimen){
				if($this->SampleMaster->find('count', array('conditions' => array('SampleMaster.collection_id' => $collection_id))) == 0){
					$collection = $this->Collection->find('first', array('conditions' => array('Collection.id' => $collection_id)));
					$default_reception_datetime = $collection['Collection']['collection_datetime'];
				}else{
					$sample = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id), 'fields' => array('MIN(SpecimenDetail.reception_datetime) AS reception_datetime')));
					$default_reception_datetime = $sample[0]['reception_datetime'];
				}
				$this->data['SpecimenDetail']['reception_datetime'] = $default_reception_datetime;
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
  	  			  	
			// Replace ',' to '.' for volume
			$this->data = $this->formatSampleFieldDecimalData($this->data);
						
			// Validates data
			
			$submitted_data_validates = true;
			
			$this->SampleMaster->set($this->data);
			$submitted_data_validates = ($this->SampleMaster->validates())? $submitted_data_validates: false;
			
			$this->SampleDetail->set($this->data);
			$submitted_data_validates = ($this->SampleDetail->validates())? $submitted_data_validates: false;
			
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
					
					$this->flash('your data has been saved', '/inventorymanagement/sample_masters/detail/' . $collection_id . '/' . $sample_master_id);	
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
		$this->set('parent_sample_data', $parent_sample_data);	

		// Set list of available SOPs to create sample
		$this->set('sample_sop_list', $this->Samples->getSampleSopList($sample_data['SampleMaster']['sample_type']));	
		
		// Set list of tissue sources
		if($sample_data['SampleMaster']['sample_type'] == 'tissue') {
			$this->set('arr_tissue_sources', $this->getTissueSourceList());
		}
	
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

			// Replace ',' to '.' for volume
			$this->data = $this->formatSampleFieldDecimalData($this->data);
									
			// Validates data
			
			$submitted_data_validates = true;
			
			$this->SampleMaster->set($this->data);
			$submitted_data_validates = ($this->SampleMaster->validates())? $submitted_data_validates: false;
			
			$this->SampleDetail->set($this->data);
			$submitted_data_validates = ($this->SampleDetail->validates())? $submitted_data_validates: false;
			
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
				$this->SampleMaster->id = $sample_master_id;
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
					
						// Update source aliquot use data
						//TODO Add test to verifiy date and created_by have been modified  before to launch update function
						$source_aliquots = $this->SourceAliquot->find('all', array('conditions' => array('SourceAliquot.sample_master_id' => $sample_master_id), 'recursive' => '-1'));
						if(!empty($source_aliquots)) {
							$use_ids = array();
							foreach($source_aliquots as $source_data) {
								$use_ids[] = $source_data['SourceAliquot']['aliquot_use_id'];
							}
							if(!$this->Aliquots->updateAliquotUses($use_ids, $this->data['DerivativeDetail']['creation_datetime'], $this->data['DerivativeDetail']['creation_by'])) { $this->redirect('/pages/err_inv_system_error', null, true); }
						}
					}

					$this->flash('your data has been updated', '/inventorymanagement/sample_masters/detail/' . $collection_id . '/' . $sample_master_id);		
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
				$this->flash('your data has been deleted', '/inventorymanagement/sample_masters/contentTreeView/' . $collection_id);
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
		$returned_nbr = $this->PathCollectionReview->find('count', array('conditions' => array('PathCollectionReview.sample_master_id' => $sample_master_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'review exists for the deleted sample'); }

		$returned_nbr = $this->ReviewMaster->find('count', array('conditions' => array('ReviewMaster.sample_master_id' => $sample_master_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'review exists for the deleted sample'); }
		
		return array('allow_deletion' => true, 'msg' => '');
	}

	/**
	 * Get list of organs a sample tissue could come from.
	 *
	 * @author N. Luc
	 * @since 2009-09-11
	 * @updated N. Luc
	 */
	 
	function getTissueSourceList() {
		//TODO Define content of tissue_source list
		$res = $this->CodingIcd10->find('all', array('fields' => 'DISTINCT site', 'order' => 'site ASC', 'conditions' => array('site != \'\'')));
		$final_arr = array();
		if(!empty($res)) { foreach($res as $data) { $final_arr[strtolower($data['CodingIcd10']['site'])] = $data['CodingIcd10']['site']; }}
		return $final_arr;
	}
	
	/**
	 * Replace ',' by '.' for all decimal field values gathered into 
	 * data submitted for sample creation or modification.
	 * 
	 * @param $submtted_data Submitted data
	 * 
	 * @return Formatted data.
	 *
	 * @author N. Luc
	 * @since 2009-09-11
	 */	
	
	function formatSampleFieldDecimalData($submtted_data) {
		if(isset($submtted_data['SampleDetail']['collected_volume'])) { $submtted_data['SampleDetail']['collected_volume'] = str_replace(',', '.', $submtted_data['SampleDetail']['collected_volume']); }				
		if(isset($submtted_data['SampleDetail']['pellet_volume'])) { $submtted_data['SampleDetail']['pellet_volume'] = str_replace(',', '.', $submtted_data['SampleDetail']['pellet_volume']); }				
		return $submtted_data;
	}
}
	
?>