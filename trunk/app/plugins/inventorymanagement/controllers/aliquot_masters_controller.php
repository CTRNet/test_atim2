<?php
class AliquotMastersController extends InventoryManagementAppController {
	
	var $components = array();
	
	var $uses = array(
		'Inventorymanagement.Collection',
		
		'Inventorymanagement.SampleMaster', 
		'Inventorymanagement.ViewSample',
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
		if((!$collection_id) || (!$sample_master_id)) { $this->redirect('/pages/err_inv_funct_param_missing?line='.__LINE__, null, true); }
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
				if(sizeof($option_for_list_all) != 2)  { $this->redirect('/pages/err_inv_system_error?line='.__LINE__, null, true); }
				$sample_control_id = $option_for_list_all[0];
				$aliquot_control_id = $option_for_list_all[1];

				$aliquot_search_criteria['SampleMaster.sample_control_id'] = $sample_control_id;
				$aliquot_search_criteria['AliquotMaster.aliquot_control_id'] = $aliquot_control_id;

				$sample_control_data = $this->SampleControl->find('first', array('conditions' => array('SampleControl.id' => $sample_control_id)));
				if(empty($sample_control_data)) { $this->redirect('/pages/err_inv_system_error?line='.__LINE__, null, true); }
				$sample_filter_value = $sample_control_data['SampleControl']['sample_type'];

				$aliquot_control_data = $this->AliquotControl->find('first', array('conditions' => array('AliquotControl.id' => $option_for_list_all[1])));
				if(empty($aliquot_control_data)) { $this->redirect('/pages/err_inv_system_error?line='.__LINE__, null, true); }
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
			if(empty($sample_data)) { $this->redirect('/pages/err_inv_no_data?line='.__LINE__, null, true); }
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
				if(sizeof($option_for_list_all) != 2)  { $this->redirect('/pages/err_inv_system_error?line='.__LINE__, null, true); }
				$sample_control_id = $option_for_list_all[0];
				$aliquot_control_id = $option_for_list_all[1];

				$aliquot_search_criteria['AliquotMaster.sample_master_id'] = $sample_master_id;
				$aliquot_search_criteria['AliquotMaster.aliquot_control_id'] = $aliquot_control_id;

				$aliquot_control_data = $this->AliquotControl->find('first', array('conditions' => array('AliquotControl.id' => $option_for_list_all[1])));
				if(empty($aliquot_control_data)) { $this->redirect('/pages/err_inv_system_error?line='.__LINE__, null, true); }
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
				$this->redirect('/pages/err_inv_system_error?line='.__LINE__, null, true);
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
	
	function addInit(){
		// Get Data
		$model = null;
		$key = null;
		if(isset($this->data['BatchSet'])|| isset($this->data['node'])){
			if(isset($this->data['SampleMaster'])) {
				$model = 'SampleMaster';
				$key = 'id';
			} else if(isset($this->data['ViewSample'])) {
				$model = 'ViewSample';
				$key = 'sample_master_id';
			} else {
				$this->redirect('/pages/err_inv_system_error?line='.__LINE__, null, true);
			}
		} else {
			$this->redirect('/pages/err_inv_system_error?line='.__LINE__, null, true);
		}	
		
		// Set url to redirect
		$url_to_cancel = isset($this->data['BatchSet'])?'/datamart/batch_sets/listall/all/' . $this->data['BatchSet']['id'] : '/datamart/browser/browse/' . $this->data['node']['id'];
		$this->set('url_to_cancel', $url_to_cancel);
		$_SESSION['aliq_creation_batch_process']['url_to_cancel'] = $url_to_cancel;
		
		// Manage data	
		
		$init_data = $this->batchInit(
			$this->SampleMaster, 
			$model,
			$key,
			'sample_control_id',
			$this->SampleToAliquotControl, 
			'sample_control_id',
			'you cannot create aliquots with this sample type');
		if(array_key_exists('error', $init_data)) {
			$this->flash(__($init_data['error'], true), "javascript:history.back();", 5);
			return;
		}
		if(sizeof($init_data['possibilities']) == 1) {
			// Only one available type move to next step
			$session_data = array();
			$session_data[0]['ids'] = $init_data['ids'];
			$session_data[0]['realiquot_into'] = $init_data['possibilities'][0]['AliquotControl']['id'];
			
			$hook_link = $this->hook('redirect');
			if($hook_link){
				require($hook_link);
			}
							
			$_SESSION['aliq_creation_batch_process']['init'] = $session_data;
			$this->redirect('/inventorymanagement/aliquot_masters/add/');
		}		
		
		// Manage structure and menus
		
		foreach($init_data['possibilities'] as $possibility){
			AliquotMaster::$aliquot_type_dropdown[$possibility['AliquotControl']['id']] = __($possibility['AliquotControl']['aliquot_type'], true);
		}
		
		$this->set('ids', $init_data['ids']);
		
		$this->Structures->set('aliquot_type_selection');
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/'));
		
		$hook_link = $this->hook('format');
		if($hook_link){ 
			require($hook_link);
		}
	}
	
	function add($sample_master_id=null, $aliquot_control_id=null){
			
		// CHECK PARAMETERS
		
		if(!empty($sample_master_id) && !empty($aliquot_control_id)) {
			// User just click on add aliquot button from sample detail form
			$this->data = array();
			$this->data[0]['ids'] = $sample_master_id;
			$this->data[0]['realiquot_into'] = $aliquot_control_id;
		} else if(isset($_SESSION['aliq_creation_batch_process']['init']) && (!empty($_SESSION['aliq_creation_batch_process']['init']))) {
			// addInit() function redirect to add() function because only one aliquot type can be created
			$this->data = $_SESSION['aliq_creation_batch_process']['init'];
			unset($_SESSION['aliq_creation_batch_process']['init']);
		} else if(empty($this->data)){ $this->redirect('/pages/err_inv_system_error?line='.__LINE__, null, true); }

		$is_intial_display = isset($this->data[0]['ids'])? true : false;
		$is_batch_process = empty($sample_master_id)? true : false;
		$this->set('is_batch_process',$is_batch_process);
		
		// GET ALIQUOT CONTROL DATA
		
		if($this->data[0]['realiquot_into'] == ""){
			$this->flash(__('you need to select an aliquot type', true), "javascript:history.back(1);");
			return;
		}
		
		$aliquot_control = $this->AliquotControl->findById($this->data[0]['realiquot_into']);
		if(empty($aliquot_control)) $this->redirect('/pages/err_inv_system_error?line='.__LINE__, null, true);
		
		$this->set('aliquot_control_id',$aliquot_control['AliquotControl']['id']);
		
		// GET SAMPLES DATA		
		
		$sample_master_ids = array();
		if($is_intial_display) {
			$sample_master_ids = explode(",", $this->data[0]['ids']);
			unset($this->data[0]);
		} else {
			unset($this->data[0]);
			if(!empty($this->data)) {
				$sample_master_ids = array_keys($this->data);
			} else {
				// User don't work in batch mode and deleted all aliquot rows
				if(empty($sample_master_id)) $this->redirect('/pages/err_inv_system_error?line='.__LINE__, null, true);
				$sample_master_ids = array($sample_master_id);
			}
		}
		$samples = $this->ViewSample->find('all', array('conditions' => array('sample_master_id' => $sample_master_ids), 'recursive' => -1));
		$samples_from_id = array();
		
		$is_specimen = (strcmp($samples[0]['ViewSample']['sample_category'], 'specimen') ==0)? true: false;
				
		// Sample checks
		if(sizeof($samples) != sizeof($sample_master_ids)) $this->redirect('/pages/err_inv_system_error?line='.__LINE__, null, true);
		
		$sample_control_id = null;
		foreach($samples as $sample_master_data) {
			if(is_null($sample_control_id)) {
				$sample_control_id = $sample_master_data['ViewSample']['sample_control_id'];
			} else {
				if($sample_master_data['ViewSample']['sample_control_id'] != $sample_control_id) $this->redirect('/pages/err_inv_system_error?line='.__LINE__, null, true);
			}
			
			$samples_from_id[$sample_master_data['ViewSample']['sample_master_id']] = $sample_master_data;
		}
			
		$criteria = array(
			'SampleControl.id' => $sample_control_id,
			'SampleToAliquotControl.flag_active' => '1',
			'AliquotControl.id' => $aliquot_control['AliquotControl']['id']);
		if(!$this->SampleToAliquotControl->find('count', array('conditions' => $criteria))) $this->redirect('/pages/err_inv_system_error?line='.__LINE__, null, true);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('sample_master_id',$sample_master_id);
		
		// Set menu
		$atim_menu_link = '/inventorymanagement/';
		if(!$is_batch_process) {
			$atim_menu_link = '/inventorymanagement/aliquot_masters/listall/%%Collection.id%%/' . ($is_specimen? '%%SampleMaster.initial_specimen_sample_id%%': '%%SampleMaster.id%%');
		}
		$this->set('atim_menu', $this->Menus->get($atim_menu_link));
		
		if(!$is_batch_process) {
			$this->set('atim_menu_variables', array(
				'Collection.id' => $samples[0]['ViewSample']['collection_id'], 
				'SampleMaster.id' => $sample_master_id, 
				'SampleMaster.initial_specimen_sample_id' => $samples[0]['ViewSample']['initial_specimen_sample_id']));
		}
		
		// set structure
		$this->Structures->set($aliquot_control['AliquotControl']['form_alias']);
		if($is_batch_process) {
			$this->Structures->set('view_sample_joined_to_collection', 'sample_info');
		}
		
		// set data for initial data to allow bank to override data
		$this->set('override_data', array(
				'AliquotMaster.aliquot_type' => $aliquot_control['AliquotControl']['aliquot_type'],
				'AliquotMaster.aliquot_volume_unit' => $aliquot_control['AliquotControl']['volume_unit'],
				'AliquotMaster.storage_datetime' => ($is_batch_process? date('Y-m-d G:i'): $this->getDefaultAliquotStorageDate($this->SampleMaster->find('first', array('conditions' => array('SampleMaster.id' => $sample_master_id))))),
				'AliquotMaster.in_stock' => 'yes - available'));
		
		// Set url to cancel

		$url_to_cancel = '/unknown/';
		if($is_batch_process) {
			if(!isset($_SESSION['aliq_creation_batch_process']['url_to_cancel'])) $this->redirect('/pages/err_inv_system_error?line='.__LINE__, null, true);
			$url_to_cancel = $_SESSION['aliq_creation_batch_process']['url_to_cancel'];
		} else {
			$url_to_cancel = '/inventorymanagement/sample_masters/detail/' . $sample_master_data['ViewSample']['collection_id'] . '/' . $sample_master_id;
		}
		$this->set('url_to_cancel', $url_to_cancel);
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link); 
		}
		
		if($is_intial_display){
			
			// 1- INITIAL DISPLAY
			
			$this->data = array();
			foreach($samples as $sample){
				$this->data[] = array('parent' => $sample, 'children' => array());
			}
			
		}else{
					
			// 2- VALIDATE PROCESS
			
			$errors = array();
			$prev_data = $this->data;
			$this->data = array();
			$record_counter = 0;
			foreach($prev_data as $sample_master_id => $created_aliquots){
				$record_counter++;
				
				unset($created_aliquots['ViewSample']);
				if(!isset($samples_from_id[$sample_master_id])) $this->redirect('/pages/err_inv_system_error?line='.__LINE__, null, true);
				$sample_master_data = $samples_from_id[$sample_master_id];
				
				$new_aliquot_created = false;
				$line_counter = 0;
				foreach($created_aliquots as $key => $aliquot){
					$line_counter++;
					$new_aliquot_created = true;
					
					// Set AliquotMaster.initial_volume
					if(array_key_exists('initial_volume', $aliquot['AliquotMaster'])){
						if(empty($aliquot_control['AliquotControl']['volume_unit'])){
							$this->redirect('/pages/err_inv_system_error?line='.__LINE__, null, true); 
						}
						$aliquot['AliquotMaster']['current_volume'] = $aliquot['AliquotMaster']['initial_volume'];				
					}
					
					// Validate and update position data
					$aliquot['AliquotMaster']['aliquot_control_id'] = $aliquot_control['AliquotControl']['id'];
					$this->AliquotMaster->set($aliquot);
					if(!$this->AliquotMaster->validates()){
						foreach($this->AliquotMaster->validationErrors as $field => $msg) {
							$errors[$field][$msg][] = ($is_batch_process? $record_counter : $line_counter);
						}
					}
					
					// Reset data to get position data
					$created_aliquots[$key] = $this->AliquotMaster->data;
				}
				$this->data[] = array('parent' => $sample_master_data, 'children' => $created_aliquots);//prep data in case validation fails
				if(!$new_aliquot_created) $errors[]['at least one aliquot has to be created'][] = ($is_batch_process? $record_counter : '');
			}
			
			if(empty($this->data)) {
				$errors[]['at least one aliquot has to be created'][] = '';
				$this->data[] = array('parent' => $samples[0], 'children' => array());
			}
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}				
			
			// 3- SAVE PROCESS
			
			if(empty($errors)){
				
				unset($_SESSION['aliq_creation_batch_process']);
	
				//save
				if($is_batch_process) $_SESSION['tmp_batch_set']['BatchId'] = array();
				foreach($this->data as $created_aliquots){
					foreach($created_aliquots['children'] as $new_aliquot) {	
						$this->AliquotMaster->id = null;
						$new_aliquot['AliquotMaster']['id'] = null;
						$new_aliquot['AliquotMaster']['collection_id'] = $created_aliquots['parent']['ViewSample']['collection_id'];
						$new_aliquot['AliquotMaster']['sample_master_id'] = $created_aliquots['parent']['ViewSample']['sample_master_id'];
						$new_aliquot['AliquotMaster']['aliquot_type'] = $aliquot_control['AliquotControl']['aliquot_type'];
						if(!$this->AliquotMaster->save($new_aliquot, false)){ 
							$this->redirect('/pages/err_inv_record_err', null, true); 
						} 
						$child_id = $this->AliquotMaster->getLastInsertId();
						if($is_batch_process) $_SESSION['tmp_batch_set']['BatchId'][] =$child_id;
					}
				}
				
				if($is_batch_process) {
					$datamart_structure = AppModel::atimNew("datamart", "DatamartStructure", true);
					$_SESSION['tmp_batch_set']['datamart_structure_id'] = $datamart_structure->getIdByModelName('ViewAliquot');
					$this->flash('your data has been saved', '/datamart/batch_sets/listall/0');
				} else {
					$this->flash('your data has been saved', '/inventorymanagement/sample_masters/detail/' . $samples[0]['ViewSample']['collection_id'] . '/' . $sample_master_id);
				}
				
			}else{
				$this->AliquotMaster->validationErrors = array();
				foreach($errors as $field => $msg_and_lines) {
					foreach($msg_and_lines as $msg => $lines) {
						$msg = __($msg, true);
						$lines_strg = implode(",", array_unique($lines));
						if(!empty($lines_strg)) {
							$pattern = $is_batch_process? 'see # %s' : 'see line %s';
							$msg .= ' - ' . str_replace('%s', $lines_strg, __($pattern,true));
						} 
						$this->AliquotMaster->validationErrors[$field][] = $msg;					
					} 
				}
			}
		}
	}
	
	function detail($collection_id, $sample_master_id, $aliquot_master_id, $is_tree_view_detail_form = false, $is_inventory_plugin_form = true) {
		if((!$collection_id) || (!$sample_master_id) || (!$aliquot_master_id)){
			$this->redirect('/pages/err_inv_funct_param_missing?line='.__LINE__, null, true); 
		}		
		if($is_tree_view_detail_form){
			Configure::write('debug', 0);
		}
		// MANAGE DATA
	
		// Get the aliquot data
		$aliquot_data = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.collection_id' => $collection_id, 'AliquotMaster.sample_master_id' => $sample_master_id, 'AliquotMaster.id' => $aliquot_master_id)));
		if(empty($aliquot_data)) { 
			$this->redirect('/pages/err_inv_no_data?line='.__LINE__, null, true); 
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
				if(empty($derivative_detail_data)) { $this->redirect('/pages/err_inv_funct_param_missing?line='.__LINE__, null, true); }	
				$aliquot_data['Generated']['creat_to_stor_spent_time_msg'] = $this->manageSpentTimeDataDisplay($this->getSpentTime($derivative_detail_data['DerivativeDetail']['creation_datetime'], $aliquot_data['AliquotMaster']['storage_datetime']));
				break;
				
			default:
				$this->redirect('/pages/err_inv_system_error?line='.__LINE__, null, true);
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
		$this->set('storage_data', $storage_data);
				
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
	}
	
	function edit($collection_id, $sample_master_id, $aliquot_master_id) {
		if((!$collection_id) || (!$sample_master_id) || (!$aliquot_master_id)) { 
			$this->redirect('/pages/err_inv_funct_param_missing?line='.__LINE__, null, true); 
		}		
		
		// MANAGE DATA

		// Get the aliquot data
				
		$aliquot_data = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.collection_id' => $collection_id, 'AliquotMaster.sample_master_id' => $sample_master_id, 'AliquotMaster.id' => $aliquot_master_id)));
		if(empty($aliquot_data)){ 
			$this->redirect('/pages/err_inv_no_data?line='.__LINE__, null, true); 
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
				$this->redirect('/pages/err_inv_system_error?line='.__LINE__, null, true); 
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
		if((!$collection_id) || (!$sample_master_id) || (!$aliquot_master_id)) { $this->redirect('/pages/err_inv_funct_param_missing?line='.__LINE__, null, true); }		
		
		// MANAGE DATA

		// Get the aliquot data
		$aliquot_data = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.collection_id' => $collection_id, 'AliquotMaster.sample_master_id' => $sample_master_id, 'AliquotMaster.id' => $aliquot_master_id)));
		if(empty($aliquot_data)) { $this->redirect('/pages/err_inv_no_data?line='.__LINE__, null, true); }		
		
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
		if((!$collection_id) || (!$sample_master_id) || (!$aliquot_master_id)) { $this->redirect('/pages/err_inv_funct_param_missing?line='.__LINE__, null, true); }		
	
		// Get the aliquot data
		$aliquot_data = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.collection_id' => $collection_id, 'AliquotMaster.sample_master_id' => $sample_master_id, 'AliquotMaster.id' => $aliquot_master_id)));
		if(empty($aliquot_data)) { $this->redirect('/pages/err_inv_no_data?line='.__LINE__, null, true); }		
		
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
		if((!$collection_id) || (!$sample_master_id) || (!$aliquot_master_id)) { $this->redirect('/pages/err_inv_funct_param_missing?line='.__LINE__, null, true); }
		
		// MANAGE DATA

		// Get the aliquot data
		$aliquot_data = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.collection_id' => $collection_id, 'AliquotMaster.sample_master_id' => $sample_master_id, 'AliquotMaster.id' => $aliquot_master_id)));
		if(empty($aliquot_data)) { $this->redirect('/pages/err_inv_no_data?line='.__LINE__, null, true); }		

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
		if((!$aliquot_master_id) || (!$aliquot_use_id)) { $this->redirect('/pages/err_inv_funct_param_missing?line='.__LINE__, null, true); }
			
 		// MANAGE DATA

		// Get the use data
		$use_data = $this->AliquotInternalUse->find('first', array('conditions' => array('AliquotInternalUse.aliquot_master_id' => $aliquot_master_id, 'AliquotInternalUse.id' => $aliquot_use_id)));
		if(empty($use_data)) { $this->redirect('/pages/err_inv_no_data?line='.__LINE__, null, true); }		
		$this->data = $use_data;		
		
		// Get Sample Data
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $use_data['AliquotMaster']['collection_id'], 'SampleMaster.id' => $use_data['AliquotMaster']['sample_master_id']), 'recursive' => '-1'));
		if(empty($sample_data)) { $this->redirect('/pages/err_inv_no_data?line='.__LINE__, null, true); }	
		
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
		if((!$aliquot_master_id) || (!$aliquot_use_id)) { $this->redirect('/pages/err_inv_funct_param_missing?line='.__LINE__, null, true); }
			
 		// MANAGE DATA

		// Get the use data
		$use_data = $this->AliquotInternalUse->find('first', array('conditions' => array('AliquotInternalUse.aliquot_master_id' => $aliquot_master_id, 'AliquotInternalUse.id' => $aliquot_use_id)));
		if(empty($use_data)) { $this->redirect('/pages/err_inv_no_data?line='.__LINE__, null, true); }	
		
		// Get Sample Data
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $use_data['AliquotMaster']['collection_id'], 'SampleMaster.id' => $use_data['AliquotMaster']['sample_master_id']), 'recursive' => '-1'));
		if(empty($sample_data)) { $this->redirect('/pages/err_inv_no_data?line='.__LINE__, null, true); }	
		
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
		if((!$aliquot_master_id) || (!$aliquot_use_id)) { $this->redirect('/pages/err_inv_funct_param_missing?line='.__LINE__, null, true); }	
		
 		// MANAGE DATA
		
		// Get the use data
		$use_data = $this->AliquotInternalUse->find('first', array('conditions' => array('AliquotInternalUse.aliquot_master_id' => $aliquot_master_id, 'AliquotInternalUse.id' => $aliquot_use_id)));
		if(empty($use_data)) { $this->redirect('/pages/err_inv_no_data?line='.__LINE__, null, true); }	
		
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
		if((!$collection_id) || (!$sample_master_id)) { $this->redirect('/pages/err_inv_funct_param_missing?line='.__LINE__, null, true); }
		
		// MANAGE DATA

		// Get Sample data
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id), 'recursive' => '0'));
		if(empty($sample_data)) { $this->redirect('/pages/err_inv_no_data?line='.__LINE__, null, true); }	
		
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
		if((!$collection_id) || (!$sample_master_id)) { $this->redirect('/pages/err_inv_funct_param_missing?line='.__LINE__, null, true); }

		// MANAGE DATA

		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id), 'recursive' => '-1'));
		if(empty($sample_data)) { $this->redirect('/pages/err_inv_no_data?line='.__LINE__, null, true); }	
		
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
		if((!$sample_master_id) || (!$aliquot_master_id) || (!$source)) { $this->redirect('/pages/err_inv_funct_param_missing?line='.__LINE__, null, true); }	

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

	function realiquotInit($aliquot_id = null){	
					
		// Get ids of the studied aliquots
		if(!empty($aliquot_id)){
			$ids = array($aliquot_id);
		}else if(isset($this->data['BatchSet'])|| isset($this->data['node'])){
			if(isset($this->data['AliquotMaster'])) {
				$ids = $this->data['AliquotMaster']['id'];
			} else if(isset($this->data['ViewAliquot'])) {
				$ids = $this->data['ViewAliquot']['aliquot_master_id'];
			} else {
				$this->redirect('/pages/err_inv_system_error?line='.__LINE__, null, true);
			}
			$ids = array_filter($ids);	
		} else {
			$this->redirect('/pages/err_inv_system_error?line='.__LINE__, null, true);
		}		
		
		// Find parent aliquot
		$ids[] = 0;
		$aliquots = $this->AliquotMaster->findAllById($ids);
		if(empty($aliquots)){
			$this->redirect('/pages/err_inv_system_error?line='.__LINE__, null, true);
		}
		$this->set('aliquot_id', $aliquot_id);
		
		// Set url to redirect
		$url_to_cancel = null;
		if(!empty($aliquot_id)){		
			$url_to_cancel = '/inventorymanagement/aliquot_masters/detail/' . $aliquots[0]['AliquotMaster']['collection_id'] . '/' . $aliquots[0]['AliquotMaster']['sample_master_id'] . '/' . $aliquots[0]['AliquotMaster']['id'] . '/';				
		}else if(isset($this->data['BatchSet'])|| isset($this->data['node'])){
			$url_to_cancel = isset($this->data['BatchSet'])?'/datamart/batch_sets/listall/all/' . $this->data['BatchSet']['id'] : '/datamart/browser/browse/' . $this->data['node']['id'];
		}
		$this->set('url_to_cancel', $url_to_cancel);
		$_SESSION['realiquot_batch_process']['url_to_cancel'] = $url_to_cancel;
		
		// Check aliquot & sample types of the selected aliquots are identical
		$aliquot_ctrl_id = $aliquots[0]['AliquotMaster']['aliquot_control_id'];
		$sample_ctrl_id = $aliquots[0]['SampleMaster']['sample_control_id'];
		if(count($aliquots) > 1){
			foreach($aliquots as $aliquot){
				if(($aliquot['AliquotMaster']['aliquot_control_id'] != $aliquot_ctrl_id) || ($aliquot['SampleMaster']['sample_control_id'] != $sample_ctrl_id)) {
					$this->flash(__("you cannot realiquot those elements together because they are of different types", true), $url_to_cancel);
					return;
				}
			}
		}
		$this->set('realiquot_from', $aliquot_ctrl_id);
		
		// Build list of aliquot type that could be created from the sources
		$possible_ctrl_ids = $this->RealiquotingControl->getAllowedChildrenCtrlId($sample_ctrl_id, $aliquot_ctrl_id);

		if(empty($possible_ctrl_ids)){
			$this->flash(__("you cannot realiquot those elements", true), "javascript:history.back();", 5);
			return;
		
		} else if(sizeof($possible_ctrl_ids) == 1) {
			// Only one available type move to next step
			$session_data = array();
			$session_data[0]['realiquot_into'] = $possible_ctrl_ids[0];
			$session_data[0]['ids'] = implode(",", $ids);
			$session_data['realiquot_from'] = $aliquot_ctrl_id;
			
			$hook_link = $this->hook('redirect');
			if($hook_link){
				require($hook_link);
			}
					
			$_SESSION['realiquot_batch_process']['init'] = $session_data;
			$this->redirect('/inventorymanagement/aliquot_masters/realiquot/'.$aliquot_id);
		}
		
		// Manage display for children type selection
		$aliquot_ctrls = $this->AliquotControl->findAllById($possible_ctrl_ids);
		assert(!empty($aliquot_ctrls));
		foreach($aliquot_ctrls as $aliquot_ctrl){
			$dropdown[$aliquot_ctrl['AliquotControl']['id']] = __($aliquot_ctrl['AliquotControl']['aliquot_type'], true);
		}
		
		// Set data & structure
		$this->data[0]['ids'] = implode(",", $ids);
		AliquotMaster::$aliquot_type_dropdown = $dropdown;
//TODO derivative_lab_book
		$this->Structures->set('aliquot_type_selection,derivative_lab_book');
		
		if(empty($aliquot_id)) {
			$this->set('atim_menu', $this->Menus->get('/inventorymanagement/'));
		} else {
			$atim_menu_link = ($aliquots[0]['SampleMaster']['sample_category'] == 'specimen')? 
				'/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%AliquotMaster.id%%': 
				'/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%';
			$this->set('atim_menu', $this->Menus->get($atim_menu_link));
			$this->set('atim_menu_variables', array(
				'Collection.id' => $aliquots[0]['AliquotMaster']['collection_id'], 
				'SampleMaster.id' => $aliquots[0]['AliquotMaster']['sample_master_id'], 
				'SampleMaster.initial_specimen_sample_id' => $aliquots[0]['SampleMaster']['initial_specimen_sample_id'], 
				'AliquotMaster.id' => $aliquot_id));
		}
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
	}	
	
	function realiquot($aliquot_id = null){
		if(isset($_SESSION['realiquot_batch_process']['init']) && (!empty($_SESSION['realiquot_batch_process']['init']))) {
			// Check init redirect
			$this->data = $_SESSION['realiquot_batch_process']['init'];
			unset($_SESSION['realiquot_batch_process']['init']);
		} else if(empty($this->data)){ $this->redirect("/pages/err_inv_no_data", null, true); }
		
		// Get parent an child control data
		$parent_aliquot_ctrl_id = isset($this->data['realiquot_from'])? $this->data['realiquot_from']: null;
		$child_aliquot_ctrl_id = isset($this->data[0]['realiquot_into'])? $this->data[0]['realiquot_into'] : (isset($this->data['realiquot_into'])? $this->data['realiquot_into'] : null);		
		$parent_aliquot_ctrl = $this->AliquotControl->findById($parent_aliquot_ctrl_id);
		$child_aliquot_ctrl = ($parent_aliquot_ctrl_id == $child_aliquot_ctrl_id)? $parent_aliquot_ctrl : $this->AliquotControl->findById($child_aliquot_ctrl_id);		
		if(empty($parent_aliquot_ctrl) || empty($child_aliquot_ctrl)) { $this->redirect('/pages/err_inv_system_error?line='.__LINE__, null, true); }
		
		// Structure and menu data
		$this->set('aliquot_id', $aliquot_id);
		if(empty($aliquot_id)) {
			$this->set('atim_menu', $this->Menus->get('/inventorymanagement/'));
		} else {
			$parent = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.id' => $aliquot_id), 'recursive' => '0'));
			if(empty($parent)){
				$this->redirect('/pages/err_inv_system_error?line='.__LINE__, null, true);
			}
			$atim_menu_link = ($parent['SampleMaster']['sample_category'] == 'specimen')? 
				'/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%AliquotMaster.id%%': 
				'/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%';
			$this->set('atim_menu', $this->Menus->get($atim_menu_link));
			$this->set('atim_menu_variables', array(
				'Collection.id' => $parent['AliquotMaster']['collection_id'], 
				'SampleMaster.id' => $parent['AliquotMaster']['sample_master_id'], 
				'SampleMaster.initial_specimen_sample_id' => $parent['SampleMaster']['initial_specimen_sample_id'], 
				'AliquotMaster.id' => $aliquot_id));
		}
				
		$this->set('aliquot_type', $child_aliquot_ctrl['AliquotControl']['aliquot_type']);
		$this->set('realiquot_from', $parent_aliquot_ctrl_id);
		$this->set('realiquot_into', $child_aliquot_ctrl_id);
			
		$this->Structures->set('in_stock_detail', 'in_stock_detail');
		$this->Structures->set($child_aliquot_ctrl['AliquotControl']['form_alias'].(empty($parent_aliquot_ctrl['AliquotControl']['volume_unit'])? ',realiquot_without_vol': ',realiquot_with_vol'));
		
		$this->set('lab_book_id', $this->data['DerivativeDetail']['lab_book_id']);
		$this->set('sync_with_lab_book', $this->data['DerivativeDetail']['sync_with_lab_book']);

		if(!isset($_SESSION['realiquot_batch_process']['url_to_cancel'])) $this->redirect('/pages/err_inv_system_error?line='.__LINE__, null, true);
		$this->set('url_to_cancel', $_SESSION['realiquot_batch_process']['url_to_cancel']);

		// set data for initial data to allow bank to override data
		$this->set('created_aliquot_override_data', array(
			'AliquotMaster.aliquot_type' => $child_aliquot_ctrl['AliquotControl']['aliquot_type'],
			'AliquotMaster.aliquot_volume_unit' => $child_aliquot_ctrl['AliquotControl']['volume_unit'],
			'AliquotMaster.storage_datetime' => date('Y-m-d G:i'),
			'AliquotMaster.in_stock' => 'yes - available',
	
			'Realiquoting.realiquoting_datetime' => date('Y-m-d G:i'),
		
			'GeneratedParentAliquot.aliquot_volume_unit' => $parent_aliquot_ctrl['AliquotControl']['volume_unit']));
		
		if(isset($this->data[0]) && isset($this->data[0]['ids']) && isset($this->data[0]['realiquot_into'])){
			
			//1- INITIAL DISPLAY
			
			$parent_aliquots = $this->AliquotMaster->findAllById(explode(",", $this->data[0]['ids']));
			if(empty($parent_aliquots)) { $this->redirect('/pages/err_inv_system_error?line='.__LINE__, null, true); }
			
			//build data array
			$this->data = array();
			foreach($parent_aliquots as $parent_aliquot){
				if($parent_aliquot_ctrl_id != $parent_aliquot['AliquotMaster']['aliquot_control_id']) { $this->redirect('/pages/err_inv_system_error?line='.__LINE__, null, true); }
				$this->data[] = array('parent' => $parent_aliquot, 'children' => array());
			}
						
			$hook_link = $this->hook('format');
			if($hook_link){
				require($hook_link);
			}	
			
		}else{
			
			// 2- VALIDATE PROCESS

			unset($this->data['realiquot_into']);
			unset($this->data['realiquot_from']);
			
			$errors = array();
			$validated_data = array();
			$record_counter = 0;
			
			foreach($this->data as $parent_id => $parent_and_children) {
				$record_counter++;
				
				//A- Validate parent aliquot data
				
				$this->AliquotMaster->id = null;
				//---------------------------------------------------------
				// Set data to empty array to guaranty 
				// no merge will be done with previous AliquotMaster data
				// when AliquotMaster set() function will be called again.
				//---------------------------------------------------------
				$this->AliquotMaster->data = array();
				
				$parent_aliquot_data = $parent_and_children['AliquotMaster'];
				$parent_aliquot_data['id'] = $parent_id;
				$parent_aliquot_data['aliquot_control_id'] = $parent_aliquot_ctrl_id;
				
				$this->AliquotMaster->set(array("AliquotMaster" => $parent_aliquot_data));
				if(!$this->AliquotMaster->validates()){
					foreach($this->AliquotMaster->validationErrors as $field => $msg) {
						$errors[$field][$msg][] = $record_counter;
					}
				}
				
				// Set parent data to $validated_data
				$validated_data[$parent_id]['parent']['AliquotMaster'] = $parent_aliquot_data;
				$validated_data[$parent_id]['parent']['FunctionManagement'] = $parent_and_children['FunctionManagement'];
				$validated_data[$parent_id]['children'] = array();
				
				//B- Validate new aliquot created + realiquoting data
				
				$new_aliquot_created = false;
				
				foreach($parent_and_children as $tmp_id => $child) {
					
					if(is_numeric($tmp_id)) {
						$new_aliquot_created = true;
						
						// ** Aliquot **
							
						// Set AliquotMaster.initial_volume
						if(array_key_exists('initial_volume', $child['AliquotMaster'])){
							if(empty($child_aliquot_ctrl['AliquotControl']['volume_unit'])){
								$this->redirect('/pages/err_inv_system_error?line='.__LINE__, null, true); 
							}
							$child['AliquotMaster']['current_volume'] = $child['AliquotMaster']['initial_volume'];				
						}
						
						// Validate and update position data
						$this->AliquotMaster->id = null;
						//---------------------------------------------------------
						// Set data to empty array to guaranty 
						// no merge will be done with previous AliquotMaster data
						// when AliquotMaster set() function will be called again.
						//---------------------------------------------------------
						$this->AliquotMaster->data = array();
						
						$child['AliquotMaster']['id'] = null;
						$child['AliquotMaster']['aliquot_control_id'] = $child_aliquot_ctrl_id;
						$child['AliquotMaster']['aliquot_type'] = $child_aliquot_ctrl['AliquotControl']['aliquot_type'];
						$child['AliquotMaster']['sample_master_id'] = $validated_data[$parent_id]['parent']['AliquotMaster']['sample_master_id'];
						$child['AliquotMaster']['collection_id'] = $validated_data[$parent_id]['parent']['AliquotMaster']['collection_id'];
						
						$this->AliquotMaster->set($child);
						if(!$this->AliquotMaster->validates()){
							foreach($this->AliquotMaster->validationErrors as $field => $msg) {
								$errors[$field][$msg][] = $record_counter;
							}
						}
						
						// Reset data to get position data
						$child = $this->AliquotMaster->data;						

						// ** Realiquoting **					
												
						$this->Realiquoting->set(array('Realiquoting' =>  $child['Realiquoting']));
						if(!$this->Realiquoting->validates()){
							foreach($this->Realiquoting->validationErrors as $field => $msg) {
								$errors[$field][$msg][] = $record_counter;
							}
						}
						
						// Check volume can be completed
						if((!empty($child['Realiquoting']['parent_used_volume'])) && empty($child['GeneratedParentAliquot']['aliquot_volume_unit'])) {
							// No volume has to be recored for this aliquot type				
							$errors['parent_used_volume']['no volume has to be recorded when the volume unit field is empty'][] = $record_counter;
						}
						
						// Set child data to $validated_data
						$validated_data[$parent_id]['children'][$tmp_id] = $child;
					}
				}
				
				if(!$new_aliquot_created) $errors[]['at least one child has to be created'][] = $record_counter;
			}
			
			$this->data = $validated_data;
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}				
			
			// 3- SAVE PROCESS
			
			if(empty($errors)) { 

				$_SESSION['tmp_batch_set']['BatchId'] = array();	// Set session data to display batchset
				
				foreach($this->data as $parent_id => $parent_and_children){
					
					// A- Save parent aliquot data
					
					//---------------------------------------------------------
					// Set data to empty array to guaranty 
					// no merge will be done with previous AliquotMaster data
					// when AliquotMaster set() function will be called again.
					//---------------------------------------------------------
					$this->AliquotMaster->data = array();
					$this->AliquotMaster->id = $parent_id;
					
					$parent_data = $parent_and_children['parent'];
					if($parent_data['FunctionManagement']['remove_from_storage'] || ($parent_data['AliquotMaster']['in_stock'] == 'no')) {
						// Delete storage data
						$parent_data['AliquotMaster']['storage_master_id'] = null;
						$parent_data['AliquotMaster']['storage_coord_x'] = null;
						$parent_data['AliquotMaster']['storage_coord_y'] = null;
					}
					$parent_data['AliquotMaster']['id'] = $parent_id;
					
					if(!$this->AliquotMaster->save(array('AliquotMaster' => $parent_data['AliquotMaster']), false)){
						$this->redirect('/pages/err_inv_system_error?line='.__LINE__, null, true);
					}
					
					foreach($parent_and_children['children'] as $children) {
						
						$realiquoting_data = array('Realiquoting' => $children['Realiquoting']);
						unset($children['Realiquoting']);
						unset($children['FunctionManagement']);
						unset($children['GeneratedParentAliquot']);
						
						// B- Save children aliquot data	
						
						$this->AliquotMaster->id = null;
						//---------------------------------------------------------
						// Set data to empty array to guaranty 
						// no merge will be done with previous AliquotMaster data
						// when AliquotMaster set() function will be called again.
						//---------------------------------------------------------
						$this->AliquotMaster->data = array();
						if(!$this->AliquotMaster->save($children, false)){ 
							$this->redirect('/pages/err_inv_system_error?line='.__LINE__, null, true); 
						} 						
						$child_id = $this->AliquotMaster->getLastInsertId();
						if(empty($aliquot_id)) $_SESSION['tmp_batch_set']['BatchId'][] = $child_id;
							
						// C- Save realiquoting data	
						
		  				$realiquoting_data['Realiquoting']['parent_aliquot_master_id'] = $parent_id;
		 				$realiquoting_data['Realiquoting']['child_aliquot_master_id'] = $child_id;	
						$this->Realiquoting->id = NULL;
		  				if(!$this->Realiquoting->save($realiquoting_data, false)){
							$this->redirect('/pages/err_inv_system_error?line='.__LINE__, null, true);
						}
					}
					
					// D- Update parent aliquot current volume
					$this->AliquotMaster->updateAliquotUseAndVolume($parent_id, true, (empty($parent_aliquot_ctrl['AliquotControl']['volume_unit'])? false : true), false);
				}
				
				unset($_SESSION['realiquot_batch_process']);
				if(empty($aliquot_id)) {
					$datamart_structure = AppModel::atimNew("datamart", "DatamartStructure", true);
					$_SESSION['tmp_batch_set']['datamart_structure_id'] = $datamart_structure->getIdByModelName('ViewAliquot');
					$this->flash(__('your data has been saved',true).'<br>'.__('aliquot storage data were deleted (if required)',true), '/datamart/batch_sets/listall/0');
				} else {
					$this->flash(__('your data has been saved',true).'<br>'.__('aliquot storage data were deleted (if required)',true), '/inventorymanagement/aliquot_masters/detail/' . $parent['AliquotMaster']['collection_id'] . '/' . $parent['AliquotMaster']['sample_master_id']. '/' . $aliquot_id);
				}
					
			} else {
				$this->AliquotMaster->validationErrors = array();
				$this->Realiquoting->validationErrors = array();
				foreach($errors as $field => $msg_and_lines) {
					foreach($msg_and_lines as $msg => $lines) {
						$this->AliquotMaster->validationErrors[$field][] = __($msg, true) .(empty($aliquot_id)? ' - ' . str_replace('%s', implode(",", $lines), __('see # %s',true)) : '');					
					} 
				}
			}
		}
	}
	
	function defineRealiquotedChildren($collection_id = null, $sample_master_id = null, $aliquot_master_id = null){
		$initial_display = false;		// Boolean to define if data for intial display should be built
		$parent_aliquots = array();		// Parent aliquots list
		
		//set the structure early to ensure validation works
		$this->Structures->set('children_aliquots_selection', 'atim_structure_for_children_aliquots_selection');
		$this->Structures->set('in_stock_detail', 'in_stock_detail');
		
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/'));
		
		$url_to_cancel = isset($_SESSION['define_realiquoted_aliquot']['url_to_cancel'])? $_SESSION['define_realiquoted_aliquot']['url_to_cancel'] : '/menus';
		
		if(isset($this->data['BatchSet']) || isset($this->data['node'])) {
						
			// BATCH EDIT : Action has been launched from datamart to realiquot in batch
			// Build list of parent aliquots
			
			// Build redirect url
			$url_to_cancel = isset($this->data['BatchSet'])?'/datamart/batch_sets/listall/all/' . $this->data['BatchSet']['id'] : '/datamart/browser/browse/' . $this->data['node']['id'];
		
			$studied_aliquot_master_ids = array();
			if(isset($this->data['AliquotMaster'])) {
				$studied_aliquot_master_ids = $this->data['AliquotMaster']['id'];
			} else if(isset($this->data['ViewAliquot'])) {
				$studied_aliquot_master_ids = $this->data['ViewAliquot']['aliquot_master_id'];
			} else {
				$this->redirect('/pages/err_inv_system_error?line='.__LINE__, null, true); 
			}
			$studied_aliquot_master_ids = array_filter($studied_aliquot_master_ids);
						
			$parent_aliquots = $this->AliquotMaster->find('all', array('conditions' => array('AliquotMaster.id' => $studied_aliquot_master_ids)));
			if(empty($parent_aliquots)){
				$this->redirect('/pages/err_inv_system_error?line='.__LINE__, null, true);
			}
			
			$initial_display = true;
		
		}else if($collection_id && $sample_master_id && $aliquot_master_id){
			if(empty($this->data)) $initial_display = true;
			
			// SINGLE EDIT : Action has been launched from aliquot detail form to define aliquot realiquoting data
			// Build list of parent aliquots
			
			//Get the parent aliquot data
			$tmp = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.collection_id' => $collection_id, 'AliquotMaster.sample_master_id' => $sample_master_id, 'AliquotMaster.id' => $aliquot_master_id)));
			if(empty($tmp)){
				$this->redirect('/pages/err_inv_no_data?line='.__LINE__, null, true); 
			}
			$parent_aliquots[] = $tmp;
		
			// Get the current menu object.
			$this->set('atim_menu_variables', array('Collection.id' => $collection_id, 'SampleMaster.id' => $sample_master_id, 'SampleMaster.initial_specimen_sample_id' => $parent_aliquots[0]['SampleMaster']['initial_specimen_sample_id'], 'AliquotMaster.id' => $aliquot_master_id));
			// Get the current menu object.
			$atim_menu_link = ($parent_aliquots[0]['SampleMaster']['sample_category'] == 'specimen')? 
				'/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%AliquotMaster.id%%': 
				'/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%';
			$this->set('atim_menu', $this->Menus->get($atim_menu_link));
			
			$url_to_cancel = '/inventorymanagement/aliquot_masters/detail/'.$collection_id.'/'.$sample_master_id.'/'.$aliquot_master_id;
		
		}
		
		// Set url to cancel
		$_SESSION['define_realiquoted_aliquot']['url_to_cancel'] = $url_to_cancel;
		$this->set('url_to_cancel', $url_to_cancel);
			
		if($initial_display){
			
			// BUILD DATA FOR INTIAL DISPLAY
			
			$this->data = array();
			$excluded_parent_aliquot = array();
			
			foreach($parent_aliquots as $parent_aliquot_data){
				
				// Get aliquot already defined as children
				$existing_children = array();
				
				foreach($parent_aliquot_data['RealiquotingChildren'] as $realiquoting_data) {
					$existing_children[] = $realiquoting_data['child_aliquot_master_id'];
				}
				
				// Get aliquots being parent of the studied parent
				$existing_parents_tmp = $this->Realiquoting->find('all', array('conditions' => array('Realiquoting.child_aliquot_master_id' => $parent_aliquot_data['AliquotMaster']['id']), 'recursive' => '-1'));
				$existing_parents = array();
				foreach($existing_parents_tmp as $realiquoting_data) {
					$existing_parents[] = $realiquoting_data['Realiquoting']['parent_aliquot_master_id'];
				}	
								
				//Get aliquot type that could be defined as children of the parent aliquot type
				$allowed_children_aliquot_control_ids = $this->RealiquotingControl->getAllowedChildrenCtrlId($parent_aliquot_data['SampleMaster']['sample_control_id'], $parent_aliquot_data['AliquotMaster']['aliquot_control_id']);
				
				// Search Sample Aliquots could be defined as children aliquot
				$criteria = array(
					"AliquotMaster.id != '".$parent_aliquot_data['AliquotMaster']['id']."'", 
					'AliquotMaster.sample_master_id' => $parent_aliquot_data['AliquotMaster']['sample_master_id'],
					'AliquotMaster.aliquot_control_id' => $allowed_children_aliquot_control_ids,
					'NOT' => array('AliquotMaster.id' => $existing_children),
					'NOT' => array('AliquotMaster.id' => $existing_parents));
				
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
				$tmp_barcode = array();
				foreach($excluded_parent_aliquot as $new_aliquot) {
					$tmp_barcode[] = $new_aliquot['AliquotMaster']['barcode'];
				}
				$this->AliquotMaster->validationErrors[] = __('no new aliquot could be actually defined as realiquoted child for the following parent aliquot(s)',true).': ['.implode(",", $tmp_barcode).']';
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
			$record_counter = 0;
			foreach($this->data as $parent_id => &$children){
				$record_counter++;
				
				// Validate parent aliquot data
				$parent_aliquot_data = $children['AliquotMaster'];
				$parent_aliquot_data["id"] = $parent_id;
				$this->AliquotMaster->set(array("AliquotMaster" => $parent_aliquot_data));
				if(!$this->AliquotMaster->validates()){
					foreach($this->AliquotMaster->validationErrors as $field => $msg) {
						$errors[$field][$msg][] = $record_counter;
					}
				}
				unset($children['AliquotMaster']);
				unset($children['FunctionManagement']);
			}
			
			//2- Validate realiquoting data
			if(empty($errors)){
			$relations = array();
				$record_counter = 0;
				foreach($this->data as $parent_aliquot_id => $children_aliquots){
					$record_counter++;
					$children_has_been_defined = false;
					foreach($children_aliquots as $children_aliquot){
						if(!$children_aliquot['FunctionManagement']['use']){
							continue;
						}
						$children_has_been_defined = true;
						
						if(isset($relations[$children_aliquot['AliquotMaster']['id']])){
							$errors[][sprintf(__("circular assignation with [%s]", true), $children_aliquot['AliquotMaster']['barcode'])][] = $record_counter;
						}
						$relations[$parent_aliquot_id] = $children_aliquot['AliquotMaster']['id'];
						
						$this->Realiquoting->set(array('Realiquoting' =>  $children_aliquot['Realiquoting']));
						if(!$this->Realiquoting->validates()){
							foreach($this->Realiquoting->validationErrors as $field => $msg) {
								$errors[$field][$msg][] = $record_counter;
							}
						}
						
						// Check volume can be completed
						if((!empty($children_aliquot['Realiquoting']['parent_used_volume'])) && empty($children_aliquot['GeneratedParentAliquot']['aliquot_volume_unit'])) {
							// No volume has to be recored for this aliquot type	
							$errors['parent_used_volume']['no volume has to be recorded when the volume unit field is empty'][] = $record_counter;					
						} 
					}
					
					if(!$children_has_been_defined) $errors[]['at least one child has not been defined'][] = $record_counter;
				}				
			}
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}
			
			if(!empty($errors)){
				// Errors have been detected => rebuild form data
								
				$this->AliquotMaster->validationErrors = array();
				foreach($errors as $field => $msg_and_lines) {
					foreach($msg_and_lines as $msg => $lines) {
						$msg = __($msg, true);
						$lines_strg = implode(",", array_unique($lines));
						if(!empty($lines_strg) && ($collection_id == null)) {
							$msg .= ' - ' . str_replace('%s', $lines_strg, __('see # %s',true));
						} 
						$this->AliquotMaster->validationErrors[$field][] = $msg;					
					} 
				}			
				
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
					if(!$this->AliquotMaster->save(array('AliquotMaster' => $children['AliquotMaster']), false)){
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
				
				$datamart_structure = AppModel::atimNew("datamart", "DatamartStructure", true);
				$_SESSION['tmp_batch_set']['datamart_structure_id'] = $datamart_structure->getIdByModelName('ViewAliquot');
								
				//redirect to virtual batch set
				//$_SESSION data was set into the define children function
				if($collection_id == null){
					$this->flash(__('your data has been saved',true).'<br>'.__('aliquot storage data were deleted (if required)',true), '/datamart/batch_sets/listall/0');
				}else{
					$this->flash(__('your data has been saved',true).'<br>'.__('aliquot storage data were deleted (if required)',true), '/inventorymanagement/aliquot_masters/detail/'.$collection_id.'/'.$sample_master_id.'/'.$aliquot_master_id);
				}
			}
			
		}else{ 
			$this->redirect('/pages/err_inv_funct_param_missing?line='.__LINE__, null, true); 
		}
	}
	
	function listAllRealiquotedParents($collection_id, $sample_master_id, $aliquot_master_id) {
		if((!$collection_id) || (!$sample_master_id) || (!$aliquot_master_id)) { $this->redirect('/pages/err_inv_funct_param_missing?line='.__LINE__, null, true); }

		// MANAGE DATA
		
		// Get the aliquot data
		$current_aliquot_data = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.collection_id' => $collection_id, 'AliquotMaster.sample_master_id' => $sample_master_id, 'AliquotMaster.id' => $aliquot_master_id)));
		if(empty($current_aliquot_data)) { $this->redirect('/pages/err_inv_no_data?line='.__LINE__, null, true); }		
		
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
		if((!$parent_id) || (!$child_id) || (!$source)) { $this->redirect('/pages/err_inv_funct_param_missing?line='.__LINE__, null, true); }	

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
				if(empty($collection_data)) { $this->redirect('/pages/err_inv_no_data?line='.__LINE__, null, true); }
				$sample_master = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.id' => $sample_master_data['SampleMaster']['id'])));
				return $sample_master['SpecimenDetail']['reception_datetime'];
				
			case 'derivative':
				// Default creation date will be the derivative creation date or Specimen reception date
				$derivative_detail_data = $this->DerivativeDetail->find('first', array('conditions' => array('DerivativeDetail.sample_master_id' => $sample_master_data['SampleMaster']['id']), 'recursive' => '-1'));
				if(empty($derivative_detail_data)) { $this->redirect('/pages/err_inv_funct_param_missing?line='.__LINE__, null, true); }
				
				return $derivative_detail_data['DerivativeDetail']['creation_datetime'];
				
			default:
				$this->redirect('/pages/err_inv_system_error?line='.__LINE__, null, true);			
		}
		
		return null;
	}
	
	function validateAliquotStorageData(&$aliquots_data) {
		pr('deprecated');
		$this->redirect('/pages/err_inv_system_error?line='.__LINE__, null, true);
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
	
	function contentTreeView($collection_id, $aliquot_master_id, $is_ajax = false){
		if(!$collection_id) { 
			$this->redirect('/pages/err_inv_funct_param_missing?line='.__LINE__, null, true); 
		}
		if($is_ajax){
			$this->layout = 'ajax';
			Configure::write('debug', 0);
		}
		$atim_structure['AliquotMaster'] = $this->Structures->get('form','aliquot_masters_for_collection_tree_view');
		$this->set('atim_structure', $atim_structure);
		$this->set("collection_id", $collection_id);
		$this->set("is_ajax", $is_ajax);
		$ids = $this->Realiquoting->find('list', array('fields' => array('Realiquoting.child_aliquot_master_id'), 'conditions' => array('Realiquoting.parent_aliquot_master_id' => $aliquot_master_id)));
		$this->data = $this->AliquotMaster->find('all', array('conditions' => array('AliquotMaster.id' => $ids, 'AliquotMaster.collection_id' => $collection_id)));		
	}
}

?>
