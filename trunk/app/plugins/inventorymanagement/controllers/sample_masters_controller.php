<?php

class SampleMastersController extends InventorymanagementAppController {

	var $uses = array(
		'Inventorymanagement.Collection',
		
		'Inventorymanagement.SampleMaster',
		'Inventorymanagement.SampleControl',
	 	'Inventorymanagement.SpecimenDetail',		
		'Inventorymanagement.DerivativeDetail',		
		
		'Inventorymanagement.ParentToDerivativeSampleControl',
		
		'Inventorymanagement.SourceAliquot',
		'Inventorymanagement.QualityControl',
		'Inventorymanagement.PathCollectionReview',
		'Inventorymanagement.ReviewMaster',
		
		'Inventorymanagement.AliquotControl', 
		'Inventorymanagement.AliquotMaster',
		
		'Inventorymanagement.SampleToAliquotControl');
	
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
						
		$_SESSION['ctrapp_core']['search'] = null; // clear SEARCH criteria
		unset($_SESSION['InventoryManagement']['treeView']['Filter']); // clear Filter
		unset($_SESSION['InventoryManagement']['Sample']['Filter']);
		
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
		if(!$collection_id) { $this->redirect('/pages/err_inv_coll_no_id', null, true); }

		// MANAGE DATA

		// set FILTER
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
			if(!isset($specimen_sample_controls_list[$studied_specimen_sample_control_id])) { 
				unset($_SESSION['InventoryManagement']['treeView']['Filter']);
				$this->redirect('/pages/err_inv_system_error', null, true); 
			}
			$filter_value = $specimen_sample_controls_list[$studied_specimen_sample_control_id]['SampleControl']['sample_type'];
		}
		
		// Get the current menu object. 
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
	
	function listAll($collection_id, $filter_option = null) {
		if(!$collection_id) { $this->redirect('/pages/err_inv_coll_no_id', null, true); }

		// MANAGE DATA

		// Manage Session data
		if(!$filter_option) {
			// User click on collection samples menu: get existing filter
			if(isset($_SESSION['InventoryManagement']['Sample']['Filter'])) {
				$filter_option = $_SESSION['InventoryManagement']['Sample']['Filter'];
			}
		} else if($filter_option == '-1') {
			// User unactived filter
			$filter_option = null;
			unset($_SESSION['InventoryManagement']['Sample']['Filter']);
		}
		
		// Search data to display		
		$additional_criteria = array();
		$menu_link = '/inventorymanagement/sample_masters/listAll/%%Collection.id%%';
		$additional_menu_variables = array();
		$override_form_alias = null;
		$filter_value = 'all content';
		$is_derivatives_list = false;
		
		if(!is_null($filter_option)) {
			// Get filter options
			$option_for_list_all = explode("|", $filter_option);			
			if(sizeof($option_for_list_all) != 2)  { $this->redirect('/pages/err_inv_system_error', null, true); }

			switch($option_for_list_all[0]) {
				case 'SPEC_DERIV':
					// List all specimen derivatives
					$additional_criteria['SampleMaster.initial_specimen_sample_id'] = $option_for_list_all[1]; 
					$additional_criteria['SampleMaster.sample_category'] = 'derivative'; 
					
					$additional_menu_variables = array('SampleMaster.initial_specimen_sample_id' => $option_for_list_all[1]);
					$menu_link = '/inventorymanagement/sample_masters/listAll/%%Collection.id%%/SPEC_DERIV|%%SampleMaster.initial_specimen_sample_id%%';
					
					$is_derivatives_list = true;	
					$filter_value = null;			
					break;
					
				case 'CATEGORY':
					// list all collection samples according to sample category in collection listall form
					$additional_criteria['SampleMaster.sample_category'] = $option_for_list_all[1];
					$filter_value = $option_for_list_all[1];
					
					$_SESSION['InventoryManagement']['Sample']['Filter'] = $filter_option;
					break;
					
				case 'SAMP_TYPE':
					// list all collection samples according to sample type in collection listall form
					$additional_criteria['SampleMaster.sample_control_id'] = $option_for_list_all[1]; 
					
					$sample_control_data = $this->SampleControl->find('first', array('conditions' => array('SampleControl.id' => $option_for_list_all[1])));
					if(empty($sample_control_data)) { $this->redirect('/pages/err_inv_no_samp_cont_data', null, true); }	
									
					$override_form_alias = $sample_control_data['SampleControl']['form_alias'];
					$filter_value = $sample_control_data['SampleControl']['sample_type'];
					
					$_SESSION['InventoryManagement']['Sample']['Filter'] = $filter_option;
					break;
					
				default:
					$this->redirect('/pages/err_inv_funct_param_missing', null, true);								
			}
		}
		
		$criteria = $additional_criteria;
		$criteria['SampleMaster.collection_id'] = $collection_id;
		$this->data = $this->paginate($this->SampleMaster, $criteria);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS	
		$form_alias = 'samplemasters';
		if($override_form_alias) {
			$form_alias = $override_form_alias;
		} 	
		$this->set('atim_structure', $this->Structures->get('form', $form_alias));
		
		// Get all sample control types to build the add to selected button
		$specimen_sample_controls_list = $this->SampleControl->atim_list(array('conditions' => array('SampleControl.status' => 'active', 'SampleControl.sample_category' => 'specimen'), 'order' => 'SampleControl.sample_type ASC'));
		$this->set('specimen_sample_controls_list', $specimen_sample_controls_list);
		
		// Get all collection sample type list to build the filter button
		$sample_type_list = array();
		$collection_sample_type_list = $this->SampleMaster->find('all', array('fields' => 'DISTINCT SampleMaster.sample_type, SampleMaster.sample_control_id', 'conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.sample_category' => 'specimen'), 'order' => 'SampleMaster.sample_type ASC', 'recursive' => '-1'));
		foreach($collection_sample_type_list as $new_sample_type) {
			$sample_control_id = $new_sample_type['SampleMaster']['sample_control_id'];
			$sample_type = $new_sample_type['SampleMaster']['sample_type'];
			$sample_type_list[$sample_type] = $sample_control_id;
		}
		$this->set('specimen_sample_type_list', $sample_type_list);

		$sample_type_list = array();
		$collection_sample_type_list = $this->SampleMaster->find('all', array('fields' => 'DISTINCT SampleMaster.sample_type, SampleMaster.sample_control_id', 'conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.sample_category' => 'derivative'), 'order' => 'SampleMaster.sample_type ASC', 'recursive' => '-1'));
		foreach($collection_sample_type_list as $new_sample_type) {
			$sample_control_id = $new_sample_type['SampleMaster']['sample_control_id'];
			$sample_type = $new_sample_type['SampleMaster']['sample_type'];
			$sample_type_list[$sample_type] = $sample_control_id;
		}
		$this->set('derivative_sample_type_list', $sample_type_list);
		
		// Get the current menu object. 
		$atim_menu = $this->Menus->get($menu_link);
		$this->set('atim_menu', $atim_menu);
				
		// Set menu variables
		$this->set('atim_menu_variables', array_merge($additional_menu_variables, array('Collection.id' => $collection_id, 'filter_value' => $filter_value)));
				
		// Set menu variables
		$this->set('is_derivatives_list', $is_derivatives_list);
	}
	
	function detail($collection_id, $sample_master_id, $is_tree_view_detail_form = 0) {
		if((!$collection_id) || (!$sample_master_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }		
		
		// MANAGE DATA

		// Get the sample data
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id)));
		if(empty($sample_data)) { $this->redirect('/pages/err_inv_samp_no_data', null, true); }		
		
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

		$this->data = $sample_data;

		// Get parent sample information
		$parent_sample_master_id = $sample_data['SampleMaster']['parent_id'];
		$parent_sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $parent_sample_master_id), 'recursive' => '-1'));
		if(!empty($parent_sample_master_id) && empty($parent_sample_data)) { $this->redirect('/pages/err_inv_samp_no_data', null, true); }	
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

		// Get the current menu object.
		$atim_menu_link = '/inventorymanagement/sample_masters/detail/%%Collection.id%%/';
		$atim_menu = $bool_is_specimen?  $this->Menus->get($atim_menu_link . '%%SampleMaster.initial_specimen_sample_id%%') : $this->Menus->get($atim_menu_link . '%%SampleMaster.id%%');
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

		// Get all aliquot control types to build the add to selected button
		$criteria = array(
			'SampleControl.id' => $sample_data['SampleControl']['id'],
			'SampleToAliquotControl.status' => 'active',
			'AliquotControl.status' => 'active');
		$allowed_aliquot_type_temp = $this->SampleToAliquotControl->find('all', array('conditions' => $criteria, 'order' => 'AliquotControl.aliquot_type ASC'));
		
		$allowed_aliquot_type = array();
		foreach($allowed_aliquot_type_temp as $new_link) {
			$allowed_aliquot_type[$new_link['AliquotControl']['id']]['AliquotControl'] = $new_link['AliquotControl'];
		}
		
		$this->set('allowed_aliquot_type', $allowed_aliquot_type);
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
			if(empty($sample_control_data)) { $this->redirect('/pages/err_inv_no_samp_cont_data', null, true); }	
			
			// Check collection id
			$collection_data = $this->Collection->find('first', array('conditions' => array('Collection.id' => $collection_id)));
			if(empty($collection_data)) { $this->redirect('/pages/err_inv_coll_no_data', null, true); }			
			
		} else {
			// Created sample is a derivative: Get parent sample information
			$bool_is_specimen = false;
			
			// Get parent data
			$parent_sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $parent_sample_master_id), 'recursive' => '-1'));
			if(empty($parent_sample_data)) { $this->redirect('/pages/err_inv_samp_no_data', null, true); }
			
			// Get Control Data
			$criteria = array(
				'ParentSampleControl.id' => $parent_sample_data['SampleMaster']['sample_control_id'],
				'ParentToDerivativeSampleControl.status' => 'active',
				'DerivativeControl.status' => 'active',
				'DerivativeControl.id' => $sample_control_id);
			$parent_to_derivative_sample_control = $this->ParentToDerivativeSampleControl->find('first', array('conditions' => $criteria));	
			if(empty($parent_to_derivative_sample_control)) { $this->redirect('/pages/err_inv_no_samp_cont_data', null, true); }
			$sample_control_data['SampleControl'] = $parent_to_derivative_sample_control['DerivativeControl'];
		}
		
		// Set parent data
		$this->set('parent_sample_data', $parent_sample_data);
		
		// Set new sample control information
		$this->set('sample_control_data', $sample_control_data);	
		
		// Set list of available SOPs to create sample
		$this->set('arr_sample_sops', $this->getSampleSopList($sample_control_data['SampleControl']['sample_type']));
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Set menu
		$atim_menu_link = '/inventorymanagement/sample_masters/listAll/%%Collection.id%%';
		$atim_menu = $bool_is_specimen? $this->Menus->get($atim_menu_link): $this->Menus->get($atim_menu_link . '/%%SampleMaster.initial_specimen_sample_id%%');
		$this->set('atim_menu', $atim_menu);
		
		$atim_menu_variables = (empty($parent_sample_data)? array('Collection.id' => $collection_id) : array('Collection.id' => $collection_id, 'SampleMaster.initial_specimen_sample_id' => $parent_sample_data['SampleMaster']['initial_specimen_sample_id']));
		$this->set('atim_menu_variables', $atim_menu_variables);
		
		// set structure alias based on VALUE from CONTROL table
		$this->set('atim_structure', $this->Structures->get('form', $sample_control_data['SampleControl']['form_alias']));
	
		// MANAGE DATA RECORD
			
		if(!empty($this->data)) {	

			// Set control additional data
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

			// ... Currently no additional validation
						
			if($submitted_data_validates) {
				// Save sample data
				$bool_save_done = true;
				
				$sample_master_id = null;
				if($this->SampleMaster->save($this->data)) {
					$sample_master_id = $this->SampleMaster->getLastInsertId();
				} else {
					$bool_save_done = false;
				}
				
				// Record additional sample data
				if($bool_save_done) {
					$sample_data_to_update = array();
					$sample_data_to_update['SampleMaster']['sample_code'] = $this->createSampleCode($sample_master_id, $this->data, $sample_control_data);
					
					if($bool_is_specimen) {
						// System is right now able to record initial_specimen_sample_id for the specimen
						$sample_data_to_update['SampleMaster']['initial_specimen_sample_id'] = $sample_master_id;					
					}

					$this->SampleMaster->id = $sample_master_id;					
					if(!$this->SampleMaster->save($sample_data_to_update)) {
						$bool_save_done = false;
					}
				}

				//Save either Specimen or Derivative Details
				if($bool_save_done) {
					if($bool_is_specimen){
						// SpecimenDetail
						$this->data['SpecimenDetail']['sample_master_id'] = $sample_master_id;
						if(!$this->SpecimenDetail->save($this->data['SpecimenDetail'])){
							$bool_save_done = false;
						}
					} else {
						// DerivativeDetail
						$this->data['DerivativeDetail']['sample_master_id'] = $sample_master_id;
						if(!$this->DerivativeDetail->save($this->data['DerivativeDetail'])){
							$bool_save_done = false;
						}
					}
				}				
					
				if($bool_save_done) {
					$this->flash('Your data has been saved.', '/inventorymanagement/sample_masters/detail/' . $collection_id . '/' . $sample_master_id);				
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
		if(empty($sample_data)) { $this->redirect('/pages/err_inv_samp_no_data', null, true); }		

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
		if(!empty($parent_sample_master_id) && empty($parent_sample_data)) { $this->redirect('/pages/err_inv_samp_no_data', null, true); }	
		$this->set('parent_sample_data', $parent_sample_data);	

		// Set list of available SOPs to create sample
		$this->set('arr_sample_sops', $this->getSampleSopList($sample_data['SampleMaster']['sample_type']));	
	
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Get the current menu object. Needed to disable menu options based on sample category
		$atim_menu_link = '/inventorymanagement/sample_masters/detail/%%Collection.id%%/';
		$atim_menu = $bool_is_specimen?  $this->Menus->get($atim_menu_link . '%%SampleMaster.initial_specimen_sample_id%%') : $this->Menus->get($atim_menu_link . '%%SampleMaster.id%%');
		$this->set('atim_menu', $atim_menu);
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id, 'SampleMaster.id' => $sample_master_id, 'SampleMaster.initial_specimen_sample_id' => $sample_data['SampleMaster']['initial_specimen_sample_id']));
		
		// Set structure	
		$this->set('atim_structure', $this->Structures->get('form', $sample_data['SampleControl']['form_alias']));
		
		// MANAGE DATA RECORD
		
		if(empty($this->data)) {
				$this->data = $sample_data;

		} else {
			//Update data
			
			if(isset($this->data['SampleMaster']['parent_id'])) { $this->redirect('/pages/err_inv_system_error', null, true); }
			
			// Validates data
			$submitted_data_validates = true;
			
			// ... Currently no additional validation
			
			if($submitted_data_validates) {
				// Save sample data
				$bool_save_done = true;
				
				$this->SampleMaster->id = $sample_master_id;
				if(!$this->SampleMaster->save($this->data)) {
					$bool_save_done = false;
				}
				
				//Save either Specimen or Derivative Details
				if($bool_save_done) {
					if($bool_is_specimen){
						// SpecimenDetail
						$this->SpecimenDetail->id = $sample_data['SpecimenDetail']['id'];
						if(!$this->SpecimenDetail->save($this->data['SpecimenDetail'])){
							pr('2');
							$bool_save_done = false;
						}
					} else {
						// DerivativeDetail
						$this->DerivativeDetail->id = $sample_data['DerivativeDetail']['id'];
						if(!$this->DerivativeDetail->save($this->data['DerivativeDetail'])){
							pr('3');
							$bool_save_done = false;
						}
					}
				}				
				
				if($bool_save_done) {
					
//					//TODO update source aliquots use data
//					if((!$bool_is_specimen) && isset($this->data['DerivativeDetail'])){
//						$old_derivative_creation_date = $specimen_or_derivative_data['DerivativeDetail']['creation_datetime'];
//						$new_derivative_creation_date = $this->data['DerivativeDetail']['creation_datetime'];
//						if(strcmp($old_derivative_creation_date,$new_derivative_creation_date)!=0) {
//							$this->updateSourceAliquotUses($sample_master_id, $sample_master_data['SampleMaster']['sample_code'], $new_derivative_creation_date);
//						}
//					}
					
					$this->flash('Your data has been updated.', '/inventorymanagement/sample_masters/detail/' . $collection_id . '/' . $sample_master_id);				
				}						
			}
		}
	}
	
	function delete($collection_id, $sample_master_id) {
		if((!$collection_id) || (!$sample_master_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }		
		
		// Get the sample data
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id), 'recursive' => '-1'));
		if(empty($sample_data)) { $this->redirect('/pages/err_inv_samp_no_data', null, true); }		

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
		
		if($arr_allow_deletion['allow_deletion']) {
			if($this->SampleMaster->atim_delete($sample_master_id)) {
				//TODO
				pr('test deletion of master and detail level + SpecimenDetail or DerivativeDetail!');
				$this->flash('Your data has been deleted.', '/inventorymanagement/sample_masters/contentTreeView/' . $collection_id);
			} else {
				$this->flash('Error deleting data - Contact administrator.', '/inventorymanagement/sample_masters/contentTreeView/' . $collection_id);
			}
			
		} else {
			$this->flash($arr_allow_deletion['msg'], '/inventorymanagement/sample_masters/detail/' . $collection_id . '/' . $sample_master_id);
		}		
	}
	
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
		$returned_nbr = $this->QualityControl->find('count', array('conditions' => array('QualityControl.sample_master_id' => $sample_master_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'quality control exists for the deleted sample'); }

		// Check sample has not been linked to review	
		$returned_nbr = $this->PathCollectionReview->find('count', array('conditions' => array('PathCollectionReview.sample_master_id' => $sample_master_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'review exists for the deleted sample'); }

		$returned_nbr = $this->ReviewMaster->find('count', array('conditions' => array('ReviewMaster.sample_master_id' => $sample_master_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'review exists for the deleted sample'); }
		
		return array('allow_deletion' => true, 'msg' => '');
	}
	
}
	
?>