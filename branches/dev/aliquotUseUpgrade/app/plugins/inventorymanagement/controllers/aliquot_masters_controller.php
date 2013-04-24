<?php
class AliquotMastersController extends InventoryManagementAppController {
	
	var $components = array();
	
	var $uses = array(
		'Inventorymanagement.Collection',
		
		'Inventorymanagement.SampleMaster',
		'Inventorymanagement.DerivativeDetail',
		
		'Inventorymanagement.SampleControl',
		'Inventorymanagement.SampleToAliquotControl',
		
		'Inventorymanagement.AliquotControl', 
		'Inventorymanagement.AliquotMaster',
		'Inventorymanagement.AliquotMastersRev', 
		'Inventorymanagement.ViewAliquot',
		'Inventorymanagement.AliquotDetail',			
		
		'Inventorymanagement.SampleToAliquotControl',
		'Inventorymanagement.RealiquotingControl',
		
		'Inventorymanagement.ViewAliquotUse',
		'Inventorymanagement.AliquotInternalUse',
		'Inventorymanagement.Realiquoting',
		'Inventorymanagement.SourceAliquot',
		'Inventorymanagement.QualityCtrlTestedAliquot',	
		'Inventorymanagement.AliquotReviewMaster',
		'Order.OrderItem',
	
		'Storagelayout.StorageMaster',
		'Storagelayout.StorageCoordinate',
		
		'Datamart.BatchId'
	);
	
	var $paginate = array(
		'AliquotMaster' => array('limit' => pagination_amount , 'order' => 'AliquotMaster.barcode DESC'), 
		'ViewAliquot' => array('limit' => pagination_amount , 'order' => 'ViewAliquot.barcode DESC'), 
		'ViewAliquotUse' => array('limit' => pagination_amount, 'order' => 'ViewAliquotUse.use_datetime DESC'));

	/* --------------------------------------------------------------------------
	 * DISPLAY FUNCTIONS
	 * -------------------------------------------------------------------------- */

	/* ----------------------------- ALIQUOT MASTER ----------------------------- */
	
	function index() {
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/collections/index'));
						
		$_SESSION['ctrapp_core']['search'] = null; // clear SEARCH criteria
		$this->unsetInventorySessionData();
		
		$this->Structures->set('view_aliquot_joined_to_sample_and_collection');
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link); 
		}
	}
	
	function search() {
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/collections/index'));

		$view_aliquot = $this->Structures->get('form', 'view_aliquot_joined_to_sample_and_collection');
		$this->set('atim_structure', $view_aliquot);
		if ($this->data) $_SESSION['ctrapp_core']['search']['criteria'] = $this->Structures->parse_search_conditions($view_aliquot);
		
		$this->set('aliquots_data', $this->paginate($this->ViewAliquot, $_SESSION['ctrapp_core']['search']['criteria']));
		$this->data = array();
		
		// if SEARCH form data, save number of RESULTS and URL
		$_SESSION['ctrapp_core']['search']['results'] = $this->params['paging']['ViewAliquot']['count'];
		$_SESSION['ctrapp_core']['search']['url'] = '/inventorymanagement/aliquot_masters/search';
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link); 
		}
	}
	
	function listAll($collection_id, $sample_master_id, $filter_option = null) {
		if((!$collection_id) || (!$sample_master_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }
		// MANAGE FILTER OPTION

		$is_collection_aliquot_list = ($sample_master_id == '-1')? true: false;

		$model_to_use = null;
		$form_alias = null;
		$aliquot_search_criteria = array();
		$menu_variables = array();
		
		$sample_filter_value = '';
		$aliquot_filter_value = '';

		if($is_collection_aliquot_list) {
			//---------------------------------------------------
			// A- User is working on collection aliquots list
			//---------------------------------------------------
				
			// A.1- Manage filter option
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
				
			// A.2- Set Model, Alias, Menu Criteria and Search Criteria to use
			if(is_null($filter_option)) {
				// No filter
				$model_to_use = 'ViewAliquot';
				$form_alias = 'view_aliquot_joined_to_sample';
				
			} else  {
				// Get filter options: list all aliquots according to sample-aliquot types
				$option_for_list_all = explode("|", $filter_option);
				if(sizeof($option_for_list_all) != 2)  { $this->redirect('/pages/err_inv_system_error', null, true); }
				$sample_control_id = $option_for_list_all[0];
				$aliquot_control_id = $option_for_list_all[1];

				$aliquot_search_criteria['SampleMaster.sample_control_id'] = $sample_control_id;
				$aliquot_search_criteria['AliquotMaster.aliquot_control_id'] = $aliquot_control_id;

				$sample_control_data = $this->SampleControl->find('first', array('conditions' => array('SampleControl.id' => $sample_control_id)));
				if(empty($sample_control_data)) { $this->redirect('/pages/err_inv_system_error', null, true); }
				$sample_filter_value = $sample_control_data['SampleControl']['sample_type'];

				$aliquot_control_data = $this->AliquotControl->find('first', array('conditions' => array('AliquotControl.id' => $option_for_list_all[1])));
				if(empty($aliquot_control_data)) { $this->redirect('/pages/err_inv_system_error', null, true); }
				$form_alias = $aliquot_control_data['AliquotControl']['form_alias'];
				$aliquot_filter_value = $aliquot_control_data['AliquotControl']['aliquot_type'];

				$model_to_use = 'AliquotMaster';
				$form_alias = $aliquot_control_data['AliquotControl']['form_alias'];
								
				// Set filter option in session
				$_SESSION['InventoryManagement']['CollectionAliquots']['Filter'] = $filter_option;				
			}
				
		} else {
			//---------------------------------------------------
			// B- User is working on sample aliquots list
			//---------------------------------------------------

			// B.1- Get Sample Data			
			$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id), 'recursive' => '-1'));
			if(empty($sample_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }
			$menu_variables['SampleMaster.initial_specimen_sample_id'] = $sample_data['SampleMaster']['initial_specimen_sample_id'];
			$menu_variables['SampleMaster.id'] = $sample_data['SampleMaster']['id'];

			// B.2- Manage filter option
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
				
			// B.3- Set Model, Alias, Menu Criteria and Search Criteria to use
			if(is_null($filter_option)) {
				// No filter
				$model_to_use = 'AliquotMaster';
				$form_alias = 'aliquotmasters';
				
				$aliquot_search_criteria['AliquotMaster.sample_master_id'] = $sample_master_id;
				
			} else  {
				// Get filter options: list all aliquots according to sample-aliquot types
				$option_for_list_all = explode("|", $filter_option);
				if(sizeof($option_for_list_all) != 2)  { $this->redirect('/pages/err_inv_system_error', null, true); }
				$sample_control_id = $option_for_list_all[0];
				$aliquot_control_id = $option_for_list_all[1];

				$aliquot_search_criteria['AliquotMaster.sample_master_id'] = $sample_master_id;
				$aliquot_search_criteria['AliquotMaster.aliquot_control_id'] = $aliquot_control_id;

				$aliquot_control_data = $this->AliquotControl->find('first', array('conditions' => array('AliquotControl.id' => $option_for_list_all[1])));
				if(empty($aliquot_control_data)) { $this->redirect('/pages/err_inv_system_error', null, true); }
				$aliquot_filter_value = $aliquot_control_data['AliquotControl']['aliquot_type'];

				$model_to_use = 'AliquotMaster';
				$form_alias = $aliquot_control_data['AliquotControl']['form_alias'];
				
				// Set filter option in session
				$_SESSION['InventoryManagement']['SampleAliquots']['Filter'] = array(
					'SampleMasterId' => $sample_master_id,
					'Option' => $filter_option);
			}
		}

		// MANAGE DATA
		
		// Search data to display
		$samples_data = array();
		switch($model_to_use) {
			case 'ViewAliquot': 
				// Get data
				$aliquots_data = $this->paginate($this->ViewAliquot, array_merge(array('ViewAliquot.collection_id' => $collection_id), $aliquot_search_criteria));
				break;
				
			case 'AliquotMaster':
				$aliquots_data = $this->getAliquotsListData(array_merge(array('AliquotMaster.collection_id' => $collection_id), $aliquot_search_criteria));
				break;
				
			default:
				$this->redirect('/pages/err_inv_system_error', null, true);
		}

		$this->set('model_to_use', $model_to_use);
		$this->set('aliquots_data', $aliquots_data);
		$this->data = array();
				
		// MANAGE FORM, MENU AND ACTION BUTTONS
				
		$this->Structures->set($form_alias, 'aliquots_listall_structure');
		
		// Get all collection/sample 'sample aliquot type list' to build the filter button
		$sample_aliquot_types = array();
		$criteria = array('AliquotMaster.collection_id' => $collection_id);
		if(!$is_collection_aliquot_list) { $criteria['AliquotMaster.sample_master_id'] = $sample_master_id; }
		$tmp_sample_aliquot_type_list = $this->AliquotMaster->find('all', array('fields' => 'DISTINCT SampleMaster.sample_type, SampleMaster.sample_control_id, AliquotMaster.aliquot_type, AliquotMaster.aliquot_control_id', 'conditions' => $criteria, 'order' => 'SampleMaster.sample_type ASC, AliquotMaster.aliquot_type ASC', 'recursive' => '0'));
		foreach($tmp_sample_aliquot_type_list as $new_sample_aliquot_type) {
			// Should create key because looks like it's not a real distinct: Perhaps exists a better solution
			$sample_control_id = $new_sample_aliquot_type['SampleMaster']['sample_control_id'];
			$aliquot_control_id = $new_sample_aliquot_type['AliquotMaster']['aliquot_control_id'];
			$sample_aliquot_types[$sample_control_id . '|' . $aliquot_control_id] = array(
				'sample_type' => $new_sample_aliquot_type['SampleMaster']['sample_type'],
				'sample_control_id' => $new_sample_aliquot_type['SampleMaster']['sample_control_id'],
				'aliquot_type' => $new_sample_aliquot_type['AliquotMaster']['aliquot_type'],
				'aliquot_control_id' => $new_sample_aliquot_type['AliquotMaster']['aliquot_control_id']);
		}
		$this->set('existing_sample_aliquot_types', $sample_aliquot_types);

		// Get all aliquot control types to build the add to selected button
		$allowed_aliquot_type = array();
		if(!$is_collection_aliquot_list) {
			$allowed_aliquot_type = $this->AliquotControl->getPermissibleAliquotsArray($sample_data['SampleMaster']['sample_control_id']);
		}
		$this->set('allowed_aliquot_type', $allowed_aliquot_type);

		// Get the current menu object
		$last_menu_parameter = '-1';
		if(!$is_collection_aliquot_list) {
			// User is working on sample aliquots
			if($menu_variables['SampleMaster.initial_specimen_sample_id'] == $menu_variables['SampleMaster.id']) {
				// Studied sample is a specimen
				$last_menu_parameter = '%%SampleMaster.initial_specimen_sample_id%%';
			} else {
				// Studied sample is a derivative
				$last_menu_parameter = '%%SampleMaster.id%%';
			}
		}
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/aliquot_masters/listAll/%%Collection.id%%/' . $last_menu_parameter));

		// Set menu variables
		$atim_menu_variables = array_merge(array('Collection.id' => $collection_id), $menu_variables);
		$this->set('atim_menu_variables', $atim_menu_variables);

		$this->set('sample_filter_value', $sample_filter_value);
		$this->set('aliquot_filter_value', $aliquot_filter_value);
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
	}
	
	function add($collection_id, $sample_master_id, $aliquot_control_id) {
		if((!$collection_id) || (!$sample_master_id) || (!$aliquot_control_id)){
			$this->redirect('/pages/err_inv_funct_param_missing', null, true); 
		}		
		
		// MANAGE DATA

		// Get Sample Data
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id), 'recursive' => '-1'));
		if(empty($sample_data)){
			$this->redirect('/pages/err_inv_no_data', null, true); 
		}	
		
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
			'SampleToAliquotControl.flag_active' => '1',
			'AliquotControl.id' => $aliquot_control_id);
		$sample_to_aliquot_control = $this->SampleToAliquotControl->find('first', array('conditions' => $criteria));
		if(empty($sample_to_aliquot_control)) { $this->redirect('/pages/err_inv_no_data', null, true); }			
		$aliquot_control_data = array('AliquotControl' => $sample_to_aliquot_control['AliquotControl']);
		
		// Set new aliquot control information
		$this->set('aliquot_control_data', $aliquot_control_data);	
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Set menu
		$atim_menu_link = '/inventorymanagement/aliquot_masters/listall/%%Collection.id%%/' . ($bool_is_specimen? '%%SampleMaster.initial_specimen_sample_id%%': '%%SampleMaster.id%%');
		$this->set('atim_menu', $this->Menus->get($atim_menu_link));
		
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id, 'SampleMaster.id' => $sample_master_id, 'SampleMaster.initial_specimen_sample_id' => $sample_data['SampleMaster']['initial_specimen_sample_id']));
		
		// set structure alias based on VALUE from CONTROL table
		$this->Structures->set($aliquot_control_data['AliquotControl']['form_alias']);

		// set data for initial data to allow bank to override data
		$this->set('override_data', array(
				'AliquotMaster.aliquot_type' => $aliquot_control_data['AliquotControl']['aliquot_type'],
				'AliquotMaster.aliquot_volume_unit' => $aliquot_control_data['AliquotControl']['volume_unit'],
				'AliquotMaster.storage_datetime' => $this->getDefaultAliquotStorageDate($sample_data),
				'AliquotMaster.in_stock' => 'yes - available'));
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link); 
		}

		// MANAGE DATA RECORD
		
		if(!empty($this->data)){
			// Record process
						
			// Manage volume
			$errors = array();
			$record_counter = 0;
			foreach($this->data as $key => &$data) {	
				$record_counter++;
										
				// Set AliquotMaster.initial_volume
				if(array_key_exists('initial_volume', $this->data[$key]['AliquotMaster'])){
					if(empty($aliquot_control_data['AliquotControl']['volume_unit'])){
						$this->redirect('/pages/err_inv_system_error', null, true); 
					}
					$data['AliquotMaster']['current_volume'] = $data['AliquotMaster']['initial_volume'];				
				}
				
				// Validate and update position data
				$data['AliquotMaster']['aliquot_control_id'] = $aliquot_control_id;
				$this->AliquotMaster->set($data);
				if(!$this->AliquotMaster->validates()){
					foreach($this->AliquotMaster->validationErrors as $field => $msg) {
						$errors[$field][$msg][] = $record_counter;
					}
				}
				
				// Reste data to get position data
				$data = $this->AliquotMaster->data;
			}
								
			$submitted_data_validates = count($errors) == 0;
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link); 
			}

			if($submitted_data_validates) {
				// Save data
				foreach($this->data as $key => $new_aliquot) { 
					// Set additional data
					$this->AliquotMaster->id = null;
					$new_aliquot['AliquotMaster']['id'] = null;
					$new_aliquot['AliquotMaster']['collection_id'] = $collection_id;
					$new_aliquot['AliquotMaster']['sample_master_id'] = $sample_master_id;
					$new_aliquot['AliquotMaster']['aliquot_type'] = $aliquot_control_data['AliquotControl']['aliquot_type'];
					if(!$this->AliquotMaster->save($new_aliquot, false)){ 
						$this->redirect('/pages/err_inv_record_err', null, true); 
					} 
				}
				$this->atimFlash('your data has been saved', '/inventorymanagement/aliquot_masters/listAll/' . $collection_id . '/' . $sample_master_id);									
				return;
			} else {
				// Set error message
				$this->AliquotMaster->validationErrors = array();
				foreach($errors as $field => $msg_and_lines) {
					foreach($msg_and_lines as $msg => $lines) {
						$this->AliquotMaster->validationErrors[$field][] = __($msg, true) . ' - ' . str_replace('%s', implode(",", $lines), __('see line %s',true));					
					}
				}
			}	
		}
	}
	
	function detail($collection_id, $sample_master_id, $aliquot_master_id, $is_tree_view_detail_form = false, $is_inventory_plugin_form = true) {
		if((!$collection_id) || (!$sample_master_id) || (!$aliquot_master_id)){
			$this->redirect('/pages/err_inv_funct_param_missing', null, true); 
		}		
		if($is_tree_view_detail_form){
			Configure::write('debug', 0);
		}
		// MANAGE DATA
	
		// Get the aliquot data
		$aliquot_data = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.collection_id' => $collection_id, 'AliquotMaster.sample_master_id' => $sample_master_id, 'AliquotMaster.id' => $aliquot_master_id)));
		if(empty($aliquot_data)) { 
			$this->redirect('/pages/err_inv_no_data', null, true); 
		}		
		
		// Set times spent since either sample collection/reception or sample creation and sample storage		
		switch($aliquot_data['SampleMaster']['sample_category']) {
			case 'specimen':
				$aliquot_data['Generated']['coll_to_stor_spent_time_msg'] = $this->manageSpentTimeDataDisplay($this->getSpentTime($aliquot_data['Collection']['collection_datetime'], $aliquot_data['AliquotMaster']['storage_datetime']));
				$sample_master = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.id' => $aliquot_data['SampleMaster']['id'])));
				$aliquot_data['Generated']['rec_to_stor_spent_time_msg'] = $this->manageSpentTimeDataDisplay($this->getSpentTime($sample_master['SpecimenDetail']['reception_datetime'], $aliquot_data['AliquotMaster']['storage_datetime']));
				break;
			case 'derivative':
				$derivative_detail_data = $this->DerivativeDetail->find('first', array('conditions' => array('DerivativeDetail.sample_master_id' => $sample_master_id)));
				if(empty($derivative_detail_data)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }	
				$aliquot_data['Generated']['creat_to_stor_spent_time_msg'] = $this->manageSpentTimeDataDisplay($this->getSpentTime($derivative_detail_data['DerivativeDetail']['creation_datetime'], $aliquot_data['AliquotMaster']['storage_datetime']));
				break;
				
			default:
				$this->redirect('/pages/err_inv_system_error', null, true);
		}
		
		// Set aliquot data
		$this->set('aliquot_master_data', $aliquot_data);
		$this->data = array();
		
		// Set storage data
		$this->set('aliquot_storage_data', empty($aliquot_data['StorageMaster']['id'])? array(): array('StorageMaster' => $aliquot_data['StorageMaster']));
		
		// Set aliquot uses
		if(!$is_tree_view_detail_form) {			
			$this->set('aliquots_uses_data', $this->paginate($this->ViewAliquotUse, array('ViewAliquotUse.aliquot_master_id' => $aliquot_master_id)));
		}

		//storage history
		
		$this->Structures->set('custom_aliquot_storage_history', 'custom_aliquot_storage_history');
		$storage_data = $this->AliquotMaster->getStorageHistory($aliquot_master_id);
				
		// MANAGE FORM, MENU AND ACTION BUTTONS

		// Get the current menu object.
		$atim_menu_link = ($aliquot_data['SampleMaster']['sample_category'] == 'specimen')? 
			'/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%AliquotMaster.id%%': 
			'/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%';
		$this->set('atim_menu', $this->Menus->get($atim_menu_link));
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id, 'SampleMaster.id' => $sample_master_id, 'SampleMaster.initial_specimen_sample_id' => $aliquot_data['SampleMaster']['initial_specimen_sample_id'], 'AliquotMaster.id' => $aliquot_master_id));
		
		// Set structure
		$this->Structures->set($aliquot_data['AliquotControl']['form_alias']);
		if(!$is_tree_view_detail_form) {
			$this->Structures->set('viewaliquotuses', 'aliquots_uses_structure');
			$this->Structures->set('custom_aliquot_storage_history', 'custom_aliquot_storage_history');
		}
		
		// Define if this detail form is displayed into the collection content tree view
		$this->set('is_tree_view_detail_form', $is_tree_view_detail_form);
		$this->set('is_inventory_plugin_form', $is_inventory_plugin_form);

		// Define if aliquot is included into an order
		$order_item = $this->OrderItem->find('first', array('conditions' => array('OrderItem.aliquot_master_id' => $aliquot_master_id)));
		if(!empty($order_item)){
			$this->set('order_line_id', $order_item['OrderLine']['id']);
			$this->set('order_id', $order_item['OrderLine']['order_id']);
		}
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
		
		
		
		$hook_link = $this->hook('format_storage_data');
		if( $hook_link ) { 
			require($hook_link); 
		}
		$this->set('storage_data', $storage_data);
	}
	
	function edit($collection_id, $sample_master_id, $aliquot_master_id) {
		if((!$collection_id) || (!$sample_master_id) || (!$aliquot_master_id)) { 
			$this->redirect('/pages/err_inv_funct_param_missing', null, true); 
		}		
		
		// MANAGE DATA

		// Get the aliquot data
				
		$aliquot_data = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.collection_id' => $collection_id, 'AliquotMaster.sample_master_id' => $sample_master_id, 'AliquotMaster.id' => $aliquot_master_id)));
		if(empty($aliquot_data)){ 
			$this->redirect('/pages/err_inv_no_data', null, true); 
		}		
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Get the current menu object.
		$atim_menu_link = ($aliquot_data['SampleMaster']['sample_category'] == 'specimen')? 
			'/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%AliquotMaster.id%%': 
			'/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%';
		$this->set('atim_menu', $this->Menus->get($atim_menu_link));
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id, 'SampleMaster.id' => $sample_master_id, 'SampleMaster.initial_specimen_sample_id' => $aliquot_data['SampleMaster']['initial_specimen_sample_id'], 'AliquotMaster.id' => $aliquot_master_id));
		
		// Set structure
		$this->Structures->set($aliquot_data['AliquotControl']['form_alias']);
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link); 
		}
		
		// MANAGE DATA RECORD
		
		if(empty($this->data)){
			$aliquot_data['FunctionManagement']['recorded_storage_selection_label'] = $this->StorageMaster->getStorageLabelAndCodeForDisplay(array('StorageMaster' => $aliquot_data['StorageMaster']));
			$this->data = $aliquot_data;

		}else{
			//Update data
			if(array_key_exists('initial_volume', $this->data['AliquotMaster']) && empty($aliquot_data['AliquotControl']['volume_unit'])) { 
				$this->redirect('/pages/err_inv_system_error', null, true); 
			}

			// Launch validations
			
			$submitted_data_validates = true;
					
			// -> Fields validation
			//  --> AliquotMaster
			$this->data['AliquotMaster']['id'] = $aliquot_master_id;
			$this->data['AliquotMaster']['aliquot_control_id'] = $aliquot_data['AliquotMaster']['aliquot_control_id'];
			$this->AliquotMaster->set($this->data);
			$this->AliquotMaster->id = $aliquot_master_id;
			$submitted_data_validates = ($this->AliquotMaster->validates()) ? $submitted_data_validates: false;
			
			// Reste data to get position data
			$this->data = $this->AliquotMaster->data;
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}
			
			// Save data
			if($submitted_data_validates) {
				$this->AliquotMaster->id = $aliquot_master_id;
				if(!$this->AliquotMaster->save($this->data, false)) { 
					$this->redirect('/pages/err_inv_record_err', null, true); 
				}
				if(!$this->AliquotMaster->updateAliquotUseAndVolume($aliquot_master_id, true, false)) { 
					$this->redirect('/pages/err_inv_record_err', null, true); 
				}			
				$this->atimFlash('your data has been updated', '/inventorymanagement/aliquot_masters/detail/' . $collection_id . '/' . $sample_master_id. '/' . $aliquot_master_id);				
				return;
			}
		}
	}
	
	function removeAliquotFromStorage($collection_id, $sample_master_id, $aliquot_master_id) {
		if((!$collection_id) || (!$sample_master_id) || (!$aliquot_master_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }		
		
		// MANAGE DATA

		// Get the aliquot data
		$aliquot_data = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.collection_id' => $collection_id, 'AliquotMaster.sample_master_id' => $sample_master_id, 'AliquotMaster.id' => $aliquot_master_id)));
		if(empty($aliquot_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }		
		
		// Delete storage data
		$this->AliquotMaster->id = $aliquot_master_id;
		$aliquot_data_to_save = 
			array('AliquotMaster' => array(
				'storage_master_id' => null,
				'storage_coord_x' => null,
				'storage_coord_y' => null));
		if(!$this->AliquotMaster->save($aliquot_data_to_save, false)) {
			$this->redirect('/pages/err_inv_record_err', null, true);
		}
		
		$this->atimFlash('your data has been updated', '/inventorymanagement/aliquot_masters/detail/' . $collection_id . '/' . $sample_master_id. '/' . $aliquot_master_id);				
	}
	
	function delete($collection_id, $sample_master_id, $aliquot_master_id) {
		if((!$collection_id) || (!$sample_master_id) || (!$aliquot_master_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }		
	
		// Get the aliquot data
		$aliquot_data = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.collection_id' => $collection_id, 'AliquotMaster.sample_master_id' => $sample_master_id, 'AliquotMaster.id' => $aliquot_master_id)));
		if(empty($aliquot_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }		
		
		// Check deletion is allowed
		$arr_allow_deletion = $this->allowAliquotDeletion($aliquot_master_id);
			
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }		
		
		if($arr_allow_deletion['allow_deletion']) {
			if($this->AliquotMaster->atim_delete($aliquot_master_id)) {
				$this->atimFlash('your data has been deleted', '/inventorymanagement/aliquot_masters/listAll/' . $collection_id . '/' . $sample_master_id);
			} else {
				$this->flash('error deleting data - contact administrator', '/inventorymanagement/aliquot_masters/listAll/' . $collection_id . '/' . $sample_master_id);
			}
		} else {
			$this->flash($arr_allow_deletion['msg'], '/inventorymanagement/aliquot_masters/detail/' . $collection_id . '/' . $sample_master_id . '/' . $aliquot_master_id);
		}		
	}
	
	/* ------------------------------ ALIQUOT INTERNAL USES ------------------------------ */

	function addAliquotInternalUse($collection_id, $sample_master_id, $aliquot_master_id) {
		if((!$collection_id) || (!$sample_master_id) || (!$aliquot_master_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }
		
		// MANAGE DATA

		// Get the aliquot data
		$aliquot_data = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.collection_id' => $collection_id, 'AliquotMaster.sample_master_id' => $sample_master_id, 'AliquotMaster.id' => $aliquot_master_id)));
		if(empty($aliquot_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }		

		// Set aliquot volume unit
		$aliquot_volume_unit = empty($aliquot_data['AliquotMaster']['aliquot_volume_unit'])? 'n/a': $aliquot_data['AliquotMaster']['aliquot_volume_unit'];

		// MANAGE FORM, MENU AND ACTION BUTTONS

		// Get the current menu object.
		$atim_menu_link = ($aliquot_data['SampleMaster']['sample_category'] == 'specimen')? 
			'/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%AliquotMaster.id%%': 
			'/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%';
		$this->set('atim_menu', $this->Menus->get($atim_menu_link));
		$this->set('atim_menu_variables', 
			array('Collection.id' => $collection_id, 
				'SampleMaster.id' => $sample_master_id, 
				'SampleMaster.initial_specimen_sample_id' => $aliquot_data['SampleMaster']['initial_specimen_sample_id'], 
				'AliquotMaster.id' => $aliquot_master_id));
		
		// Set structure
		$this->Structures->set('aliquotinternaluses');
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
		
		// MANAGE DATA RECORD

		if(empty($this->data)) {
			// Force $this->data to empty array() to override AliquotMaster.aliquot_volume_unit 
			$this->data = array();
			$this->data['AliquotMaster']['aliquot_volume_unit'] = $aliquot_volume_unit;
			$this->data['AliquotMaster']['current_volume'] = (empty($aliquot_data['AliquotMaster']['current_volume'])? 'N/A' : $aliquot_data['AliquotMaster']['current_volume']);
			
		} else {	
			// Launch save process
			$submitted_data_validates = true;
						
			if(((!empty($this->data['AliquotInternalUse']['used_volume'])) || ($this->data['AliquotInternalUse']['used_volume'] == '0'))&& empty($aliquot_data['AliquotMaster']['aliquot_volume_unit'])) {
				// No volume has to be recored for this aliquot type				
				$this->AliquotInternalUse->validationErrors['used_volume'][] = 'no volume has to be recorded for this aliquot type';	
				$submitted_data_validates = false;	
				pr('la');		
			} else if(empty($this->data['AliquotInternalUse']['used_volume'])) {
				// Change '0' to null
				$this->data['AliquotInternalUse']['used_volume'] = null;
			}
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}
					
			// if data VALIDATE, then save data
			if ($submitted_data_validates) {
				$this->data['AliquotInternalUse']['aliquot_master_id'] = $aliquot_master_id;			
				if ($this->AliquotInternalUse->save($this->data)) { 
					if(!$this->AliquotMaster->updateAliquotUseAndVolume($aliquot_master_id, true, true)) { $this->redirect('/pages/err_inv_record_err', null, true); }	
					$this->atimFlash('your data has been saved', '/inventorymanagement/aliquot_masters/detail/'.$collection_id.'/'.$sample_master_id.'/'.$aliquot_master_id.'/');
				} 
			}
		}
	}
	
	function redirectToAliquotUseDetail($url) {
		$this->redirect(str_replace('|', '/', $url));
	}
	
	function detailAliquotInternalUse($aliquot_master_id, $aliquot_use_id) {
		if((!$aliquot_master_id) || (!$aliquot_use_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }
			
 		// MANAGE DATA

		// Get the use data
		$use_data = $this->AliquotInternalUse->find('first', array('conditions' => array('AliquotInternalUse.aliquot_master_id' => $aliquot_master_id, 'AliquotInternalUse.id' => $aliquot_use_id)));
		if(empty($use_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }		
		$this->data = $use_data;		
		
		// Get Sample Data
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $use_data['AliquotMaster']['collection_id'], 'SampleMaster.id' => $use_data['AliquotMaster']['sample_master_id']), 'recursive' => '-1'));
		if(empty($sample_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }	
		
		// Set aliquot volume unit
		$aliquot_volume_unit = empty($use_data['AliquotMaster']['aliquot_volume_unit'])? 'n/a': $use_data['AliquotMaster']['aliquot_volume_unit'];

		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Get the current menu object.
		$atim_menu_link = ($sample_data['SampleMaster']['sample_category'] == 'specimen')? 
			'/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%AliquotMaster.id%%': 
			'/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%';
		$this->set('atim_menu', $this->Menus->get($atim_menu_link));
		$this->set('atim_menu_variables', 
			array('Collection.id' => $use_data['AliquotMaster']['collection_id'], 
				'SampleMaster.id' => $use_data['AliquotMaster']['sample_master_id'], 
				'SampleMaster.initial_specimen_sample_id' => $sample_data['SampleMaster']['initial_specimen_sample_id'], 
				'AliquotMaster.id' => $aliquot_master_id));
			
		// Set structure
		$this->Structures->set('aliquotinternaluses');
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}	
	
	function editAliquotInternalUse($aliquot_master_id, $aliquot_use_id) {
		if((!$aliquot_master_id) || (!$aliquot_use_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }
			
 		// MANAGE DATA

		// Get the use data
		$use_data = $this->AliquotInternalUse->find('first', array('conditions' => array('AliquotInternalUse.aliquot_master_id' => $aliquot_master_id, 'AliquotInternalUse.id' => $aliquot_use_id)));
		if(empty($use_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }	
		
		// Get Sample Data
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $use_data['AliquotMaster']['collection_id'], 'SampleMaster.id' => $use_data['AliquotMaster']['sample_master_id']), 'recursive' => '-1'));
		if(empty($sample_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }	
		
		// Set aliquot volume unit
		$aliquot_volume_unit = empty($use_data['AliquotMaster']['aliquot_volume_unit'])? 'n/a': $use_data['AliquotMaster']['aliquot_volume_unit'];

		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Get the current menu object.
		$atim_menu_link = ($sample_data['SampleMaster']['sample_category'] == 'specimen')? 
			'/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%AliquotMaster.id%%': 
			'/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%';
		$this->set('atim_menu', $this->Menus->get($atim_menu_link));
		$this->set('atim_menu_variables', 
			array('Collection.id' => $use_data['AliquotMaster']['collection_id'], 
				'SampleMaster.id' => $use_data['AliquotMaster']['sample_master_id'], 
				'SampleMaster.initial_specimen_sample_id' => $sample_data['SampleMaster']['initial_specimen_sample_id'], 
				'AliquotMaster.id' => $aliquot_master_id));
			
		// Set structure
		$this->Structures->set('aliquotinternaluses');
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
					
		// MANAGE DATA RECORD
		
		if(empty($this->data)) {
			$this->data = $use_data;
			
		} else {
			
			// Launch validations		
			$submitted_data_validates = true;
			
			if((!empty($this->data['AliquotInternalUse']['used_volume'])) && empty($use_data['AliquotMaster']['aliquot_volume_unit'])) {
				// No volume has to be recored for this aliquot type				
				$this->AliquotInternalUse->validationErrors['used_volume'] = 'no volume has to be recorded for this aliquot type';	
				$submitted_data_validates = false;			
			} else if(empty($this->data['AliquotInternalUse']['used_volume'])) {
				// Change '0' to null
				$this->data['AliquotInternalUse']['used_volume'] = null;
			}
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link); 
			}
			
			// if data VALIDATE, then save data
			if ($submitted_data_validates) {
				$this->AliquotInternalUse->id = $aliquot_use_id;			
				if ($this->AliquotInternalUse->save($this->data)) { 
					if(!$this->AliquotMaster->updateAliquotUseAndVolume($aliquot_master_id, true, false)) { $this->redirect('/pages/err_inv_record_err', null, true); }
					$this->atimFlash('your data has been saved', '/inventorymanagement/aliquot_masters/detailAliquotInternalUse/' . $aliquot_master_id . '/' . $aliquot_use_id . '/');
				} 
			}
		}
	}
	
	function deleteAliquotInternalUse($aliquot_master_id, $aliquot_use_id) {
		if((!$aliquot_master_id) || (!$aliquot_use_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }	
		
 		// MANAGE DATA
		
		// Get the use data
		$use_data = $this->AliquotInternalUse->find('first', array('conditions' => array('AliquotInternalUse.aliquot_master_id' => $aliquot_master_id, 'AliquotInternalUse.id' => $aliquot_use_id)));
		if(empty($use_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }	
		
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }

		$flash_url = '/inventorymanagement/aliquot_masters/detail/' . $use_data['AliquotMaster']['collection_id'] . '/' . $use_data['AliquotMaster']['sample_master_id'] . '/' . $aliquot_master_id;		
		
		// LAUNCH DELETION
		$deletion_done = true;
		
		// -> Delete use
		if($deletion_done) {
			if(!$this->AliquotInternalUse->atim_delete($aliquot_use_id)) { $deletion_done = false; }	
		}
		
		// -> Delete use
		if($deletion_done) {
			if(!$this->AliquotMaster->updateAliquotUseAndVolume($aliquot_master_id, true, true)) { $deletion_done = false; }
		}
		if($deletion_done) {
			$this->atimFlash('your data has been deleted - update the aliquot in stock data', $flash_url); 
		} else {
			$this->flash('error deleting data - contact administrator', $flash_url); 
		}	
	}
	
	/* ----------------------------- SOURCE ALIQUOTS ---------------------------- */
	
	function addSourceAliquots($collection_id, $sample_master_id) {
		if((!$collection_id) || (!$sample_master_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }
		
		// MANAGE DATA

		// Get Sample data
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id), 'recursive' => '0'));
		if(empty($sample_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }	
		
		// Get aliquot already defined as source
		$existing_source_aliquots = $this->SourceAliquot->find('all', array('conditions' => array('SourceAliquot.sample_master_id'=>$sample_master_id), 'recursive' => '-1'));
		$existing_source_aliquot_ids = array();
		if(!empty($existing_source_aliquots)) {
			foreach($existing_source_aliquots as $source_aliquot) {
				$existing_source_aliquot_ids[] = $source_aliquot['SourceAliquot']['aliquot_master_id'];
			}
		}
		
		// Get parent sample aliquot that could be defined as source
		$criteria = array(
			'AliquotMaster.collection_id' => $collection_id,
			'AliquotMaster.sample_master_id' => $sample_data['SampleMaster']['parent_id']);
		if(!empty($existing_source_aliquot_ids)) { $criteria['NOT'] = array('AliquotMaster.id' => $existing_source_aliquot_ids); }
		$available_sample_aliquots = $this->AliquotMaster->find('all', array('conditions' => $criteria, 'order' => 'AliquotMaster.barcode ASC', 'recursive' => '-1'));
		
		if(empty($available_sample_aliquots)) {
			$this->flash('no new sample aliquot could be actually defined as source aliquot', '/inventorymanagement/aliquot_masters/listAllSourceAliquots/' . $collection_id . '/' . $sample_master_id);
		}
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/aliquot_masters/listAllSourceAliquots/%%Collection.id%%/%%SampleMaster.id%%'));	
		
		// Get the current menu object.
		$this->set( 'atim_menu_variables', 
			array('Collection.id' => $sample_data['SampleMaster']['collection_id'], 
			'SampleMaster.id' => $sample_master_id,
			'SampleMaster.initial_specimen_sample_id' => $sample_data['SampleMaster']['initial_specimen_sample_id']) );

		// Set structure
		$this->Structures->set('sourcealiquots');

		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
					
		// MANAGE DATA RECORD

		if (empty($this->data)) {
			$this->data = $available_sample_aliquots;

		} else {
			// Launch validation
			$submitted_data_validates = true;	
			
			$aliquots_defined_as_source = array();
			$errors = array();	
			$line_counter = 0;
			foreach($this->data as $key => $new_studied_aliquot){
				$line_counter++;
				
				if($new_studied_aliquot['FunctionManagement']['use']){
					// New aliquot defined as source
				
					// Check volume
					if((!empty($new_studied_aliquot['SourceAliquot']['used_volume'])) && empty($new_studied_aliquot['AliquotMaster']['aliquot_volume_unit'])) {
						// No volume has to be recored for this aliquot type				
						$errors['SourceAliquot']['used_volume']['no volume has to be recorded for this aliquot type'][] = $line_counter; 
						$submitted_data_validates = false;			
					} else if(empty($new_studied_aliquot['SourceAliquot']['used_volume'])) {
						// Change '0' to null
						$new_studied_aliquot['SourceAliquot']['used_volume'] = null;
					}
					
					// Launch Aliquot Master validation
					$this->AliquotMaster->set($new_studied_aliquot);
					$this->AliquotMaster->id = $new_studied_aliquot['AliquotMaster']['id'];
					$submitted_data_validates = ($this->AliquotMaster->validates())? $submitted_data_validates: false;
					foreach($this->AliquotMaster->invalidFields() as $field => $error) { $errors['AliquotMaster'][$field][$error][] = $line_counter; }					
					
					// Reste data to get position data (not really required for this function)
					$new_studied_aliquot = $this->AliquotMaster->data;				

					// Launch Aliquot Source validation
					$this->SourceAliquot->set($new_studied_aliquot);
					$submitted_data_validates = ($this->SourceAliquot->validates())? $submitted_data_validates: false;
					foreach($this->SourceAliquot->invalidFields() as $field => $error) { $errors['SourceAliquot'][$field][$error][] = $line_counter; }
					
					// Add record to array of tested aliquots
					$aliquots_defined_as_source[] = $new_studied_aliquot;		
				}
				
				// Reset data
				$this->data[$key] = $new_studied_aliquot;				
			}
			
			if(empty($aliquots_defined_as_source)) { 
				$this->SourceAliquot->validationErrors['use'] = 'no aliquot has been defined as source aliquot';	
				$submitted_data_validates = false;			
			}

			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}
		
			if (!$submitted_data_validates) {
				// Set error message
				foreach($errors as $model => $field_messages) {
					$this->{$model}->validationErrors = array();
					foreach($field_messages as $field => $messages) {
						foreach($messages as $message => $lines) {
							$this->{$model}->validationErrors[$field][] = __($message, true) . ' - ' . str_replace('%s', implode(",", $lines), __('see line %s',true));
						}
					}
				}
				
			} else {
				// Launch save process
								
				// Parse records to save
				foreach($aliquots_defined_as_source as $new_source_aliquot) {
					// Get Source Aliquot Master Id
					$aliquot_master_id = $new_source_aliquot['AliquotMaster']['id'];
					
					// Set aliquot master data					
					if($new_source_aliquot['FunctionManagement']['remove_from_storage'] || ($new_source_aliquot['AliquotMaster']['in_stock'] = 'no')) {
						// Delete aliquot storage data
						$new_source_aliquot['AliquotMaster']['storage_master_id'] = null;
						$new_source_aliquot['AliquotMaster']['storage_coord_x'] = null;
						$new_source_aliquot['AliquotMaster']['storage_coord_y'] = null;	
					}
					
					// Save data:
					// - AliquotMaster
					$this->AliquotMaster->id = $aliquot_master_id;
					if(!$this->AliquotMaster->save($new_source_aliquot, false)) { $this->redirect('/pages/err_inv_record_err', null, true); }
					
					// - SourceAliquot
					$this->SourceAliquot->id = null;
					$new_source_aliquot['SourceAliquot']['aliquot_master_id'] = $aliquot_master_id;
					$new_source_aliquot['SourceAliquot']['sample_master_id'] = $sample_master_id;
					if(!$this->SourceAliquot->save($new_source_aliquot)) { $this->redirect('/pages/err_inv_record_err', null, true); }

					// - Update aliquot current volume
					if(!$this->AliquotMaster->updateAliquotUseAndVolume($aliquot_master_id, true, true)) { $this->redirect('/pages/err_inv_record_err', null, true); }
				}
				
				$this->atimFlash(__('your data has been saved',true).'<br>'.__('aliquot storage data were deleted (if required)',true), 
					'/inventorymanagement/aliquot_masters/listAllSourceAliquots/' . $collection_id . '/' . $sample_master_id); 
			}
		}
	}
	
	function listAllSourceAliquots($collection_id, $sample_master_id) {
		if((!$collection_id) || (!$sample_master_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }

		// MANAGE DATA

		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id), 'recursive' => '-1'));
		if(empty($sample_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }	
		
		$this->data = $this->paginate($this->SourceAliquot, array('SourceAliquot.sample_master_id'=>$sample_master_id, 'SampleMaster.collection_id'=>$collection_id));

		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Get the current menu object.
		$this->set('atim_menu_variables', 
			array('Collection.id' => $sample_data['SampleMaster']['collection_id'], 
			'SampleMaster.id' => $sample_master_id,
			'SampleMaster.initial_specimen_sample_id' => $sample_data['SampleMaster']['initial_specimen_sample_id']));
		
		// Set structure
		$this->Structures->set('sourcealiquots');

		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
	}
	
	function deleteSourceAliquot($sample_master_id, $aliquot_master_id, $source) {
		if((!$sample_master_id) || (!$aliquot_master_id) || (!$source)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }	

 		// MANAGE DATA
		
		// Get the realiquoting data
		$source_data = $this->SourceAliquot->find('first', array('conditions' => array('SourceAliquot.sample_master_id' => $sample_master_id, 'SourceAliquot.aliquot_master_id' => $aliquot_master_id)));
		if(empty($source_data)) { $this->redirect('/pages/err_inv_no_data?line='.__LINE__, null, true); }				
			
		$flash_url = '';
		switch($source) {
			case 'aliquot_source':
				$flash_url = '/inventorymanagement/aliquot_masters/detail/' . $source_data['AliquotMaster']['collection_id'] . '/' . $source_data['AliquotMaster']['sample_master_id'] . '/' . $source_data['AliquotMaster']['id'];
				break;
			case 'sample_derivative':
				$flash_url = '/inventorymanagement/aliquot_masters/listAllSourceAliquots/' . $source_data['SampleMaster']['collection_id'] . '/' . $source_data['SampleMaster']['id'];
				break;
			default:
				$this->redirect('/pages/err_inv_system_error?line='.__LINE__, null, true);
		}
		
		
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }
			
		// LAUNCH DELETION
		$deletion_done = true;
		
		// -> Delete Realiquoting
		if(!$this->SourceAliquot->atim_delete($source_data['SourceAliquot']['id'])) { $deletion_done = false; }	
		
		// -> Update volume
		if($deletion_done) {
			if(!$this->AliquotMaster->updateAliquotUseAndVolume($source_data['AliquotMaster']['id'], true, true)) { $deletion_done = false; }
		}
		
		if($deletion_done) {
			$this->atimFlash('your data has been deleted - update the aliquot in stock data', $flash_url); 
		} else {
			$this->flash('error deleting data - contact administrator', $flash_url); 
		}
	}

		/* ------------------------------ REALIQUOTING ------------------------------ */

	function defineRealiquotedChildren($collection_id = null, $sample_master_id = null, $aliquot_master_id = null){
		$initial_display = false;		// Boolean to define if data for intial display should be built
		$proceed_with_display = true;	// Boolean to define if entry form should be displayed
		
		$parent_aliquots = array();		// Parent aliquots list
		
		//set the structure early to ensure validation works
		$this->Structures->set('children_aliquots_selection', 'atim_structure_for_children_aliquots_selection');
		$this->Structures->set('in_stock_detail', 'in_stock_detail');
		
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/'));
			
		if(isset($this->data['ViewAliquot']['aliquot_master_id'])){
			
			// BATCH EDIT : Action has been launched from datamart to realiquot in batch
			// Build list of parent aliquots
			
			$parent_aliquots = $this->AliquotMaster->find('all', array('conditions' => array('AliquotMaster.id' => $this->data['ViewAliquot']['aliquot_master_id'])));
			if(empty($parent_aliquots)){
				$this->redirect('/pages/err_inv_system_error', null, true);
			}
			
			$initial_display = true;
		
		}else if($collection_id && $sample_master_id && $aliquot_master_id){
			if(empty($this->data)) $initial_display = true;
			
			// SINGLE EDIT : Action has been launched from aliquot detail form to define aliquot realiquoting data
			// Build list of parent aliquots
			
			//Get the parent aliquot data
			$tmp = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.collection_id' => $collection_id, 'AliquotMaster.sample_master_id' => $sample_master_id, 'AliquotMaster.id' => $aliquot_master_id)));
			if(empty($tmp)){
				$this->redirect('/pages/err_inv_no_data', null, true); 
			}
			$parent_aliquots[] = $tmp;
		
			// Get the current menu object.
			$this->set('atim_menu_variables', array('Collection.id' => $collection_id, 'SampleMaster.id' => $sample_master_id, 'SampleMaster.initial_specimen_sample_id' => $parent_aliquots[0]['SampleMaster']['initial_specimen_sample_id'], 'AliquotMaster.id' => $aliquot_master_id));
			// Get the current menu object.
			$atim_menu_link = ($parent_aliquots[0]['SampleMaster']['sample_category'] == 'specimen')? 
				'/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%AliquotMaster.id%%': 
				'/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%';
			$this->set('atim_menu', $this->Menus->get($atim_menu_link));
		}
			
		if($initial_display){
			
			// BUILD DATA FOR INTIAL DISPLAY
			
			$this->data = array();
			$excluded_parent_aliquot = array();
			
			foreach($parent_aliquots as $parent_aliquot_data){
				
				// Get aliquot already defined as children
				$existing_children = array();
				foreach($parent_aliquot_data['RealiquotingChildren'] as $realiquoting_data) {
					$existing_children = $realiquoting_data['child_aliquot_master_id'];
				}
				
				//Get aliquot type that could be defined as children of the parent aliquot type
				$criteria = array(
					'ParentSampleToAliquotControl.sample_control_id' => $parent_aliquot_data['SampleMaster']['sample_control_id'], 
					'ParentSampleToAliquotControl.aliquot_control_id' => $parent_aliquot_data['AliquotMaster']['aliquot_control_id'],
					'ParentSampleToAliquotControl.flag_active' => '1',
					'RealiquotingControl.flag_active' => '1',
					'ChildSampleToAliquotControl.sample_control_id' => $parent_aliquot_data['SampleMaster']['sample_control_id'], 
					'ChildSampleToAliquotControl.flag_active' => '1'
				);	
				$realiquotind_control_data = $this->RealiquotingControl->find('all', array('conditions' => $criteria));
				
				$allowed_children_aliquot_control_ids = array();
				foreach($realiquotind_control_data as $new_realiquoting_control) {
					$allowed_children_aliquot_control_ids[] = $new_realiquoting_control['ChildSampleToAliquotControl']['aliquot_control_id'];
				}
				
				// Search Sample Aliquots could be defined as children aliquot
				$criteria = array(
					"AliquotMaster.id != '".$parent_aliquot_data['AliquotMaster']['id']."'", 
					'AliquotMaster.sample_master_id' => $parent_aliquot_data['AliquotMaster']['sample_master_id'],
					'AliquotMaster.aliquot_control_id' => $allowed_children_aliquot_control_ids,
					'NOT' => array('AliquotMaster.id' => $existing_children)
				);
				
				$exclude_aliquot = false;
				$aliquot_data_for_selection = $this->AliquotMaster->find('all', array('conditions' => $criteria, 'order' => 'AliquotMaster.storage_datetime DESC', 'recursive' => '0'));
				if(empty($aliquot_data_for_selection)) {
					if($collection_id != null){
						$this->flash('no new sample aliquot could be actually defined as realiquoted child', '/inventorymanagement/aliquot_masters/detail/' . $collection_id . '/' . $sample_master_id . '/' . $aliquot_master_id);
						return;
					} else {
						$exclude_aliquot = true;
						$excluded_parent_aliquot[] = $parent_aliquot_data;	
					}
				}
				
				// Set parent aliquot volume unit
				$parent_aliquot_volume_unit = empty($parent_aliquot_data['AliquotMaster']['aliquot_volume_unit'])? '': $parent_aliquot_data['AliquotMaster']['aliquot_volume_unit'];
				
				//Set default data
				$default_use_datetime = $this->getDefaultRealiquotingDate($parent_aliquot_data);
				foreach($aliquot_data_for_selection as &$children_aliquot) {
					$children_aliquot['GeneratedParentAliquot']['aliquot_volume_unit'] = $parent_aliquot_volume_unit;
					$children_aliquot['Realiquoting']['realiquoting_datetime'] = $default_use_datetime;
				}
				$data = array('parent' => $parent_aliquot_data, 'children' => $aliquot_data_for_selection);
				
				if(!$exclude_aliquot) $this->data[] = $data;
			}
			
			if(!empty($excluded_parent_aliquot)) {
				$tmp_msg = '';
				$comma = '';
				foreach($excluded_parent_aliquot as $new_aliquot) {
					$tmp_msg .= $comma.$new_aliquot['AliquotMaster']['barcode'];
					$comma = ',';
				}
				$this->AliquotMaster->validationErrors[] = __('no new aliquot could be actually defined as realiquoted child for the follwing parent aliquot(s)',true).': ['.$tmp_msg.']';
			}

			$hook_link = $this->hook('format');
			if($hook_link){
				require($hook_link);
			}
				
		} else if(!empty($this->data)){
			
			// LAUNCH VALIDATE & SAVE PROCESSES
			
			$errors = array();
			$submitted_data = $this->data;
			
			//1- Validate parent aliquot data
			foreach($this->data as $parent_id => &$children){
				// Validate parent aliquot data
				$parent_aliquot_data = $children['AliquotMaster'];
				$parent_aliquot_data["id"] = $parent_id;
				$this->AliquotMaster->set(array("AliquotMaster" => $parent_aliquot_data));
				if(!$this->AliquotMaster->validates()){
					$errors = array_merge_recursive($errors, $this->AliquotMaster->validationErrors);
				}
				unset($children['AliquotMaster']);
				unset($children['FunctionManagement']);
			}
			
			//2- Validate realiquoting data
			if(empty($errors)){
			$relations = array();
		
				foreach($this->data as $parent_aliquot_id => $children_aliquots){
					$children_has_been_defined = false;
					foreach($children_aliquots as $children_aliquot){
						if(!$children_aliquot['FunctionManagement']['use']){
							continue;
						}
						$children_has_been_defined = true;
						
						if(isset($relations[$children_aliquot['AliquotMaster']['id']])){
							$errors[] = sprintf(__("circular assignation with [%s]", true), $children_aliquot['AliquotMaster']['barcode']);
						}
						$relations[$parent_aliquot_id] = $children_aliquot['AliquotMaster']['id'];
						
						$this->Realiquoting->set(array('Realiquoting' =>  $children_aliquot['Realiquoting']));
						if(!$this->Realiquoting->validates()){
							$errors = array_merge($errors, $this->Realiquoting->validationErrors);
						}
						
						// Check volume can be completed
						if((!empty($children_aliquot['Realiquoting']['parent_used_volume'])) && empty($children_aliquot['GeneratedParentAliquot']['aliquot_volume_unit'])) {
							// No volume has to be recored for this aliquot type				
							$errors = array_merge($errors, array('parent_used_volume' => 'no volume has to be recorded when the volume unit field is empty'));		
						} 
					}
					
					if(!$children_has_been_defined) $errors = array_merge($errors, array('barcode' => 'at least one child has not been defined'));
				}				
			}
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}
			
			if(!empty($errors)){
				// Errors have been detected => rebuild form data
				
				$this->AliquotMaster->validationErrors = $errors;
				
				$this->data = array();
				foreach($submitted_data as $parent_id => $children) {
					// parent data
					$new_data_set = array();
					$new_data_set['parent']['AliquotMaster'] =  $children['AliquotMaster'];
					$new_data_set['parent']['AliquotMaster']['id'] = $parent_id;
					$new_data_set['parent']['FunctionManagement'] =  $children['FunctionManagement'];
					unset($children['AliquotMaster']);
					unset($children['FunctionManagement']);
					
					// children data
					$new_data_set['children'] = $children;

					$this->data[] = $new_data_set;
				}
				
			}else{
				// No errors : Save
				
				$_SESSION['tmp_batch_set']['BatchId'] = array();	// Set session data to display batchset
				
				//realiquoting done, save parent stock detail
				foreach($submitted_data as $parent_id => $children){
					// Save parent aliquot data
					if($children['FunctionManagement']['remove_from_storage'] || ($children['AliquotMaster']['in_stock'] == 'no')) {
						// Delete storage data
						$children['AliquotMaster']['storage_master_id'] = null;
						$children['AliquotMaster']['storage_coord_x'] = null;
						$children['AliquotMaster']['storage_coord_y'] = null;
					}
					$children['AliquotMaster']['id'] = $parent_id;
					$this->AliquotMaster->id = $parent_id;
					if(!$this->AliquotMaster->save(array('AliquotMaster' => $children['AliquotMaster']), false)){exit;
						$this->redirect('/pages/err_inv_system_error?line='.__LINE__, null, true);
					}					
					unset($children['AliquotMaster']);
					unset($children['FunctionManagement']);
					
					// Record realiquoting data
					foreach($children as $children_aliquot) {
						if($children_aliquot['FunctionManagement']['use']){
			  				//save realiquoting
			  				$children_aliquot['Realiquoting']['parent_aliquot_master_id'] = $parent_id;
			 				$children_aliquot['Realiquoting']['child_aliquot_master_id'] = $children_aliquot['AliquotMaster']['id'];	
							$this->Realiquoting->id = NULL;
			  				if(!$this->Realiquoting->save(array('Realiquoting' => $children_aliquot['Realiquoting'], false))){
								$this->redirect('/pages/err_inv_system_error?line='.__LINE__, null, true);
							}		
							
							// Set data for batchset
							$_SESSION['tmp_batch_set']['BatchId'][] = $children_aliquot['AliquotMaster']['id'];	
						}
					}
					
					// Update aliquot current volume
					$this->AliquotMaster->updateAliquotUseAndVolume($parent_id, true, true, false);
				}
				
				$_SESSION['tmp_batch_set']['datamart_structure_id'] = 1;	//ViewAliquots
				
				//redirect to virtual batch set
				//$_SESSION data was set into the define children function
				if($collection_id == null){
					$this->flash(__('your data has been saved',true).'<br>'.__('aliquot storage data were deleted (if required)',true), '/datamart/batch_sets/listall/0');
				}else{
					$this->flash('your data has been saved', '/inventorymanagement/aliquot_masters/detail/'.$collection_id.'/'.$sample_master_id.'/'.$aliquot_master_id);
				}
			}
			
		}else{ 
			$this->redirect('/pages/err_inv_funct_param_missing', null, true); 
		}
	}
	
	function listAllRealiquotedParents($collection_id, $sample_master_id, $aliquot_master_id) {
		if((!$collection_id) || (!$sample_master_id) || (!$aliquot_master_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }

		// MANAGE DATA
		
		// Get the aliquot data
		$current_aliquot_data = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.collection_id' => $collection_id, 'AliquotMaster.sample_master_id' => $sample_master_id, 'AliquotMaster.id' => $aliquot_master_id)));
		if(empty($current_aliquot_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }		
		
		// Get/Manage Parent Aliquots
		$this->data = $this->paginate($this->Realiquoting, array('Realiquoting.child_aliquot_master_id '=> $aliquot_master_id));
						
		// MANAGE FORM, MENU AND ACTION BUTTONS

		// Get the current menu object.
		$atim_menu_link = ($current_aliquot_data['SampleMaster']['sample_category'] == 'specimen')? 
			'/inventorymanagement/aliquot_masters/listAllRealiquotedParents/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%AliquotMaster.id%%': 
			'/inventorymanagement/aliquot_masters/listAllRealiquotedParents/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%';
		$this->set('atim_menu', $this->Menus->get($atim_menu_link));
		
		// Get the current menu object.
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id, 'SampleMaster.id' => $sample_master_id, 'SampleMaster.initial_specimen_sample_id' => $current_aliquot_data['SampleMaster']['initial_specimen_sample_id'], 'AliquotMaster.id' => $aliquot_master_id));
		
		// Set structure
		$this->Structures->set('realiquotedparent');
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
	}
	
	function deleteRealiquotingData($parent_id, $child_id, $source) {
		if((!$parent_id) || (!$child_id) || (!$source)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }	

 		// MANAGE DATA
		
		// Get the realiquoting data
		$realiquoting_data = $this->Realiquoting->find('first', array('conditions' => array('Realiquoting.parent_aliquot_master_id' => $parent_id, 'Realiquoting.child_aliquot_master_id' => $child_id)));
		if(empty($realiquoting_data)) { $this->redirect('/pages/err_inv_no_data?line='.__LINE__, null, true); }				
		
		$flash_url = '';
		switch($source) {
			case 'parent':
				$flash_url = '/inventorymanagement/aliquot_masters/detail/' . $realiquoting_data['AliquotMaster']['collection_id'] . '/' . $realiquoting_data['AliquotMaster']['sample_master_id'] . '/' . $realiquoting_data['AliquotMaster']['id'];
				break;
			case 'child':
				$flash_url = '/inventorymanagement/aliquot_masters/listAllRealiquotedParents/' . $realiquoting_data['AliquotMasterChildren']['collection_id'] . '/' . $realiquoting_data['AliquotMasterChildren']['sample_master_id'] . '/' . $realiquoting_data['AliquotMasterChildren']['id'];
				break;
			default:
				$this->redirect('/pages/err_inv_system_error?line='.__LINE__, null, true);
		}
		
		
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }
			
		// LAUNCH DELETION
		$deletion_done = true;
		
		// -> Delete Realiquoting
		if(!$this->Realiquoting->atim_delete($realiquoting_data['Realiquoting']['id'])) { $deletion_done = false; }	
		
		// -> Update volume
		if($deletion_done) {
			if(!$this->AliquotMaster->updateAliquotUseAndVolume($realiquoting_data['AliquotMaster']['id'], true, true)) { $deletion_done = false; }
		}
		
		if($deletion_done) {
			$this->atimFlash('your data has been deleted - update the aliquot in stock data', $flash_url); 
		} else {
			$this->flash('error deleting data - contact administrator', $flash_url); 
		}
	}
	
	/* --------------------------------------------------------------------------
	 * ADDITIONAL FUNCTIONS
	 * -------------------------------------------------------------------------- */
			
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
				if(empty($collection_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }
				$sample_master = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.id' => $sample_master_data['SampleMaster']['id'])));
				return $sample_master['SpecimenDetail']['reception_datetime'];
				
			case 'derivative':
				// Default creation date will be the derivative creation date or Specimen reception date
				$derivative_detail_data = $this->DerivativeDetail->find('first', array('conditions' => array('DerivativeDetail.sample_master_id' => $sample_master_data['SampleMaster']['id']), 'recursive' => '-1'));
				if(empty($derivative_detail_data)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }
				
				return $derivative_detail_data['DerivativeDetail']['creation_datetime'];
				
			default:
				$this->redirect('/pages/err_inv_system_error', null, true);			
		}
		
		return null;
	}
	
	function validateAliquotStorageData(&$aliquots_data) {
		pr('deprecated');
		$this->redirect('/pages/err_inv_system_error', null, true);
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
		$returned_nbr = $this->AliquotInternalUse->find('count', array('conditions' => array('AliquotInternalUse.aliquot_master_id' => $aliquot_master_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'use exists for the deleted aliquot'); }
	
		// Check aliquot is not linked to realiquoting process	
		$returned_nbr = $this->Realiquoting->find('count', array('conditions' => array('Realiquoting.child_aliquot_master_id' => $aliquot_master_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'realiquoting data exists for the deleted aliquot'); }
		$returned_nbr = $this->Realiquoting->find('count', array('conditions' => array('Realiquoting.parent_aliquot_master_id' => $aliquot_master_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'realiquoting data exists for the deleted aliquot'); }
		
		// Check aliquot is not linked to review	
		$returned_nbr = $this->AliquotReviewMaster->find('count', array('conditions' => array('AliquotReviewMaster.aliquot_master_id' => $aliquot_master_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'review exists for the deleted aliquot'); }
	
		// Check aliquot is not linked to order	
		$returned_nbr = $this->OrderItem->find('count', array('conditions' => array('OrderItem.aliquot_master_id' => $aliquot_master_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'order exists for the deleted aliquot'); }

		// Check aliquot is not linked to a qc	
		$returned_nbr = $this->QualityCtrlTestedAliquot->find('count', array('conditions' => array('QualityCtrlTestedAliquot.aliquot_master_id' => $aliquot_master_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'quality control data exists for the deleted aliquot'); }
		
		// Check aliquot is not linked to a derivative	
		$returned_nbr = $this->SourceAliquot->find('count', array('conditions' => array('SourceAliquot.aliquot_master_id' => $aliquot_master_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'derivative creation data exists for the deleted aliquot'); }

		return array('allow_deletion' => true, 'msg' => '');
	}
	
	/**
	 * Get the default realiquoting date.
	 * 
	 * @param $aliquot_data_for_selection Sample Aliquots that could be defined as child.
	 * 
	 * @return Default realiquoting date.
	 *
	 * @author N. Luc
	 * @since 2009-09-11
	 * @updated N. Luc
	 */
	 
	function getDefaultRealiquotingDate($aliquot_data_for_selection) {
		// Get first found storage datetime
		foreach($aliquot_data_for_selection as $aliquot) {
			if(!empty($aliquot['AliquotMaster']['storage_datetime'])) { return $aliquot['AliquotMaster']['storage_datetime']; }
		}

		return date('Y-m-d G:i');
	}
	
	function realiquotInit($aliquot_id = null){
//TODO NLUse
pr('TODO NLUse');

		if($aliquot_id == null){
			$ids = $this->data['ViewAliquot']['aliquot_master_id'];
			$ids = array_filter($ids);
		}else{
			$ids = $aliquots_id;
		}
		$ids[] = 0;
		$aliquots = $this->AliquotMaster->findAllById($ids);
		if(empty($aliquots)){
			$this->redirect('/pages/err_inv_system_error', null, true);
		}
		$aliquot_ctrl_id = $aliquots[0]['AliquotMaster']['aliquot_control_id'];
		$sample_ctrl_id = $aliquots[0]['SampleMaster']['sample_control_id'];
		if(count($aliquots) > 1){
			foreach($aliquots as $aliquot){
				if($aliquot['AliquotMaster']['aliquot_control_id'] != $sample_ctrl_id || $aliquot['SampleMaster']['sample_control_id'] != $aliquot_ctrl_id){
					$this->flash(__("you cannot realiquot those elements together because they are of diferent types", true), "javascript:history.back();", 5);
				}
			}
		}
		$sample_to_aliquot_ctrl_id = $this->SampleToAliquotControl->find('first', array('conditions' => array('SampleToAliquotControl.sample_control_id' => $sample_ctrl_id, 'SampleToAliquotControl.aliquot_control_id' => $aliquot_ctrl_id)));
		$possibilities = $this->RealiquotingControl->find('all', array('conditions' => array('RealiquotingControl.parent_sample_to_aliquot_control_id' => $sample_to_aliquot_ctrl_id['SampleToAliquotControl']['id'])));
		if(empty($possibilities)){
			$this->flash(__("you cannot realiquot those elements", true), "javascript:history.back();", 5);
			return;
		}
		$possible_ctrl_ids = array();
		foreach($possibilities as $possibility){
			$possible_ctrl_ids[] = $possibility['ChildSampleToAliquotControl']['aliquot_control_id'];
		}
		
		$aliquot_ctrls = $this->AliquotControl->findAllById($possible_ctrl_ids);
		assert(!empty($aliquot_ctrls));
		foreach($aliquot_ctrls as $aliquot_ctrl){
			$dropdown[$aliquot_ctrl['AliquotControl']['id']] = __($aliquot_ctrl['AliquotControl']['aliquot_type'], true);
		}
		
		AliquotMaster::$aliquot_type_dropdown = $dropdown;
		$this->Structures->set('aliquot_type_selection');
		$this->data[0]['ids'] = implode(",", $ids);
	}	
	
	function realiquot(){
//TODO NLUse
pr('TODO NLUse');
		pr('deprecated?');exit;
		$aliquots = null;
		if(empty($this->data)){
			$this->redirect("/pages/err_inv_no_data", null, true);
		}else if(isset($this->data[0]) && isset($this->data[0]['ids']) && isset($this->data[0]['realiquot_into'])){
			//initial display
			$this->set('realiquot_into', $this->data[0]['realiquot_into']);
			$aliquot_ctrl = $this->AliquotControl->findById($this->data[0]['realiquot_into']);
			$this->Structures->set($aliquot_ctrl['AliquotControl']['form_alias'].",realiquot,realiquot_vol", 'struct_vol');
			$this->Structures->set($aliquot_ctrl['AliquotControl']['form_alias'].",realiquot", 'struct_no_vol');
			$aliquots = $this->AliquotMaster->findAllById(explode(",", $this->data[0]['ids']));
			
			//build data array
			$this->data = array();
			foreach($aliquots as $aliquot){
				$this->data[] = array('parent' => $aliquot, 'children' => array());
			}
		}else{
			//submit
			$aliquot_ctrl = $this->AliquotControl->findById($this->data['realiquot_into']);
			$this->set('realiquot_into', $this->data['realiquot_into']);
			unset($this->data['realiquot_into']);
			//-----
			//do not invert or AliquotUse validation won't work
			$this->Structures->set($aliquot_ctrl['AliquotControl']['form_alias'].",realiquot", 'struct_no_vol');
			$this->Structures->set($aliquot_ctrl['AliquotControl']['form_alias'].",realiquot,realiquot_vol", 'struct_vol');
			//-----
			$new_data = array();
			$aliquot_errors = array();
			$use_errors = array();
			$barcodes = array();
			//validate new aliquots
			foreach($this->data as $parent_id => &$children){
				$new_children = array();
				$parent = $this->AliquotMaster->findById($parent_id);
				$parent['AliquotMaster']['in_stock'] = $children['AliquotMaster']['in_stock'];
				$parent['AliquotMaster']['in_stock_detail'] = $children['AliquotMaster']['in_stock_detail'];
				$this->AliquotMaster->set($parent);
				$this->AliquotMaster->validates();
				$aliquot_errors = array_merge_recursive($aliquot_errors, $this->AliquotMaster->validationErrors);
				unset($children['AliquotMaster']);//remove non children data
				foreach($children as &$child){
					$child['AliquotMaster']['aliquot_control_id'] = $aliquot_ctrl['AliquotControl']['id'];
					$child['AliquotMaster']['sample_master_id'] = $parent['AliquotMaster']['sample_master_id'];
					$child['AliquotMaster']['collection_id'] = $parent['AliquotMaster']['collection_id'];
					$child['AliquotMaster']['current_volume'] = $child['AliquotMaster']['initial_volume']; 
					$this->AliquotMaster->set($child);
					$this->AliquotMaster->validates();
					$this->AliquotUse->set($child);
					$this->AliquotUse->validates();
					$new_children[] = $child;
					$aliquot_errors = array_merge_recursive($aliquot_errors, $this->AliquotMaster->validationErrors);
					$use_errors = array_merge_recursive($use_errors, $this->AliquotUse->validationErrors);
					$barcodes[] = $child['AliquotMaster']['barcode'];
				}
				
				$new_data[] = array('parent' => $parent, 'children' => $new_children);
			}
			if($this->AliquotMaster->find('count', array('conditions' => array('AliquotMaster.barcode' => $barcodes))) != 0
			|| count($barcodes) != count(array_unique($barcodes))){
				$aliquot_errors['barcode'] = __('barcodes must be unique', true);
			}
			if(empty($aliquot_errors) && empty($use_errors)){
				//Validation successfull
				//update aliquots parents stock status, but do not commit right away
				$data_source = $this->AliquotMaster->getDataSource();
				$data_source->begin($this->AliquotMaster);
				foreach($new_data as $unit){
					$this->AliquotMaster->set($unit['parent']);
					$this->AliquotMaster->save();//already validated earlier
				}
				
				//create children aliquots
				foreach($this->data as $parent_id => &$children){
					foreach($children as &$child){
						$this->AliquotMaster->id = null;
						$this->AliquotMaster->set($child);
						$this->AliquotMaster->save();
						$child['AliquotMaster']['id'] = $this->AliquotMaster->id;
						$child['AliquotUse']['use_datetime'] = $child['AliquotMaster']['storage_datetime'];
						$child['FunctionManagement']['use'] = true; 
					}
				}
				
				//create uses/realiquoting
				$errors = $this->AliquotMaster->defineRealiquot($this->data);
				if(empty($errors)){
					$data_source->commit($this->AliquotMasters);
					$this->flash('your data has been saved', '/datamart/batch_sets/listall/0');
				}else{
					$data_source->rollback($this->AliquotMasters);
					$this->redirect('/pages/err_inv_system_error', null, true);
				}
			}else{
				//validation failed
				$this->AliquotMaster->validationErrors = $aliquot_errors;
				$this->AliquotUse->validationErrors = $use_errors;
				$this->data = $new_data;
			}
		}
		$this->Structures->set('in_stock_detail', 'in_stock_detail');
		$this->set('aliquot_type', $aliquot_ctrl['AliquotControl']['aliquot_type']);
	}
	
	function autocompleteBarcode(){
		//layout = ajax to avoid printing layout
		$this->layout = 'ajax';
		//debug = 0 to avoid printing debug queries that would break the javascript array
		Configure::write('debug', 0);
		
		//query the database
		$term = str_replace('_', '\_', str_replace('%', '\%', $_GET['term']));
		$data = $this->AliquotMaster->find('all', array(
			'conditions' => array(
				'AliquotMaster.barcode LIKE' => $term.'%'),
			'fields' => array('AliquotMaster.barcode'), 
			'limit' => 10,
			'recursive' => -1));
		
		//build javascript textual array
		$result = "";
		foreach($data as $data_unit){
			$result .= '"'.$data_unit['AliquotMaster']['barcode'].'", ';
		}
		if(sizeof($result) > 0){
			$result = substr($result, 0, -2);
		}
		$this->set('result', "[".$result."]");
	}
	
	function batchAddInit(){
//TODO NLUse
pr('TODO NLUse');
		$init_data = $this->batchInit(
			$this->SampleMaster, 
			'ViewSample',
			'sample_master_id',
			'sample_control_id',
			$this->SampleToAliquotControl, 
			'sample_control_id',
			__('you cannot create aliquots with this sample type', true)
		);
		
		foreach($init_data['possibilities'] as $possibility){
			AliquotMaster::$aliquot_type_dropdown[$possibility['AliquotControl']['id']] = __($possibility['AliquotControl']['aliquot_type'], true);
		}
		$this->Structures->set('aliquot_type_selection');
		$this->data[0]['ids'] = $init_data['ids'];
	}
	
	function batchAdd(){
//TODO NLUse
pr('TODO NLUse');
		if(empty($this->data)){
			$this->redirect('/pages/err_inv_system_error', null, true);
		}else if($this->data[0]['realiquot_into'] == ""){
			$this->flash(__('you need to select an aliquot type', true), "javascript:history.back(1);");
		}else{
			$control = $this->AliquotControl->findById($this->data[0]['realiquot_into']);
			if(isset($this->data[0]['ids'])){
				//first access
				$ids = explode(",", $this->data[0]['ids']);
				$samples = $this->SampleMaster->find('all', array('conditions' => array('id' => $ids), 'recursive' => -1));
				$this->data = array();
				foreach($samples as $sample){
					$this->data[] = array('parent' => $sample, 'children' => array());
				}
			}else{
				unset($this->data[0]);
				$prev_data = $this->data;
				$this->data = array();
				$errors = array();
				$all_aliquots = array();
				foreach($prev_data as $parent_id => &$children){
					//validate
					$sample = $this->SampleMaster->find('first', array('conditions' => array('id' => $parent_id), 'recursive' => -1));
					foreach($children as &$child){
						$child['AliquotMaster']['aliquot_control_id'] = $control['AliquotControl']['id'];
						$this->AliquotMaster->id = NULL;
						$this->AliquotMaster->set($child);
						if(!$this->AliquotMaster->validates()){
							$errors = array_merge_recursive($errors, $this->AliquotMaster->validationErrors);
						}
						$all_aliquots[] = $child;
					}
					$this->data[] = array('parent' => $sample, 'children' => $children);
				}
				
				if(empty($errors)){
					//all clear, save!
					echo "save";
				}
				$this->AliquotMaster->validationErrors = $errors;
			}	
			$this->set('aliquot_control', $control['AliquotControl']);
			$this->Structures->set($control['AliquotControl']['form_alias']);	
		}
	}
}

?>