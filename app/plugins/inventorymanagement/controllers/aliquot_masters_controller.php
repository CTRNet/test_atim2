<?php

class AliquotMastersController extends InventoryManagementAppController {
	
	/*
	var $uses = array(
			'AliquotControl', 
			'AliquotMaster', 
			'AliquotUse', 
			'Collection',
			'DerivativeDetail',
			'OrderItem',
			'PathCollectionReview',
			'QualityCtrl', 
			
			'ReviewMaster',
			'SampleAliquotControlLink', 
			'SampleControl', 
			'SampleMaster',
			'SopMaster', 
			'SourceAliquot', 
			'StorageMaster',
			'StudySummary'
	);
	*/

	var $components = array('Inventorymanagement.Aliquots', 'Study.StudySummaries', 'Storagelayout.Storages');
	
	var $uses = array(
		'Inventorymanagement.Collection',
		
		'Inventorymanagement.SampleMaster',
		'Inventorymanagement.DerivativeDetail',
		
		'Inventorymanagement.SampleControl',
		'Inventorymanagement.SampleToAliquotControl',
		
		'Inventorymanagement.AliquotControl', 
		'Inventorymanagement.AliquotMaster',
		'Inventorymanagement.AliquotDetail',			
		
		'Inventorymanagement.SampleToAliquotControl',
		
		'Inventorymanagement.AliquotUse',
		'Inventorymanagement.Realiquoting',
		'Inventorymanagement.PathCollectionReview',
		
		'Inventorymanagement.OrderItem',
		
		'Storagelayout.StorageMaster',
		
		'Study.StudySummary'
	);
	
	var $paginate = array('AliquotMaster'=>array('limit'=>10,'order' => 'AliquotMaster.barcode DESC'));

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
		$this->unsetInventorySessionData();
		
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
		$this->setAliquotSearchData($_SESSION['ctrapp_core']['search']['criteria']);
				
		// if SEARCH form data, save number of RESULTS and URL
		$_SESSION['ctrapp_core']['search']['results'] = $this->params['paging']['AliquotMaster']['count'];
		$_SESSION['ctrapp_core']['search']['url'] = '/inventorymanagement/aliquot_masters/search';
	}
	
	function setAliquotSearchData($criteria) {
		// Search Data
		$has_one_details = array(
			'hasMany' => array(
				'RealiquotedParent' => array(
					'className' => 'Inventorymanagement.Realiquoting',
					'foreignKey' => 'child_aliquot_master_id'),
				'ChildrenAliquot' => array(
					'className' => 'Inventorymanagement.Realiquoting',
					'foreignKey' => 'parent_aliquot_master_id')));
		
		$this->AliquotMaster->bindModel($has_one_details, false);	
		$working_data = $this->paginate($this->AliquotMaster, $criteria);
		$this->AliquotMaster->unbindModel(array('hasMany' => array('RealiquotedParent', 'ChildrenAliquot')), false);
		
		// Manage Data
		$key_to_sample_parent_id = array();
		foreach($working_data as $key => $aliquot_data) {
			// Set aliquot use
			$working_data[$key]['Generated']['generated_field_use'] = sizeof($aliquot_data['AliquotUse']);
			
			// Set realiquoting data
			$realiquoting_value = 0;
			$realiquoting_value += (sizeof($aliquot_data['ChildrenAliquot']))? 1: 0;
			$realiquoting_value += (sizeof($aliquot_data['RealiquotedParent']))? 2: 0;
			
			switch($realiquoting_value) {
				case '0':
					$working_data[$key]['Generated']['realiquoting_data'] = 'n/a';
					break;
				case '1':
					$working_data[$key]['Generated']['realiquoting_data'] = 'parent';
					break;
				case '2':
					$working_data[$key]['Generated']['realiquoting_data'] = 'child';
					break;
				case '3':
					$working_data[$key]['Generated']['realiquoting_data'] = 'parent/child';
					break;	
			}
			
			// Build GeneratedParentSample
			$working_data[$key]['GeneratedParentSample'] = array();
			if(!empty($aliquot_data['SampleMaster']['parent_id'])) { $key_to_sample_parent_id[$key] = $aliquot_data['SampleMaster']['parent_id']; }
		}
		
		// Add GeneratedParentSample Data
		$parent_sample_data = $this->SampleMaster->atim_list(array('conditions' => array('SampleMaster.id' => $key_to_sample_parent_id), 'recursive' => '-1'));
		foreach($key_to_sample_parent_id as $key => $parent_id) {
			if(!isset($parent_sample_data[$parent_id])) { $this->redirect('/pages/err_inv_system_error', null, true); }
			$working_data[$key]['GeneratedParentSample'] = $parent_sample_data[$parent_id]['SampleMaster'];
		}
		
		$this->data = $working_data;
		
		// Set list of banks
		$this->set('banks', $this->getBankList());
	}
	
	function listAll($collection_id, $sample_master_id, $filter_option = null) {
		if((!$collection_id) || (!$sample_master_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }		
		
		// MANAGE FILTER OPTION
		
		$is_collection_aliquot_list = ($sample_master_id == '-1')? true: false;
		
		$specific_aliquot_search_criteria = array();
		$specific_form_alias = null;
		$specific_menu_variables = array();
		
		if($is_collection_aliquot_list) {
			// User is working on collection aliquots list
			
			// Manage filter option
			if(is_null($filter_option)) {
				if(isset($_SESSION['InventoryManagement']['CollectionAliquots']['Filter'])) { 
					// Get existing filter
					$filter_option = $_SESSION['InventoryManagement']['CollectionAliquots']['Filter']; 
				}
			} else if($filter_option == '-1') {
				// User inactived filter
				$filter_option = null;
				unset($_SESSION['InventoryManagement']['CollectionAliquots']['Filter']);
			}
			
			// Search data to display	
			$specific_menu_variables['FilterLevel'] = 'collection';
	
			if(!is_null($filter_option)) {
				// Get filter options
				$option_for_list_all = explode("|", $filter_option);			
				if(sizeof($option_for_list_all) != 2)  { $this->redirect('/pages/err_inv_system_error', null, true); }
				$sample_control_id = $option_for_list_all[0];
				$aliquot_control_id = $option_for_list_all[1];
				
				$specific_aliquot_search_criteria['SampleMaster.sample_control_id'] = $sample_control_id;	
				$specific_aliquot_search_criteria['AliquotMaster.aliquot_control_id'] = $aliquot_control_id; 

				$sample_control_data = $this->SampleControl->find('first', array('conditions' => array('SampleControl.id' => $sample_control_id)));
				if(empty($sample_control_data)) { $this->redirect('/pages/err_inv_no_samp_cont_data', null, true); }	
				$specific_menu_variables['SampleTypeForFilter'] = $sample_control_data['SampleControl']['sample_type'];
				
				$aliquot_control_data = $this->AliquotControl->find('first', array('conditions' => array('AliquotControl.id' => $option_for_list_all[1])));
				if(empty($aliquot_control_data)) { $this->redirect('/pages/err_inv_no_aliqu_cont_data', null, true); }					
				$specific_form_alias = $aliquot_control_data['AliquotControl']['form_alias'];
				$specific_menu_variables['AliquotTypeForFilter'] = $aliquot_control_data['AliquotControl']['aliquot_type'];	
				
				// Set filter option in session
				$_SESSION['InventoryManagement']['CollectionAliquots']['Filter'] = $filter_option;
			}			
			
		} else {
			// User is working on sample aliquots list	
			$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id), 'recursive' => '-1'));
			if(empty($sample_data)) { $this->redirect('/pages/err_inv_samp_no_data', null, true); }		
			$specific_menu_variables['SampleMaster.initial_specimen_sample_id'] = $sample_data['SampleMaster']['initial_specimen_sample_id'];
			$specific_menu_variables['SampleMaster.id'] = $sample_data['SampleMaster']['id'];

			// Set sample master id into criteria
			$specific_aliquot_search_criteria['AliquotMaster.sample_master_id'] = $sample_master_id; 
					
			// Manage filter option
			if(is_null($filter_option)) {
				// Get existing filter
				if(isset($_SESSION['InventoryManagement']['SampleAliquots']['Filter'])) { 
					if($_SESSION['InventoryManagement']['SampleAliquots']['Filter']['SampleMasterId'] != $sample_master_id) {
						// New studied sample: clear filter option
						$filter_option = null;
						unset($_SESSION['InventoryManagement']['SampleAliquots']['Filter']);						
						
					} else {
						// Get existing filter
						$filter_option = $_SESSION['InventoryManagement']['SampleAliquots']['Filter']['Option']; 
					}
				}
			} else if($filter_option == '-1') {
				// User inactived filter
				$filter_option = null;
				unset($_SESSION['InventoryManagement']['SampleAliquots']['Filter']);
			}
			
			// Search data to display	
			$specific_menu_variables['FilterLevel'] = 'sample';
				
			if(!is_null($filter_option)) {
				// Get filter options (being sample_control_id and aliquot_control_id)
				$option_for_list_all = explode("|", $filter_option);			
				if(sizeof($option_for_list_all) != 2)  { $this->redirect('/pages/err_inv_system_error', null, true); }
				$sample_control_id = $option_for_list_all[0];
				$aliquot_control_id = $option_for_list_all[1];
				
				$specific_aliquot_search_criteria['AliquotMaster.aliquot_control_id'] = $aliquot_control_id; 
				
				$aliquot_control_data = $this->AliquotControl->find('first', array('conditions' => array('AliquotControl.id' => $option_for_list_all[1])));
				if(empty($aliquot_control_data)) { $this->redirect('/pages/err_inv_no_aliqu_cont_data', null, true); }					
				$specific_form_alias = $aliquot_control_data['AliquotControl']['form_alias'];
				$specific_menu_variables['AliquotTypeForFilter'] = $aliquot_control_data['AliquotControl']['aliquot_type'];	
				
				// Set filter option in session
				$_SESSION['InventoryManagement']['SampleAliquots']['Filter'] = array(
					'SampleMasterId' => $sample_master_id,
					'Option' => $filter_option);
			}			
		}

		// MANAGE DATA
				
		$this->setAliquotSearchData(array_merge(array('AliquotMaster.collection_id' => $collection_id), $specific_aliquot_search_criteria));		

		// MANAGE FORM, MENU AND ACTION BUTTONS	
		$form_alias = (is_null($specific_form_alias))? 'aliquotmasters': $specific_form_alias;
		$this->set('atim_structure', $this->Structures->get('form', $form_alias));
		
		// Get all collection/sample 'sample aliquot type list' to build the filter button
		$sample_aliquot_types = array();
		$criteria = array('AliquotMaster.collection_id' => $collection_id);
		if(!$is_collection_aliquot_list) { $criteria['AliquotMaster.sample_master_id'] = $sample_master_id; }
		$tmp_sample_aliquot_type_list = $this->AliquotMaster->find('all', array('fields' => 'DISTINCT SampleMaster.sample_type, SampleMaster.sample_control_id, AliquotMaster.aliquot_type, AliquotMaster.aliquot_control_id', 'conditions' => $criteria, 'order' => 'SampleMaster.sample_type ASC, AliquotMaster.aliquot_type ASC', 'recursive' => '0'));
		foreach($tmp_sample_aliquot_type_list as $new_sample_aliquot_type) {
			// TODO: Should create key because looks like it's not a real distinct: Perhaps exists a better solution 
			$sample_control_id = $new_sample_aliquot_type['SampleMaster']['sample_control_id'];
			$aliquot_control_id = $new_sample_aliquot_type['AliquotMaster']['aliquot_control_id'];
			$sample_aliquot_types[$sample_control_id . '|' . $aliquot_control_id] = array(
				'sample_type' => $new_sample_aliquot_type['SampleMaster']['sample_type'],
				'sample_control_id' => $new_sample_aliquot_type['SampleMaster']['sample_control_id'],
				'aliquot_type' => $new_sample_aliquot_type['AliquotMaster']['aliquot_type'],
				'aliquot_control_id' => $new_sample_aliquot_type['AliquotMaster']['aliquot_control_id']);
		}
		$this->set('existing_sample_aliquot_types', $sample_aliquot_types);

		// Get the current menu object
		$last_menu_parameter = '-1';
		if(!$is_collection_aliquot_list) {	
			// User is working on sample aliquots
			if($specific_menu_variables['SampleMaster.initial_specimen_sample_id'] == $specific_menu_variables['SampleMaster.id']) {
				// Studied sample is a specimen
				$last_menu_parameter = '%%SampleMaster.initial_specimen_sample_id%%';
			} else {
				// Studied sample is a derivative
				$last_menu_parameter = '%%SampleMaster.id%%';	
			}
		}	
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/aliquot_masters/listAll/%%Collection.id%%/' . $last_menu_parameter));
				
		// Set menu variables
		$atim_menu_variables = array_merge(array('Collection.id' => $collection_id), $specific_menu_variables);
		$this->set('atim_menu_variables', $atim_menu_variables);
	}
	
	function add($collection_id, $sample_master_id, $aliquot_control_id) {
		if((!$collection_id) || (!$sample_master_id) || (!$aliquot_control_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }		
		
		// MANAGE DATA

		// Get Sample Data
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id), 'recursive' => '-1'));
		if(empty($sample_data)) { $this->redirect('/pages/err_inv_samp_no_data', null, true); }	
		
		$bool_is_specimen = null;
		switch($sample_data['SampleMaster']['sample_category']) {
			case 'specimen':
				$bool_is_specimen = true;
				break;
			case 'derivative':
				$bool_is_specimen = false;
				break;
			default:
				$this->redirect('/pages/err_inv_system_error', null, true);
		}
		
		// Get control data
		$criteria = array(
			'SampleControl.id' => $sample_data['SampleMaster']['sample_control_id'],
			'SampleToAliquotControl.status' => 'active',
			'AliquotControl.status' => 'active',
			'AliquotControl.id' => $aliquot_control_id);
		$sample_to_aliquot_control = $this->SampleToAliquotControl->find('first', array('conditions' => $criteria));	
		if(empty($sample_to_aliquot_control)) { $this->redirect('/pages/err_inv_no_aliqu_cont_data', null, true); }			
		$aliquot_control_data = array('AliquotControl' => $sample_to_aliquot_control['AliquotControl']);
		
		// Set new aliquot control information
		$this->set('aliquot_control_data', $aliquot_control_data);	
		
		// Set list of available SOPs to create aliquot
		$this->set('arr_aliquot_sops', $this->getAliquotSopList($sample_data['SampleMaster']['sample_type'], $aliquot_control_data['AliquotControl']['aliquot_type']));

		// Set list of studies
		$this->set('arr_studies', $this->getStudiesList());
		
		// Set list of sample blocks (will only works for sample type being linked to block type)
		$this->set('arr_sample_blocks', $this->getSampleBlocksList($sample_data));

		// Set list of sample gel matrices (will only works for sample type being linked to gel matrix type)
		$this->set('arr_sample_gel_matrices', $this->getSampleGelMatricesList($sample_data));
				
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Set menu
		$atim_menu_link = '/inventorymanagement/aliquot_masters/listall/%%Collection.id%%/';
		$atim_menu = $bool_is_specimen? $this->Menus->get($atim_menu_link . '%%SampleMaster.initial_specimen_sample_id%%'): $this->Menus->get($atim_menu_link . '%%SampleMaster.id%%');
		$this->set('atim_menu', $atim_menu);
		
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id, 'SampleMaster.id' => $sample_master_id, 'SampleMaster.initial_specimen_sample_id' => $sample_data['SampleMaster']['initial_specimen_sample_id']));
		
		// set structure alias based on VALUE from CONTROL table
		$this->set('atim_structure', $this->Structures->get('form', $aliquot_control_data['AliquotControl']['form_alias']));	
	
		// MANAGE DATA RECORD

		if (empty($this->data)) {
			// Initial Display
			$this->set('default_storage_datetime', $this->getDefaultAliquotStorageDate($sample_data));
			$this->set('arr_preselected_storages', array());
						
			//TODO: form should be a datagrid with 'add record'/'remove record' buttons
			$this->data = array(array('AliquotMaster' => array()), array('AliquotMaster' => array()), array('AliquotMaster' => array()));
			
		} else {
// TODO used to correct a bug
unset($this->data['AliquotMaster']);	
			
			// Set current volume
			foreach($this->data as $id => $data) {
				if(array_key_exists('initial_volume', $this->data['AliquotMaster'])){
					// TODO Perhaps could code lines be moved to model?
					if(empty($aliquot_control_data['AliquotControl']['volume_unit'])) { $this->redirect('/pages/err_inv_system_error', null, true); }
					$this->data[$id]['AliquotMaster']['current_volume'] = $this->data[$id]['AliquotMaster']['initial_volume'];				
				}
			}
			
			// Launch validations
			$submitted_data_validates = true;
			
			// -> Barcode validation
			if($this->isDuplicatedAliquotBarcode($this->data)) {
				$submitted_data_validates = false;
			}
			
			// -> Storage definition validation
			if(!$this->validateAliquotStorageData($this->data)) {
				$submitted_data_validates = false;
			}			
		
			// -> Fields validation
			foreach($this->data as $id => $new_aliquot) {
				// TODO validates AliquotMaster
				// TODO validates AliquotDetail			
			}
			
			// Save data
			if($submitted_data_validates) {
				$bool_save_done = true;

				// TODO save correctly AliquotMaster				
				foreach($this->data as $id => $new_aliquot) { 
					// Set additional data
					$new_aliquot['AliquotMaster']['id'] = null;
					$new_aliquot['AliquotMaster']['collection_id'] = $collection_id;
					$new_aliquot['AliquotMaster']['sample_master_id'] = $sample_master_id;
					$new_aliquot['AliquotMaster']['aliquot_control_id'] = $aliquot_control_id;
					$new_aliquot['AliquotMaster']['aliquot_type'] = $aliquot_control_data['AliquotControl']['aliquot_type'];
	
					if(!$this->AliquotMaster->save($new_aliquot)) { $bool_save_done = false; } 
				}
				
				if($bool_save_done) {
					$this->flash('Your data has been saved . ', '/inventorymanagement/aliquot_masters/listAll/' . $collection_id . '/' . $sample_master_id);				
				}						
			}	
		}
	}
	
	function detail($collection_id, $sample_master_id, $aliquot_master_id, $is_tree_view_detail_form = 0, $is_collection_tree_view = 0) {
		if((!$collection_id) || (!$sample_master_id) || (!$aliquot_master_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }		
			
		// MANAGE DATA

		// Get the aliquot data
		$aliquot_data = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.collection_id' => $collection_id, 'AliquotMaster.sample_master_id' => $sample_master_id, 'AliquotMaster.id' => $aliquot_master_id)));
		if(empty($aliquot_data)) { $this->redirect('/pages/err_inv_aliquot_no_data', null, true); }		

		// Set aliquot use
		$aliquot_data['Generated']['use'] = sizeof($aliquot_data['AliquotUse']);

// TODO: Is it necessary to call this function updateAliquotCurrentVolume()
				
		$this->data = $aliquot_data;
		
		// Set list of available SOPs to create aliquot
		$this->set('arr_aliquot_sops', $this->getAliquotSopList($aliquot_data['SampleMaster']['sample_type'], $aliquot_data['AliquotMaster']['aliquot_type']));

		// Set list of studies
		$this->set('arr_studies', $this->getStudiesList());
		
		// Set list of sample blocks (will only works for sample type being linked to block type)
		$this->set('arr_sample_blocks', $this->getSampleBlocksList(array('SampleMaster' => $aliquot_data['SampleMaster'])));

		// Set list of sample gel matrices (will only works for sample type being linked to gel matrix type)
		$this->set('arr_sample_gel_matrices', $this->getSampleGelMatricesList(array('SampleMaster' => $aliquot_data['SampleMaster'])));

		// Set times spent since either sample collection/reception or sample creation and sample storage					
		switch($aliquot_data['SampleMaster']['sample_category']) {
			case 'specimen':
				$this->set('coll_to_stor_spent_time_msg', $this->getSpentTime($aliquot_data['Collection']['collection_datetime'], $aliquot_data['AliquotMaster']['storage_datetime']));
				$this->set('rec_to_stor_spent_time_msg', $this->getSpentTime($aliquot_data['Collection']['reception_datetime'], $aliquot_data['AliquotMaster']['storage_datetime']));
				break;
				
			case 'derivative':
				$derivative_detail_data = $this->DerivativeDetail->find('first', array('conditions' => array('DerivativeDetail.sample_master_id' => $sample_master_id)));
				if(empty($derivative_detail_data)) { $this->redirect('/pages/err_inv_missing_samp_data', null, true); }	
				$this->set('creat_to_stor_spent_time_msg', $this->getSpentTime($derivative_detail_data['DerivativeDetail']['creation_datetime'], $aliquot_data['AliquotMaster']['storage_datetime']));
				break;
				
			default:
				$this->redirect('/pages/err_inv_system_error', null, true);
		}
		
		// Set storage data
		$this->set('aliquot_storage_data', empty($this->data['StorageMaster']['id'])? array(): array('StorageMaster' => $this->data['StorageMaster']));
		
		// MANAGE FORM, MENU AND ACTION BUTTONS

		// Get the current menu object.
		$atim_menu_link = ($aliquot_data['SampleMaster']['sample_category'] == 'specimen')? '/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%AliquotMaster.id%%': '/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%';
		$atim_menu = $this->Menus->get($atim_menu_link);
		$this->set('atim_menu', $atim_menu);
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id, 'SampleMaster.id' => $sample_master_id, 'SampleMaster.initial_specimen_sample_id' => $aliquot_data['SampleMaster']['initial_specimen_sample_id'], 'AliquotMaster.id' => $aliquot_master_id));
		
		// Set structure
		$this->set('atim_structure', $this->Structures->get('form', $aliquot_data['AliquotControl']['form_alias']));

		// Define if this detail form is displayed into the collection content tree view
		$this->set('is_tree_view_detail_form', $is_tree_view_detail_form);
		$this->set('is_collection_tree_view', $is_collection_tree_view);
	}
	
	function edit($collection_id, $sample_master_id, $aliquot_master_id) {
		if((!$collection_id) || (!$sample_master_id) || (!$aliquot_master_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }		
		
		// MANAGE DATA

		// Get the aliquot data
			
		$aliquot_data = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.collection_id' => $collection_id, 'AliquotMaster.sample_master_id' => $sample_master_id, 'AliquotMaster.id' => $aliquot_master_id)));
		if(empty($aliquot_data)) { $this->redirect('/pages/err_inv_aliquot_no_data', null, true); }		

		// Set list of available SOPs to create aliquot
		$this->set('arr_aliquot_sops', $this->getAliquotSopList($aliquot_data['SampleMaster']['sample_type'], $aliquot_data['AliquotMaster']['aliquot_type']));

		// Set list of studies
		$this->set('arr_studies', $this->getStudiesList());
		
		// Set list of sample blocks (will only works for sample type being linked to block type)
		$this->set('arr_sample_blocks', $this->getSampleBlocksList(array('SampleMaster' => $aliquot_data['SampleMaster'])));

		// Set list of sample gel matrices (will only works for sample type being linked to gel matrix type)
		$this->set('arr_sample_gel_matrices', $this->getSampleGelMatricesList(array('SampleMaster' => $aliquot_data['SampleMaster'])));
	
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Get the current menu object.
		$atim_menu_link = ($aliquot_data['SampleMaster']['sample_category'] == 'specimen')? '/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%AliquotMaster.id%%': '/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%';
		$atim_menu = $this->Menus->get($atim_menu_link);
		$this->set('atim_menu', $atim_menu);
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id, 'SampleMaster.id' => $sample_master_id, 'SampleMaster.initial_specimen_sample_id' => $aliquot_data['SampleMaster']['initial_specimen_sample_id'], 'AliquotMaster.id' => $aliquot_master_id));
		
		// Set structure
		$this->set('atim_structure', $this->Structures->get('form', $aliquot_data['AliquotControl']['form_alias']));
		
		// MANAGE DATA RECORD
		
		if(empty($this->data)) {
			$this->data = $aliquot_data;
			$this->set('arr_preselected_storages', empty($aliquot_data['StorageMaster']['id'])? array(): array($aliquot_data['StorageMaster']['id'] => array('StorageMaster' => $aliquot_data['StorageMaster'])));
			
		} else {
			//Update data
			if(array_key_exists('initial_volume', $this->data['AliquotMaster']) && empty($aliquot_control_data['AliquotControl']['volume_unit'])) { $this->redirect('/pages/err_inv_system_error', null, true); }
									
			// Launch validations
			$submitted_data_validates = true;
			
			// -> Storage definition validation
			if(!$this->validateAliquotStorageData($this->data)) {
				$submitted_data_validates = false;
			}			
			
			// ... Currently no additional validation
			
			// Save data
			if($submitted_data_validates) {
				$bool_save_done = true;
				
				$this->AliquotMaster->id = $aliquot_master_id;
				if(!$this->AliquotMaster->save($this->data)) {
					$bool_save_done = false;
				}
				
				if(!$this->Aliquots->updateAliquotCurrentVolume($aliquot_master_id)) {
					$this->redirect('/pages/err_inv_aliquot_record_err', null, true);
				}
				
				if($bool_save_done) {			
					$this->flash('Your data has been updated . ', '/inventorymanagement/aliquot_masters/detail/' . $collection_id . '/' . $sample_master_id. '/' . $aliquot_master_id);				
				}
			}
		}
	}
	
	function removeAliquotFromStorage($collection_id, $sample_master_id, $aliquot_master_id) {
		if((!$collection_id) || (!$sample_master_id) || (!$aliquot_master_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }		
		
		// MANAGE DATA

		// Get the aliquot data
		$aliquot_data = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.collection_id' => $collection_id, 'AliquotMaster.sample_master_id' => $sample_master_id, 'AliquotMaster.id' => $aliquot_master_id)));
		if(empty($aliquot_data)) { $this->redirect('/pages/err_inv_aliquot_no_data', null, true); }		
		
		// Delete storage data
		$this->AliquotMaster->id = $aliquot_master_id;
		if(!$this->AliquotMaster->save(array('AliquotMaster' => array('storage_master_id' => null, 'storage_coord_x' => null, 'storage_coord_y' => null)))) {
			$this->redirect('/pages/err_inv_aliquot_record_err', null, true);
		}
		
		$this->flash('Your data has been updated . ', '/inventorymanagement/aliquot_masters/detail/' . $collection_id . '/' . $sample_master_id. '/' . $aliquot_master_id);				
	}
	
	function delete($collection_id, $sample_master_id, $aliquot_master_id) {
		if((!$collection_id) || (!$sample_master_id) || (!$aliquot_master_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }		
	
		// Get the aliquot data
		$aliquot_data = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.collection_id' => $collection_id, 'AliquotMaster.sample_master_id' => $sample_master_id, 'AliquotMaster.id' => $aliquot_master_id)));
		if(empty($aliquot_data)) { $this->redirect('/pages/err_inv_aliquot_no_data', null, true); }		
		
		// Check deletion is allowed
		$arr_allow_deletion = $this->allowAliquotDeletion($aliquot_master_id);
			
		if($arr_allow_deletion['allow_deletion']) {
			if($this->AliquotMaster->atim_delete($aliquot_master_id)) {
				//TODO There is a problem with flash function
				pr('test deletion of master and detail level!');
				pr('/inventorymanagement/aliquot_masters/listAll/' . $collection_id . '/' . $sample_master_id);
				$this->flash('Your data has been deleted . ', '/inventorymanagement/aliquot_masters/listAll/' . $collection_id . '/' . $sample_master_id);
				exit;
			} else {
				$this->flash('Error deleting data - Contact administrator . ', '/inventorymanagement/aliquot_masters/listAll/' . $collection_id . '/' . $sample_master_id);
			}
		} else {
			$this->flash($arr_allow_deletion['msg'], '/inventorymanagement/aliquot_masters/detail/' . $collection_id . '/' . $sample_master_id . '/' . $aliquot_master_id);
		}		
	}
	
	
	/* --------------------------------------------------------------------------
	 * ADDITIONAL FUNCTIONS
	 * -------------------------------------------------------------------------- */
	
	/**
	 * Get list of SOPs existing to build aliquot.
	 * 
	 * Note: Function to allow bank to customize this function when they don't use 
	 * SOP module.
	 *
	 *	@param $sample_type Sample Type
	 *	@param $aliquot_type Aliquot Type
	 *
	 * @return Array gathering all sops
	 *
	 * @author N. Luc
	 * @since 2009-09-11
	 * @updated N. Luc
	 */
	 
	function getAliquotSopList($sample_type, $aliquot_type) {
		return $this->getSopList('aliquot');
	}
	
	/**
	 * Get list of Studies existing into the system.
	 * 
	 * Note: Function to allow bank to customize this function when they don't use 
	 * Study module.
	 *
	 * @return Array gathering all studies
	 *
	 * @author N. Luc
	 * @since 2009-09-11
	 * @updated N. Luc
	 */
	 
	function getStudiesList() {
		return $this->StudySummaries->getStudiesList();
	}
	
	/**
	 * Get list of blocks created for the studied sample.
	 * 
	 * @param $sample_master_data Master data of the studied sample.
	 * 
	 * @return Array gathering all sample blocks data.
	 *
	 * @author N. Luc
	 * @since 2009-09-11
	 * @updated N. Luc
	 */
	 
	function getSampleBlocksList($sample_master_data) {
		// Check block can be created for the studied sample
		$criteria = array(
			'SampleControl.id' => $sample_master_data['SampleMaster']['sample_control_id'],
			'SampleToAliquotControl.status' => 'active',
			'AliquotControl.status' => 'active',
			'AliquotControl.form_alias' => 'ad_spec_tiss_blocks');
		$sample_to_block_control = $this->SampleToAliquotControl->find('first', array('conditions' => $criteria));	
		
		if(empty($sample_to_block_control)) { return array(); }
		
		// Get block type control id
		$block_control_id = $sample_to_block_control['AliquotControl']['id'];
		
		// Get existing sample block
		$criteria = array();
		$criteria['AliquotMaster.aliquot_control_id'] = $block_control_id;
		$criteria['AliquotMaster.status'] = 'available';
		$criteria['AliquotMaster.sample_master_id'] = $sample_master_data['SampleMaster']['id'];
		$criteria['AliquotMaster.collection_id'] = $sample_master_data['SampleMaster']['collection_id'];
		$criteria['AliquotMaster.deleted'] = '0';
				
		$blocks_list = $this->AliquotMaster->atim_list(array('conditions' => $criteria, 'order' => array('AliquotMaster.barcode ASC')));
		
		return (empty($blocks_list)? array() : $blocks_list);
	}
	
	/**
	 * Get list of gel matrices created for the studied sample.
	 * 
	 * @param $sample_master_data Master data of the studied sample.
	 * 
	 * @return Array gathering all sample gel matrices data.
	 *
	 * @author N. Luc
	 * @since 2009-09-11
	 * @updated N. Luc
	 */
	 
	function getSampleGelMatricesList($sample_master_data) {
		// Check gel matrix can be created for the studied sample
		$criteria = array(
			'SampleControl.id' => $sample_master_data['SampleMaster']['sample_control_id'],
			'SampleToAliquotControl.status' => 'active',
			'AliquotControl.status' => 'active',
			'AliquotControl.form_alias' => 'ad_der_cel_gel_matrices');
		$sample_to_gel_matrix_control = $this->SampleToAliquotControl->find('first', array('conditions' => $criteria));	
		
		if(empty($sample_to_gel_matrix_control)) { return array(); }
		
		// Get block type control id
		$gel_matrix_control_id = $sample_to_gel_matrix_control['AliquotControl']['id'];
		
		// Get existing sample block
		$criteria = array();
		$criteria['AliquotMaster.aliquot_control_id'] = $gel_matrix_control_id;
		$criteria['AliquotMaster.status'] = 'available';
		$criteria['AliquotMaster.sample_master_id'] = $sample_master_data['SampleMaster']['id'];
		$criteria['AliquotMaster.collection_id'] = $sample_master_data['SampleMaster']['collection_id'];
		$criteria['AliquotMaster.deleted'] = '0';
				
		$gel_matrices_list = $this->AliquotMaster->atim_list(array('conditions' => $criteria, 'order' => array('AliquotMaster.barcode ASC')));
		
		return (empty($gel_matrices_list)? array() : $gel_matrices_list);
	}	
		
	/**
	 * Get default storage date for a new created aliquot.
	 * 
	 * @param $sample_master_data Master data of the studied sample.
	 * 
	 * @return Default storage date.
	 *
	 * @author N. Luc
	 * @since 2009-09-11
	 * @updated N. Luc
	 */
	 
	function getDefaultAliquotStorageDate($sample_master_data) {
		switch($sample_master_data['SampleMaster']['sample_category']) {
			case 'specimen':
				// Default creation date will be the specimen reception date
				$collection_data = $this->Collection->find('first', array('conditions' => array('Collection.id' => $sample_master_data['SampleMaster']['collection_id']), 'recursive' => '-1'));
				if(empty($collection_data)) { $this->redirect('/pages/err_inv_coll_no_data', null, true); }
				
				return $collection_data['Collection']['reception_datetime'];
				
			case 'derivative':
				// Default creation date will be the derivative creation date or Specimen reception date
				$derivative_detail_data = $this->DerivativeDetail->find('first', array('conditions' => array('DerivativeDetail.sample_master_id' => $sample_master_data['SampleMaster']['id']), 'recursive' => '-1'));
				if(empty($derivative_detail_data)) { $this->redirect('/pages/err_inv_missing_samp_data', null, true); }
				
				return $derivative_detail_data['DerivativeDetail']['creation_datetime'];
				
			default:
				$this->redirect('/pages/err_inv_system_error', null, true);			
		}
		
		return null;
	}
	
	/**
	 * Check created barcodes are not duplicated and set error if they are.
	 * 
	 * Note: 
	 *  - This function supports form data structure built by either 'add' form or 'datagrid' form.
	 *  - Has been created to allow customisation.
	 * 
	 * @param $aliquots_data Aliquots data stored into an array having structure like either:
	 * 	- $aliquots_data = array('AliquotMaster' => array(...))
	 * 	or
	 * 	- $aliquots_data = array(array('AliquotMaster' => array(...)))
	 *
	 * @return Return true if barcodes are duplicated.
	 * 
	 * @author N. Luc
	 * @date 2007-08-15
	 */
	function isDuplicatedAliquotBarcode($aliquots_data) {
		$is_duplicated_barcode = false;
		
		$new_barcodes = array();
		$duplicated_barcodes = array();
		
		// check data structure
		$is_multi_records_data = true;
		if(isset($aliquots_data[0]['AliquotMaster'])) {
			// Multi records: Nothing to do
		} else if(isset($aliquots_data['AliquotMaster'])) {
			// Single record to manage as multi records
			$aliquots_data = array('0' => $aliquots_data);
			$is_multi_records_data = false;
		} else {
			$this->redirect('/pages/err_inv_system_error', null, true);
		}
		
		// Check duplicated barcode into submited record
		foreach($aliquots_data as $new_aliquot) {
			$barcode = $new_aliquot['AliquotMaster']['barcode'];
			if(isset($new_barcodes[$barcode])) {
				$duplicated_barcodes[$barcode] = $barcode;
			} else {
				$new_barcodes[$barcode] = $barcode;
			}
		}
		
		// Check duplicated barcode into db
		$criteria = ' AliquotMaster.barcode in  (\'' . implode('\',\'', array_values($new_barcodes)) . '\')';
		$aliquots_having_duplicated_barcode = $this->AliquotMaster->atim_list(array('conditions' => $criteria));
		if(!empty($aliquots_having_duplicated_barcode)) {
			foreach($aliquots_having_duplicated_barcode as $new_aliquot) {
				$barcode = $new_aliquot['AliquotMaster']['barcode'];
				$duplicated_barcodes[$barcode] = $barcode;
			}			
		}
		
		// Set errors
		if(!empty($duplicated_barcodes)) {
			// Set boolean
			$is_duplicated_barcode = true;
			
			// Set error message
			$this->AliquotMaster->validationErrors['barcode']	= ' ';					// TODO: Used to color field in red 
			$this->AliquotMaster->validationErrors[]	= 'barcode must be unique';	// TODO: To be sure data won't be overriden by field control 
			$str_barcodes_in_error = ' => ';
			foreach($duplicated_barcodes as $barcode) {
				$str_barcodes_in_error .= '[' . $barcode . '] ';
			}
			$this->AliquotMaster->validationErrors[]	= $str_barcodes_in_error; 
		}
		
		return $is_duplicated_barcode;
	}

	/**
	 * Check both aliquot storage definition and aliquot positions and set error if required.
	 * 
	 * Note: 
	 *  - This function supports form data structure built by either 'add' form or 'datagrid' form.
	 *  - Has been created to allow customisation.
	 * 
	 * @param $aliquots_data Aliquots data stored into an array having structure like either:
	 * 	- $aliquots_data = array('AliquotMaster' => array(...))
	 * 	or
	 * 	- $aliquots_data = array(array('AliquotMaster' => array(...)))
	 *
	 * @return Return true if storage data are validated.
	 * 
	 * @author N. Luc
	 * @date 2007-08-15
	 */
	function validateAliquotStorageData(&$aliquots_data) {
		$submitted_data_validates = true;
				
		$arr_preselected_storages = array();
		$storage_validation_errors = array('id' => array(), 'x' => array(), 'y' => array());

		// check data structure
		$is_multi_records_data = true;
		if(isset($aliquots_data[0]['AliquotMaster'])) {
			// Multi records: Nothing to do
		} else if(isset($aliquots_data['AliquotMaster'])) {
			// Single record to manage as multi records
			$aliquots_data = array('0' => $aliquots_data);
			$is_multi_records_data = false;
		} else {
			$this->redirect('/pages/err_inv_system_error', null, true);
		}
		
		// Launch validation		
		foreach ($aliquots_data as $id => $new_aliquot) {		
			// Check the aliquot storage definition (selection label versus selected storage_master_id)
			$arr_storage_selection_results = $this->Storages->validateStorageIdVersusSelectionLabel($new_aliquot['FunctionManagement']['recorded_storage_selection_label'], $new_aliquot['AliquotMaster']['storage_master_id']);
					
			$new_aliquot['AliquotMaster']['storage_master_id'] = $arr_storage_selection_results['selected_storage_master_id'];
			$arr_preselected_storages += $arr_storage_selection_results['matching_storage_list'];
	
			if(!empty($arr_storage_selection_results['storage_definition_error'])) {
				$submitted_data_validates = false;
				$error_msg = $arr_storage_selection_results['storage_definition_error'];
				$storage_validation_errors['id'][$error_msg] = $error_msg;		
			
			} else {
				// Check aliquot position within storage
				$storage_data = (empty($new_aliquot['AliquotMaster']['storage_master_id'])? null: $arr_storage_selection_results['matching_storage_list'][$new_aliquot['AliquotMaster']['storage_master_id']]);
				$arr_position_results = $this->Storages->validatePositionWithinStorage($new_aliquot['AliquotMaster']['storage_master_id'], $new_aliquot['AliquotMaster']['storage_coord_x'], $new_aliquot['AliquotMaster']['storage_coord_y'], $storage_data);
				
				// Manage errors
				if(!empty($arr_position_results['position_definition_error'])) {
					$submitted_data_validates = false;
					$error = $arr_position_results['position_definition_error'];
					if($arr_position_results['error_on_x']) { $storage_validation_errors['x'][$error] = $error; } 
					if($arr_position_results['error_on_y']) { $storage_validation_errors['y'][$error] = $error; }	
				}
								
				// Reset aliquot storage data
				$new_aliquot['AliquotMaster']['storage_coord_x'] = $arr_position_results['validated_position_x'];
				$new_aliquot['AliquotMaster']['coord_x_order'] = $arr_position_results['position_x_order'];
				$new_aliquot['AliquotMaster']['storage_coord_y'] = $arr_position_results['validated_position_y'];
				$new_aliquot['AliquotMaster']['coord_y_order'] = $arr_position_results['position_y_order'];
			}
			
			// Update $aliquots_data for the studied record
			$aliquots_data[$id] = $new_aliquot;
		}
		
		// Set preselected storage list		
		$this->set('arr_preselected_storages', $arr_preselected_storages);
			
		// Manage error message
		foreach($storage_validation_errors['id'] as $error) {
			$this->AliquotMaster->validationErrors['storage_master_id'] = ' ';	// TODO: Used to color field in red
			$this->AliquotMaster->validationErrors[] = $error;							// TODO: Used to be sure all message will be displayed
		}
		
		foreach($storage_validation_errors['x'] as $error) {
			$this->AliquotMaster->validationErrors['storage_coord_x'] = ' ';		// TODO: Same notice
			$this->AliquotMaster->validationErrors[] = $error;
		}
		

		foreach($storage_validation_errors['y'] as $error) {
			$this->AliquotMaster->validationErrors['storage_coord_y'] = ' ';		// TODO: Same notice
			if(!isset($storage_validation_errors['x'][$error])) { $this->AliquotMaster->validationErrors[] = $error; }
		}
		
		if(!$is_multi_records_data) {
			// Reset correctly single record data
			$aliquots_data = $aliquots_data['0'];
		}
		
		return $submitted_data_validates;
	}

	/**
	 * Check if an aliquot can be deleted.
	 * 
	 * @param $aliquot_master_id Id of the studied sample.
	 * 
	 * @return Return results as array:
	 * 	['allow_deletion'] = true/false
	 * 	['msg'] = message to display when previous field equals false
	 * 
	 * @author N. Luc
	 * @since 2007-10-16
	 */
	 
	function allowAliquotDeletion($aliquot_master_id){
		// Check aliquot has no use	
		$returned_nbr = $this->AliquotUse->find('count', array('conditions' => array('AliquotUse.aliquot_master_id' => $aliquot_master_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'use exists for the deleted aliquot'); }
	
		// Check aliquot is not linked to realiquoting process	
		$returned_nbr = $this->Realiquoting->find('count', array('conditions' => array('Realiquoting.child_aliquot_master_id' => $aliquot_master_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'realiquoting data exists for the deleted aliquot'); }
		$returned_nbr = $this->Realiquoting->find('count', array('conditions' => array('Realiquoting.parent_aliquot_master_id' => $aliquot_master_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'realiquoting data exists for the deleted aliquot'); }
		
		// Check aliquot is not linked to review	
		$returned_nbr = $this->PathCollectionReview->find('count', array('conditions' => array('PathCollectionReview.aliquot_master_id' => $aliquot_master_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'review exists for the deleted aliquot'); }
		//TODO ReviewMaster?
	
		// Check aliquot is not linked to order	
		$returned_nbr = $this->OrderItem->find('count', array('conditions' => array('OrderItem.aliquot_master_id' => $aliquot_master_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'order exists for the deleted aliquot'); }
	
		// Check aliquot is not block used to create either slide or core
		$tmp_aliquot_detail = new AliquotDetail(false, 'ad_tissue_cores');
		$returned_nbr = $tmp_aliquot_detail->find('count', array('conditions' => array('AliquotDetail.block_aliquot_master_id' => $aliquot_master_id)));
		if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'either core or slide exists for the deleted aliquot'); }	
		$tmp_aliquot_detail = new AliquotDetail(false, 'ad_tissue_slides');
		$returned_nbr = $tmp_aliquot_detail->find('count', array('conditions' => array('AliquotDetail.block_aliquot_master_id' => $aliquot_master_id)));
		if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'either core or slide exists for the deleted aliquot'); }	
	
		// Check aliquot is not gel matrix used to create either core
		$tmp_aliquot_detail = new AliquotDetail(false, 'ad_cell_cores');
		$returned_nbr = $tmp_aliquot_detail->find('count', array('conditions' => array('AliquotDetail.gel_matrix_aliquot_master_id' => $aliquot_master_id)));
		if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'either core or slide exists for the deleted aliquot'); }	
		
		return array('allow_deletion' => true, 'msg' => '');
	}
	
	
	
	/**
	 * Define if a aliquot can be deleted.
	 * 
	 * @param $aliquot_master_id Id of the studied sample.
	 * 
	 * @return Return true if the aliquot can be deleted.
	 * 
	 * @author N. Luc
	 * @since 2007-08-16
	 */
//	function allowAliquotDeletion($aliquot_master_id){
//	
//	
//	
//	
//	
//	
//	
//	
//	
//	
//		
//		// Verify that this aliquot has not been used 
//		$criteria = 'AliquotUse.aliquot_master_id ="' .$aliquot_master_id . '"';			 
//		$aliquot_use_nbr = $this->AliquotUse->findCount($criteria);
//				
//		if($aliquot_use_nbr > 0){
//			return false;
//		}
//		
//		// Verify that this aliquot is not linked to a realiquoted aliquot	
//		$criteria = ' ="' .$aliquot_master_id . '"';			 
//		$realiquoted_aliquot_nbr = $this->Realiquoting->find($criteria);
//			
//		if($realiquoted_aliquot_nbr > 0){
//			return false;
//		}
//		
//		// Verify this aliquot has not been used for review
//		$criteria = ' ="' .$aliquot_master_id . '"';			 
//		$aliquot_path_review_nbr = $this->PathCollectionReview->findCount($criteria);
//
//		if($aliquot_path_review_nbr > 0){
//			return false;
//		}
//
//		
//
//		
//		$criteria = ' ="' .$aliquot_master_id . '"';			 
//		$aliquot_review_nbr = $this->ReviewMaster->findCount($criteria);
//
//		if($aliquot_review_nbr > 0){
//			return false;
//		}
//		
//		// Attache to an order line
//		$criteria = ' ="' .$aliquot_master_id . '"';			 
//		$aliquot_order_nbr = $this->OrderItem->findCount($criteria);
//		
//		if($aliquot_order_nbr > 0){
//			return false;
//		}
//		
//		// Verify block attched to tissue slide
//		$special_aliquot_detail = new AliquotDetail(false, 'ad_tissue_slides');
//		$criteria = ' ="' .$aliquot_master_id . '"';			 
//		$aliquot_tiss_slide_nbr = $special_aliquot_detail->findCount($criteria);
//		
//		if($aliquot_tiss_slide_nbr > 0){
//			return false;
//		}
//		
//		// Verify block atched to tissue core
//		$special_aliquot_detail = new AliquotDetail(false, 'ad_tissue_cores');
//		$criteria = ' ="' .$aliquot_master_id . '"';			 
//		$aliquot_tiss_slide_nbr = $special_aliquot_detail->findCount($criteria);
//		
//		if($aliquot_tiss_slide_nbr > 0){
//			return false;
//		}
//		
//		// Verify gel matrix atched to cell core
//		$special_aliquot_detail = new AliquotDetail(false, '');
//		$criteria = 'd ="' .$aliquot_master_id . '"';			 
//		$aliquot_tiss_slide_nbr = $special_aliquot_detail->findCount($criteria);
//		
//		if($aliquot_tiss_slide_nbr > 0){
//			return false;
//		}
//			
//						
//		// Etc...
//		
//		return true;
//	}
	
	
	
	
	
	
	
	
	
	
	/* --------------------------------------------------------------------------------------------- */


























	

	

	
	/**
	 * Allow to delete a aliquot of a collection group sample.
	 * 
	 * @param $specimen_group_menu_id Menu id that corresponds to the tab clicked to 
	 * display the samples of the collection group (Ascite, Blood, Tissue, etc).
	 * @param $group_specimen_type Type of the source specimens of the group.
	 * @param $sample_categroy Sample Category.
	 * @param $collection_id Id of the studied collection.
	 * @param $aliquot_master_id Master Id of the aliquot. 
	 * 
	 * @author N. Luc
	 * @date 2007-08-15
	 */
	function deleteAliquot($specimen_group_menu_id=null,  $group_specimen_type=null, $sample_category=null, 
	$collection_id=null, $aliquot_master_id=null) {
			
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($specimen_group_menu_id) || empty($group_specimen_type) || 
		empty($sample_category) || empty($collection_id) || empty($aliquot_master_id)) {
			$this->redirect('/pages/err_inv_funct_param_missing'); 
			exit;
		}
		
		// ** Load  ALIQUOT MASTER info **
		$this->AliquotMaster->id = $aliquot_master_id;
		$aliquot_master_data = $this->AliquotMaster->read();

		if(empty($aliquot_master_data)){
			$this->redirect('/pages/err_inv_aliquot_no_data'); 
			exit;
		}

		if(strcmp($aliquot_master_data['AliquotMaster']['collection_id'], $collection_id) != 0) {
			$this->redirect('/pages/err_inv_no_coll_id_map'); 
			exit;			
		}
		
		// Verify aliquot can be deleted
		if(!$this->allowAliquotDeletion($aliquot_master_id)){
			$this->redirect('/pages/err_inv_aliqu_del_forbid'); 
			exit;
		}

		// Look for sample master id
		$sample_master_id = $aliquot_master_data['AliquotMaster']['sample_master_id'];

		//Look for aliquot control table
		$this->AliquotControl->id = $aliquot_master_data['AliquotMaster']['aliquot_control_id'];
		$aliquot_control_data = $this->AliquotControl->read();
	
		if(empty($aliquot_control_data)){
			$this->redirect('/pages/err_inv_no_aliqu_cont_data'); 
			exit;	
		}	

		// look for CUSTOM HOOKS, "validation"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'] . '_' . $this->params['action'] . '_validation.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
		//Delete aliquot
		$bool_delete_aliquot = true;
		
		if(!is_null($aliquot_control_data['AliquotControl']['form_alias'])){
			// This aliquot has specific data
			$this->AliquotDetail = new AliquotDetail(false, $aliquot_control_data['AliquotControl']['detail_tablename']);
			
			if(!$this->AliquotDetail->del($aliquot_master_id)){
				$bool_delete_aliquot = false;		
			}			
		}
			
		if($bool_delete_aliquot){
			if(!$this->AliquotMaster->del($aliquot_master_id)){
				$bool_delete_aliquot = false;		
			}	
		}
		
		if(!$bool_delete_aliquot){exit;
			$this->redirect('/pages/err_inv_aliqu_del_err'); 
			exit;
		}
		
		$this->Flash('Your data has been deleted . ',
			'/aliquot_masters/listAllSampleAliquots/'.
			$specimen_group_menu_id . '/' . $group_specimen_type . '/' . $sample_category . '/'.
			$collection_id . '/' . $sample_master_id . '/');
	
	} //end deleteAliquot

	/* --------------------------------------------------------------------------
	 * SOURCE ALIQUOTS FUNCTIONS
	 * -------------------------------------------------------------------------- */	
		
	/**
	 * Allow to list all parent sample aliquots
	 * used to create the derivative.
	 * 
	 * @param $specimen_group_menu_id Menu id that corresponds to the tab clicked to 
	 * display the samples of the collection group (Ascite, Blood, Tissue, etc).
	 * @param $group_specimen_type Type of the source specimens of the group.
	 * @param $sample_category Sample Category.
	 * @param $collection_id Id of the studied collection.
	 * @param $sample_master_id Id of the derivative.
	 * 
	 * @author N. Luc
	 * @date 2007-08-15
	 */
	function listSourceAliquots($specimen_group_menu_id=null, $group_specimen_type=null, $sample_category=null, 
	$collection_id=null, $sample_master_id=null) {

		// ** Parameters check **
		// Verify parameters have been set
		if(empty($specimen_group_menu_id) || empty($group_specimen_type) || 
		empty($sample_category) || empty($collection_id) || 
		empty($sample_master_id)) {
			$this->redirect('/pages/err_inv_funct_param_missing'); 
			exit;
		}
		
		// read SAMPLE MASTER info
		$criteria = 'SampleMaster.id ="' . $sample_master_id . '"';
		$sample_master_data = $this->SampleMaster->find($criteria, null, null, 0);
				
		if(empty($sample_master_data)){
			$this->redirect('/pages/err_inv_samp_no_data'); 
			exit;
		}
		
		if(strcmp($sample_master_data['SampleMaster']['collection_id'], $collection_id) != 0) {
			$this->redirect('/pages/err_inv_no_coll_id_map'); 
			exit;			
		}
		
		if(strcmp($sample_master_data['SampleMaster']['sample_category'], 'specimen') == 0){
			$this->redirect('/pages/err_inv_no_source_for_specimen'); 
			exit;	
		}
		
		// ** Set FORM variable **
		$this->set('ctrapp_form', $this->Forms->getFormArray('source_aliquots_list'));
		
		// ** Set DATA for echo on view **
		$this->set('specimen_group_menu_id', $specimen_group_menu_id);
		$this->set('group_specimen_type', $group_specimen_type);
		$this->set('sample_category', $sample_category);
		
		$this->set('collection_id', $collection_id);
		$this->set('sample_master_id', $sample_master_id);

//		$this->set('sample_code', $sample_master_data['SampleMaster']['sample_code']);
		
		// ** Set MENU variable for echo on VIEW **
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_00', 'inv_CAN_10', $collection_id);
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_10', $specimen_group_menu_id, $collection_id);
		
		$specimen_grp_menu_lists = $this->getSpecimenGroupMenu($specimen_group_menu_id);
		
		switch($sample_category) {
			case "derivative":
				$specimen_sample_master_id=$sample_master_data['SampleMaster']['initial_specimen_sample_id'];
				$derivative_sample_master_id=$sample_master_id;		
				
				$specimen_menu_id = $specimen_group_menu_id . '-sa_der';
				$derivative_menu_id = $specimen_group_menu_id . '-der_so_al';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id . '/' . $specimen_sample_master_id);	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $derivative_menu_id, $specimen_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_menu_id, $derivative_menu_id, $collection_id . '/' . $derivative_sample_master_id . '/');	
				break;
			
			default:
				$this->redirect('/pages/err_inv_menu_definition'); 
				exit;
		}
		
		$this->set('ctrapp_menu', $ctrapp_menu);
	
		// ** Set SUMMARY variable from plugin's COMPONENTS **
		$this->set('ctrapp_summary', $this->Summaries->build($collection_id, $sample_master_id));
		
		// ** Set SIDEBAR variable **
		// Use PLUGIN_CONTROLLER_ACTION by default, 
		// but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray(
				$this->params['plugin'] . '_'.
				$this->params['controller'] . '_'.
				$this->params['action']));
		

		// ** Search aliquot data to display in the list **
			
		// Search aliquots that have been used to create the derivative
		// Note: Normaly a aliquot can be used once for the creation of
		// a specifc derivative.
		
		$criteria = array();
		$criteria['sample_master_id'] = $sample_master_id;

		$use_id_from_source_aliquot_id = 
			$this->SourceAliquot->generateList(
				$criteria, 
				null, 
				null, 
				'{n}.SourceAliquot.aliquot_master_id', 
				'{n}.SourceAliquot.aliquot_use_id');
											
		// Build array of data to display
		$source_aliquots = array();
		
		if(!empty($use_id_from_source_aliquot_id)){
						
			// Search source aliquot used volumes
			$criteria = array();
			$criteria['AliquotUse.id'] = array_values($use_id_from_source_aliquot_id);
			
			$use_vol_from_source_aliquot_id 
				= $this->AliquotUse->generateList(
					$criteria, 
					null, 
					null, 
					'{n}.AliquotUse.aliquot_master_id', 
					'{n}.AliquotUse.used_volume');
			
			if(empty($use_vol_from_source_aliquot_id) 
			|| (sizeof($use_vol_from_source_aliquot_id) != sizeof($use_id_from_source_aliquot_id))){
				// It looks like at least one record defined in SourceAliquot has not
				// its attached data into AliquotUse	
				$this->redirect('/pages/err_inv_system_error'); 
				exit;		
			}				
			
			// Search source aliquots data
			$criteria = array();
			$criteria['AliquotMaster.id'] = array_keys($use_id_from_source_aliquot_id);
			$criteria = array_filter($criteria);
			
			list($order, $limit, $page) = $this->Pagination->init($criteria);
			$source_aliquots = $this->AliquotMaster->findAll($criteria, null, $order, $limit, $page, 0);

			// For each source aliquot, set the used_volume.
			foreach($source_aliquots as $id_ct => $new_source_aliquot){
				if(isset($use_vol_from_source_aliquot_id[$new_source_aliquot['AliquotMaster']['id']])){
					$source_aliquots[$id_ct]['AliquotUse']['used_volume'] = 
						$use_vol_from_source_aliquot_id[$new_source_aliquot['AliquotMaster']['id']];
				}			
			}
		}			
		
		$this->set('source_aliquots', $source_aliquots);
	
		// ** Verify if additional parent sample aliquots could be added to the list of source aliquots **
		$criteria= 'AliquotMaster.sample_master_id = ' . $sample_master_data['SampleMaster']['parent_id'];
		$criteria.= ' AND AliquotMaster.status = \'available\'';
		if(!empty($use_id_from_source_aliquot_id)) {
			// Aliquot have already be defined as source
			$criteria.= ' AND AliquotMaster.id NOT IN (\''.implode('\',\'', array_keys($use_id_from_source_aliquot_id)) . '\')';
		}
		
		$av_parent_sample_aliquots = 
			$this->AliquotMaster->findCount($criteria);
			
		$bool_av_parent_sample_aliquots = false;
		
		if($av_parent_sample_aliquots > 0){
			$bool_av_parent_sample_aliquots = true;
		}
										
		$this->set('bool_av_parent_sample_aliquots', $bool_av_parent_sample_aliquots);
		
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'] . '_' . $this->params['action'] . '_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}

	} // listSourceAliquots
	
	/**
	 * Allow to define parent aliquots as source aliquots.
	 * 
	 * @param $specimen_group_menu_id Menu id that corresponds to the tab clicked to 
	 * display the samples of the collection group (Ascite, Blood, Tissue, etc).
	 * @param $group_specimen_type Type of the source specimens of the group.
	 * @param $sample_catgory Sample Category.
	 * @param $collection_id Id of the studied collection.
	 * @param $sample_master_id Id of the studied sample derivative.
	 * 
	 * @author N. Luc
	 * @date 2007-08-15
	 */
	function addSourceAliquotInBatch($specimen_group_menu_id=null, $group_specimen_type=null, $sample_category=null, 
	$collection_id=null, $sample_master_id=null) {
			
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($specimen_group_menu_id) || empty($group_specimen_type) || 
		empty($sample_category) || empty($collection_id) || empty($sample_master_id)) {
			$this->redirect('/pages/err_inv_funct_param_missing'); 
			exit;
		}
		
		// read SAMPLE MASTER info
		$criteria = 'SampleMaster.id ="' . $sample_master_id . '"';
		$sample_master_data = $this->SampleMaster->find($criteria, null, null, 0);
				
		if(empty($sample_master_data)){
			$this->redirect('/pages/err_inv_samp_no_data'); 
			exit;
		}
		
		if(strcmp($sample_master_data['SampleMaster']['collection_id'], $collection_id) != 0) {
			$this->redirect('/pages/err_inv_no_coll_id_map'); 
			exit;			
		}
		
		if(strcmp($sample_master_data['SampleMaster']['sample_category'], 'specimen') == 0){
			$this->redirect('/pages/err_inv_no_source_for_specimen'); 
			exit;	
		}

		// ** Set MENU variable for echo on VIEW **
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_00', 'inv_CAN_10', $collection_id);
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_10', $specimen_group_menu_id, $collection_id);
		
		$specimen_grp_menu_lists = $this->getSpecimenGroupMenu($specimen_group_menu_id);
		
		switch($sample_category) {
			case "derivative":
				$specimen_sample_master_id=$sample_master_data['SampleMaster']['initial_specimen_sample_id'];
				$derivative_sample_master_id=$sample_master_id;		
				
				$specimen_menu_id = $specimen_group_menu_id . '-sa_der';
				$derivative_menu_id = $specimen_group_menu_id . '-der_so_al';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id . '/' . $specimen_sample_master_id);	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $derivative_menu_id, $specimen_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_menu_id, $derivative_menu_id, $collection_id . '/' . $derivative_sample_master_id . '/');	
				break;
			
			default:
				$this->redirect('/pages/err_inv_menu_definition'); 
				exit;
		}
		
		$this->set('ctrapp_menu', $ctrapp_menu);
	
		// ** Set SUMMARY varible from plugin's COMPONENTS **
		$this->set('ctrapp_summary', $this->Summaries->build($collection_id, $sample_master_id));
		
		// ** Set SIDEBAR variable **
		// Use PLUGIN_CONTROLLER_ACTION by default, 
		// but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray(
				$this->params['plugin'] . '_'.
				$this->params['controller'] . '_'.
				$this->params['action']));
		
		// ** Set FORM variable, for HELPER call on VIEW **
		$this->set('ctrapp_form', $this->Forms->getFormArray('source_aliquots_list'));
		
		// ** Set DATA variable, for echo en view or create link **
		$this->set('specimen_group_menu_id', $specimen_group_menu_id);
		$this->set('group_specimen_type', $group_specimen_type);
		$this->set('sample_category', $sample_category);

		$this->set('collection_id', $collection_id);
		$this->set('sample_master_id', $sample_master_id);	
		
		$this->set('sample_code', $sample_master_data['SampleMaster']['sample_code']);
		
		// Set aliquot use date with the sample creation date
		$criteria = 'DerivativeDetail.id ="' . $sample_master_id . '"';
		$derivative_detail_data = $this->DerivativeDetail->find($criteria, null, null, 0);

		if(empty($derivative_detail_data)){
			$this->redirect('/pages/err_inv_missing_samp_data'); 
			exit;
		}
			
		$this->set('sample_creation_datetime', $derivative_detail_data['DerivativeDetail']['creation_datetime']);
							
		// ** Search aliquot data to display in the list **
		
		// Search ids of the aliquots that have been already used to create this aliquot
		// These aliquots will be excluded from the list
		
		$criteria = array();
		$criteria['sample_master_id'] = $sample_master_id;

		$already_used_aliquot_id = 
			$this->SourceAliquot->generateList($criteria, 
											null, 
											null, 
											'{n}.SourceAliquot.aliquot_master_id', 
											'{n}.SourceAliquot.aliquot_master_id');

		// Search ids of the aliquots that could be used to create the derivative

		$criteria= 'AliquotMaster.sample_master_id = ' . $sample_master_data['SampleMaster']['parent_id'];
		$criteria.= ' AND AliquotMaster.status = \'available\'';
		
		if(!empty($already_used_aliquot_id)) {
			// Aliquot have already be defined as source
			$criteria.= ' AND AliquotMaster.id NOT IN (\''.implode('\',\'', array_keys($already_used_aliquot_id)) . '\')';
		}
				
		$available_source_aliquots = $this->AliquotMaster->findAll($criteria, null, null, null, 0);

		if(empty($available_source_aliquots)){
			$this->redirect('/pages/err_inv_no_aliquot_source_to_add'); 
			exit;
		}
		
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'] . '_' . $this->params['action'] . '_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
		if (empty($this->data)) {
			// Edit Data
			$this->data = $available_source_aliquots;
			$this->set('data', $this->data);	
							
		} else {
			// ** Save data	**

			// setup MODEL(s) validation array(s) for displayed FORM 
			foreach ($this->Forms->getValidateArray('source_aliquots_list') as $validate_model=>$validate_rules) {
				$this->{$validate_model}->validate = $validate_rules;
			}
			
			// Run validation
			$submitted_data_validates = true;	
			$aliquots_to_define_as_source = array();
					
			foreach($this->data as $id => $new_studied_aliquot){
				// New aliquot that was displayed in the datgarid
				
				if(strcmp($new_studied_aliquot['FunctionManagement']['use'], 'yes') == 0){
					// This aliquot should be defined as source aliquot.
					
					// Validates Fields of Aliquot Master Table
					if(!$this->AliquotMaster->validates($new_studied_aliquot['AliquotMaster'])){
						$submitted_data_validates = false;
					}
					
					if(!$this->AliquotUse->validates($new_studied_aliquot['AliquotUse'])){
						$submitted_data_validates = false;
					}
					
					if(empty($new_studied_aliquot['AliquotMaster']['aliquot_volume_unit']) 
					&& (!empty($new_studied_aliquot['AliquotUse']['used_volume']))) {
						// No volume is tracked for this aliquot type
						$this->AliquotMaster->validationErrors[] 
							= 'no volume has to be recorded for this aliquot type';	
						$submitted_data_validates = false;
					}
					if(empty($new_studied_aliquot['AliquotUse']['used_volume'])){
						$new_studied_aliquot['AliquotUse']['used_volume']=null;
					}
			
					if($submitted_data_validates){
						$aliquots_to_define_as_source[] = $new_studied_aliquot;
					} else {
						break;	
					}			
				}
			} // End foreach to study all datgrid records
			
			// look for CUSTOM HOOKS, "validation"
			$custom_ctrapp_controller_hook 
				= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
				'controllers' . DS . 'hooks' . DS . 
				$this->params['controller'] . '_' . $this->params['action'] . '_validation.php';
			
			if (file_exists($custom_ctrapp_controller_hook)) {
				require($custom_ctrapp_controller_hook);
			}
			
			if ($submitted_data_validates) {
				
				if(empty($aliquots_to_define_as_source)){
					// Data have been updated
					$this->Flash('No aliquot has been defined as sample source aliquot . ', 
						'/aliquot_masters/listSourceAliquots/'.
							$specimen_group_menu_id . '/' . $group_specimen_type . '/' . $sample_category . '/'.
							$collection_id . '/' . $sample_master_id . '/');	
					exit;					
				}
					
				// Launch Save function
				$bool_save_done = true;
	
				// Parse records to save
				foreach($aliquots_to_define_as_source as $id_sec => $new_aliquot_to_use){
										
					// Save data of this aliquot
					$aliquot_use_id = null;					
					$source_aliquot_master_id = $new_aliquot_to_use['AliquotMaster']['id'];

					if(strcmp($new_aliquot_to_use['FunctionManagement']['delete_storage_data'], 'yes') == 0){
						// Delete aliquot storage data
						$new_aliquot_to_use['AliquotMaster']['storage_master_id'] = null;
						$new_aliquot_to_use['AliquotMaster']['storage_coord_x'] = null;
						$new_aliquot_to_use['AliquotMaster']['storage_coord_y'] = null;
					}
					
					// Save ALIQUOT MASTER data
					
					unset($new_aliquot_to_use['AliquotMaster']['created']);
					unset($new_aliquot_to_use['AliquotMaster']['created_by']);
					
					$new_aliquot_to_use['AliquotMaster']['modified'] = date('Y-m-d G:i');
					$new_aliquot_to_use['AliquotMaster']['modified_by'] = $this->othAuth->user('id');
					
					if(!$this->AliquotMaster->save($new_aliquot_to_use['AliquotMaster'])){
						$bool_save_done = false;
					} else {
						// Save ALIQUOT USE data
						
						// Add additional data
						$new_aliquot_to_use['AliquotUse']['aliquot_master_id'] = $source_aliquot_master_id;
										
						$new_aliquot_to_use['AliquotUse']['use_definition'] = 'sample derivative creation';
						$new_aliquot_to_use['AliquotUse']['use_details'] = $sample_master_data['SampleMaster']['sample_code'];
						$new_aliquot_to_use['AliquotUse']['use_recorded_into_table'] = 'source_aliquots';	
						$new_aliquot_to_use['AliquotUse']['use_datetime'] = $derivative_detail_data['DerivativeDetail']['creation_datetime'];						
						
						$new_aliquot_to_use['AliquotUse']['created'] = date('Y-m-d G:i');
						$new_aliquot_to_use['AliquotUse']['created_by'] = $this->othAuth->user('id');
						$new_aliquot_to_use['AliquotUse']['modified'] = date('Y-m-d G:i');
						$new_aliquot_to_use['AliquotUse']['modified_by'] = $this->othAuth->user('id');
						
						if(is_null($new_aliquot_to_use['AliquotMaster']['aliquot_volume_unit'])){
							// No volume should be recorded: Set used volume to null
							$new_aliquot_to_use['AliquotUse']['used_volume'] = null;
						}					
	
						if(!$this->AliquotUse->save($new_aliquot_to_use['AliquotUse'])){
							$bool_save_done = false;
							
						} else {
							$aliquot_use_id = $this->AliquotUse->getLastInsertId();

							// Set data for source_aliquots table
							$source_aliquot_data = array();
							$source_aliquot_data['SourceAliquot']['id'] = null;
							$source_aliquot_data['SourceAliquot']['aliquot_master_id'] = $source_aliquot_master_id;
							$source_aliquot_data['SourceAliquot']['sample_master_id'] = $sample_master_id;
							$source_aliquot_data['SourceAliquot']['aliquot_use_id'] = $aliquot_use_id;
							
							$source_aliquot_data['SourceAliquot']['created'] = date('Y-m-d G:i');
							$source_aliquot_data['SourceAliquot']['created_by'] = $this->othAuth->user('id');
							$source_aliquot_data['SourceAliquot']['modified'] = date('Y-m-d G:i');
							$source_aliquot_data['SourceAliquot']['modified_by'] = $this->othAuth->user('id');
													
							if(!$this->SourceAliquot->save($source_aliquot_data)){
								$bool_save_done = false;
							} else {
								// Update current volume of the source aliquot
								$this->updateAliquotCurrentVolume($source_aliquot_master_id);
							}
						}					
					} // End Save one source aliquot
					
					
					if(!$bool_save_done){
						break;
					}
					
				} // End foreach to save all source aliquots

				if(!$bool_save_done){
					$this->redirect('/pages/err_inv_aliquot_use_record_err'); 
					exit;
				} else {
					// Data have been updated
					$this->Flash('Your aliquots have been defined as sample source aliquot . ', 
						'/aliquot_masters/listSourceAliquots/'.
							$specimen_group_menu_id . '/' . $group_specimen_type . '/' . $sample_category . '/'.
							$collection_id . '/' . $sample_master_id . '/');				
				} 
			} // End Save Functions execution	
			
		} // End Save Section (validation + save)
	} // End function addSourceAliquotInBatch

	/**
	 * Allow to delete a source aliquot from the list of parent sample aliquots
	 * used as source.
	 * 
	 * @param $specimen_group_menu_id Menu id that corresponds to the tab clicked to 
	 * display the samples of the collection group (Ascite, Blood, Tissue, etc).
	 * @param $group_specimen_type Type of the source specimens of the group.
	 * @param $sample_category Sample Category.
	 * @param $collection_id Id of the studied collection.
	 * @param $sample_master_id Id of the studied sample derivative.
	 * @param $source_aliquot_master_id Id of the aliquot used as source that the user expects
	 * to delete from liste.
	 * 
	 * @author N. Luc
	 * @date 2007-08-15
	 */
	function deleteSourceAliquot($specimen_group_menu_id=null, $group_specimen_type=null, $sample_category=null, 
	$collection_id=null, $sample_master_id=null, $source_aliquot_master_id=null) {
		
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($specimen_group_menu_id) || empty($group_specimen_type) || 
		empty($sample_category) || empty($collection_id) || 
		empty($sample_master_id) || empty($source_aliquot_master_id)) {
			$this->redirect('/pages/err_inv_funct_param_missing'); 
			exit;
		}
		
		// * Verify that this record match a source aliquot defintion **
		
		// Check in SourceAliquot
		$criteria = array();		
		$criteria['SourceAliquot.aliquot_master_id'] = $source_aliquot_master_id;
		$criteria['SourceAliquot.sample_master_id'] = $sample_master_id;
				
		$source_aliquot_record = $this->SourceAliquot->find($criteria, null, null, 0);
		
		if(empty($source_aliquot_record)){
			$this->redirect('/pages/err_inv_invalid_source_aliquot'); 
			exit;	
		}
			
		// Check in AliquotUse
		$aliquot_use_id = $source_aliquot_record['SourceAliquot']['aliquot_use_id'];
		
		$criteria = array();		
		$criteria['AliquotUse.id'] = $aliquot_use_id;
		$criteria['AliquotUse.aliquot_master_id'] = $source_aliquot_master_id;
				
		$aliquot_use_record = $this->AliquotUse->find($criteria, null, null, 0);
		
		if(empty($aliquot_use_record)){
			$this->redirect('/pages/err_inv_invalid_source_aliquot'); 
			exit;		
		}	

		// look for CUSTOM HOOKS, "validation"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'] . '_' . $this->params['action'] . '_validation.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
		// ** Delete Record **
		$bool_delete_source_aliquot = true;
	
		if(!$this->SourceAliquot->del($source_aliquot_record['SourceAliquot']['id'])){
			$bool_delete_source_aliquot = false;		
		}	
		
		if($bool_delete_source_aliquot){
			if(!$this->AliquotUse->del($aliquot_use_id)){
				$bool_delete_source_aliquot = false;		
			}			
		}
		
		if(!$bool_delete_source_aliquot){
			$this->redirect('/pages/err_inv_aliqu_use_del_err'); 
			exit;
		}
		
		$this->flash('Your aliquot has been deleted from the list of Source Aliquot . ', 
					'/aliquot_masters/listSourceAliquots/'.
					$specimen_group_menu_id . '/' . $group_specimen_type . '/' . $sample_category . '/'.
					$collection_id . '/' . $sample_master_id . '/');
		
	} // End function deleteSourceAliquot

	function listRealiquotedParents($specimen_group_menu_id=null, $group_specimen_type=null, $sample_category=null,	
	$collection_id=null, $aliquot_master_id=null) {

		// ** Parameters check **
		// Verify parameters have been set
		if(empty($specimen_group_menu_id) || empty($group_specimen_type) || 
		empty($sample_category) || empty($collection_id) || empty($aliquot_master_id)) {
			$this->redirect('/pages/err_inv_funct_param_missing'); 
			exit;
		}
		
		// ** Look for Aliquot Data **
		$criteria = array();
		$criteria['AliquotMaster.id'] = $aliquot_master_id;
		$criteria['AliquotMaster.collection_id'] = $collection_id;
		$criteria = array_filter($criteria);
		
		$aliquot_master_data = $this->AliquotMaster->find($criteria, null, null, 0);

		if(empty($aliquot_master_data)){
			$this->redirect('/pages/err_inv_aliquot_no_data'); 
			exit;
		}
				
		//** Get the aliquot sample master data **
		
		$sample_master_id = $aliquot_master_data['AliquotMaster']['sample_master_id'];
		
		$criteria = array();
		$criteria['SampleMaster.id'] = $sample_master_id;
		$criteria['SampleMaster.collection_id'] = $collection_id;
		$criteria = array_filter($criteria);
	
		$sample_master_data = $this->SampleMaster->find($criteria, null, null, 0);
		
		if(empty($sample_master_data)){
			$this->redirect('/pages/err_inv_samp_no_data'); 
			exit;
		}
		
		// ** Set SIDEBAR variable **
		// Use PLUGIN_CONTROLLER_ACTION by default, 
		// but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray(
				$this->params['plugin'] . '_'.
				$this->params['controller'] . '_'.
				$this->params['action']));
														
		// ** Set SUMMARY variable from plugin's COMPONENTS **
		$this->set('ctrapp_summary', $this->Summaries->build($collection_id, $sample_master_id, $aliquot_master_id));
															
		// ** Set FORM variable **
		$this->set('ctrapp_form', $this->Forms->getFormArray('realiquoted_parent_list'));

		// ** Set FORM data for echo on view **
		$this->set('aliquot_barcode', $aliquot_master_data['AliquotMaster']['barcode']);
//		$this->set('sample_code', $sample_master_data['SampleMaster']['sample_code']);

		$this->set('specimen_group_menu_id', $specimen_group_menu_id);
		$this->set('group_specimen_type', $group_specimen_type);
		$this->set('sample_category', $sample_category);
		
		$this->set('collection_id', $collection_id);
		$this->set('aliquot_master_id', $aliquot_master_id);
				
		// ** Set MENU variable for echo on VIEW **
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_00', 'inv_CAN_10', $collection_id);
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_10', $specimen_group_menu_id, $collection_id);
		
		$specimen_grp_menu_lists = $this->getSpecimenGroupMenu($specimen_group_menu_id);
		
		switch($sample_category) {
			case "specimen":
				$specimen_sample_master_id=$sample_master_id;
				
				$specimen_menu_id = $specimen_group_menu_id . '-sa_al';
				$aliquot_menu_id = $specimen_group_menu_id . '-sa_al_re';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id . '/' . $specimen_sample_master_id);	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $aliquot_menu_id, $specimen_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($specimen_menu_id, $aliquot_menu_id, $collection_id . '/' . $aliquot_master_id);	
				break;
				
			case "derivative":
				$specimen_sample_master_id=$sample_master_data['SampleMaster']['initial_specimen_sample_id'];
				$derivative_sample_master_id=$sample_master_id;		
				
				$specimen_menu_id = $specimen_group_menu_id . '-sa_der';
				$derivative_menu_id = $specimen_group_menu_id . '-der_al';
				$aliquot_menu_id = $specimen_group_menu_id . '-der_al_re';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id . '/' . $specimen_sample_master_id);	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $derivative_menu_id, $specimen_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_menu_id, $derivative_menu_id, $collection_id . '/' . $derivative_sample_master_id . '/');	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $aliquot_menu_id, $derivative_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($derivative_menu_id, $aliquot_menu_id, $collection_id . '/' . $aliquot_master_id);	
				break;
			
			default:
				$this->redirect('/pages/err_inv_menu_definition'); 
				exit;
		}
		
		$this->set('ctrapp_menu', $ctrapp_menu);

		// ** Search aliquot data to display in the list **
			
		// Search parent aliquots that have been realiquoted to create the new aliquot
	
		$criteria = array();
		$criteria['child_aliquot_master_id'] = $aliquot_master_id;

		$realiquoting_data = 
			$this->Realiquoting->generateList(
				$criteria, 
				null, 
				null, 
				'{n}.Realiquoting.parent_aliquot_master_id', 
				'{n}.Realiquoting');
		
		$use_id_from_realiquoted_parent_id = array();		
		if(!empty($realiquoting_data)){
			foreach($realiquoting_data as $par_aliqu_master_id => $studied_record) {
				$use_id_from_realiquoted_parent_id[$par_aliqu_master_id] = $studied_record['aliquot_use_id'];
			}
		}
											
		// Build array of data to display
		$realiquoted_parents = array();
		
		if(!empty($use_id_from_realiquoted_parent_id)){
						
			// Search realiquoted parent used volumes
			$criteria = array();
			$criteria['AliquotUse.id'] = array_values($use_id_from_realiquoted_parent_id);
			
			$use_vol_from_realiquoted_parent_id 
				= $this->AliquotUse->generateList(
					$criteria, 
					null, 
					null, 
					'{n}.AliquotUse.aliquot_master_id', 
					'{n}.AliquotUse.used_volume');
			
			if(empty($use_vol_from_realiquoted_parent_id) 
			|| (sizeof($use_vol_from_realiquoted_parent_id) != sizeof($use_id_from_realiquoted_parent_id))){
				// It looks like at least one record defined in ParentAliquot has not
				// its attached data into AliquotUse	
				$this->redirect('/pages/err_inv_system_error'); 
				exit;		
			}				
			
			// Search realiquoted aliquots data
			$criteria = array();
			$criteria['AliquotMaster.id'] = array_keys($use_id_from_realiquoted_parent_id);
			$criteria = array_filter($criteria);
			
			list($order, $limit, $page) = $this->Pagination->init($criteria);
			$realiquoted_parents = $this->AliquotMaster->findAll($criteria, null, $order, $limit, $page, 0);

			// For each source aliquot, set different information
			foreach($realiquoted_parents as $id_ct => $new_realiquoted_parent){
				// Set AliquotUse.used_volume
				if(isset($use_vol_from_realiquoted_parent_id[$new_realiquoted_parent['AliquotMaster']['id']])){
					$realiquoted_parents[$id_ct]['AliquotUse']['used_volume'] = 
						$use_vol_from_realiquoted_parent_id[$new_realiquoted_parent['AliquotMaster']['id']];
				}
				// Set Realiquoting.realiquoted_by
				if(isset($realiquoting_data[$new_realiquoted_parent['AliquotMaster']['id']])){
					$realiquoted_parents[$id_ct]['Realiquoting']['realiquoted_by'] = 
						$realiquoting_data[$new_realiquoted_parent['AliquotMaster']['id']]['realiquoted_by'];
				}
				// Set Realiquoting.realiquoted_datetime
				if(isset($realiquoting_data[$new_realiquoted_parent['AliquotMaster']['id']])){
					$realiquoted_parents[$id_ct]['Realiquoting']['realiquoted_datetime'] = 
						$realiquoting_data[$new_realiquoted_parent['AliquotMaster']['id']]['realiquoted_datetime'];
				}
							
			}
		}
		
		$this->set('realiquoted_parents', $realiquoted_parents);
		
		// ** Verify if additional sample aliquots could be added to the list of realiquoted parents **
		
		$bool_av_realiquotable_aliquots = false;
		
		if(sizeof($realiquoted_parents) == 0) {
			// Note: We consider that only one realiquoted parent can be defined
			
			$criteria= 'AliquotMaster.sample_master_id = ' . $sample_master_id;
			$criteria.= ' AND AliquotMaster.status = \'available\'';
			$criteria.= ' AND AliquotMaster.id NOT IN (\'' . $aliquot_master_id . '\'';
			if(!empty($use_id_from_realiquoted_parent_id)) {
				// Aliquot have already be defined as parent
				$criteria.= ', \''.implode('\',\'', array_keys($use_id_from_realiquoted_parent_id)) . '\'';
			}
			$criteria.= ')';
			
			$av_realiquotable_aliquots = 
				$this->AliquotMaster->findCount($criteria);
					
			if($av_realiquotable_aliquots > 0){
				$bool_av_realiquotable_aliquots = true;
			}
		}
										
		$this->set('bool_av_realiquotable_aliquots', $bool_av_realiquotable_aliquots);
		
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'] . '_' . $this->params['action'] . '_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}

	} // listRealiquotedParent
	
	function addRealiquotedParentInBatch($specimen_group_menu_id=null, $group_specimen_type=null, $sample_category=null,	
	$collection_id=null, $aliquot_master_id=null) {
			
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($specimen_group_menu_id) || empty($group_specimen_type) || 
		empty($sample_category) || empty($collection_id) || empty($aliquot_master_id)) {
			$this->redirect('/pages/err_inv_funct_param_missing'); 
			exit;
		}
		
		// ** Look for Aliquot Data **
		$criteria = array();
		$criteria['AliquotMaster.id'] = $aliquot_master_id;
		$criteria['AliquotMaster.collection_id'] = $collection_id;
		$criteria = array_filter($criteria);
		
		$aliquot_master_data = $this->AliquotMaster->find($criteria, null, null, 0);

		if(empty($aliquot_master_data)){
			$this->redirect('/pages/err_inv_aliquot_no_data'); 
			exit;
		}
		
		$realiquoted_aliquot_barcode = $aliquot_master_data['AliquotMaster']['barcode'];
				
		//** Get the aliquot sample master data **
		
		$sample_master_id = $aliquot_master_data['AliquotMaster']['sample_master_id'];
			
		$criteria = array();
		$criteria['SampleMaster.id'] = $sample_master_id;
		$criteria['SampleMaster.collection_id'] = $collection_id;
		$criteria = array_filter($criteria);
	
		$sample_master_data = $this->SampleMaster->find($criteria, null, null, 0);
		
		if(empty($sample_master_data)){
			$this->redirect('/pages/err_inv_samp_no_data'); 
			exit;
		}
		
		// ** Set SIDEBAR variable **
		// Use PLUGIN_CONTROLLER_ACTION by default, 
		// but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray(
				$this->params['plugin'] . '_'.
				$this->params['controller'] . '_'.
				$this->params['action']));
														
		// ** Set SUMMARY variable from plugin's COMPONENTS **
		$this->set('ctrapp_summary', $this->Summaries->build($collection_id, $sample_master_id, $aliquot_master_id));
															
		// ** Set FORM variable **
		
		$this->set('realiquotable_parent_form', $this->Forms->getFormArray('realiquotable_parent_list'));
		$this->set('ctrapp_form', $this->Forms->getFormArray('realiquoted_parent_list'));

		// ** Set FORM data for echo on view **
//		$this->set('aliquot_barcode', $aliquot_master_data['AliquotMaster']['barcode']);
//		$this->set('sample_code', $sample_master_data['SampleMaster']['sample_code']);

		$this->set('specimen_group_menu_id', $specimen_group_menu_id);
		$this->set('group_specimen_type', $group_specimen_type);
		$this->set('sample_category', $sample_category);
		
		$this->set('collection_id', $collection_id);
		$this->set('aliquot_master_id', $aliquot_master_id);
		
				
		// ** Set MENU variable for echo on VIEW **
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_00', 'inv_CAN_10', $collection_id);
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_10', $specimen_group_menu_id, $collection_id);
		
		$specimen_grp_menu_lists = $this->getSpecimenGroupMenu($specimen_group_menu_id);
		
		switch($sample_category) {
			case "specimen":
				$specimen_sample_master_id=$sample_master_id;
				
				$specimen_menu_id = $specimen_group_menu_id . '-sa_al';
				$aliquot_menu_id = $specimen_group_menu_id . '-sa_al_re';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id . '/' . $specimen_sample_master_id);	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $aliquot_menu_id, $specimen_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($specimen_menu_id, $aliquot_menu_id, $collection_id . '/' . $aliquot_master_id);	
				break;
				
			case "derivative":
				$specimen_sample_master_id=$sample_master_data['SampleMaster']['initial_specimen_sample_id'];
				$derivative_sample_master_id=$sample_master_id;		
				
				$specimen_menu_id = $specimen_group_menu_id . '-sa_der';
				$derivative_menu_id = $specimen_group_menu_id . '-der_al';
				$aliquot_menu_id = $specimen_group_menu_id . '-der_al_re';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id . '/' . $specimen_sample_master_id);	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $derivative_menu_id, $specimen_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_menu_id, $derivative_menu_id, $collection_id . '/' . $derivative_sample_master_id . '/');	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $aliquot_menu_id, $derivative_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($derivative_menu_id, $aliquot_menu_id, $collection_id . '/' . $aliquot_master_id);	
				break;
			
			default:
				$this->redirect('/pages/err_inv_menu_definition'); 
				exit;
		}
		
		$this->set('ctrapp_menu', $ctrapp_menu);

		// ** Search aliquot data to display in the list **
		
		// Search ids of the aliquots that have been already be defined as realiquoted parent
		// These aliquots will be excluded from the list
		
		$criteria = array();
		$criteria['child_aliquot_master_id'] = $aliquot_master_id;

		$already_realiquoted_parent_id = 
			$this->Realiquoting->generateList($criteria, 
											null, 
											null, 
											'{n}.Realiquoting.parent_aliquot_master_id', 
											'{n}.Realiquoting.parent_aliquot_master_id');

		// Note we actually consider that only one aliquot can be defined as realiquoted parent
		if(sizeof($already_realiquoted_parent_id) >= 1) {
			$this->redirect('/pages/err_inv_system_error'); 
			exit;
		}

		// Search ids of the aliquots that could be defined as realiquoted parent

		$criteria= 'AliquotMaster.sample_master_id = ' . $sample_master_data['SampleMaster']['id'];
		$criteria.= ' AND AliquotMaster.status = \'available\'';
		$criteria.= ' AND AliquotMaster.id NOT IN (\'' . $aliquot_master_id . '\'';
		if(!empty($already_realiquoted_parent_id)) {
			// Aliquot have already be defined as parent
			$criteria.= ', \''.implode('\',\'', array_keys($already_realiquoted_parent_id)) . '\'';
		}
		$criteria.= ')';
				
		$av_realiquotable_aliquots = $this->AliquotMaster->findAll($criteria, null, null, null, 0);

		if(empty($av_realiquotable_aliquots)){
			$this->redirect('/pages/err_inv_system_error'); 
			exit;
		}
		
		$this->set('realiquotable_aliquots', $av_realiquotable_aliquots);
		
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'] . '_' . $this->params['action'] . '_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
		if (empty($this->data)) {
			// Edit Data
			$this->data = $av_realiquotable_aliquots;
			$this->set('data', $this->data);	
							
		} else {
			// ** Save data	**
						
			// setup MODEL(s) validation array(s) for displayed FORM 
			foreach ($this->Forms->getValidateArray('realiquoted_parent_list') as $validate_model=>$validate_rules) {
				$this->{$validate_model}->validate = $validate_rules;
			}
			
			// Run validation
			$submitted_data_validates = true;	
			$aliquots_to_define_as_source = array();
			
			if(!$this->AliquotMaster->validates($this->data['AliquotMaster'])){
				$submitted_data_validates = false;
			}
			
			if(!$this->AliquotUse->validates($this->data['AliquotUse'])){
				$submitted_data_validates = false;
			}
			
			if(!$this->Realiquoting->validates($this->data['Realiquoting'])){
				$submitted_data_validates = false;
			}
			
			$parent_aliquot_master_id = null;
			$parent_aliquot_volume_unit = null;
			if(empty($this->data['Realiquoting']['parent_aliquot_master_id'])) {
				$submitted_data_validates = false;
				$this->AliquotMaster->validationErrors[] = 'realiquoted parent selection is required';						
			} else {
				
				// Search the realiquoted parent aliquot volume unit
				$parent_aliquot_master_id = $this->data['Realiquoting']['parent_aliquot_master_id'];
				
				$criteria = array();
				$criteria['AliquotMaster.id'] = $parent_aliquot_master_id;
				$criteria['AliquotMaster.collection_id'] = $collection_id;
				$criteria = array_filter($criteria);
				
				$parent_aliquot_master_data = $this->AliquotMaster->find($criteria, null, null, 0);		
				if(empty($parent_aliquot_master_data)){
					$this->redirect('/pages/err_inv_aliquot_no_data'); 
					exit;
				}
				
				$parent_aliquot_volume_unit = $parent_aliquot_master_data['AliquotMaster']['aliquot_volume_unit'];
				
				if(empty($parent_aliquot_volume_unit) 
				&& (!empty($this->data['AliquotUse']['used_volume']))) {
					// No volume is tracked for this aliquot type
					$this->AliquotMaster->validationErrors[] 
						= 'no volume has to be recorded for this aliquot type';	
					$submitted_data_validates = false;
				}
				
			}
						
			if(empty($this->data['AliquotUse']['used_volume'])){
				$this->data['AliquotUse']['used_volume']=null;
			}
			
			// look for CUSTOM HOOKS, "validation"
			$custom_ctrapp_controller_hook 
				= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
				'controllers' . DS . 'hooks' . DS . 
				$this->params['controller'] . '_' . $this->params['action'] . '_validation.php';
			
			if (file_exists($custom_ctrapp_controller_hook)) {
				require($custom_ctrapp_controller_hook);
			}
			
			if ($submitted_data_validates) {
				
				$this->cleanUpFields('Realiquoting');
					
				// Get data
				$realiquoting_data = $this->data['Realiquoting'];	
				$realiquoted_aliquot_master_data = $this->data['AliquotMaster'];	
				$use_data = $this->data['AliquotUse'];	
				$function_management_data = $this->data['FunctionManagement'];
				
				// Launch Save function
				$bool_save_done = true;
										
				// 1- Update ALIQUOT MASTER data of the realiquoted parent	
				$realiquoted_aliquot_master_data['id'] = $parent_aliquot_master_id;			
				
				if(strcmp($function_management_data['delete_storage_data'], 'yes') == 0){
					// Delete aliquot storage data
					$realiquoted_aliquot_master_data['storage_master_id'] = null;
					$realiquoted_aliquot_master_data['storage_coord_x'] = null;
					$realiquoted_aliquot_master_data['storage_coord_y'] = null;
				}
				
				// Save 
				unset($realiquoted_aliquot_master_data['created']);
				unset($realiquoted_aliquot_master_data['created_by']);
				
				if(!$this->AliquotMaster->save($realiquoted_aliquot_master_data)){
					$bool_save_done = false;
				} 

				// 2- Save ALIQUOT USE data for the realiquoted parent					
				if($bool_save_done) {
					
					// Add additional data
					$use_data['aliquot_master_id'] = $parent_aliquot_master_id;
					$use_data['use_datetime'] = $realiquoting_data['realiquoted_datetime'];
					
					$use_data['use_definition'] = 'realiquoted to';
					$use_data['use_details'] = $realiquoted_aliquot_barcode;
					$use_data['use_recorded_into_table'] = 'realiquotings';
					
					if(is_null($parent_aliquot_volume_unit) || empty($parent_aliquot_volume_unit)){
						// No volume should be recorded: Set used volume to null
						$use_data['used_volume'] = null;
					}					

				if(!$this->AliquotUse->save($use_data)){
					$bool_save_done = false;
				} 
					
				}
				
				// 3- Save realiquoting data into REALIQUOTING table
				if($bool_save_done) {
					
					$aliquot_use_id = $this->AliquotUse->getLastInsertId();

					// Set data for realiquotinf table
					$realiquoting_data['child_aliquot_master_id'] = $aliquot_master_id;
					$realiquoting_data['aliquot_use_id'] = $aliquot_use_id;	
					
					$realiquoting_data['created'] = date('Y-m-d G:i');
					$realiquoting_data['created_by'] = $this->othAuth->user('id');
					$realiquoting_data['modified'] = date('Y-m-d G:i');
					$realiquoting_data['modified_by'] = $this->othAuth->user('id');		
				
					if(!$this->Realiquoting->save($realiquoting_data)){
						$bool_save_done = false;
					}
				
				}
						
				if(!$bool_save_done){
					$this->redirect('/pages/err_inv_aliquot_use_record_err'); 
					exit;
					
				} else {
					
					// Update current volume of the realiquoted parent aliquot
					$this->updateAliquotCurrentVolume($parent_aliquot_master_id);
												
					// Data have been updated
					$this->Flash('Your aliquot has been defined as realiquoted parent aliquot . ', 
						'/aliquot_masters/listRealiquotedParents/'.
							$specimen_group_menu_id . '/' . $group_specimen_type . '/' . $sample_category . '/' . $collection_id.
							'/' . $aliquot_master_id . '/');			
				} 
			} // End Save Functions execution	
			
		} // End Save Section (validation + save)
		
	} // End function addRealiquotedParentInBatch

	function deleteRealiquotedParent($specimen_group_menu_id=null, $group_specimen_type=null, $sample_category=null,	
	$collection_id=null, $aliquot_master_id=null, $realiquoted_aliquot_master_id) {
		
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($specimen_group_menu_id) || empty($group_specimen_type) || 
		empty($sample_category) || empty($collection_id) || empty($aliquot_master_id)
		|| empty($realiquoted_aliquot_master_id)) {
			$this->redirect('/pages/err_inv_funct_param_missing'); 
			exit;
		}
		
		// * Verify that this record match a realiquoted defintion **
		
		// Check in Realiquoting
		$criteria = array();		
		$criteria['Realiquoting.parent_aliquot_master_id'] = $realiquoted_aliquot_master_id;
		$criteria['Realiquoting.child_aliquot_master_id'] = $aliquot_master_id;
				
		$realiquoting_record = $this->Realiquoting->find($criteria, null, null, 0);
		
		if(empty($realiquoting_record)){
			$this->redirect('/pages/err_inv_system_error'); 
			exit;	
		}
			
		// Check in AliquotUse
		$aliquot_use_id = $realiquoting_record['Realiquoting']['aliquot_use_id'];
		
		$criteria = array();		
		$criteria['AliquotUse.id'] = $aliquot_use_id;
		$criteria['AliquotUse.aliquot_master_id'] = $realiquoted_aliquot_master_id;
				
		$aliquot_use_record = $this->AliquotUse->find($criteria, null, null, 0);
		
		if(empty($aliquot_use_record)){
			$this->redirect('/pages/err_inv_invalid_source_aliquot'); 
			exit;		
		}	
		
		// look for CUSTOM HOOKS, "validation"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'] . '_' . $this->params['action'] . '_validation.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
		// ** Delete Record **
		$bool_delete_source_aliquot = true;
	
		if(!$this->Realiquoting->del($realiquoting_record['Realiquoting']['id'])){
			$bool_delete_source_aliquot = false;		
		}	
		
		if($bool_delete_source_aliquot){
			if(!$this->AliquotUse->del($aliquot_use_id)){
				$bool_delete_source_aliquot = false;		
			}			
		}
		
		if(!$bool_delete_source_aliquot){
			$this->redirect('/pages/err_inv_aliqu_use_del_err'); 
			exit;
		}
		
		$this->flash('Your aliquot has been deleted from the list of realiquoted parent . ', 
					'/aliquot_masters/listRealiquotedParents/'.
							$specimen_group_menu_id . '/' . $group_specimen_type . '/'.
							$sample_category . '/' . $collection_id.
							'/' . $aliquot_master_id . '/');
		
	} // End function deleteSourceAliquot
	
	/**
	 * Allow to display the use list of a aliquot.
	 * 
	 * @param $specimen_group_menu_id Menu id that corresponds to the tab clicked to 
	 * display the samples of the collection group (Ascite, Blood, Tissue, etc).
	 * @param $group_specimen_type Type of the source specimens of the group.
	 * @param $sample_category Sample Category.
	 * @param $collection_id Id of the studied collection.
	 * @param $aliquot_master_id Master Id of the aliquot. 
	 * 
	 * @author N. Luc
	 * @date 2007-08-15
	 */
	function listAliquotUses($specimen_group_menu_id=null, $group_specimen_type=null, $sample_category=null,	
	$collection_id=null, $aliquot_master_id=null) {
		
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($specimen_group_menu_id) || empty($group_specimen_type) || 
		empty($sample_category) || empty($collection_id) || empty($aliquot_master_id)) {
			$this->redirect('/pages/err_inv_funct_param_missing'); 
			exit;
		}
		
		// ** Look for Aliquot Data **
		$criteria = array();
		$criteria['AliquotMaster.id'] = $aliquot_master_id;
		$criteria['AliquotMaster.collection_id'] = $collection_id;
		$criteria = array_filter($criteria);
		
		$aliquot_master_data = $this->AliquotMaster->find($criteria, null, null, 0);
		
		if(empty($aliquot_master_data)){
			$this->redirect('/pages/err_inv_aliquot_no_data'); 
			exit;
		}
				
		//** Get the aliquot sample master data **
		
		$sample_master_id = $aliquot_master_data['AliquotMaster']['sample_master_id'];
		
		$criteria = array();
		$criteria['SampleMaster.id'] = $sample_master_id;
		$criteria['SampleMaster.collection_id'] = $collection_id;
		$criteria = array_filter($criteria);
	
		$sample_master_data = $this->SampleMaster->find($criteria, null, null, 0);
		
		if(empty($sample_master_data)){
			$this->redirect('/pages/err_inv_samp_no_data'); 
			exit;
		}
		
		// ** Set SIDEBAR variable **
		// Use PLUGIN_CONTROLLER_ACTION by default, 
		// but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray(
				$this->params['plugin'] . '_'.
				$this->params['controller'] . '_'.
				$this->params['action']));
														
		// ** Set SUMMARY variable from plugin's COMPONENTS **
		$this->set('ctrapp_summary', $this->Summaries->build($collection_id, $sample_master_id, $aliquot_master_id));
															
		// ** Set FORM variable **
		$this->set('ctrapp_form', $this->Forms->getFormArray('aliquot_use_list'));
		
		// ** Set FORM data for echo on view **
		$this->set('specimen_group_menu_id', $specimen_group_menu_id);
		$this->set('group_specimen_type', $group_specimen_type);
		$this->set('sample_category', $sample_category);
		
		$this->set('collection_id', $collection_id);
		$this->set('aliquot_master_id', $aliquot_master_id);
		
		$this->set('studies_list', $this->getStudiesArray());
					
		// ** Set MENU variable for echo on VIEW **
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_00', 'inv_CAN_10', $collection_id);
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_10', $specimen_group_menu_id, $collection_id);
		
		$specimen_grp_menu_lists = $this->getSpecimenGroupMenu($specimen_group_menu_id);
		
		switch($sample_category) {
			case "specimen":
				$specimen_sample_master_id=$sample_master_id;
				
				$specimen_menu_id = $specimen_group_menu_id . '-sa_al';
				$aliquot_menu_id = $specimen_group_menu_id . '-sa_al_us';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id . '/' . $specimen_sample_master_id);	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $aliquot_menu_id, $specimen_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($specimen_menu_id, $aliquot_menu_id, $collection_id . '/' . $aliquot_master_id);	
				break;
				
			case "derivative":
				$specimen_sample_master_id=$sample_master_data['SampleMaster']['initial_specimen_sample_id'];
				$derivative_sample_master_id=$sample_master_id;		
				
				$specimen_menu_id = $specimen_group_menu_id . '-sa_der';
				$derivative_menu_id = $specimen_group_menu_id . '-der_al';
				$aliquot_menu_id = $specimen_group_menu_id . '-der_al_us';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id . '/' . $specimen_sample_master_id);	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $derivative_menu_id, $specimen_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_menu_id, $derivative_menu_id, $collection_id . '/' . $derivative_sample_master_id . '/');	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $aliquot_menu_id, $derivative_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($derivative_menu_id, $aliquot_menu_id, $collection_id . '/' . $aliquot_master_id);	
				break;
			
			default:
				$this->redirect('/pages/err_inv_menu_definition'); 
				exit;
		}
		
		$this->set('ctrapp_menu', $ctrapp_menu);

		// ** Search aliquot uses data **
		
		$this->AliquotMaster->unbindModel(array('hasMany' => array('AliquotUse')));
		$this->AliquotMaster->unbindModel(array('belongsTo' => array('StorageMaster')));
		
		$this->AliquotUse->bindModel(array('belongsTo' => 
			array('AliquotMaster' => array(
					'className' => 'AliquotMaster',
					'conditions' => '',
					'order'      => '',
					'foreignKey' => 'aliquot_master_id'))));
		
		$criteria = array();
		$criteria['AliquotUse.aliquot_master_id'] = $aliquot_master_id;
		$criteria = array_filter($criteria);
		
		$aliquot_uses = $this->AliquotUse->findAll($criteria, null, null, null, 1);

		$this->set('aliquot_uses', $aliquot_uses);	
		
		// ** Build list of additional uses a user can add **
		$this->set('allowed_additional_uses', $this->getAllowedAdditionalAliqUses());
		
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'] . '_' . $this->params['action'] . '_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
	}

	function detailAliquotUse($specimen_group_menu_id=null, $group_specimen_type=null, $sample_category=null,	
	$collection_id=null, $aliquot_master_id=null, $aliquot_use_id=null) {
		
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($specimen_group_menu_id) || empty($group_specimen_type) || 
		empty($sample_category) || empty($collection_id) || empty($aliquot_master_id)
		|| empty($aliquot_use_id)) {
			$this->redirect('/pages/err_inv_funct_param_missing'); 
			exit;
		}
		
		// ** Look for Aliquot Data **
		$criteria = array();
		$criteria['AliquotMaster.id'] = $aliquot_master_id;
		$criteria['AliquotMaster.collection_id'] = $collection_id;
		$criteria = array_filter($criteria);
		
		$aliquot_master_data = $this->AliquotMaster->find($criteria, null, null, 0);
		
		if(empty($aliquot_master_data)){
			$this->redirect('/pages/err_inv_aliquot_no_data'); 
			exit;
		}
				
		//** Get the aliquot sample master data **
		
		$sample_master_id = $aliquot_master_data['AliquotMaster']['sample_master_id'];
		
		$criteria = array();
		$criteria['SampleMaster.id'] = $sample_master_id;
		$criteria['SampleMaster.collection_id'] = $collection_id;
		$criteria = array_filter($criteria);
	
		$sample_master_data = $this->SampleMaster->find($criteria, null, null, 0);
		
		if(empty($sample_master_data)){
			$this->redirect('/pages/err_inv_samp_no_data'); 
			exit;
		}
		
		// ** Set SIDEBAR variable **
		// Use PLUGIN_CONTROLLER_ACTION by default, 
		// but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray(
				$this->params['plugin'] . '_'.
				$this->params['controller'] . '_'.
				$this->params['action']));
														
		// ** Set SUMMARY variable from plugin's COMPONENTS **
		$this->set('ctrapp_summary', $this->Summaries->build($collection_id, $sample_master_id, $aliquot_master_id));
															
		// ** Set FORM variable **
		$this->set('ctrapp_form', $this->Forms->getFormArray('aliquot_use_list'));
		
		// ** Set FORM data for echo on view **
		$this->set('specimen_group_menu_id', $specimen_group_menu_id);
		$this->set('group_specimen_type', $group_specimen_type);
		$this->set('sample_category', $sample_category);
		
		$this->set('collection_id', $collection_id);
		$this->set('aliquot_master_id', $aliquot_master_id);
		
		$this->set('studies_list', $this->getStudiesArray());
					
		// ** Set MENU variable for echo on VIEW **
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_00', 'inv_CAN_10', $collection_id);
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_10', $specimen_group_menu_id, $collection_id);
		
		$specimen_grp_menu_lists = $this->getSpecimenGroupMenu($specimen_group_menu_id);
		
		switch($sample_category) {
			case "specimen":
				$specimen_sample_master_id=$sample_master_id;
				
				$specimen_menu_id = $specimen_group_menu_id . '-sa_al';
				$aliquot_menu_id = $specimen_group_menu_id . '-sa_al_us';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id . '/' . $specimen_sample_master_id);	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $aliquot_menu_id, $specimen_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($specimen_menu_id, $aliquot_menu_id, $collection_id . '/' . $aliquot_master_id);	
				break;
				
			case "derivative":
				$specimen_sample_master_id=$sample_master_data['SampleMaster']['initial_specimen_sample_id'];
				$derivative_sample_master_id=$sample_master_id;		
				
				$specimen_menu_id = $specimen_group_menu_id . '-sa_der';
				$derivative_menu_id = $specimen_group_menu_id . '-der_al';
				$aliquot_menu_id = $specimen_group_menu_id . '-der_al_us';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id . '/' . $specimen_sample_master_id);	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $derivative_menu_id, $specimen_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_menu_id, $derivative_menu_id, $collection_id . '/' . $derivative_sample_master_id . '/');	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $aliquot_menu_id, $derivative_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($derivative_menu_id, $aliquot_menu_id, $collection_id . '/' . $aliquot_master_id);	
				break;
			
			default:
				$this->redirect('/pages/err_inv_menu_definition'); 
				exit;
		}
		
		$this->set('ctrapp_menu', $ctrapp_menu);

		// ** Search aliquot use data **
		$this->AliquotMaster->unbindModel(array('hasMany' => array('AliquotUse')));
		$this->AliquotMaster->unbindModel(array('belongsTo' => array('StorageMaster')));
		
		$this->AliquotUse->bindModel(array('belongsTo' => 
			array('AliquotMaster' => array(
					'className' => 'AliquotMaster',
					'conditions' => '',
					'order'      => '',
					'foreignKey' => 'aliquot_master_id'))));
		
		$criteria = array();
		$criteria['AliquotUse.id'] = $aliquot_use_id;
		$criteria['AliquotUse.aliquot_master_id'] = $aliquot_master_id;
		$criteria = array_filter($criteria);
	
		$aliquot_use_data = $this->AliquotUse->find($criteria, null, null, 0);
		
		if(empty($aliquot_use_data)){
			$this->redirect('/pages/err_inv_aliq_use_no_data'); 
			exit;
		}
		
		$this->set('aliquot_use_data', $aliquot_use_data);
		
		$allow_use_management_by_user = false;
		if(in_array($aliquot_use_data['AliquotUse']['use_definition'], $this->getAllowedAdditionalAliqUses())) {
			$allow_use_management_by_user = true;
		}	
		$this->set('allow_use_management_by_user', $allow_use_management_by_user);
		
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'] . '_' . $this->params['action'] . '_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
	}
	
	function addAliquotUse($specimen_group_menu_id=null, $group_specimen_type=null, $sample_category=null,	
	$collection_id=null, $aliquot_master_id=null, $aliquot_use_defintion= null) {
		
		// ** Get the aliquot_use_defintion **
		if (isset($this->params['form']['aliquot_use_defintion'])) {
			$aliquot_use_defintion = $this->params['form']['aliquot_use_defintion'];
		}
		
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($specimen_group_menu_id) || empty($group_specimen_type) || 
		empty($sample_category) || empty($collection_id) || empty($aliquot_master_id) ||
		empty($aliquot_use_defintion)) {
			$this->redirect('/pages/err_inv_funct_param_missing'); 
			exit;
		}
		
		// ** Look for Aliquot Data **
		$criteria = array();
		$criteria['AliquotMaster.id'] = $aliquot_master_id;
		$criteria['AliquotMaster.collection_id'] = $collection_id;
		$criteria = array_filter($criteria);
		
		$aliquot_master_data = $this->AliquotMaster->find($criteria, null, null, 0);
		
		if(empty($aliquot_master_data)){
			$this->redirect('/pages/err_inv_aliquot_no_data'); 
			exit;
		}
				
		//** Get the aliquot sample master data **
		
		$sample_master_id = $aliquot_master_data['AliquotMaster']['sample_master_id'];
		
		$criteria = array();
		$criteria['SampleMaster.id'] = $sample_master_id;
		$criteria['SampleMaster.collection_id'] = $collection_id;
		$criteria = array_filter($criteria);
	
		$sample_master_data = $this->SampleMaster->find($criteria, null, null, 0);
		
		if(empty($sample_master_data)){
			$this->redirect('/pages/err_inv_samp_no_data'); 
			exit;
		}
		
		// ** Set SIDEBAR variable **
		// Use PLUGIN_CONTROLLER_ACTION by default, 
		// but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray(
				$this->params['plugin'] . '_'.
				$this->params['controller'] . '_'.
				$this->params['action']));
														
		// ** Set SUMMARY variable from plugin's COMPONENTS **
		$this->set('ctrapp_summary', $this->Summaries->build($collection_id, $sample_master_id, $aliquot_master_id));
															
		// ** Set FORM variable **
		$this->set('ctrapp_form', $this->Forms->getFormArray('aliquot_use_list'));
		
		// ** Set FORM data for echo on view **
		$this->set('specimen_group_menu_id', $specimen_group_menu_id);
		$this->set('group_specimen_type', $group_specimen_type);
		$this->set('sample_category', $sample_category);
		
		$this->set('collection_id', $collection_id);
		$this->set('aliquot_master_id', $aliquot_master_id);
		
		$this->set('aliquot_use_defintion', $aliquot_use_defintion);
		$this->set('aliquot_volume_unit', $aliquot_master_data['AliquotMaster']['aliquot_volume_unit']);
		
		$this->set('studies_list', $this->getStudiesArray());
					
		// ** Set MENU variable for echo on VIEW **
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_00', 'inv_CAN_10', $collection_id);
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_10', $specimen_group_menu_id, $collection_id);
		
		$specimen_grp_menu_lists = $this->getSpecimenGroupMenu($specimen_group_menu_id);
		
		switch($sample_category) {
			case "specimen":
				$specimen_sample_master_id=$sample_master_id;
				
				$specimen_menu_id = $specimen_group_menu_id . '-sa_al';
				$aliquot_menu_id = $specimen_group_menu_id . '-sa_al_us';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id . '/' . $specimen_sample_master_id);	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $aliquot_menu_id, $specimen_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($specimen_menu_id, $aliquot_menu_id, $collection_id . '/' . $aliquot_master_id);	
				break;
				
			case "derivative":
				$specimen_sample_master_id=$sample_master_data['SampleMaster']['initial_specimen_sample_id'];
				$derivative_sample_master_id=$sample_master_id;		
				
				$specimen_menu_id = $specimen_group_menu_id . '-sa_der';
				$derivative_menu_id = $specimen_group_menu_id . '-der_al';
				$aliquot_menu_id = $specimen_group_menu_id . '-der_al_us';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id . '/' . $specimen_sample_master_id);	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $derivative_menu_id, $specimen_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_menu_id, $derivative_menu_id, $collection_id . '/' . $derivative_sample_master_id . '/');	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $aliquot_menu_id, $derivative_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($derivative_menu_id, $aliquot_menu_id, $collection_id . '/' . $aliquot_master_id);	
				break;
			
			default:
				$this->redirect('/pages/err_inv_menu_definition'); 
				exit;
		}
		
		$this->set('ctrapp_menu', $ctrapp_menu);
		
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'] . '_' . $this->params['action'] . '_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}

		if (!empty($this->data)) {
			
			// setup MODEL(s) validation array(s) for displayed FORM 
			foreach ($this->Forms->getValidateArray('aliquot_use_list') as $validate_model=>$validate_rules) {
				$this->{ $validate_model }->validate = $validate_rules;
			}

			$this->cleanUpFields('AliquotUse');
						
			// set a FLAG
			$submitted_data_validates = true;
			
			// VALIDATE submitted data
			if (!$this->AliquotUse->validates($this->data)) {
				$submitted_data_validates = false;
			}
			
			if(empty($this->data['AliquotMaster']['aliquot_volume_unit']) 
			&& (!empty($this->data['AliquotUse']['used_volume']))) {
				// No volume is tracked for this aliquot type
				$this->AliquotMaster->validationErrors[] 
					= 'no volume has to be recorded for this aliquot type';	
				$submitted_data_validates = false;
			}
			if(empty($this->data['AliquotUse']['used_volume'])){
				$this->data['AliquotUse']['used_volume']=null;
			}
			
			// look for CUSTOM HOOKS, "validation"
			$custom_ctrapp_controller_hook 
				= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
				'controllers' . DS . 'hooks' . DS . 
				$this->params['controller'] . '_' . $this->params['action'] . '_validation.php';
			
			if (file_exists($custom_ctrapp_controller_hook)) {
				require($custom_ctrapp_controller_hook);
			}
			
			// if data VALIDATE, then save data
			if ($submitted_data_validates) {
				
				if ($this->AliquotUse->save($this->data['AliquotUse'])) {
					
					$this->updateAliquotCurrentVolume($aliquot_master_id);
					
					$this->flash('Your data has been saved . ', 
						'/aliquot_masters/listAliquotUses/'.
						$specimen_group_menu_id . '/' . $group_specimen_type . '/' . $sample_category . '/'.
						$collection_id . '/' . $aliquot_master_id . '/');
				} else {
					$this->redirect('/pages/err_inv_aliquot_use_record_err'); 
					exit;
				}
				
			}
			
		}
		
	}
	
	function editAliquotUse($specimen_group_menu_id=null, $group_specimen_type=null, $sample_category=null,	
	$collection_id=null, $aliquot_master_id=null, $aliquot_use_id= null) {
		
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($specimen_group_menu_id) || empty($group_specimen_type) || 
		empty($sample_category) || empty($collection_id) || empty($aliquot_master_id) ||
		empty($aliquot_use_id)) {
			$this->redirect('/pages/err_inv_funct_param_missing'); 
			exit;
		}
		
		// ** Look for Aliquot Data **
		$criteria = array();
		$criteria['AliquotMaster.id'] = $aliquot_master_id;
		$criteria['AliquotMaster.collection_id'] = $collection_id;
		$criteria = array_filter($criteria);
		
		$aliquot_master_data = $this->AliquotMaster->find($criteria, null, null, 0);
		
		if(empty($aliquot_master_data)){
			$this->redirect('/pages/err_inv_aliquot_no_data'); 
			exit;
		}
				
		//** Get the aliquot sample master data **
		
		$sample_master_id = $aliquot_master_data['AliquotMaster']['sample_master_id'];
		
		$criteria = array();
		$criteria['SampleMaster.id'] = $sample_master_id;
		$criteria['SampleMaster.collection_id'] = $collection_id;
		$criteria = array_filter($criteria);
	
		$sample_master_data = $this->SampleMaster->find($criteria, null, null, 0);
		
		if(empty($sample_master_data)){
			$this->redirect('/pages/err_inv_samp_no_data'); 
			exit;
		}
		
		// ** Set SIDEBAR variable **
		// Use PLUGIN_CONTROLLER_ACTION by default, 
		// but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray(
				$this->params['plugin'] . '_'.
				$this->params['controller'] . '_'.
				$this->params['action']));
														
		// ** Set SUMMARY variable from plugin's COMPONENTS **
		$this->set('ctrapp_summary', $this->Summaries->build($collection_id, $sample_master_id, $aliquot_master_id));
															
		// ** Set FORM variable **
		$this->set('ctrapp_form', $this->Forms->getFormArray('aliquot_use_list'));
		
		// ** Set FORM data for echo on view **
		$this->set('specimen_group_menu_id', $specimen_group_menu_id);
		$this->set('group_specimen_type', $group_specimen_type);
		$this->set('sample_category', $sample_category);
		
		$this->set('collection_id', $collection_id);
		$this->set('aliquot_master_id', $aliquot_master_id);
		
		$this->set('aliquot_volume_unit', $aliquot_master_data['AliquotMaster']['aliquot_volume_unit']);
		$this->set('studies_list', $this->getStudiesArray());
					
		// ** Set MENU variable for echo on VIEW **
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_00', 'inv_CAN_10', $collection_id);
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_10', $specimen_group_menu_id, $collection_id);
		
		$specimen_grp_menu_lists = $this->getSpecimenGroupMenu($specimen_group_menu_id);
		
		switch($sample_category) {
			case "specimen":
				$specimen_sample_master_id=$sample_master_id;
				
				$specimen_menu_id = $specimen_group_menu_id . '-sa_al';
				$aliquot_menu_id = $specimen_group_menu_id . '-sa_al_us';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id . '/' . $specimen_sample_master_id);	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $aliquot_menu_id, $specimen_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($specimen_menu_id, $aliquot_menu_id, $collection_id . '/' . $aliquot_master_id);	
				break;
				
			case "derivative":
				$specimen_sample_master_id=$sample_master_data['SampleMaster']['initial_specimen_sample_id'];
				$derivative_sample_master_id=$sample_master_id;		
				
				$specimen_menu_id = $specimen_group_menu_id . '-sa_der';
				$derivative_menu_id = $specimen_group_menu_id . '-der_al';
				$aliquot_menu_id = $specimen_group_menu_id . '-der_al_us';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id . '/' . $specimen_sample_master_id);	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $derivative_menu_id, $specimen_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_menu_id, $derivative_menu_id, $collection_id . '/' . $derivative_sample_master_id . '/');	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $aliquot_menu_id, $derivative_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($derivative_menu_id, $aliquot_menu_id, $collection_id . '/' . $aliquot_master_id);	
				break;
			
			default:
				$this->redirect('/pages/err_inv_menu_definition'); 
				exit;
		}
		
		$this->set('ctrapp_menu', $ctrapp_menu);
		
		// ** Search aliquot use data **
		
		$this->AliquotMaster->unbindModel(array('hasMany' => array('AliquotUse')));
		$this->AliquotMaster->unbindModel(array('belongsTo' => array('StorageMaster')));
		
		$this->AliquotUse->bindModel(array('belongsTo' => 
			array('AliquotMaster' => array(
					'className' => 'AliquotMaster',
					'conditions' => '',
					'order'      => '',
					'foreignKey' => 'aliquot_master_id'))));
		
		$criteria = array();
		$criteria['AliquotUse.id'] = $aliquot_use_id;
		$criteria['AliquotUse.aliquot_master_id'] = $aliquot_master_id;
		$criteria = array_filter($criteria);
	
		$aliquot_use_data = $this->AliquotUse->find($criteria, null, null, 0);
		
		if(empty($aliquot_use_data)){
			$this->redirect('/pages/err_inv_aliq_use_no_data'); 
			exit;
		}
		
		if(!in_array($aliquot_use_data['AliquotUse']['use_definition'], $this->getAllowedAdditionalAliqUses())) {
			// User is not alloed to modify this use record
			$this->redirect('/pages/err_inv_system_error'); 
			exit;
		}
		
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'] . '_' . $this->params['action'] . '_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}

		if (empty($this->data)) {
			
			// set use data to display
			$this->data = $aliquot_use_data;
			$this->set('data', $this->data);
			
		} else {
			
			// setup MODEL(s) validation array(s) for displayed FORM 
			foreach ($this->Forms->getValidateArray('aliquot_use_list') as $validate_model=>$validate_rules) {
				$this->{ $validate_model }->validate = $validate_rules;
			}

			$this->cleanUpFields('AliquotUse');
			
			// set a FLAG
			$submitted_data_validates = true;
			
			// VALIDATE submitted data
			if (!$this->AliquotUse->validates($this->data['AliquotUse'])) {
				$submitted_data_validates = false;
			}
			
			if(empty($this->data['AliquotMaster']['aliquot_volume_unit']) 
			&& (!empty($this->data['AliquotUse']['used_volume']))) {
				// No volume is tracked for this aliquot type
				$this->AliquotMaster->validationErrors[] 
					= 'no volume has to be recorded for this aliquot type';	
				$submitted_data_validates = false;
			}
			if(empty($this->data['AliquotUse']['used_volume'])){
				$this->data['AliquotUse']['used_volume']=null;
			}
			
			// look for CUSTOM HOOKS, "validation"
			$custom_ctrapp_controller_hook 
				= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
				'controllers' . DS . 'hooks' . DS . 
				$this->params['controller'] . '_' . $this->params['action'] . '_validation.php';
			
			if (file_exists($custom_ctrapp_controller_hook)) {
				require($custom_ctrapp_controller_hook);
			}
			
			// if data VALIDATE, then save data
			if ($submitted_data_validates) {
				
				// set a FLAG
				$bool_save_error = false;
				
				if ($this->AliquotUse->save($this->data['AliquotUse'])) {
					
					$this->updateAliquotCurrentVolume($aliquot_master_id);
					
					$this->flash('Your data has been saved . ', 
						'/aliquot_masters/detailAliquotUse/'.
						$specimen_group_menu_id . '/' . $group_specimen_type . '/' . $sample_category . '/'.
						$collection_id . '/' . $aliquot_master_id . '/' . $aliquot_use_id . '/');
				} else {
					$this->redirect('/pages/err_inv_aliquot_use_record_err'); 
					exit;
				}
				
			}
						
		}
		
	}
	
	function deleteAliquotUse($specimen_group_menu_id=null,  $group_specimen_type=null, $sample_category=null, 
	$collection_id=null, $aliquot_master_id=null, $aliquot_use_id=null) {
			
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($specimen_group_menu_id) || empty($group_specimen_type) || 
		empty($sample_category) || empty($collection_id) || empty($aliquot_master_id)|| 
		empty($aliquot_use_id)) {
			$this->redirect('/pages/err_inv_funct_param_missing'); 
			exit;
		}
		
		// ** Load  ALIQUOT USE info **
		$criteria = array();
		$criteria['AliquotUse.id'] = $aliquot_use_id;
		$criteria['AliquotUse.aliquot_master_id'] = $aliquot_master_id;
		$criteria = array_filter($criteria);
	
		$aliquot_use_data = $this->AliquotUse->find($criteria, null, null, 0);
		
		// Verify aliquot use can be deleted
		if(!in_array($aliquot_use_data['AliquotUse']['use_definition'], $this->getAllowedAdditionalAliqUses())) {
			// User is not allowed to modify this use record
			$this->redirect('/pages/err_inv_system_error'); 
			exit;
		}
		
		// look for CUSTOM HOOKS, "validation"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'] . '_' . $this->params['action'] . '_validation.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
		//Delete aliquot
		$bool_delete_aliquot = true;
	
		if(!$this->AliquotUse->del($aliquot_use_id)){
			$this->redirect('/pages/err_inv_aliqu_use_del_err'); 
			exit;
		}
		
		$this->updateAliquotCurrentVolume($aliquot_master_id);
		
		$this->Flash('Your data has been deleted . ',
			'/aliquot_masters/listAliquotUses/'.
			$specimen_group_menu_id . '/' . $group_specimen_type . '/' . $sample_category . '/'.
			$collection_id . '/' . $aliquot_master_id . '/');
	
	} //end deleteAliquotUse
	
	function getAllowedAdditionalAliqUses() {
		
		// ** Build list of additional use a user can add **
		
		$criteria = array();
		$criteria['GlobalLookup.alias'] = 'aliquot_use_definition';
		$criteria[] = "GlobalLookup.display_order != '-1'";
		$criteria = array_filter($criteria);
		
		$additional_uses = 
			$this->GlobalLookup->generateList(
				$criteria,
				"GlobalLookup.display_order ASC", 
				null, 
				'{n}.GlobalLookup.value', 
				'{n}.GlobalLookup.language_choice');
				
		return $additional_uses;			
			
	}
		
	/* --------------------------------------------------------------------------
	 * ADDITIONAL FUNCTIONS
	 * -------------------------------------------------------------------------- */	
	

		
	/**
	 * Update the current volume of a aliquot.
	 * 
	 * When the intial volume is null, the current volume will be set to 
	 * null but the status won't be changed.
	 * 
	 * When the new current volume is equal to 0 and the status is 'available',
	 * the status will be automatically change to 'not available' 
	 * and the reason to 'empty'
	 *
	 * @param $aliquot_master_id Master Id of the aliquot.
	 * 
	 * @author N. Luc
	 * @date 2007-08-15
	 */
	function obslolete_updateAliquotCurrentVolume($aliquot_master_id){}


	
	/*
		DATAMART PROCESS, addes BATCH SET aliquot IDs to ORDER ITEMs
		Multi-part process, linking Orders, OrderLines, and OrderItems (all ACTIONs the same name in each CONTROLLER)
	*/
	
	function process_add_aliquots($aliquot_id) {
		
		// clear SESSION info
		$_SESSION['ctrapp_core']['datamart']['process'] = array(
			'AliquotMaster' => array(
				'id' => array(
					'0' => $aliquot_id
				)
			),
			'BatchSet' => array(
				'process' => 'order/orders/process_add_aliquots',
				'id' => 0,
				'model' => 'AliquotMaster'
			)
		);
		
		$this->redirect('order/orders/process_add_aliquots/');
		exit();
		
	}

	function validateStorageIdAndSelectionLabel($storage_selection_label, $storage_master_id) {
	
		$submitted_data_validates = true;
		$defined_storage_id = $storage_master_id;
		$aliquot_arr_storage_list = array();
		$storage_control_errors = array();

		if(!empty($storage_selection_label)) {
			
			// Case 1: A storage selection label exists
			
			// Look for storage matching the storage selection label 
			$aliquot_arr_storage_list 
				= $this->requestAction(
					'/storagelayout/storage_masters/getStorageMatchingSelectLabel/' . $storage_selection_label);
			
			if(empty($storage_master_id)) {	
				
				// Case 1.a: No storage id has been defined: Define storage id using selection label
				
				if(empty($aliquot_arr_storage_list)) {
					// No storage matches	
					$submitted_data_validates = false;
					$storage_control_errors['B1'] 
						= 'no storage matches (at least one of) the selection label(s)';
				} else if(sizeof($aliquot_arr_storage_list) > 1) {
					// More than one storage matche this storage selection label
					$submitted_data_validates = false;
					$storage_control_errors['B2'] 
						= 'more than one storages matche (at least one of) the selection label(s)';
				} else {
					// The selection label match only one storage: Get the storage_master_id
					$defined_storage_id = key($aliquot_arr_storage_list);
				}
			
			} else {
				
				// Case 1.b: A storage id has been selected
				
				// Verify this one matches one record of the $arr_storage_list;
				if(!array_key_exists($storage_master_id, $aliquot_arr_storage_list)) {
		
					// Set error
					$submitted_data_validates = false;
					$storage_control_errors['B3'] 
						= '(at least one of) the selected id does not match a selection label';						
					
					// Add the storage to the storage list
					$aliquot_arr_storage_list[$storage_master_id] 
						= $this->requestAction('/storagelayout/storage_masters/getStorageData/' . $storage_master_id);								

				}	
			}
		
		} else if(!empty($storage_master_id)) {
			
			// Case 2: Only storage_master_id has been defined
						
			// Only  storage id has been selected:
			// Add this one in $arr_storage_list if an error is displayed
			$aliquot_arr_storage_list 
				= array($storage_master_id  
					=> $this->requestAction('/storagelayout/storage_masters/getStorageData/' . $storage_master_id));
				
		} // else if $returned_storage_id and $recorded_selection_label empty: Nothing to do	
		
		return array(
			'submitted_data_validates' => $submitted_data_validates,
			'defined_storage_id' => $defined_storage_id,
			'aliquot_arr_storage_list' => $aliquot_arr_storage_list,
			'storage_control_errors' => $storage_control_errors);
			
	}
	
	function validateStorageCoordinates($storage_master_id, $storage_coord_x, $storage_coord_y) {
		
		$submitted_data_validates = true;
		$validated_storage_coord_x = $storage_coord_x;
		$validated_storage_coord_y = $storage_coord_y;
		$storage_control_errors = array();
	
		if(empty($storage_master_id)){
			// No storage selected: no coordinate should be set
			if(!empty($storage_coord_x)){
				$submitted_data_validates = false;
				$validated_storage_coord_x = 'err!';
				$storage_control_errors['C1'] = 'no postion has to be recorded when no storage is selected';
			}
			if(!empty($storage_coord_y)){
				$submitted_data_validates = false;
				$validated_storage_coord_y = 'err!';
				$storage_control_errors['C1'] = 'no postion has to be recorded when no storage is selected';
			}						
				
		} else {
			// Verify coordinate values
			$a_coord_valid = 
				$this->requestAction('/storagelayout/storage_masters/validateStoragePosition/'.
					$storage_master_id . '/'.
					'x_' . $storage_coord_x . '/'.		// Add 'x_' before coord to support empty value
					'y_' . $storage_coord_y . '/');		// Add 'y_' before coord to support empty value
					
			// Manage coordinate x
			if(!$a_coord_valid['coord_x']['validated']) {
				$submitted_data_validates = false;
				$validated_storage_coord_x = 'err!';
				$storage_control_errors['C2'] = 'at least one position value does not match format';
			} else if($a_coord_valid['coord_x']['to_uppercase']) {
				$validated_storage_coord_x = strtoupper($storage_coord_x);
			}
			
			// Manage coordinate y
			if(!$a_coord_valid['coord_y']['validated']) {
				$submitted_data_validates = false;
				$validated_storage_coord_y = 'err!';
				$storage_control_errors['C2'] = 'at least one position value does not match format';
			} else if($a_coord_valid['coord_y']['to_uppercase']) {
				$validated_storage_coord_y = strtoupper($storage_coord_y);
			}
		
		}
		
		return array(
			'submitted_data_validates' => $submitted_data_validates,
			'validated_storage_coord_x' => $validated_storage_coord_x,
			'validated_storage_coord_y' => $validated_storage_coord_y,
			'storage_control_errors' => $storage_control_errors);
		
	}

}

?>
