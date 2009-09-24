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
						
		$_SESSION['ctrapp_core']['search'] = null; // clear SEARCH criteria
		
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
		$atim_menu = $bool_is_specimen?  $this->Menus->get('/inventorymanagement/sample_masters/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%') : $this->Menus->get('/inventorymanagement/sample_masters/detail/%%Collection.id%%/%%SampleMaster.id%%');
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
		if((!$collection_id) || (!$sample_control_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }		
		
		// MANAGE DATA
		
		$sample_control_data = $this->SampleControl->find('first', array('conditions' => array('SampleControl.id' => $sample_control_id)));
		if(empty($sample_control_data)) { $this->redirect('/pages/err_inv_no_samp_cont_data', null, true); }	
		
		$bool_is_specimen = true;
		$parent_sample_data = array();
		switch($sample_control_data['SampleControl']['sample_category']) {
			case 'specimen':
				// Created sample is a specimen
				$bool_is_specimen = true;
				if(!empty($parent_sample_master_id)) { $this->redirect('/pages/err_inv_system_error', null, true); }
				
				// Check collection id
				$collection_data = $this->Collection->find('first', array('conditions' => array('Collection.id' => $collection_id)));
				if(empty($collection_data)) { $this->redirect('/pages/err_inv_coll_no_data', null, true); }					
				break;
				
			case 'derivative':
				// Created sample is a derivative: Get parent sample information
				$bool_is_specimen = false;
				if(empty($parent_sample_master_id)) { $this->redirect('/pages/err_inv_system_error', null, true); }
				
				// Get parent data
				$parent_sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $parent_sample_master_id), 'recursive' => '-1'));
				if(empty($parent_sample_data)) { $this->redirect('/pages/err_inv_samp_no_data', null, true); }	
				break;
				
			default:
				$this->redirect('/pages/err_inv_system_error', null, true);
		}

		// Set parent data
		$this->set('parent_sample_data', $parent_sample_data);
		
		// Set new sample control information
		$this->set('sample_control_data', $sample_control_data);	
	
		// Set list of available SOPs to create sample
		$this->set('arr_sample_sops', $this->getSampleSopList($sample_control_data['SampleControl']['sample_type']));

		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Set menu
		$atim_menu = $bool_is_specimen? $this->Menus->get('/inventorymanagement/sample_masters/listAll/%%Collection.id%%'): $this->Menus->get('/inventorymanagement/sample_masters/listAll/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%');
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
		$atim_menu = $bool_is_specimen?  $this->Menus->get('/inventorymanagement/sample_masters/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%') : $this->Menus->get('/inventorymanagement/sample_masters/detail/%%Collection.id%%/%%SampleMaster.id%%');
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
	
// --------------------------------------------------------------------------------------------------------
// --------------------------------------------------------------------------------------------------------





	

	
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
	 
	function changeSampleListFormat($specimen_group_menu_id= null, $group_specimen_type= null, $sample_category = null, 
	$collection_id= null, $sample_list_type = null, $specimen_sample_master_id = null){
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
			$bool_include_aliquot = false;
		} else if(strcmp($sample_list_type, 'include aliquot') == 0){
			$_SESSION['ctrapp_core']['inventory_management']['sample_list_type'] = 'include aliquot';
			$bool_include_aliquot = true;
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
	 
	function listall($specimen_group_menu_id= null, $group_specimen_type= null, $sample_category = null, 
	$collection_id= null, $specimen_sample_master_id= null) {
			
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
	

	

		
	/* --------------------------------------------------------------------------
	 * ADDITIONAL FUNCTIONS
	 * -------------------------------------------------------------------------- */	
	

//	
//	function updateSourceAliquotUses($sample_master_id, $use_details, $use_date) {
//		
//		$this->SourceAliquot->bindModel(array('belongsTo' => 
//			array('AliquotUse' => array(
//					'className' => 'AliquotUse',
//					'conditions' => '',
//					'order'      => '',
//					'foreignKey' => 'aliquot_use_id'))));
//		
//		$criteria = array();
//		$criteria['SourceAliquot.sample_master_id'] = $sample_master_id;
//		$criteria = array_filter($criteria);
//		
//		$aliquot_uses = $this->SourceAliquot->findAll($criteria, null, null, null, 1);
//		
//		if(!empty($aliquot_uses)) {
//			foreach($aliquot_uses as $tmp => $tested_aliquot_use_data) {
//				$this->updateAliquotUseDetailAndDate($tested_aliquot_use_data['AliquotUse']['id'], 
//					$tested_aliquot_use_data['AliquotUse']['aliquot_master_id'], 
//					$use_details, 
//					$use_date);
//			}
//		}	
//	
//	}
	

?>