<?php
class AliquotMastersController extends InventoryManagementAppController {
	
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
		'Inventorymanagement.AliquotUseDetail',
		'Inventorymanagement.Realiquoting',
		'Inventorymanagement.SourceAliquot',
		
		'Inventorymanagement.PathCollectionReview',
		
		'Storagelayout.StorageMaster',
		'Storagelayout.StorageCoordinate',
		
		'Study.StudySummary',
		'Order.OrderItem'
	);
	
	var $paginate = array('AliquotMaster' => array('limit' =>10 , 'order' => 'AliquotMaster.barcode DESC'), 'AliquotUse' => array('limit' => 10, 'order' => 'AliquotUse.use_datetime DESC'));

	/* --------------------------------------------------------------------------
	 * DISPLAY FUNCTIONS
	 * -------------------------------------------------------------------------- */

	/* ----------------------------- ALIQUOT MASTER ----------------------------- */
	
	function index() {
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/collections/index'));
						
		$_SESSION['ctrapp_core']['search'] = null; // clear SEARCH criteria
		$this->unsetInventorySessionData();
		
		// Set list of banks
		$this->set('banks', $this->getBankList());	
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link); 
		}
	}
	
	function search() {
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/collections/index'));
		
		if ($this->data) $_SESSION['ctrapp_core']['search']['criteria'] = $this->Structures->parse_search_conditions();
		$this->setDataForAliquotsList($_SESSION['ctrapp_core']['search']['criteria']);
		$this->data = array();
		
		// if SEARCH form data, save number of RESULTS and URL
		$_SESSION['ctrapp_core']['search']['results'] = $this->params['paging']['AliquotMaster']['count'];
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
				if(empty($sample_control_data)) { $this->redirect('/pages/err_inv_system_error', null, true); }
				$specific_menu_variables['SampleTypeForFilter'] = $sample_control_data['SampleControl']['sample_type'];

				$aliquot_control_data = $this->AliquotControl->find('first', array('conditions' => array('AliquotControl.id' => $option_for_list_all[1])));
				if(empty($aliquot_control_data)) { $this->redirect('/pages/err_inv_system_error', null, true); }
				$specific_form_alias = $aliquot_control_data['AliquotControl']['form_alias'];
				$specific_menu_variables['AliquotTypeForFilter'] = $aliquot_control_data['AliquotControl']['aliquot_type'];

				// Set filter option in session
				$_SESSION['InventoryManagement']['CollectionAliquots']['Filter'] = $filter_option;
			}
				
		} else {
			// User is working on sample aliquots list
			$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id), 'recursive' => '-1'));
			if(empty($sample_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }
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
				if(empty($aliquot_control_data)) { $this->redirect('/pages/err_inv_system_error', null, true); }
				$specific_form_alias = $aliquot_control_data['AliquotControl']['form_alias'];
				$specific_menu_variables['AliquotTypeForFilter'] = $aliquot_control_data['AliquotControl']['aliquot_type'];

				// Set filter option in session
				$_SESSION['InventoryManagement']['SampleAliquots']['Filter'] = array(
					'SampleMasterId' => $sample_master_id,
					'Option' => $filter_option);
			}
		}

		// MANAGE DATA

		$this->setDataForAliquotsList(array_merge(array('AliquotMaster.collection_id' => $collection_id), $specific_aliquot_search_criteria));
		$this->data = array();
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$form_alias = (is_null($specific_form_alias))? 'aliquotmasters': $specific_form_alias;
		$this->set('aliquots_listall_structure', $this->Structures->get('form', $form_alias));

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
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
	}
	
	
	
	
	
	
	
	
	
//TODO: change ',' to '.' for AliquotMaster.initial_volume 	AliquotDetail.used_blood_volume AliquotUse.	used_volume
	 
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
		$this->set('arr_aliquot_sops', $this->getAliquotSopList($sample_data['SampleMaster']['sample_type'], $aliquot_control_data['AliquotControl']['aliquot_type']));

		// Set list of studies
		$this->set('arr_studies', $this->getStudiesList());
		
		// Set list of sample blocks (will only works for sample type being linked to block type)
		$this->set('arr_sample_blocks', $this->getSampleBlocksList($sample_data));

		// Set list of sample gel matrices (will only works for sample type being linked to gel matrix type)
		$this->set('arr_sample_gel_matrices', $this->getSampleGelMatricesList($sample_data));
				
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Set menu
		$atim_menu_link = '/inventorymanagement/aliquot_masters/listall/%%Collection.id%%/' . ($bool_is_specimen? '%%SampleMaster.initial_specimen_sample_id%%': '%%SampleMaster.id%%');
		$this->set('atim_menu', $this->Menus->get($atim_menu_link));
		
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id, 'SampleMaster.id' => $sample_master_id, 'SampleMaster.initial_specimen_sample_id' => $sample_data['SampleMaster']['initial_specimen_sample_id']));
		
		// set structure alias based on VALUE from CONTROL table
		$this->Structures->set($aliquot_control_data['AliquotControl']['form_alias']);
			
		// MANAGE DATA RECORD
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link); 
		}

		if (empty($this->data)) {
			// Initial Display
			$this->set('default_storage_datetime', $this->getDefaultAliquotStorageDate($sample_data));
			$this->set('arr_preselected_storages', array());
						
			$this->data = array(array());
			
		} else {
// TODO used to correct a bug
pr($this->data);exit;
unset($this->data['AliquotMaster']);	
				
			// Set current volume
			foreach($this->data as $key => $data) {
				if(array_key_exists('initial_volume', $this->data[$key]['AliquotMaster'])){
					if(empty($aliquot_control_data['AliquotControl']['volume_unit'])) { $this->redirect('/pages/err_inv_system_error', null, true); }
					$this->data[$key]['AliquotMaster']['current_volume'] = $this->data[$key]['AliquotMaster']['initial_volume'];				
				}
			}
			
			// Launch validations
			//TODO test validation
			$submitted_data_validates = true;
			$errors = array();
					
			// -> Fields validation
			foreach($this->data as $key => $new_aliquot) {
				// AliquotMaster
				$this->AliquotMaster->set($this->data[$key]);
				$submitted_data_validates = ($this->AliquotMaster->validates())? $submitted_data_validates: false;
				foreach($this->AliquotMaster->invalidFields() as $field => $error) { $errors['AliquotMaster'][$field][$error] = '-'; }

				// AliquotDetail
				$this->AliquotDetail = new AliquotDetail(false, $aliquot_control_data['AliquotControl']['detail_tablename']);
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
					$errors['AliquotDetail']['barcode'][$messages] = '-';
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
		//TODO add patch to correct bug listed in issue #650
		$aliquot_data['Generated']['aliquot_use_counter'] = sizeof($aliquot_data['AliquotUse']);
				
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
				$this->data['Generated']['coll_to_stor_spent_time'] = $this->manageSpentTimeDataDisplay($this->getSpentTime($aliquot_data['Collection']['collection_datetime'], $aliquot_data['AliquotMaster']['storage_datetime']));
				$sample_master = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.id' => $aliquot_data['SampleMaster']['id'])));
				$this->data['Generated']['rec_to_stor_spent_time'] = $this->manageSpentTimeDataDisplay($this->getSpentTime($sample_master['SpecimenDetail']['reception_datetime'], $aliquot_data['AliquotMaster']['storage_datetime']));
				break;
			case 'derivative':
				$derivative_detail_data = $this->DerivativeDetail->find('first', array('conditions' => array('DerivativeDetail.sample_master_id' => $sample_master_id)));
				if(empty($derivative_detail_data)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }	
				$this->data['Generated']['creat_to_stor_spent_time'] = $this->manageSpentTimeDataDisplay($this->getSpentTime($derivative_detail_data['DerivativeDetail']['creation_datetime'], $aliquot_data['AliquotMaster']['storage_datetime']));
				break;
				
			default:
				$this->redirect('/pages/err_inv_system_error', null, true);
		}
		
		// Set storage data
		$this->set('aliquot_storage_data', empty($this->data['StorageMaster']['id'])? array(): array('StorageMaster' => $this->data['StorageMaster']));
		
		// MANAGE FORM, MENU AND ACTION BUTTONS

		// Get the current menu object.
		$atim_menu_link = ($aliquot_data['SampleMaster']['sample_category'] == 'specimen')? '/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%AliquotMaster.id%%': '/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%';
		$this->set('atim_menu', $this->Menus->get($atim_menu_link));
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id, 'SampleMaster.id' => $sample_master_id, 'SampleMaster.initial_specimen_sample_id' => $aliquot_data['SampleMaster']['initial_specimen_sample_id'], 'AliquotMaster.id' => $aliquot_master_id));
		
		// Set structure
		$this->Structures->set($aliquot_data['AliquotControl']['form_alias']);
		
		// Define if this detail form is displayed into the collection content tree view
		$this->set('is_tree_view_detail_form', $is_tree_view_detail_form);
		$this->set('is_inventory_plugin_form', $is_inventory_plugin_form);
		
		if($aliquot_data['AliquotMaster']['status'] != 'available'){
			$order_item = $this->OrderItem->find('first', array('conditions' => array('OrderItem.aliquot_master_id' => $aliquot_data['AliquotMaster']['id'])));
			$this->set('order_line_id', $order_item['OrderLine']['id']);
			$this->set('order_id', $order_item['OrderLine']['order_id']);
		}
		
		$this->set('aliquots_uses_data', $this->paginate($this->AliquotUse, array('AliquotUse.aliquot_master_id' => $aliquot_master_id)));
		$this->set('aliquots_uses_structure', $this->Structures->get('form', 'aliquotuses'));
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
		$this->set('atim_menu', $this->Menus->get($atim_menu_link));
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id, 'SampleMaster.id' => $sample_master_id, 'SampleMaster.initial_specimen_sample_id' => $aliquot_data['SampleMaster']['initial_specimen_sample_id'], 'AliquotMaster.id' => $aliquot_master_id));
		
		// Set structure
		$this->Structures->set($aliquot_data['AliquotControl']['form_alias']);
		
		// MANAGE DATA RECORD
		
		if(empty($this->data)) {
			$this->data = $aliquot_data;
			$this->set('arr_preselected_storages', empty($aliquot_data['StorageMaster']['id'])? array(): array($aliquot_data['StorageMaster']['id'] => array('StorageMaster' => $aliquot_data['StorageMaster'])));
			$hook_link = $this->hook('format');
			if($hook_link){
				require($hook_link);
			}
		} else {
			$hook_link = $this->hook('format');
			if($hook_link){
				require($hook_link); 
			}
			//Update data
			if(array_key_exists('initial_volume', $this->data['AliquotMaster']) && empty($aliquot_data['AliquotControl']['volume_unit'])) { $this->redirect('/pages/err_inv_system_error', null, true); }
									
			// Launch validations
			//TODO test validation
			$submitted_data_validates = true;
			$errors = array();
					
			// -> Fields validation
			//  --> AliquotMaster
			$this->AliquotMaster->set($this->data);
			$submitted_data_validates = ($this->AliquotMaster->validates())? $submitted_data_validates: false;
			foreach($this->AliquotMaster->invalidFields() as $field => $error) { $errors['AliquotMaster'][$field][$error] = '-'; }
			//  --> AliquotDetail
			$this->AliquotDetail = new AliquotDetail(false, $aliquot_data['AliquotControl']['detail_tablename']);
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
			
		if($arr_allow_deletion['allow_deletion']) {
			if($this->AliquotMaster->atim_delete($aliquot_master_id)) {
				//TODO There is a problem with flash function
				//but only when debug is activated
				pr('test deletion of master and detail level!');
				pr('/inventorymanagement/aliquot_masters/listAll/' . $collection_id . '/' . $sample_master_id);
				$this->flash('your data has been deleted', '/inventorymanagement/aliquot_masters/listAll/' . $collection_id . '/' . $sample_master_id);
				exit;
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
		$this->set('arr_studies', $this->getStudiesList());		
			
		// Set aliquot volume unit
		//TODO: add n/a to aliquot volume unit
		$aliquot_volume_unit = empty($aliquot_data['AliquotMaster']['aliquot_volume_unit'])? 'n/a': $aliquot_data['AliquotMaster']['aliquot_volume_unit'];
		$this->set('aliquot_volume_unit', $aliquot_volume_unit);	
		
		// Set use defintion
		$use_defintion = null;
		if(empty($aliquot_use_defintion)) { $this->redirect('/pages/err_inv_system_error', null, true); }
		switch($aliquot_use_defintion) {
			case 'internal use':
				$use_defintion = 'internal use';
				break;
			default:
				$this->redirect('/pages/err_inv_system_error', null, true);
		}
			
		$this->set('use_defintion', $use_defintion);	
				
		// MANAGE FORM, MENU AND ACTION BUTTONS

		// Get the current menu object.
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%AliquotMaster.id%%'));
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id, 'SampleMaster.id' => $sample_master_id, 'SampleMaster.initial_specimen_sample_id' => $aliquot_data['SampleMaster']['initial_specimen_sample_id'], 'AliquotMaster.id' => $aliquot_master_id));
		
		// Set structure
		$this->Structures->set('aliquotuses');
		
		// MANAGE DATA RECORD

		if(empty($this->data)) {
			$default_use_volume = empty($aliquot_data['AliquotMaster']['aliquot_volume_unit'])? 'n/a': '';
			$this->set('default_use_volume', $default_use_volume);				
			
		} else {
			$hook_link = $this->hook('format');
			if($hook_link){
				require($hook_link);
			}
			// Launch validations		
			$submitted_data_validates = true;
			
			if((!empty($this->data['AliquotUse']['used_volume'])) && empty($aliquot_data['AliquotMaster']['aliquot_volume_unit'])) {
				// No volume has to be recored for this aliquot type				
				$this->AliquotUse->validationErrors['used_volume'] = 'no volume has to be recorded for this aliquot type';	
				$submitted_data_validates = false;			
			} else if(empty($this->data['AliquotUse']['used_volume'])) {
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
					$this->flash('your data has been saved', '/inventorymanagement/aliquot_masters/detail/'.$collection_id.'/'.$aliquot_data['SampleMaster']['initial_specimen_sample_id'].'/'.$aliquot_master_id.'/');
				} 
			}
		}
	}
	
	function editAliquotUse($collection_id, $sample_master_id, $aliquot_master_id, $aliquot_use_id) {
		if((!$collection_id) || (!$sample_master_id) || (!$aliquot_master_id) || (!$aliquot_use_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }
//TODO change volume with , to .		
 		// MANAGE DATA

		// Get the use data
		$use_data = $this->AliquotUse->find('first', array('conditions' => array('AliquotMaster.collection_id' => $collection_id, 'AliquotMaster.sample_master_id' => $sample_master_id, 'AliquotMaster.id' => $aliquot_master_id, 'AliquotUse.id' => $aliquot_use_id)));
		if(empty($use_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }		
		
		// Get Sample Data
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id), 'recursive' => '-1'));
		if(empty($sample_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }	
				
		// Set list of studies
		$this->set('arr_studies', $this->getStudiesList());		
			
		// Set aliquot volume unit
		$aliquot_volume_unit = empty($use_data['AliquotMaster']['aliquot_volume_unit'])? 'n/a': $use_data['AliquotMaster']['aliquot_volume_unit'];
		//TODO test $aliquot_volume_unit
		$this->set('aliquot_volume_unit', $aliquot_volume_unit);	
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Get the current menu object.
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id, 'SampleMaster.id' => $sample_master_id, 'SampleMaster.initial_specimen_sample_id' => $sample_data['SampleMaster']['initial_specimen_sample_id'], 'AliquotMaster.id' => $aliquot_master_id, 'AliquotUse.id' => $aliquot_use_id));
		
		// Set structure
		$form_alias = in_array($use_data['AliquotUse']['use_definition'], array('internal use'))? 'aliquotuses': 'linkedaliquotuses';
		$this->Structures->set($form_alias);
		
		// MANAGE DATA RECORD
		
		if(empty($this->data)) {
			$this->data = $use_data;
			$hook_link = $this->hook('format');
			if($hook_link){
				require($hook_link);
			}
		} else {
			$hook_link = $this->hook('format');
			if($hook_link){
				require($hook_link);
			}
			// Launch validations		
			$submitted_data_validates = true;
			
			if((!empty($this->data['AliquotUse']['used_volume'])) && empty($use_data['AliquotMaster']['aliquot_volume_unit'])) {
				// No volume has to be recored for this aliquot type				
				$this->AliquotUse->validationErrors['used_volume'] = 'no volume has to be recorded for this aliquot type';	
				$submitted_data_validates = false;			
			} else if(empty($this->data['AliquotUse']['used_volume'])) {
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
//TODO redirect all delete to this function...				

 		// MANAGE DATA
		
		// Get the use data
		$use_data = $this->AliquotUse->find('first', array('conditions' => array('AliquotMaster.collection_id' => $collection_id, 'AliquotMaster.sample_master_id' => $sample_master_id, 'AliquotMaster.id' => $aliquot_master_id, 'AliquotUse.id' => $aliquot_use_id)));
		if(empty($use_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }		

		// Set url to display next page
		if($redirect == 1){
			$flash_url = '/inventorymanagement/aliquot_masters/listAllRealiquotedParents/' . $collection_id . '/' . $sample_master_id . '/' . $aliquot_master_id;
		}else if($redirect == 2){
			$flash_url = '/inventorymanagement/quality_ctrls/listAllSourceAliquots/' . $collection_id . '/' . $sample_master_id . '/';
		}else if($redirect == 3){
			$flash_url = '/inventorymanagement/quality_ctrls/detail/' . $collection_id . '/' . $sample_master_id . '/' . $extra_param . '/';
		}else{
			$flash_url = '/inventorymanagement/aliquot_masters/detail/' . $collection_id . '/' . $sample_master_id . '/' . $aliquot_master_id;
		}
		// Set Use Detail table
		$accepted_use_detail_table = array('quality_ctrl_tested_aliquots', 'source_aliquots', 'realiquotings');
		$this->AliquotUseDetail = null;
		if(!empty($use_data['AliquotUse']['use_recorded_into_table'])) {
			if(in_array($use_data['AliquotUse']['use_recorded_into_table'], $accepted_use_detail_table)) {
				$this->AliquotUseDetail = new AliquotUseDetail(false, $use_data['AliquotUse']['use_recorded_into_table']);
			} else {
				//TODO message is not display
				$this->flash('deletion of this type of use is currently not supported from use list', $flash_url);
				exit;
			}	
		}
	
		// Launch deletion	
		$deletion_done = true;
		if(!is_null($this->AliquotUseDetail)) {
			$aliquot_use_detail = $this->AliquotUseDetail->find('first', array('conditions' => array('aliquot_use_id' => $aliquot_use_id)));
			if(empty($aliquot_use_detail)) { $this->redirect('/pages/err_inv_no_data', null, true); }
			$aliquot_use_detail_id = $aliquot_use_detail['AliquotUseDetail']['id']; 
			if(!$this->AliquotUseDetail->atim_delete($aliquot_use_detail_id)) { $deletion_done = false; }
		}
		
		if($deletion_done) {
			if(!$this->AliquotUse->atim_delete($aliquot_use_id)) { $deletion_done = false; }	
		}
		if($deletion_done) {
			if(!$this->Aliquots->updateAliquotCurrentVolume($aliquot_master_id)) { $deletion_done = false; }
		}

		if($deletion_done) {
			//TODO Error in the redirection
			$this->flash('your data has been deleted', $flash_url); 
		} else {
			$this->flash('error deleting data - contact administrator', $flash_url); 
		}	
	}
	
	/* ----------------------------- SOURCE ALIQUOTS ---------------------------- */
	
	function listAllSourceAliquots($collection_id, $sample_master_id) {
		if((!$collection_id) || (!$sample_master_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }

		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id), 'recursive' => '-1'));
		if(empty($sample_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }	
		
		$this->data = $this->paginate($this->SourceAliquot, array('SourceAliquot.sample_master_id'=>$sample_master_id, 'SampleMaster.collection_id'=>$collection_id));

		$this->set('atim_menu_variables', 
			array('Collection.id' => $sample_data['SampleMaster']['collection_id'], 
			'SampleMaster.id' => $sample_master_id,
			'SampleMaster.initial_specimen_sample_id' => $sample_data['SampleMaster']['initial_specimen_sample_id']));
		
		$this->Structures->set('sourcealiquots');

		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
	}
	
	function addSourceAliquots($collection_id, $sample_master_id) {
		if((!$collection_id) || (!$sample_master_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }
		
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id), 'recursive' => '0'));
		if(empty($sample_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }	
		
		$existing_source_aliquots = $this->SourceAliquot->find('all', array('conditions' => array('SourceAliquot.sample_master_id'=>$sample_master_id), 'recursive' => '-1'));
		
		$existing_source_aliquot_ids = array();
		if(!empty($existing_source_aliquots)) {
			foreach($existing_source_aliquots as $source_aliquot) {
				//TODO to patch bug listed in issue #650
				if($source_aliquot['SourceAliquot']['deleted'] == '1') { continue; }
				$existing_source_aliquot_ids[$source_aliquot['SourceAliquot']['aliquot_master_id']] = 'source';
			}
		}
		
		$criteria = array(
			'AliquotMaster.collection_id' => $collection_id,
			'AliquotMaster.sample_master_id' => $sample_data['SampleMaster']['parent_id'],
			'AliquotMaster.status' => 'available');
		if(!empty($existing_source_aliquot_ids)) { $criteria[] = ' AliquotMaster.id NOT IN (\''.implode('\',\'', array_keys($existing_source_aliquot_ids)).'\')'; }
		$available_sample_aliquots = $this->AliquotMaster->find('all', array('conditions' => $criteria, 'order' => 'AliquotMaster.barcode ASC', 'recursive' => '-1'));
		
		if(empty($available_sample_aliquots)) {
			$this->flash('no new sample aliquot could be actually defined as source aliquot', '/inventorymanagement/aliquot_masters/listallSourceAliquots/' . $collection_id . '/' . $sample_master_id);
		}
		
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/aliquot_masters/listallSourceAliquots/%%Collection.id%%/%%SampleMaster.id%%'));	
		
		$this->set( 'atim_menu_variables', 
			array('Collection.id' => $sample_data['SampleMaster']['collection_id'], 
			'SampleMaster.id' => $sample_master_id,
			'SampleMaster.initial_specimen_sample_id' => $sample_data['SampleMaster']['initial_specimen_sample_id']) );

		$this->Structures->set('sourcealiquots');
		
		if (empty($this->data)) {
			$this->data = $available_sample_aliquots;
			$hook_link = $this->hook('format');
			if($hook_link){
				require($hook_link);
			}
		} else {
			$hook_link = $this->hook('format');
			if($hook_link){
				require($hook_link);
			}
			// Work on submitted data
			$submitted_data_validates = true;	
			$aliquots_defined_as_source = array();
			$errors = array();
			
			foreach($this->data as $key => $new_studied_aliquot){
				if($new_studied_aliquot['FunctionManagement']['use']){
					// New aliquot defined as source
					
					// Launch validation
					if(empty($new_studied_aliquot['AliquotMaster']['aliquot_volume_unit']) && (is_numeric($new_studied_aliquot['AliquotUse']['used_volume']) || (!empty($new_studied_aliquot['AliquotUse']['used_volume'])))) {
						// No volume has to be recorded
						$errors['AliquotUse']['used_volume']['no volume has to be recorded for this aliquot type'] = '-';
						$this->data[$key]['AliquotUse']['used_volume'] = '#err#';
						$submitted_data_validates = false;
					}
					
					$this->AliquotMaster->set($new_studied_aliquot);
					$submitted_data_validates = ($this->AliquotMaster->validates())? $submitted_data_validates: false;
					foreach($this->AliquotMaster->invalidFields() as $field => $error) { $errors['AliquotMaster'][$field][$error] = '-'; }					
					
					$this->AliquotUse->set($new_studied_aliquot);
					$submitted_data_validates = ($this->AliquotUse->validates())? $submitted_data_validates: false;
					foreach($this->AliquotUse->invalidFields() as $field => $error) { $errors['AliquotUse'][$field][$error] = '-'; }					
					
					// Get aliquot_master_id
					if((!isset($available_sample_aliquots[$key])) && ($available_sample_aliquots[$key]['AliquotMaster']['barcode'] !== $new_studied_aliquot['AliquotMaster']['barcode'])) { $this->redirect('/pages/err_inv_system_error', null, true); }
					$new_studied_aliquot['AliquotMaster']['id'] = $available_sample_aliquots[$key]['AliquotMaster']['id'];
					
					// Add record to array of tested aliquots
					$aliquots_defined_as_source[] = $new_studied_aliquot;		
				}
			}
			
			if(empty($aliquots_defined_as_source)) { 
				$this->AliquotUse->validationErrors[] = 'no aliquot has been defined as source aliquot.';	
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
				// Launch save functions
					
				// Parse records to save
				foreach($aliquots_defined_as_source as $new_source_aliquot) {
					$aliquot_master_id = $new_source_aliquot['AliquotMaster']['id'];

					// set aliquot master data					
					if($new_source_aliquot['FunctionManagement']['remove_from_storage']) {
						// Delete aliquot storage data
						$new_source_aliquot['AliquotMaster']['storage_master_id'] = null;
						$new_source_aliquot['AliquotMaster']['storage_coord_x'] = null;
						$new_source_aliquot['AliquotMaster']['storage_coord_y'] = null;
					}
					
					// set aliquot use data
					if(empty($new_source_aliquot['AliquotUse']['used_volume']) && (!is_numeric($new_source_aliquot['AliquotUse']['used_volume']))) { 
						$new_source_aliquot['AliquotUse']['used_volume'] = null; 
					}
			
					$new_source_aliquot['AliquotUse']['aliquot_master_id'] = $aliquot_master_id;
					
					$new_source_aliquot['AliquotUse']['use_definition'] = 'sample derivative creation';
					$new_source_aliquot['AliquotUse']['use_code'] = $sample_data['SampleMaster']['sample_code'];
					//$new_source_aliquot['AliquotUse']['use_details'] = ;
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
	
		/* ------------------------------ REALIQUOTING ------------------------------ */

	function defineRealiquotedChildren($collection_id, $sample_master_id, $aliquot_master_id) {
		if((!$collection_id) || (!$sample_master_id) || (!$aliquot_master_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }
		// MANAGE DATA
		// Get the aliquot data
		$current_aliquot_data = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.collection_id' => $collection_id, 'AliquotMaster.sample_master_id' => $sample_master_id, 'AliquotMaster.id' => $aliquot_master_id)));
		if(empty($current_aliquot_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }		

		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%AliquotMaster.id%%'));
		
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id,
												'SampleMaster.id' => $sample_master_id,
												'AliquotMaster.id' => $aliquot_master_id,
												'SampleMaster.initial_specimen_sample_id' => $current_aliquot_data['SampleMaster']['initial_specimen_sample_id']));

		
		$aliquot_data = $this->AliquotMaster->find('all', array('conditions' => "AliquotMaster.id != '".$aliquot_master_id."'"));
		//filter data
		foreach($aliquot_data as $key => $aliquot){
			$found = false;
			foreach($aliquot['RealiquotingParent'] as $aliquot_parent){
				if($aliquot_parent['parent_aliquot_master_id'] == $aliquot_master_id){
					$found = true;
					break;
				}
			}
			if(!$found){
				foreach($aliquot['RealiquotingChildren'] as $aliquot_children){
					if($aliquot_children['child_aliquot_master_id'] == $aliquot_master_id){
						$found = true;
						break;
					}
				}
			}
			if($found){
				unset($aliquot_data[$key]);		
			}
		}
		$aliquot_data = array_values($aliquot_data);
		$this->Structures->set('aliquot_children_linking', 'atim_structure_aliquot');
		$this->Structures->set('datetime_input', 'atim_datetime_input');
		$aliquot_id_by_barcode = array();
		foreach($aliquot_data as $aliquot_unit){
			$aliquot_id_by_barcode[$aliquot_unit['AliquotMaster']['barcode']] = $aliquot_unit['AliquotMaster']['id']; 
		}
		
		if(!empty($this->data)){
			$hook_link = $this->hook('format');
			if($hook_link){
				require($hook_link);
			}
			$date = $this->data['FunctionManagement']['realiquoting_date'];
			//$date = $date['year']."-".$date['month']."-".$date['day']." ".$date['hour'].":".$date['minute']." ".$date['meridian'];
			unset($this->data['FunctionManagement']);
			
			
			$submitted_data_validates = true;
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link); 
			}

			if($submitted_data_validates){
				foreach($this->data as $key => $realiquoted){
					if($realiquoted['FunctionManagement']['use'] && isset($aliquot_id_by_barcode[$realiquoted['AliquotMaster']['barcode']])){
						$aliquot_use['AliquotUse']['aliquot_master_id'] = $aliquot_master_id;
						$aliquot_use['AliquotUse']['use_definition'] = "realiquoted to";
						$aliquot_use['AliquotUse']['use_details'] = "";
						$aliquot_use['AliquotUse']['use_code'] = $realiquoted['AliquotMaster']['barcode'];//child barcode
						$aliquot_use['AliquotUse']['use_recorded_into_table'] = "realiquotings";
						$aliquot_use['AliquotUse']['used_volume'] = is_numeric($realiquoted['FunctionManagement']['input_number']) ? $realiquoted['FunctionManagement']['input_number'] : null; 
						$aliquot_use['AliquotUse']['use_datetime'] = $date;
						$aliquot_use['AliquotUse']['used_by'] = "";
						$aliquot_use['AliquotUse']['study_summary_id'] = "";
						//TODO: Volume control (ie: numeric) is not working
						$this->AliquotUse->save($aliquot_use);
						
						$realiquoting['Realiquoting']['parent_aliquot_master_id'] = $aliquot_master_id;
						$realiquoting['Realiquoting']['child_aliquot_master_id'] = $aliquot_id_by_barcode[$realiquoted['AliquotMaster']['barcode']];
						$realiquoting['Realiquoting']['aliquot_use_id'] = $this->AliquotUse->id;
						$this->Realiquoting->save($realiquoting);
						
						$this->Aliquots->updateAliquotCurrentVolume($current_aliquot_data['AliquotMaster']['id']);
						unset($this->data[$key]);
					}
				}
				$this->Flash('Data saved. ', 
							'/inventorymanagement/aliquot_masters/detail/'.$collection_id.'/'.$sample_master_id.'/'.$aliquot_master_id.'/');
			}else{
				$this->data = $aliquot_data;
				$hook_link = $this->hook('format');
				if($hook_link){
					require($hook_link);
				}
			}
		}else{
			$this->data = $aliquot_data;
			$hook_link = $this->hook('format');
			if($hook_link){
				require($hook_link);
			}
		}
	}
	
	function listAllRealiquotedParents($collection_id, $sample_master_id, $aliquot_master_id) {
		if((!$collection_id) || (!$sample_master_id) || (!$aliquot_master_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }
		// MANAGE DATA
		// Get the aliquot data
		$current_aliquot_data = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.collection_id' => $collection_id, 'AliquotMaster.sample_master_id' => $sample_master_id, 'AliquotMaster.id' => $aliquot_master_id)));
		
		if(empty($current_aliquot_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }		

		
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id,
												'SampleMaster.id' => $sample_master_id,
												'AliquotMaster.id' => $aliquot_master_id,
												'SampleMaster.initial_specimen_sample_id' => $current_aliquot_data['SampleMaster']['initial_specimen_sample_id'],
												'AliquotMasterParent.id' => 'coco'));
		
		$this->Structures->set('realiquotedparent');
		
		$this->data = $this->paginate($this->Realiquoting, "Realiquoting.child_aliquot_master_id = '".$aliquot_master_id."' AND Realiquoting.deleted != 1 ");

		foreach($this->data as &$val){
			$val['AliquotMaster'] = $val['AliquotMasterParent'];
		}
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
		
	} // listRealiquotedParent
	
	/* -------------------------------- ORDERING -------------------------------- */

	/*
		DATAMART PROCESS, addes BATCH SET aliquot IDs to ORDER ITEMs
		Multi-part process, linking Orders, OrderLines, and OrderItems (all ACTIONs the same name in each CONTROLLER)
	*/
	
	function addToOrder($aliquot_id) {
		// clear SESSION info
		$_SESSION['ctrapp_core']['datamart']['process'] = array(
			'AliquotMaster' => array(
				'id' => array(
					'0' => $aliquot_id
				)
			),
			'BatchSet' => array(
				'process' => '/order/order_lines/addAliquotToOrder/'.$aliquot_id.'/',
				'id' => 0,
				'model' => 'AliquotMaster'
			)
		);
		
		$this->redirect('/order/order_lines/addAliquotToOrder/'.$aliquot_id.'/');
		exit();
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
			if(empty($barcode)) {
				// Not studied
			} else if(isset($new_barcodes[$barcode])) {
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
		$this->set('arr_preselected_storages', $arr_preselected_storages);
				
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
}

?>
