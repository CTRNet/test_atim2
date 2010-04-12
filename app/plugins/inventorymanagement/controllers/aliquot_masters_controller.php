<?php
class AliquotMastersController extends InventoryManagementAppController {
	
	var $components = array(
		'Inventorymanagement.Collections', 
		'Inventorymanagement.Aliquots', 
		
		'Storagelayout.Storages',
		
		'Study.StudySummaries', 
		'Administrate.Administrates',
		'Sop.Sops');
	
	var $uses = array(
		'Inventorymanagement.Collection',
		
		'Inventorymanagement.SampleMaster',
		'Inventorymanagement.DerivativeDetail',
		
		'Inventorymanagement.SampleControl',
		'Inventorymanagement.SampleToAliquotControl',
		
		'Inventorymanagement.AliquotControl', 
		'Inventorymanagement.AliquotMaster', 
		'Inventorymanagement.ViewAliquot',
		'Inventorymanagement.AliquotDetail',			
		
		'Inventorymanagement.SampleToAliquotControl',
		'Inventorymanagement.RealiquotingControl',
		
		'Inventorymanagement.AliquotUse',
		'Inventorymanagement.AliquotUseDetail',
		'Inventorymanagement.Realiquoting',
		'Inventorymanagement.SourceAliquot',
		
		'Inventorymanagement.PathCollectionReview',
		
		'Storagelayout.StorageMaster',
		'Storagelayout.StorageCoordinate',
		
		'Administrate.Bank',
		'Study.StudySummary',
		'Order.OrderItem',
		'Sop.SopMaster'
	);
	
	var $paginate = array(
		'AliquotMaster' => array('limit' => pagination_amount , 'order' => 'AliquotMaster.barcode DESC'), 
		'ViewAliquot' => array('limit' => pagination_amount , 'order' => 'ViewAliquot.barcode DESC'), 
		'AliquotUse' => array('limit' => pagination_amount, 'order' => 'AliquotUse.use_datetime DESC'));

	/* --------------------------------------------------------------------------
	 * DISPLAY FUNCTIONS
	 * -------------------------------------------------------------------------- */

	/* ----------------------------- ALIQUOT MASTER ----------------------------- */
	
	function index() {
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/collections/index'));
						
		$_SESSION['ctrapp_core']['search'] = null; // clear SEARCH criteria
		$this->unsetInventorySessionData();
		
		// Set list of banks
		$this->set('bank_list', $this->Collections->getBankList());	

		$this->Structures->set('view_aliquot_joined_to_collection');
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link); 
		}
	}
	
	function search() {
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/collections/index'));

		$view_aliquot = $this->Structures->get('form', 'view_aliquot_joined_to_collection');
		$this->set('atim_structure', $view_aliquot);
		if ($this->data) $_SESSION['ctrapp_core']['search']['criteria'] = $this->Structures->parse_search_conditions($view_aliquot);
		
		$this->set('aliquots_data', $this->paginate($this->ViewAliquot, $_SESSION['ctrapp_core']['search']['criteria']));
		$this->data = array();
		
		// Set list of banks
		$this->set('bank_list', $this->Collections->getBankList());
		
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
				$model_to_use = 'ViewAliquot';
				$form_alias = 'view_aliquot_joined_to_sample';
				
				$aliquot_search_criteria['ViewAliquot.sample_master_id'] = $sample_master_id;
				
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
			$allowed_aliquot_type = $this->getAllowedAliquotTypes($sample_data['SampleMaster']['sample_control_id']);
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
		if((!$collection_id) || (!$sample_master_id) || (!$aliquot_control_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }		
		
		// MANAGE DATA

		// Get Sample Data
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id), 'recursive' => '-1'));
		if(empty($sample_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }	
		
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
		if(empty($sample_to_aliquot_control)) { $this->redirect('/pages/err_inv_no_data', null, true); }			
		$aliquot_control_data = array('AliquotControl' => $sample_to_aliquot_control['AliquotControl']);
		
		// Set new aliquot control information
		$this->set('aliquot_control_data', $aliquot_control_data);	
		
		// Set list of available SOPs to create aliquot
		$this->set('arr_aliquot_sops_for_display', $this->Aliquots->getAliquotSopList($sample_data['SampleMaster']['sample_type'], $aliquot_control_data['AliquotControl']['aliquot_type']));
		
		// Set list of studies
		$this->set('arr_studies_for_display', $this->getStudiesList());
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Set menu
		$atim_menu_link = '/inventorymanagement/aliquot_masters/listall/%%Collection.id%%/' . ($bool_is_specimen? '%%SampleMaster.initial_specimen_sample_id%%': '%%SampleMaster.id%%');
		$this->set('atim_menu', $this->Menus->get($atim_menu_link));
		
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id, 'SampleMaster.id' => $sample_master_id, 'SampleMaster.initial_specimen_sample_id' => $sample_data['SampleMaster']['initial_specimen_sample_id']));
		
		// set structure alias based on VALUE from CONTROL table
		$this->Structures->set($aliquot_control_data['AliquotControl']['form_alias']);
			
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link); 
		}

		// MANAGE DATA RECORD
		
		if (empty($this->data)) {
			// Initial Display
			$this->set('default_storage_datetime', $this->getDefaultAliquotStorageDate($sample_data));
			$this->set('arr_preselected_storages_for_display', array());
						
			$this->data = array(array());
			
		} else {
			// Record process
			
			// Manage volume
			foreach($this->data as $key => $data) {
				// Format decimal data
				$this->data[$key] = $this->formatAliquotFieldDecimalData($this->data[$key]);
				
				// Set AliquotMaster.initial_volume
				if(array_key_exists('initial_volume', $this->data[$key]['AliquotMaster'])){
					if(empty($aliquot_control_data['AliquotControl']['volume_unit'])) { $this->redirect('/pages/err_inv_system_error', null, true); }
					$this->data[$key]['AliquotMaster']['current_volume'] = $this->data[$key]['AliquotMaster']['initial_volume'];				
				}				
			}
					
			// Launch validations
			
			$submitted_data_validates = true;
			$errors = array();
					
			// -> Fields validation
			foreach($this->data as $key => $new_aliquot) {
				// AliquotMaster
				$this->AliquotMaster->set($this->data[$key]);
				$submitted_data_validates = ($this->AliquotMaster->validates())? $submitted_data_validates: false;
				foreach($this->AliquotMaster->invalidFields() as $field => $error) { $errors['AliquotMaster'][$field][$error] = '-'; }

				// AliquotDetail
				$this->AliquotDetail->set($this->data[$key]);
				$submitted_data_validates = ($this->AliquotDetail->validates())? $submitted_data_validates: false;			
				foreach($this->AliquotDetail->invalidFields() as $field => $error) { $errors['AliquotDetail'][$field][$error] = '-'; }
			}
			
			// -> Barcode validation
			$duplicated_barcode_validation = $this->isDuplicatedAliquotBarcode($this->data);
			if($duplicated_barcode_validation['is_duplicated_barcode']) {
				// Duplicated barcodes have been detected
				$submitted_data_validates = false;
				foreach($duplicated_barcode_validation['messages'] as $messages) {
					$errors['AliquotMaster']['barcode'][$messages] = '-';
				}
			}
			
			// -> Storage definition validation
			$storage_data_validation = $this->validateAliquotStorageData($this->data);
			if(!$storage_data_validation['submitted_data_validates']) {
				// Error in storage definition
				$submitted_data_validates = false;
				foreach($storage_data_validation['messages_sorted_per_field']  as $field => $messages) {
					foreach($messages as $message) {
						$errors['AliquotMaster'][$field][$message] = '-';
					}
				}
			}	
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link); 
			}		

			if($submitted_data_validates) {
				// Save data
				foreach($this->data as $key => $new_aliquot) { 
					// Set additional data
					$new_aliquot['AliquotMaster']['id'] = null;
					$new_aliquot['AliquotMaster']['collection_id'] = $collection_id;
					$new_aliquot['AliquotMaster']['sample_master_id'] = $sample_master_id;
					$new_aliquot['AliquotMaster']['aliquot_control_id'] = $aliquot_control_id;
					$new_aliquot['AliquotMaster']['aliquot_type'] = $aliquot_control_data['AliquotControl']['aliquot_type'];
					if(!$this->AliquotMaster->save($new_aliquot, false)) { $this->redirect('/pages/err_inv_record_err', null, true); } 
				}
				$this->flash('your data has been saved', '/inventorymanagement/aliquot_masters/listAll/' . $collection_id . '/' . $sample_master_id);									
				return;
			} else {
				// Set error message
				foreach($errors as $model => $field_messages) {
					$this->{$model}->validationErrors = array();
					foreach($field_messages as $field => $messages) {
						foreach($messages as $message => $tmp) {
							if(!array_key_exists($field, $this->{$model}->validationErrors)) {
								$this->{$model}->validationErrors[$field] = $message;
							} else {
								$this->{$model}->validationErrors[] = $message;
							}
						}
					}
				}
			}	
		}
	}
	
	function detail($collection_id, $sample_master_id, $aliquot_master_id, $is_tree_view_detail_form = false, $is_inventory_plugin_form = true) {
		if((!$collection_id) || (!$sample_master_id) || (!$aliquot_master_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }		
		
		// MANAGE DATA

		// Get the aliquot data
		$aliquot_data = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.collection_id' => $collection_id, 'AliquotMaster.sample_master_id' => $sample_master_id, 'AliquotMaster.id' => $aliquot_master_id)));
		if(empty($aliquot_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }		
		
		// Set aliquot use
		$aliquot_data['Generated']['aliquot_use_counter'] = sizeof($aliquot_data['AliquotUse']);
				
		// Set list of available SOPs to create aliquot
		$this->set('arr_aliquot_sops_for_display', $this->Aliquots->getAliquotSopList($aliquot_data['SampleMaster']['sample_type'], $aliquot_data['AliquotMaster']['aliquot_type']));

		// Set list of studies
		$this->set('arr_studies_for_display', $this->getStudiesList());
		
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
		$this->set('aliquots_uses_data', $this->paginate($this->AliquotUse, array('AliquotUse.aliquot_master_id' => $aliquot_master_id)));
		
		// MANAGE FORM, MENU AND ACTION BUTTONS

		// Get the current menu object.
		$atim_menu_link = ($aliquot_data['SampleMaster']['sample_category'] == 'specimen')? 
			'/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%AliquotMaster.id%%': 
			'/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%';
		$this->set('atim_menu', $this->Menus->get($atim_menu_link));
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id, 'SampleMaster.id' => $sample_master_id, 'SampleMaster.initial_specimen_sample_id' => $aliquot_data['SampleMaster']['initial_specimen_sample_id'], 'AliquotMaster.id' => $aliquot_master_id));
		
		// Set structure
		$this->Structures->set($aliquot_data['AliquotControl']['form_alias']);
		$this->Structures->set('aliquotuses', 'aliquots_uses_structure');
		
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
	}
	
	function edit($collection_id, $sample_master_id, $aliquot_master_id) {
		if((!$collection_id) || (!$sample_master_id) || (!$aliquot_master_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }		
		
		// MANAGE DATA

		// Get the aliquot data
				
		$aliquot_data = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.collection_id' => $collection_id, 'AliquotMaster.sample_master_id' => $sample_master_id, 'AliquotMaster.id' => $aliquot_master_id)));
		if(empty($aliquot_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }		

		// Set list of available SOPs to create aliquot
		$this->set('arr_aliquot_sops_for_display', $this->Aliquots->getAliquotSopList($aliquot_data['SampleMaster']['sample_type'], $aliquot_data['AliquotMaster']['aliquot_type']));

		// Set list of studies
		$this->set('arr_studies_for_display', $this->getStudiesList());
		
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
		
		if(empty($this->data)) {
			$this->data = $aliquot_data;
			
			$tmp_arr_preselected_storages = empty($aliquot_data['StorageMaster']['id'])? array(): array($aliquot_data['StorageMaster']['id'] => array('StorageMaster' => $aliquot_data['StorageMaster']));
			$this->set('arr_preselected_storages_for_display', $this->formatPreselectedStoragesForDisplay($tmp_arr_preselected_storages));

		} else {
			
			//Update data
			if(array_key_exists('initial_volume', $this->data['AliquotMaster']) && empty($aliquot_data['AliquotControl']['volume_unit'])) { $this->redirect('/pages/err_inv_system_error', null, true); }

			// Format decimal data
			$this->data = $this->formatAliquotFieldDecimalData($this->data);
									
			// Launch validations
			
			$submitted_data_validates = true;
			$errors = array();
					
			// -> Fields validation
			//  --> AliquotMaster
			$this->AliquotMaster->set($this->data);
			$submitted_data_validates = ($this->AliquotMaster->validates())? $submitted_data_validates: false;
			foreach($this->AliquotMaster->invalidFields() as $field => $error) { $errors['AliquotMaster'][$field][$error] = '-'; }
			//  --> AliquotDetail
			$this->AliquotDetail->set($this->data);
			$submitted_data_validates = ($this->AliquotDetail->validates())? $submitted_data_validates: false;
			foreach($this->AliquotDetail->invalidFields() as $field => $error) { $errors['AliquotDetail'][$field][$error] = '-'; }
			
			// -> Storage definition validation
			$storage_data_validation = $this->validateAliquotStorageData($this->data);
			if(!$storage_data_validation['submitted_data_validates']) {
				// Error in storage definition
				$submitted_data_validates = false;
				foreach($storage_data_validation['messages_sorted_per_field']  as $field => $all_messages) {
					foreach($all_messages as $message) {
						$errors['AliquotMaster'][$field][$message] = '-';
					}
				}
			}
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}
			
			// Save data
			if($submitted_data_validates) {
				$this->AliquotMaster->id = $aliquot_master_id;
				if(!$this->AliquotMaster->save($this->data, false)) { $this->redirect('/pages/err_inv_record_err', null, true); }
				if(!$this->Aliquots->updateAliquotCurrentVolume($aliquot_master_id)) { $this->redirect('/pages/err_inv_record_err', null, true); }			
				$this->flash('your data has been updated', '/inventorymanagement/aliquot_masters/detail/' . $collection_id . '/' . $sample_master_id. '/' . $aliquot_master_id);				
				return;
			} else {
				// Set error message
				foreach($errors as $model => $field_messages) {
					$this->{$model}->validationErrors = array();
					foreach($field_messages as $field => $messages) {
						foreach($messages as $message => $tmp) {
							if(!array_key_exists($field, $this->{$model}->validationErrors)) {
								$this->{$model}->validationErrors[$field] = $message;
							} else {
								$this->{$model}->validationErrors[] = $message;
							}
						}
					}
				}
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
		if(!$this->AliquotMaster->save(array('AliquotMaster' => array('storage_master_id' => null, 'storage_coord_x' => null, 'storage_coord_y' => null)))) {
			$this->redirect('/pages/err_inv_record_err', null, true);
		}
		
		$this->flash('your data has been updated', '/inventorymanagement/aliquot_masters/detail/' . $collection_id . '/' . $sample_master_id. '/' . $aliquot_master_id);				
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
				$this->flash('your data has been deleted', '/inventorymanagement/aliquot_masters/listAll/' . $collection_id . '/' . $sample_master_id);
			} else {
				$this->flash('error deleting data - contact administrator', '/inventorymanagement/aliquot_masters/listAll/' . $collection_id . '/' . $sample_master_id);
			}
		} else {
			$this->flash($arr_allow_deletion['msg'], '/inventorymanagement/aliquot_masters/detail/' . $collection_id . '/' . $sample_master_id . '/' . $aliquot_master_id);
		}		
	}
	
	/* ------------------------------ ALIQUOT USES ------------------------------ */

	function addAliquotUse($collection_id, $sample_master_id, $aliquot_master_id, $aliquot_use_defintion = null) {
		if((!$collection_id) || (!$sample_master_id) || (!$aliquot_master_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }
		
		// MANAGE DATA

		// Get the aliquot data
		$aliquot_data = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.collection_id' => $collection_id, 'AliquotMaster.sample_master_id' => $sample_master_id, 'AliquotMaster.id' => $aliquot_master_id)));
		if(empty($aliquot_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }		

		// Set list of studies
		$this->set('arr_studies_for_display', $this->getStudiesList());		
			
		// Set aliquot volume unit
		$aliquot_volume_unit = empty($aliquot_data['AliquotMaster']['aliquot_volume_unit'])? 'n/a': $aliquot_data['AliquotMaster']['aliquot_volume_unit'];
		$this->set('aliquot_volume_unit', $aliquot_volume_unit);	
		
		// Set use defintion
		$use_defintions_system_dependent = array('quality control', 'sample derivative creation', 'realiquoted to', 'aliquot shipment');
		if(empty($aliquot_use_defintion)  || (in_array($aliquot_use_defintion, $use_defintions_system_dependent))) { $this->redirect('/pages/err_inv_system_error', null, true); }			
		$this->set('use_defintion', $aliquot_use_defintion);	
				
		// MANAGE FORM, MENU AND ACTION BUTTONS

		// Get the current menu object.
		$atim_menu_link = ($aliquot_data['SampleMaster']['sample_category'] == 'specimen')? 
			'/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%AliquotMaster.id%%': 
			'/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%';
		$this->set('atim_menu', $this->Menus->get($atim_menu_link));
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id, 'SampleMaster.id' => $sample_master_id, 'SampleMaster.initial_specimen_sample_id' => $aliquot_data['SampleMaster']['initial_specimen_sample_id'], 'AliquotMaster.id' => $aliquot_master_id));
		
		// Set structure
		$this->Structures->set('aliquotuses');
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
		
		// MANAGE DATA RECORD

		if(empty($this->data)) {
			// Force $this->data to empty array() to override AliquotMaster.aliquot_volume_unit 
			$this->data = array();
			
		} else {
			// Format decimal data
			$this->data = $this->Aliquots->formatAliquotUseFieldDecimalData($this->data);
			
			// Launch save process
			$submitted_data_validates = true;
			
			if(((!empty($this->data['AliquotUse']['used_volume'])) || ($this->data['AliquotUse']['used_volume'] == '0'))&& empty($aliquot_data['AliquotMaster']['aliquot_volume_unit'])) {
				// No volume has to be recored for this aliquot type				
				$this->AliquotUse->validationErrors['used_volume'] = 'no volume has to be recorded for this aliquot type';	
				$submitted_data_validates = false;			
			} else if(empty($this->data['AliquotUse']['used_volume'])) {
				// Change '0' to null
				$this->data['AliquotUse']['used_volume'] = null;
			}
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}
			
			// if data VALIDATE, then save data
			if ($submitted_data_validates) {
				$this->data['AliquotUse']['aliquot_master_id'] = $aliquot_master_id;			
				if ($this->AliquotUse->save($this->data)) { 
					if(!$this->Aliquots->updateAliquotCurrentVolume($aliquot_master_id)) { $this->redirect('/pages/err_inv_record_err', null, true); }	
					$this->flash('your data has been saved', '/inventorymanagement/aliquot_masters/detail/'.$collection_id.'/'.$sample_master_id.'/'.$aliquot_master_id.'/');
				} 
			}
		}
	}
	
	function editAliquotUse($collection_id, $sample_master_id, $aliquot_master_id, $aliquot_use_id) {
		if((!$collection_id) || (!$sample_master_id) || (!$aliquot_master_id) || (!$aliquot_use_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }
			
 		// MANAGE DATA

		// Get the use data
		$use_data = $this->AliquotUse->find('first', array('conditions' => array('AliquotMaster.collection_id' => $collection_id, 'AliquotMaster.sample_master_id' => $sample_master_id, 'AliquotMaster.id' => $aliquot_master_id, 'AliquotUse.id' => $aliquot_use_id)));
		if(empty($use_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }		
		
		// Get Sample Data
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id), 'recursive' => '-1'));
		if(empty($sample_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }	
				
		// Set list of studies
		$this->set('arr_studies_for_display', $this->getStudiesList());		
			
		// Set aliquot volume unit
		$aliquot_volume_unit = empty($use_data['AliquotMaster']['aliquot_volume_unit'])? 'n/a': $use_data['AliquotMaster']['aliquot_volume_unit'];
		$this->set('aliquot_volume_unit', $aliquot_volume_unit);	
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$atim_menu_link = ($sample_data['SampleMaster']['sample_category'] == 'specimen')? 
			'/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%AliquotMaster.id%%': 
			'/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%';
		$this->set('atim_menu', $this->Menus->get($atim_menu_link));	
			
		// Get the current menu object.
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id, 'SampleMaster.id' => $sample_master_id, 'SampleMaster.initial_specimen_sample_id' => $sample_data['SampleMaster']['initial_specimen_sample_id'], 'AliquotMaster.id' => $aliquot_master_id, 'AliquotUse.id' => $aliquot_use_id));
		
		// Set structure
		$use_defintions_system_dependent = array('quality control', 'sample derivative creation', 'realiquoted to', 'aliquot shipment');
		$form_alias = in_array($use_data['AliquotUse']['use_definition'], $use_defintions_system_dependent)?  'aliquotuses_system_dependent':'aliquotuses';
		$this->Structures->set($form_alias);

		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
					
		// MANAGE DATA RECORD
		
		if(empty($this->data)) {
			$this->data = $use_data;

		} else {
			// Format decimal data
			$this->data = $this->Aliquots->formatAliquotUseFieldDecimalData($this->data);
						
			// Launch validations		
			$submitted_data_validates = true;
			
			if((!empty($this->data['AliquotUse']['used_volume'])) && empty($use_data['AliquotMaster']['aliquot_volume_unit'])) {
				// No volume has to be recored for this aliquot type				
				$this->AliquotUse->validationErrors['used_volume'] = 'no volume has to be recorded for this aliquot type';	
				$submitted_data_validates = false;			
			} else if(empty($this->data['AliquotUse']['used_volume'])) {
				// Change '0' to null
				$this->data['AliquotUse']['used_volume'] = null;
			}
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link); 
			}
			
			// if data VALIDATE, then save data
			if ($submitted_data_validates) {
				$this->AliquotUse->id = $aliquot_use_id;			
				if ($this->AliquotUse->save($this->data)) { 
					if(!$this->Aliquots->updateAliquotCurrentVolume($aliquot_master_id)) { $this->redirect('/pages/err_inv_record_err', null, true); }
					$this->flash('your data has been saved', '/inventorymanagement/aliquot_masters/detail/' . $collection_id . '/' . $sample_master_id . '/' . $aliquot_master_id);
				} 
			}
		}
	}
	
	function deleteAliquotUse($collection_id, $sample_master_id, $aliquot_master_id, $aliquot_use_id, $redirect = null, $extra_param = null) {
		if((!$collection_id) || (!$sample_master_id) || (!$aliquot_master_id) || (!$aliquot_use_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }	

 		// MANAGE DATA
		
		// Get the use data
		$use_data = $this->AliquotUse->find('first', array('conditions' => array('AliquotMaster.collection_id' => $collection_id, 'AliquotMaster.sample_master_id' => $sample_master_id, 'AliquotMaster.id' => $aliquot_master_id, 'AliquotUse.id' => $aliquot_use_id)));
		if(empty($use_data)) { exit;$this->redirect('/pages/err_inv_no_data', null, true); }		

		// Set url to display next page
		$flash_url = '';
		switch($redirect) {
			case 'realiquoting':
				$flash_url = '/inventorymanagement/aliquot_masters/listAllRealiquotedParents/' . $collection_id . '/' . $sample_master_id . '/' . $extra_param;
				break;
			case 'sourcealiquot':
				$flash_url = '/inventorymanagement/aliquot_masters/listAllSourceAliquots/' . $collection_id . '/' . $extra_param . '/';
				break;
			case 'qualitycontrol':
				$flash_url = '/inventorymanagement/quality_ctrls/detail/' . $collection_id . '/' . $sample_master_id . '/' . $extra_param . '/';
				break;
			default:
				$flash_url = '/inventorymanagement/aliquot_masters/detail/' . $collection_id . '/' . $sample_master_id . '/' . $aliquot_master_id;
		}
		
		// Set Use Detail table
		$this->AliquotUseDetail = null;
		if(!empty($use_data['AliquotUse']['use_recorded_into_table'])) {
			$supported_use_detail_table = array('quality_ctrl_tested_aliquots', 'source_aliquots', 'realiquotings');
			
			if(in_array($use_data['AliquotUse']['use_recorded_into_table'], $supported_use_detail_table)) {
				$this->AliquotUseDetail = new AliquotUseDetail(false, $use_data['AliquotUse']['use_recorded_into_table']);
			} else {
				$this->flash('deletion of this type of use is currently not supported from use list', $flash_url);
				return;
			}	
		}
	
		// LAUNCH DELETION
		
		// -> Delete use detail if exists	
		$deletion_done = true;
		if(!is_null($this->AliquotUseDetail)) {
			$aliquot_use_detail = $this->AliquotUseDetail->find('first', array('conditions' => array('aliquot_use_id' => $aliquot_use_id)));
			if(empty($aliquot_use_detail)) { $this->redirect('/pages/err_inv_no_data', null, true); }
			$aliquot_use_detail_id = $aliquot_use_detail['AliquotUseDetail']['id']; 
			if(!$this->AliquotUseDetail->atim_delete($aliquot_use_detail_id)) { $deletion_done = false; }
		}
		
		// -> Delete use
		if($deletion_done) {
			if(!$this->AliquotUse->atim_delete($aliquot_use_id)) { $deletion_done = false; }	
		}
		
		// -> Delete use
		if($deletion_done) {
			if(!$this->Aliquots->updateAliquotCurrentVolume($aliquot_master_id)) { $deletion_done = false; }
		}
		
		if($deletion_done) {
			$this->flash('your data has been deleted - update the aliquot in stock data', $flash_url); 
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
		
		// Set array to get id from barcode
		$aliquot_id_by_barcode = array();
		foreach($available_sample_aliquots as $aliquot_data){
			$aliquot_id_by_barcode[$aliquot_data['AliquotMaster']['barcode']] = $aliquot_data['AliquotMaster']['id']; 
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
			foreach($this->data as $key => $new_studied_aliquot){
				if($new_studied_aliquot['FunctionManagement']['use']){
					// New aliquot defined as source
					
					// Format decimal data
					$new_studied_aliquot = $this->Aliquots->formatAliquotUseFieldDecimalData($new_studied_aliquot);
					
					// Check volume
					if((!empty($new_studied_aliquot['AliquotUse']['used_volume'])) && empty($new_studied_aliquot['AliquotMaster']['aliquot_volume_unit'])) {
						// No volume has to be recored for this aliquot type				
						$errors['AliquotUse']['used_volume']['no volume has to be recorded for this aliquot type'] = '-'; 
						$new_studied_aliquot['AliquotUse']['used_volume'] = '#err#';
						$submitted_data_validates = false;			
					} else if(empty($new_studied_aliquot['AliquotUse']['used_volume'])) {
						// Change '0' to null
						$new_studied_aliquot['AliquotUse']['used_volume'] = null;
					}
					
					// Launch Aliquot Master validation
					$this->AliquotMaster->set($new_studied_aliquot);
					$submitted_data_validates = ($this->AliquotMaster->validates())? $submitted_data_validates: false;
					foreach($this->AliquotMaster->invalidFields() as $field => $error) { $errors['AliquotMaster'][$field][$error] = '-'; }					
					
					// Launch Aliquot Use validation
					$this->AliquotUse->set($new_studied_aliquot);
					$submitted_data_validates = ($this->AliquotUse->validates())? $submitted_data_validates: false;
					foreach($this->AliquotUse->invalidFields() as $field => $error) { $errors['AliquotUse'][$field][$error] = '-'; }
					
					// Get child aliquot master id
					if(!isset($aliquot_id_by_barcode[$new_studied_aliquot['AliquotMaster']['barcode']])) { $this->redirect('/pages/err_inv_system_error', null, true); }
					$new_studied_aliquot['AliquotMaster']['id'] = $aliquot_id_by_barcode[$new_studied_aliquot['AliquotMaster']['barcode']];
					
					// Add record to array of tested aliquots
					$aliquots_defined_as_source[] = $new_studied_aliquot;		
				}
				
				// Reset data
				$this->data[$key] = $new_studied_aliquot;				
			}
			
			if(empty($aliquots_defined_as_source)) { 
				$this->AliquotUse->validationErrors[] = 'no aliquot has been defined as source aliquot';	
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
						foreach($messages as $message => $tmp) {
							if(!array_key_exists($field, $this->{$model}->validationErrors)) {
								$this->{$model}->validationErrors[$field] = $message;
							} else {
								$this->{$model}->validationErrors[] = $message;
							}
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
					if($new_source_aliquot['FunctionManagement']['remove_from_storage']) {
						// Delete aliquot storage data
						$new_source_aliquot['AliquotMaster']['storage_master_id'] = null;
						$new_source_aliquot['AliquotMaster']['storage_coord_x'] = null;
						$new_source_aliquot['AliquotMaster']['storage_coord_y'] = null;
					}
					
					// Set aliquot use data
					$new_source_aliquot['AliquotUse']['aliquot_master_id'] = $aliquot_master_id;
					$new_source_aliquot['AliquotUse']['use_definition'] = 'sample derivative creation';
					$new_source_aliquot['AliquotUse']['use_code'] = $sample_data['SampleMaster']['sample_code'];
					$new_source_aliquot['AliquotUse']['use_details'] = '';
					$new_source_aliquot['AliquotUse']['use_datetime'] = $sample_data['DerivativeDetail']['creation_datetime'];
					$new_source_aliquot['AliquotUse']['used_by'] = $sample_data['DerivativeDetail']['creation_by'];
					$new_source_aliquot['AliquotUse']['use_recorded_into_table'] = 'source_aliquots';					
					
					// Save data:
					// - AliquotMaster
					$this->AliquotMaster->id = $aliquot_master_id;
					if(!$this->AliquotMaster->save($new_source_aliquot, false)) { $this->redirect('/pages/err_inv_record_err', null, true); }
					
					// - AliquotUse
					$this->AliquotUse->id = null;
					if(!$this->AliquotUse->save($new_source_aliquot, false)) { $this->redirect('/pages/err_inv_record_err', null, true); }
					$aliquot_use_id = $this->AliquotUse->getLastInsertId();
					
					// - QualityCtrlTestedAliquot
					$this->SourceAliquot->id = null;
					$source_aliquot_data = array( 'SourceAliquot' => array('aliquot_master_id' => $aliquot_master_id, 'sample_master_id' => $sample_master_id, 'aliquot_use_id' => $aliquot_use_id));
					if(!$this->SourceAliquot->save($source_aliquot_data)) { $this->redirect('/pages/err_inv_record_err', null, true); }

					// - Update aliquot current volume
					if(!$this->Aliquots->updateAliquotCurrentVolume($aliquot_master_id)) { $this->redirect('/pages/err_inv_record_err', null, true); }
				}
				
				$this->flash('your data has been saved', '/inventorymanagement/aliquot_masters/listAllSourceAliquots/' . $collection_id . '/' . $sample_master_id); 
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
	
		/* ------------------------------ REALIQUOTING ------------------------------ */

	function defineRealiquotedChildren($collection_id, $sample_master_id, $aliquot_master_id) {
		if((!$collection_id) || (!$sample_master_id) || (!$aliquot_master_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }
		
		// MANAGE DATA
		
		// Get the parent aliquot data
		$parent_aliquot_data = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.collection_id' => $collection_id, 'AliquotMaster.sample_master_id' => $sample_master_id, 'AliquotMaster.id' => $aliquot_master_id)));
		if(empty($parent_aliquot_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }		

		// Get aliquot already defined as children
		$existing_children = array();
		foreach($parent_aliquot_data['RealiquotingChildren'] as $realiquoting_data) {
			$existing_children[] = $realiquoting_data['child_aliquot_master_id'];
		}
		
		// Get aliquot type that could be defined as children of the parent aliquot type
		$criteria = array(
			'ParentSampleToAliquotControl.sample_control_id' => $parent_aliquot_data['SampleMaster']['sample_control_id'], 
			'ParentSampleToAliquotControl.aliquot_control_id' => $parent_aliquot_data['AliquotMaster']['aliquot_control_id'],
			'ParentSampleToAliquotControl.status' => 'active',
			'RealiquotingControl.status' => 'active',
			'ChildSampleToAliquotControl.sample_control_id' => $parent_aliquot_data['SampleMaster']['sample_control_id'], 
			'ChildSampleToAliquotControl.status' => 'active'
		);	
		
		$realiquotind_control_data = $this->RealiquotingControl->find('all', array('conditions' => $criteria));
		
		$allowed_children_aliquot_control_ids = array();
		foreach($realiquotind_control_data as $new_realiquoting_control) {
			$allowed_children_aliquot_control_ids[] = $new_realiquoting_control['ChildSampleToAliquotControl']['aliquot_control_id'];
		}
		
		// Search Sample Aliquots could be defined as children aliquot
		$criteria = array(
			"AliquotMaster.id != '$aliquot_master_id'", 
			'AliquotMaster.sample_master_id' => $sample_master_id,
			'AliquotMaster.aliquot_control_id' => $allowed_children_aliquot_control_ids,
			'NOT' => array('AliquotMaster.id' => $existing_children)
		);
	
		$aliquot_data_for_selection = $this->AliquotMaster->find('all', array('conditions' => $criteria, 'recursive' => '0'));
		if(empty($aliquot_data_for_selection)) {
			$this->flash('no new sample aliquot could be actually defined as realiquoted child', '/inventorymanagement/aliquot_masters/detail/' . $collection_id . '/' . $sample_master_id . '/' . $aliquot_master_id);
			return;
		}
		
		// Set array to get id from barcode
		$aliquot_id_by_barcode = array();
		foreach($aliquot_data_for_selection as $aliquot_data){
			$aliquot_id_by_barcode[$aliquot_data['AliquotMaster']['barcode']] = $aliquot_data['AliquotMaster']['id']; 
		}
			
		// Set parent aliquot volume unit
		$aliquot_volume_unit = empty($parent_aliquot_data['AliquotMaster']['aliquot_volume_unit'])? 'n/a': $parent_aliquot_data['AliquotMaster']['aliquot_volume_unit'];
		$this->set('parent_aliquot_volume_unit', $aliquot_volume_unit);	
		
		// MANAGE FORM, MENU AND ACTION BUTTONS

		// Get the current menu object.
		$atim_menu_link = ($parent_aliquot_data['SampleMaster']['sample_category'] == 'specimen')? 
			'/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%AliquotMaster.id%%': 
			'/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%';
		$this->set('atim_menu', $this->Menus->get($atim_menu_link));
		
		// Get the current menu object.
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id, 'SampleMaster.id' => $sample_master_id, 'SampleMaster.initial_specimen_sample_id' => $parent_aliquot_data['SampleMaster']['initial_specimen_sample_id'], 'AliquotMaster.id' => $aliquot_master_id));
		
		// Set structure
		$this->Structures->set('children_aliquots_selection', 'atim_structure_for_children_aliquots_selection');
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
			
		// MANAGE DATA RECORD
		
		if(empty($this->data)) {
			$this->set('default_realiquoting_date', $this->getDefaultRealiquotingDate($aliquot_data_for_selection));
			$this->data = $aliquot_data_for_selection;
			
		} else {
						
			// Launch validation
			$submitted_data_validates = true;
			
			$data_to_save = array();
			$aliquot_use_data_errors = array();
			foreach($this->data as $id => $new_studied_aliquot) {
				// New studied aliquot

				if($new_studied_aliquot['FunctionManagement']['use']) {
					// Aliquot has been defined as child
					
					// Format decimal data
					$new_studied_aliquot = $this->Aliquots->formatAliquotUseFieldDecimalData($new_studied_aliquot);
					
					// Check volume
					if((!empty($new_studied_aliquot['AliquotUse']['used_volume'])) && empty($parent_aliquot_data['AliquotMaster']['aliquot_volume_unit'])) {
						// No volume has to be recored for this aliquot type				
						$aliquot_use_data_errors['used_volume']['no volume has to be recorded for this aliquot type'] = '-'; 	
						$submitted_data_validates = false;			
					} else if(empty($new_studied_aliquot['AliquotUse']['used_volume'])) {
						// Change '0' to null
						$new_studied_aliquot['AliquotUse']['used_volume'] = null;
					}
					
					// Launch Aliquot Use validation
					$this->AliquotUse->set($new_studied_aliquot);
					$submitted_data_validates = ($this->AliquotUse->validates())? $submitted_data_validates: false;
					foreach($this->AliquotUse->invalidFields() as $field => $error) { $aliquot_use_data_errors[$field][$error] = '-'; }
					
					// Get child aliquot master id
					if(!isset($aliquot_id_by_barcode[$new_studied_aliquot['AliquotMaster']['barcode']])) { $this->redirect('/pages/err_inv_system_error', null, true); }
					$new_studied_aliquot['AliquotMaster']['id'] = $aliquot_id_by_barcode[$new_studied_aliquot['AliquotMaster']['barcode']];
					
					// Define data as 'to save'
					$data_to_save[] = $new_studied_aliquot;
				}
				
				// Reset data
				$this->data[$id] = $new_studied_aliquot;
			}
			
			if(empty($data_to_save)) { 
				$this->AliquotUse->validationErrors[] = 'no aliquot has been defined as realiquoted child';	
				$submitted_data_validates = false;			
			}
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link); 
			}
			
			if (!$submitted_data_validates) {
				// Set error message
				foreach($aliquot_use_data_errors as $field => $error_messages) {
					foreach($error_messages as $message => $tmp) {
						if(!array_key_exists($field, $this->AliquotUse->validationErrors)) {
							$this->AliquotUse->validationErrors[$field] = $message;
						} else {
							$this->AliquotUse->validationErrors[] = $message;
						}
					}
				}
				
			} else {
				
				// Launch Save Process
				
				foreach($data_to_save as $key => $realiquoted_child){
					// Get child aliquot master id
					$child_aliquot_master_id = $realiquoted_child['AliquotMaster']['id'];
					
					// Set data to save into AliquotUses
					$aliquot_use = array();
					$aliquot_use['AliquotUse']['id'] = null;
					$aliquot_use['AliquotUse']['aliquot_master_id'] = $aliquot_master_id;
					$aliquot_use['AliquotUse']['use_definition'] = 'realiquoted to';
					$aliquot_use['AliquotUse']['use_details'] = '';
					$aliquot_use['AliquotUse']['use_code'] = $realiquoted_child['AliquotMaster']['barcode'];
					$aliquot_use['AliquotUse']['use_recorded_into_table'] = 'realiquotings';
					$aliquot_use['AliquotUse']['used_volume'] = $realiquoted_child['AliquotUse']['used_volume']; 
					$aliquot_use['AliquotUse']['use_datetime'] = $realiquoted_child['AliquotUse']['use_datetime'];
					$aliquot_use['AliquotUse']['used_by'] = $realiquoted_child['AliquotUse']['used_by'];
					$aliquot_use['AliquotUse']['study_summary_id'] = '';
						
					if(!$this->AliquotUse->save($aliquot_use, false)) { $this->redirect('/pages/err_inv_record_err', null, true); }					
						
					// Set data to save into Realiquotings
					$realiquoting = array();					
					$realiquoting['Realiquoting']['id'] = null;
					$realiquoting['Realiquoting']['parent_aliquot_master_id'] = $aliquot_master_id;
					$realiquoting['Realiquoting']['child_aliquot_master_id'] = $child_aliquot_master_id;
					$realiquoting['Realiquoting']['aliquot_use_id'] = $this->AliquotUse->id;
					
					if(!$this->Realiquoting->save($realiquoting, false)) { $this->redirect('/pages/err_inv_record_err', null, true); }
				}
				
				// Update aliquot current volume
				if(!$this->Aliquots->updateAliquotCurrentVolume($aliquot_master_id)) { $this->redirect('/pages/err_inv_record_err', null, true); }
				
				$this->Flash('your data has been saved', '/inventorymanagement/aliquot_masters/detail/'.$collection_id.'/'.$sample_master_id.'/'.$aliquot_master_id.'/');
			}
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
	
	/* -------------------------------- ORDERING -------------------------------- */
	
	/* --------------------------------------------------------------------------
	 * ADDITIONAL FUNCTIONS
	 * -------------------------------------------------------------------------- */
	
	/**
	 * Get formatted list of Studies existing into the system.
	 * 
	 * Note: Function to allow bank to customize this function when they don't use 
	 * Study module.
	 *
	 * @return Studies list into array having following structure: 
	 * 	array($study_id => $study_title_built_by_function)
	 *
	 * @author N. Luc
	 * @since 2009-09-11
	 * @updated N. Luc
	 */
	 
	function getStudiesList() {
		$studies_data = $this->StudySummaries->getStudiesList();
		
		$formatted_data = array();
		if(!empty($studies_data)) {
			foreach($studies_data as $new_study) {
				$formatted_data[$new_study['StudySummary']['id']] = $new_study['StudySummary']['title'] . ' ('.__($new_study['StudySummary']['disease_site'], true) .'-'.__($new_study['StudySummary']['study_type'], true) .')'; 
			}	
		}
		
		return $formatted_data;
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
	 * @return  Following results array:
	 * 	array(
	 * 		'is_duplicated_barcode' => TRUE when barcodes are duplicaed,
	 * 		'messages' => array($message_1, $message_2, ...)
	 * 	)
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
		if(is_array($aliquots_data)) {
			if(isset($aliquots_data['AliquotMaster'])) {
				// Single record to manage as multi records
				$aliquots_data = array('0' => $aliquots_data);
				$is_multi_records_data = false;
			} else {
				$tmp_arr_to_test = array_values($aliquots_data);	// Use in case user created aliquots in batch and hidden the first row of the datagrid
				if(is_array($tmp_arr_to_test) && isset($tmp_arr_to_test[0]['AliquotMaster'])) {
					// Multi records: Nothing to do				
				} else {
					$this->redirect('/pages/err_inv_system_error', null, true);
				}
			}
		} else {
			$this->redirect('/pages/err_inv_system_error', null, true);
		}
		
		// Check duplicated barcode into submited record
		foreach($aliquots_data as $new_aliquot) {
			$barcode = $new_aliquot['AliquotMaster']['barcode'];
			if(empty($barcode)) {
				// Not studied
			} else if(isset($new_barcodes[$barcode])) {
				$duplicated_barcodes[$barcode] = $barcode;
			} else {
				$new_barcodes[$barcode] = $barcode;
			}
		}
		
		// Check duplicated barcode into db
		$criteria = array('AliquotMaster.barcode' => $new_barcodes);
		$aliquots_having_duplicated_barcode = $this->AliquotMaster->atim_list(array('conditions' => $criteria));
		if(!empty($aliquots_having_duplicated_barcode)) {
			foreach($aliquots_having_duplicated_barcode as $new_aliquot) {
				$barcode = $new_aliquot['AliquotMaster']['barcode'];
				$duplicated_barcodes[$barcode] = $barcode;
			}			
		}
		
		// Set errors
		$messages = array();
		if(!empty($duplicated_barcodes)) {
			// Set boolean
			$is_duplicated_barcode = true;
			
			// Set error message
			$messages[]	= 'barcode must be unique';
			$str_barcodes_in_error = ' => ';
			foreach($duplicated_barcodes as $barcode) {
				$str_barcodes_in_error .= '[' . $barcode . '] ';
			}
			$messages[]	= $str_barcodes_in_error; 
		}
		
		return array('is_duplicated_barcode' => $is_duplicated_barcode, 'messages' => $messages);
	}
	
	/**
	 * Replace ',' by '.' for all decimal field values gathered into 
	 * data submitted for aliquot creation or modification.
	 * 
	 * @param $submtted_data Submitted data
	 * 
	 * @return Formatted data.
	 *
	 * @author N. Luc
	 * @since 2009-09-11
	 */	
	
	function formatAliquotFieldDecimalData($submtted_data) {
		// Work on AliquotMaster fields
		if(isset($submtted_data['AliquotMaster'])) {
			if(isset($submtted_data['AliquotMaster']['initial_volume'])) { $submtted_data['AliquotMaster']['initial_volume'] = str_replace(',', '.', $submtted_data['AliquotMaster']['initial_volume']); }					
		}
		
		// Work on AliquotDetail fields
		if(isset($submtted_data['AliquotDetail'])) {
			if(isset($submtted_data['AliquotDetail']['used_blood_volume'])) { $submtted_data['AliquotDetail']['used_blood_volume'] = str_replace(',', '.', $submtted_data['AliquotDetail']['used_blood_volume']); }					
			if(isset($submtted_data['AliquotDetail']['cell_count'])) { $submtted_data['AliquotDetail']['cell_count'] = str_replace(',', '.', $submtted_data['AliquotDetail']['cell_count']); }					
			if(isset($submtted_data['AliquotDetail']['concentration'])) { $submtted_data['AliquotDetail']['concentration'] = str_replace(',', '.', $submtted_data['AliquotDetail']['concentration']); }					
		}
		
		return $submtted_data;
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
	 * @return Following results array:
	 * 	array(
	 * 		'submitted_data_validates' => TRUE when data are validated,
	 * 		'messages_sorted_per_field' => array ($field_name => array($message_1, $message_2, ...))
	 * 	)
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
		if(is_array($aliquots_data)) {
			if(isset($aliquots_data['AliquotMaster'])) {
				// Single record to manage as multi records
				$aliquots_data = array('0' => $aliquots_data);
				$is_multi_records_data = false;
			} else {
				$tmp_arr_to_test = array_values($aliquots_data);	// Use in case user created aliquots in batch and hidden the first row of the datagrid
				if(is_array($tmp_arr_to_test) && isset($tmp_arr_to_test[0]['AliquotMaster'])) {
					// Multi records: Nothing to do				
				} else {
					$this->redirect('/pages/err_inv_system_error', null, true);
				}
			}
		} else {
			$this->redirect('/pages/err_inv_system_error', null, true);
		}
		
		// Launch validation		
		foreach ($aliquots_data as $key => $new_aliquot) {		
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
			$aliquots_data[$key] = $new_aliquot;
		}
		
		// Set preselected storage list		
		$this->set('arr_preselected_storages_for_display', $this->formatPreselectedStoragesForDisplay($arr_preselected_storages));
				
		// Manage error message
		$messages = array();
		foreach($storage_validation_errors['id'] as $error) { $messages['storage_master_id'][] = $error; }
		foreach($storage_validation_errors['x'] as $error) { $messages['storage_coord_x'][] = $error; }
		foreach($storage_validation_errors['y'] as $error) { $messages['storage_coord_y'][] = $error; }
		
		if(!$is_multi_records_data) {
			// Reset correctly single record data
			$aliquots_data = $aliquots_data['0'];
		}
		
		return array('submitted_data_validates' => $submitted_data_validates, 'messages_sorted_per_field' => $messages);
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
	
	/**
	 * Format Preselected Storages data array for display.
	 * 
	 * @param $arr_preselected_storages PreselectedStorages data
	 * 
	 * @return Preselected storage list into array having following structure: 
	 * 	array($storage_master_id => $storage_title_built_by_function)
	 *
	 * @author N. Luc
	 * @since 2009-09-11
	 */	
	 
	function formatPreselectedStoragesForDisplay($arr_preselected_storages) {
		$formatted_data = array();
		
		if(!empty($arr_preselected_storages)) {
			foreach ($arr_preselected_storages as $storage_id => $storage_data) {
				$formatted_data[$storage_id] = $storage_data['StorageMaster']['selection_label'] . ' [' . __($storage_data['StorageMaster']['code'] . ' ('.$storage_data['StorageMaster']['storage_type'], TRUE) .')'. ']';
			}
		}
	
		return $formatted_data;
	}
}

?>
