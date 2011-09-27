<?php
class AliquotMastersController extends InventoryManagementAppController {
	
	var $components = array();
	
	var $uses = array(
		'Inventorymanagement.Collection',
		
		'Inventorymanagement.SampleMaster', 
		'Inventorymanagement.ViewSample',
		'Inventorymanagement.DerivativeDetail',
		
		'Inventorymanagement.SampleControl',
		
		'Inventorymanagement.AliquotControl', 
		'Inventorymanagement.AliquotMaster',
		'Inventorymanagement.AliquotMastersRev', 
		'Inventorymanagement.ViewAliquot',
		'Inventorymanagement.AliquotDetail',			
		
		'Inventorymanagement.RealiquotingControl',
		
		'Inventorymanagement.ViewAliquotUse',
		'Inventorymanagement.AliquotInternalUse',
		'Inventorymanagement.Realiquoting',
		'Inventorymanagement.SourceAliquot',
		'Inventorymanagement.AliquotReviewMaster',
		'Order.OrderItem',
	
		'Storagelayout.StorageMaster',
		'Storagelayout.StorageCoordinate',
		
		'Datamart.BatchId',
	
		'ExternalLink'
	);
	
	var $paginate = array(
		'AliquotMaster' => array('limit' => pagination_amount , 'order' => 'AliquotMaster.barcode DESC'), 
		'ViewAliquot' => array('limit' => pagination_amount , 'order' => 'ViewAliquot.barcode DESC')/*, 
		'ViewAliquotUse' => array('limit' => pagination_amount, 'order' => 'ViewAliquotUse.use_datetime DESC')*/);

	/* --------------------------------------------------------------------------
	 * DISPLAY FUNCTIONS
	 * -------------------------------------------------------------------------- */

	/* ----------------------------- ALIQUOT MASTER ----------------------------- */
	
	function search($search_id = 0) {
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/collections/search'));
		
		if(empty($search_id)){
			$this->unsetInventorySessionData();
		}
		
		$this->searchHandler($search_id, $this->ViewAliquot, 'view_aliquot_joined_to_sample_and_collection', '/inventorymanagement/aliquot_masters/search');

		$help_url = $this->ExternalLink->find('first', array('conditions' => array('name' => 'inventory_elements_defintions')));
		$this->set("help_url", $help_url['ExternalLink']['link']);
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link); 
		}
		
		if(empty($search_id)){
			//index
			$this->render('index');
		}
	}
	
	function listAll($collection_id, $sample_master_id, $filter_option = null) {
		if((!$collection_id) || (!$sample_master_id)) { $this->redirect('/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); }
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
				if(sizeof($option_for_list_all) != 2)  { $this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); }
				$sample_control_id = $option_for_list_all[0];
				$aliquot_control_id = $option_for_list_all[1];

				$aliquot_search_criteria['SampleMaster.sample_control_id'] = $sample_control_id;
				$aliquot_search_criteria['AliquotMaster.aliquot_control_id'] = $aliquot_control_id;

				$sample_control_data = $this->SampleControl->find('first', array('conditions' => array('SampleControl.id' => $sample_control_id)));
				if(empty($sample_control_data)) { $this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); }
				$sample_filter_value = $sample_control_data['SampleControl']['sample_type'];

				$aliquot_control_data = $this->AliquotControl->find('first', array('conditions' => array('AliquotControl.id' => $option_for_list_all[1])));
				if(empty($aliquot_control_data)) { $this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); }
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
			if(empty($sample_data)) { $this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); }
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
				if(sizeof($option_for_list_all) != 2)  { $this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); }
				$sample_control_id = $option_for_list_all[0];
				$aliquot_control_id = $option_for_list_all[1];

				$aliquot_search_criteria['AliquotMaster.sample_master_id'] = $sample_master_id;
				$aliquot_search_criteria['AliquotMaster.aliquot_control_id'] = $aliquot_control_id;

				$aliquot_control_data = $this->AliquotControl->find('first', array('conditions' => array('AliquotControl.id' => $option_for_list_all[1])));
				if(empty($aliquot_control_data)) { $this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); }
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
				$aliquots_data = $this->paginate($this->AliquotMaster, array_merge(array('AliquotMaster.collection_id' => $collection_id), $aliquot_search_criteria));
				break;
				
			default:
				$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}

		$this->set('model_to_use', $model_to_use);
		$this->set('aliquots_data', $aliquots_data);
		$this->data = array();
				
		// MANAGE FORM, MENU AND ACTION BUTTONS
				
		$this->Structures->set($form_alias, 'aliquots_listall_structure');
		
		// Get all collection/sample 'sample aliquot type list' to build the filter button
		$sample_aliquot_types = array();
		$criteria = array('AliquotMaster.collection_id' => $collection_id);
		if(!$is_collection_aliquot_list) { 
			$criteria['AliquotMaster.sample_master_id'] = $sample_master_id; 
		}
		$tmp_sample_aliquot_type_list = $this->AliquotMaster->find('all', array('fields' => 'DISTINCT SampleControl.sample_type, SampleMaster.sample_control_id, AliquotMaster.aliquot_type, AliquotMaster.aliquot_control_id', 'conditions' => $criteria, 'order' => 'SampleControl.sample_type ASC, AliquotMaster.aliquot_type ASC', 'recursive' => '0'));
		foreach($tmp_sample_aliquot_type_list as $new_sample_aliquot_type) {
			// Should create key because looks like it's not a real distinct: Perhaps exists a better solution
			$sample_control_id = $new_sample_aliquot_type['SampleMaster']['sample_control_id'];
			$aliquot_control_id = $new_sample_aliquot_type['AliquotMaster']['aliquot_control_id'];
			$sample_aliquot_types[$sample_control_id . '|' . $aliquot_control_id] = array(
				'sample_type' => $new_sample_aliquot_type['SampleControl']['sample_type'],
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
				$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}
		} else {
			$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}	
		
		// Set url to redirect
		$url_to_cancel = isset($this->data['BatchSet'])?'/datamart/batch_sets/listall/' . $this->data['BatchSet']['id'] : '/datamart/browser/browse/' . $this->data['node']['id'];
		$this->set('url_to_cancel', $url_to_cancel);
		
		// Manage data	
		
		$init_data = $this->batchInit(
			$this->SampleMaster, 
			$model,
			$key,
			'sample_control_id',
			$this->AliquotControl, 
			'sample_control_id',
			'you cannot create aliquots with this sample type');
		if(array_key_exists('error', $init_data)) {
			$this->flash(__($init_data['error'], true), "javascript:history.back();", 5);
			return;
		}		
		
		// Manage structure and menus
		
		foreach($init_data['possibilities'] as $possibility){
			AliquotMaster::$aliquot_type_dropdown[$possibility['AliquotControl']['id']] = __($possibility['AliquotControl']['aliquot_type'], true);
		}
		
		$this->set('ids', $init_data['ids']);
		
		$this->Structures->set('aliquot_type_selection');
		$this->setBatchMenu(array('SampleMaster' => $init_data['ids']));
		
		$hook_link = $this->hook('format');
		if($hook_link){ 
			require($hook_link);
		}
	}
	
	function add($sample_master_id = null, $aliquot_control_id = null, $quantity = 1){
		if($this->RequestHandler->isAjax()){
			$this->layout = 'ajax';
			ob_start();
		}
					
		// CHECK PARAMETERS
			
		if(!empty($sample_master_id) && !empty($aliquot_control_id)) {
			// User just click on add aliquot button from sample detail form
			$this->data = array();
			$this->data[0]['ids'] = $sample_master_id;
			$this->data[0]['realiquot_into'] = $aliquot_control_id;
		} else if(empty($this->data)){ 
			$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
		}

		$is_intial_display = isset($this->data[0]['ids'])? true : false;
		$is_batch_process = empty($sample_master_id)? true : false;
		$this->set('is_batch_process',$is_batch_process);
		
		// GET ALIQUOT CONTROL DATA
		
		if($this->data[0]['realiquot_into'] == ""){
			$this->flash(__('you need to select an aliquot type', true), "javascript:history.back(1);");
			return;
		}
		
		$aliquot_control = $this->AliquotControl->findById($this->data[0]['realiquot_into']);
		if(empty($aliquot_control)) $this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		
		$this->set('aliquot_control_id',$aliquot_control['AliquotControl']['id']);
		
		// GET URL TO CANCEL
		
		$url_to_cancel = null;
		if(isset($this->data['url_to_cancel'])) {
			$url_to_cancel =  $this->data['url_to_cancel'];
			unset($this->data['url_to_cancel']);	
		}
		
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
				if(empty($sample_master_id)){
					$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				}
				$sample_master_ids = array($sample_master_id);
			}
		}
		$samples = $this->ViewSample->find('all', array('conditions' => array('sample_master_id' => $sample_master_ids), 'recursive' => -1));
		$samples_from_id = array();
		
		$is_specimen = (strcmp($samples[0]['ViewSample']['sample_category'], 'specimen') ==0)? true: false;
				
		// Sample checks
		if(sizeof($samples) != sizeof($sample_master_ids)) {
			$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		
		$sample_control_id = null;
		foreach($samples as $sample_master_data) {
			if(is_null($sample_control_id)) {
				$sample_control_id = $sample_master_data['ViewSample']['sample_control_id'];
			} else {
				if($sample_master_data['ViewSample']['sample_control_id'] != $sample_control_id) $this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}
			
			$samples_from_id[$sample_master_data['ViewSample']['sample_master_id']] = $sample_master_data;
		}
			
		$criteria = array(
			'AliquotControl.sample_control_id' => $sample_control_id,
			'AliquotControl.flag_active' => '1',
			'AliquotControl.id' => $aliquot_control['AliquotControl']['id']);
		if(!$this->AliquotControl->find('count', array('conditions' => $criteria))){
			$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('sample_master_id',$sample_master_id);
		
		// Set menu
		$atim_menu_link = '/inventorymanagement/';
		if($is_batch_process) {
			$this->setBatchMenu(array('SampleMaster' => $sample_master_ids));
		}else{
			$atim_menu_link = '/inventorymanagement/sample_masters/detail/%%Collection.id%%/' . ($is_specimen? '%%SampleMaster.initial_specimen_sample_id%%': '%%SampleMaster.id%%');
			$this->set('atim_menu', $this->Menus->get($atim_menu_link));
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
		$override_data = array(
			'AliquotControl.aliquot_type' => $aliquot_control['AliquotControl']['aliquot_type'],
			'AliquotMaster.storage_datetime' => ($is_batch_process? date('Y-m-d G:i'): $this->AliquotMaster->getDefaultStorageDate($this->SampleMaster->find('first', array('conditions' => array('SampleMaster.id' => $sample_master_id))))),
			'AliquotMaster.in_stock' => 'yes - available'
		);
		if(!empty($aliquot_control['AliquotControl']['volume_unit'])){
			$override_data['AliquotControl.volume_unit'] = $aliquot_control['AliquotControl']['volume_unit'];
		}
		$this->set('override_data', $override_data);
		
		// Set url to cancel
		if(!empty($aliquot_control_id)) {
			// User just click on add aliquot button from sample detail form
			$url_to_cancel = '/inventorymanagement/sample_masters/detail/' . $samples[0]['ViewSample']['collection_id'] . '/' . $sample_master_id;
		}		
		if(empty($url_to_cancel)){
			$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
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
				$this->data[] = array('parent' => $sample, 'children' => array_fill(0, $quantity, array()));
			}
			
			$hook_link = $this->hook('initial_display');
			if($hook_link){
				require($hook_link);
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
				if(!isset($samples_from_id[$sample_master_id])) $this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				$sample_master_data = $samples_from_id[$sample_master_id];
				
				$new_aliquot_created = false;
				$line_counter = 0;
				foreach($created_aliquots as $key => $aliquot){
					$line_counter++;
					$new_aliquot_created = true;
					
					// Set AliquotMaster.initial_volume
					if(array_key_exists('initial_volume', $aliquot['AliquotMaster'])){
						if(empty($aliquot_control['AliquotControl']['volume_unit'])){
							$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
						}
						$aliquot['AliquotMaster']['current_volume'] = $aliquot['AliquotMaster']['initial_volume'];				
					}
					
					// Validate and update position data
					$aliquot['AliquotMaster']['aliquot_control_id'] = $aliquot_control['AliquotControl']['id'];
					
					$this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
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
				
				//save
				if($is_batch_process) $_SESSION['tmp_batch_set']['BatchId'] = array();
				foreach($this->data as $created_aliquots){
					foreach($created_aliquots['children'] as $new_aliquot) {	
						$this->AliquotMaster->id = null;
						$this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
						$new_aliquot['AliquotMaster']['id'] = null;
						$new_aliquot['AliquotMaster']['collection_id'] = $created_aliquots['parent']['ViewSample']['collection_id'];
						$new_aliquot['AliquotMaster']['sample_master_id'] = $created_aliquots['parent']['ViewSample']['sample_master_id'];
						$new_aliquot['AliquotMaster']['aliquot_type'] = $aliquot_control['AliquotControl']['aliquot_type'];
						if(!$this->AliquotMaster->save($new_aliquot, false)){ 
							$this->redirect('/pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true); 
						} 
						$child_id = $this->AliquotMaster->getLastInsertId();
						if($is_batch_process) $_SESSION['tmp_batch_set']['BatchId'][] =$child_id;
					}
				}
				
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) { 
					require($hook_link); 
				}
					
				if($is_batch_process) {
					$datamart_structure = AppModel::getInstance("datamart", "DatamartStructure", true);
					$_SESSION['tmp_batch_set']['datamart_structure_id'] = $datamart_structure->getIdByModelName('ViewAliquot');
					$this->atimFlash('your data has been saved', '/datamart/batch_sets/listall/0');
				} else {
					if($this->RequestHandler->isAjax()){
						ob_end_clean();
						echo json_encode(array('goToNext' => true, 'display' => '', 'id' => -1));
						exit;
					}else{
						$this->atimFlash('your data has been saved', '/inventorymanagement/sample_masters/detail/' . $samples[0]['ViewSample']['collection_id'] . '/' . $sample_master_id);
					}
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
		$this->set('is_ajax', $this->RequestHandler->isAjax());
	}
	
	function detail($collection_id, $sample_master_id, $aliquot_master_id, $is_from_tree_view_or_layout = 0) {
		// $is_from_tree_view_or_layout : 0-Normal, 1-Tree view, 2-Stoarge layout
		
		if((!$collection_id) || (!$sample_master_id) || (!$aliquot_master_id)){
			$this->redirect('/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); 
		}		
		if($is_from_tree_view_or_layout){
			Configure::write('debug', 0);
		}
		// MANAGE DATA
	
		// Get the aliquot data
		$aliquot_data = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.collection_id' => $collection_id, 'AliquotMaster.sample_master_id' => $sample_master_id, 'AliquotMaster.id' => $aliquot_master_id)));
		if(empty($aliquot_data)) { 
			$this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		}		
		
		// Set times spent since either sample collection/reception or sample creation and sample storage		
		switch($aliquot_data['SampleControl']['sample_category']) {
			case 'specimen':
				$aliquot_data['Generated']['coll_to_stor_spent_time_msg'] = AppModel::manageSpentTimeDataDisplay(AppModel::getSpentTime($aliquot_data['Collection']['collection_datetime'], $aliquot_data['AliquotMaster']['storage_datetime']));
				$sample_master = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.id' => $aliquot_data['SampleMaster']['id'])));
				$aliquot_data['Generated']['rec_to_stor_spent_time_msg'] = AppModel::manageSpentTimeDataDisplay(AppModel::getSpentTime($sample_master['SpecimenDetail']['reception_datetime'], $aliquot_data['AliquotMaster']['storage_datetime']));
				break;
			case 'derivative':
				$aliquot_data['Generated']['coll_to_stor_spent_time_msg'] = AppModel::manageSpentTimeDataDisplay(AppModel::getSpentTime($aliquot_data['Collection']['collection_datetime'], $aliquot_data['AliquotMaster']['storage_datetime']));
				$derivative_detail_data = $this->DerivativeDetail->find('first', array('conditions' => array('DerivativeDetail.sample_master_id' => $sample_master_id)));
				if(empty($derivative_detail_data)) { $this->redirect('/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); }	
				$aliquot_data['Generated']['creat_to_stor_spent_time_msg'] = AppModel::manageSpentTimeDataDisplay(AppModel::getSpentTime($derivative_detail_data['DerivativeDetail']['creation_datetime'], $aliquot_data['AliquotMaster']['storage_datetime']));
				break;
				
			default:
				$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		
		// Set aliquot data
		$this->set('aliquot_master_data', $aliquot_data);
		$this->data = array();
		
		// Set storage data
		$this->set('aliquot_storage_data', empty($aliquot_data['StorageMaster']['id'])? array(): array('StorageMaster' => $aliquot_data['StorageMaster']));
		
		// Set aliquot uses
		if(!$is_from_tree_view_or_layout) {		
			$this->set('aliquots_uses_data', $this->ViewAliquotUse->findFastFromAliquotMasterId($aliquot_master_id));
		}

		//storage history
		$storage_data = $this->AliquotMaster->getStorageHistory($aliquot_master_id);
		$this->set('storage_data', $storage_data);
				
		// MANAGE FORM, MENU AND ACTION BUTTONS

		// Get the current menu object.
		$atim_menu_link = ($aliquot_data['SampleControl']['sample_category'] == 'specimen')? 
			'/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%AliquotMaster.id%%': 
			'/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%';
		$this->set('atim_menu', $this->Menus->get($atim_menu_link));
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id, 'SampleMaster.id' => $sample_master_id, 'SampleMaster.initial_specimen_sample_id' => $aliquot_data['SampleMaster']['initial_specimen_sample_id'], 'AliquotMaster.id' => $aliquot_master_id));
		
		// Set structure
		$this->Structures->set($aliquot_data['AliquotControl']['form_alias']);
		if(!$is_from_tree_view_or_layout) {
			$this->Structures->set('viewaliquotuses', 'aliquots_uses_structure');
			$this->Structures->set('custom_aliquot_storage_history', 'custom_aliquot_storage_history');
		}
		
		// Define if this detail form is displayed into the collection content tree view, storage tree view, storage layout
		$this->set('is_from_tree_view_or_layout', $is_from_tree_view_or_layout);
		
		// Define if aliquot is included into an order
		$order_item = $this->OrderItem->find('first', array('conditions' => array('OrderItem.aliquot_master_id' => $aliquot_master_id)));
		if(!empty($order_item)){
			$this->set('order_line_id', $order_item['OrderLine']['id']);
			$this->set('order_id', $order_item['OrderLine']['order_id']);
		}
		
		$sample_master = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.id' => $sample_master_id), 'recursive' => -1));
		$ptdsc_model = AppModel::getInstance('inventorymanagement', 'ParentToDerivativeSampleControl', true);
		$ptdsc = $ptdsc_model->find('first', array('conditions' => array('ParentToDerivativeSampleControl.parent_sample_control_id' => $sample_master['SampleMaster']['sample_control_id']), 'recursive' => -1));
		$this->set('can_create_derivative', !empty($ptdsc));
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
	}
	
	function edit($collection_id, $sample_master_id, $aliquot_master_id) {
		if((!$collection_id) || (!$sample_master_id) || (!$aliquot_master_id)) { 
			$this->redirect('/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); 
		}		
		
		// MANAGE DATA

		// Get the aliquot data
				
		$aliquot_data = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.collection_id' => $collection_id, 'AliquotMaster.sample_master_id' => $sample_master_id, 'AliquotMaster.id' => $aliquot_master_id)));
		if(empty($aliquot_data)){ 
			$this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		}		
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Get the current menu object.
		$this->setAliquotMenu($aliquot_data);
		
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
			
			$hook_link = $this->hook('initial_display');
			if($hook_link){
				require($hook_link);
			}
			
		}else{
			//Update data
			if(array_key_exists('initial_volume', $this->data['AliquotMaster']) && empty($aliquot_data['AliquotControl']['volume_unit'])) { 
				$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
			}

			// Launch validations
			
			$submitted_data_validates = true;
					
			// -> Fields validation
			//  --> AliquotMaster
			$this->data['AliquotMaster']['id'] = $aliquot_master_id;
			$this->data['AliquotMaster']['aliquot_control_id'] = $aliquot_data['AliquotMaster']['aliquot_control_id'];
			
			$this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
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
				$this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
				$this->AliquotMaster->id = $aliquot_master_id;
				if(!$this->AliquotMaster->save($this->data, false)) { 
					$this->redirect('/pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true); 
				}
				if(!$this->AliquotMaster->updateAliquotUseAndVolume($aliquot_master_id, true, false)) { 
					$this->redirect('/pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true); 
				}
				
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) { 
					require($hook_link); 
				}	
				
				$this->atimFlash('your data has been updated', '/inventorymanagement/aliquot_masters/detail/' . $collection_id . '/' . $sample_master_id. '/' . $aliquot_master_id);				
				return;
			}
		}
	}
	
	function removeAliquotFromStorage($collection_id, $sample_master_id, $aliquot_master_id) {
		if((!$collection_id) || (!$sample_master_id) || (!$aliquot_master_id)) { $this->redirect('/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); }		
		
		// MANAGE DATA

		// Get the aliquot data
		$aliquot_data = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.collection_id' => $collection_id, 'AliquotMaster.sample_master_id' => $sample_master_id, 'AliquotMaster.id' => $aliquot_master_id)));
		if(empty($aliquot_data)) { $this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); }		
		
		// Delete storage data
		$this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
		$this->AliquotMaster->id = $aliquot_master_id;
		$aliquot_data_to_save = 
			array('AliquotMaster' => array(
				'storage_master_id' => null,
				'storage_coord_x' => null,
				'storage_coord_y' => null));
		if(!$this->AliquotMaster->save($aliquot_data_to_save, false)) {
			$this->redirect('/pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		
		$this->atimFlash('your data has been updated', '/inventorymanagement/aliquot_masters/detail/' . $collection_id . '/' . $sample_master_id. '/' . $aliquot_master_id);				
	}
	
	function delete($collection_id, $sample_master_id, $aliquot_master_id) {
		if((!$collection_id) || (!$sample_master_id) || (!$aliquot_master_id)) { $this->redirect('/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); }		
	
		// Get the aliquot data
		$aliquot_data = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.collection_id' => $collection_id, 'AliquotMaster.sample_master_id' => $sample_master_id, 'AliquotMaster.id' => $aliquot_master_id)));
		if(empty($aliquot_data)) { $this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); }		
		
		// Check deletion is allowed
		$arr_allow_deletion = $this->AliquotMaster->allowDeletion($aliquot_master_id);
			
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }		
		
		if($arr_allow_deletion['allow_deletion']) {
			if($this->AliquotMaster->atim_delete($aliquot_master_id)) {
				
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) { require($hook_link); }
				
				$this->atimFlash('your data has been deleted', '/inventorymanagement/aliquot_masters/listAll/' . $collection_id . '/' . $sample_master_id);
			} else {
				$this->flash('error deleting data - contact administrator', '/inventorymanagement/aliquot_masters/listAll/' . $collection_id . '/' . $sample_master_id);
			}
		} else {
			$this->flash($arr_allow_deletion['msg'], '/inventorymanagement/aliquot_masters/detail/' . $collection_id . '/' . $sample_master_id . '/' . $aliquot_master_id);
		}		
	}
	
	/* ------------------------------ ALIQUOT INTERNAL USES ------------------------------ */

	function addAliquotInternalUse($aliquot_master_id = null) {
		if($aliquot_master_id != null){
			$this->data['ViewAliquot']['aliquot_master_id'][] = $aliquot_master_id;
		}
		
		$aliquot_ids = array();
		if(isset($this->data['ViewAliquot']['aliquot_master_id'])){
			$aliquot_ids = array_filter($this->data['ViewAliquot']['aliquot_master_id']);
			$aliquot_data = $this->AliquotMaster->find('all', array(
				'conditions' => array('AliquotMaster.id' => $aliquot_ids),
			));
		}else{
			$aliquot_ids = array_keys($this->data);
		}
		
		$this->Structures->set('sourcealiquots', "aliquots_structure");
		$this->Structures->set('sourcealiquots,sourcealiquots_volume', 'aliquots_volume_structure');
		$this->Structures->set('aliquotinternaluses', 'aliquotinternaluses_structure');
		$this->Structures->set('aliquotinternaluses_volume,aliquotinternaluses', 'aliquotinternaluses_volume_structure');

		$atim_menu_link = null;
		if(count($aliquot_ids) == 1){
			$aliquot_data = $this->AliquotMaster->find('first', array(
				'conditions' => array('AliquotMaster.id' => $aliquot_ids)
			));
			$atim_menu_link = ($aliquot_data['SampleControl']['sample_category'] == 'specimen')? 
				'/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%AliquotMaster.id%%': 
				'/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%';
			$this->set('atim_menu_variables', array(
				'Collection.id' => $aliquot_data['AliquotMaster']['collection_id'], 
				'SampleMaster.id' => $aliquot_data['AliquotMaster']['sample_master_id'], 
				'SampleMaster.initial_specimen_sample_id' => $aliquot_data['SampleMaster']['initial_specimen_sample_id'], 
				'AliquotMaster.id' => $aliquot_data['AliquotMaster']['id'])
			);
			$this->set('cancel_button', '/inventorymanagement/aliquot_masters/detail/'.$aliquot_data['AliquotMaster']['collection_id'].'/'.$aliquot_data['AliquotMaster']['sample_master_id'].'/'.$aliquot_data['AliquotMaster']['id'].'/');
		}else{
			$atim_menu_link = '/inventorymanagement/';
			$this->set('cancel_button', '/menus/');
			$unconsented_aliquots = $this->AliquotMaster->getUnconsentedAliquots(array('id' => $aliquot_ids));
			if(!empty($unconsented_aliquots)){
				AppController::addWarningMsg(__('aliquot(s) without a proper consent', true).": ".count($unconsented_aliquots));
			} 
		}
		$this->set('atim_menu', $this->Menus->get($atim_menu_link));

		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
		
		if(isset($this->data['ViewAliquot'])){
			// Force $this->data to empty array() to override AliquotMaster.aliquot_volume_unit 
			$previous_data = $this->data;
			$this->data = array();
			
			$aliquot_data = $this->AliquotMaster->find('all', array(
				'conditions' => array('AliquotMaster.id' => $aliquot_ids),
				'recursive' => 0
			));
			
			foreach($aliquot_data as $aliquot_data_unit){
				$this->data[] = array('parent' => $aliquot_data_unit, 'children' => array());
			}
			
		} else {
			$previous_data = $this->data;
			$this->data = array();
			
			//validate
			$errors = array();
			$aliquot_data_to_save = array();
			$uses_to_save = array();
			$line = 0;
			
			foreach($previous_data as $aliquot_master_id => $data_unit){
				$data_unit['AliquotMaster']['id'] = $aliquot_master_id;
				$aliquot_data['AliquotMaster'] = $data_unit['AliquotMaster'];
				$this->AliquotMaster->data = null;
				unset($aliquot_data['AliquotMaster']['storage_coord_x']);
				unset($aliquot_data['AliquotMaster']['storage_coord_y']);
				$this->AliquotMaster->set($aliquot_data);
				if(!$this->AliquotMaster->validates()){
					$error_msg = array_merge($error_msg, $this->AliquotMaster->validationError);
				}
				
				$aliquot_data_to_save_tmp = array(
					'id'				=> $aliquot_master_id,
					'aliquot_control_id'=> $aliquot_data['AliquotControl']['id'],
					'in_stock'			=> $data_unit['AliquotMaster']['in_stock'],
					'in_stock_detail'	=> $data_unit['AliquotMaster']['in_stock_detail']
				);
				if($data_unit['FunctionManagement']['remove_from_storage']){
					$aliquot_data_to_save_tmp += array(
						'storage_master_id' => null,
						'storage_coord_x' => null,
						'storage_coord_y' => null
					);
				}
				$aliquot_data_to_save[] = $aliquot_data_to_save_tmp;
				
				$parent = array(
					'AliquotMaster' => $data_unit['AliquotMaster'],
					'StorageMaster'	=> $data_unit['StorageMaster'],
					'FunctionManagement' => $data_unit['FunctionManagement'],
					'AliquotControl' => isset($data_unit['AliquotControl']) ? $data_unit['AliquotControl'] : array() 
				);
				
				unset($data_unit['AliquotMaster']);
				unset($data_unit['FunctionManagement']);
				unset($data_unit['AliquotControl']);
				
				if(empty($data_unit)){
					$errors[''] = __('you must define at least one use for each aliquot', true);
				}
				foreach($data_unit as &$use_data_unit){
					++$line;
					$use_data_unit['AliquotInternalUse']['aliquot_master_id'] = $aliquot_master_id;
					$this->AliquotInternalUse->data = null;
					$this->AliquotInternalUse->set($use_data_unit);
					if(!$this->AliquotInternalUse->validates()){
						$errors = array_merge($errors, $this->AliquotInternalUse->validationErrors);
					}
				}
				unset($data_unit['StorageMaster']);
				$uses_to_save = array_merge($uses_to_save, $data_unit);
				$this->data[] = array('parent' => $parent, 'children' => $data_unit);
			}
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}
			
			if(empty($errors)){
				//saving
				$this->AliquotInternalUse->saveAll($uses_to_save, array('validate' => false));
				
				if(!empty($aliquot_data_to_save)){
					$this->AliquotMaster->saveAll($aliquot_data_to_save, array('validate' => false));
				}
				
				foreach($uses_to_save as $use){
					$this->AliquotMaster->updateAliquotUseAndVolume($use['AliquotInternalUse']['aliquot_master_id'], true, true, false);
				}
				
				$hook_link = $this->hook('post_process');
				if($hook_link){
					require($hook_link);
				}
				
				if(count($uses_to_save) == 1){
					$this->atimFlash('your data has been saved', '/inventorymanagement/aliquot_masters/detailAliquotInternalUse/' . $uses_to_save[0]['AliquotInternalUse']['aliquot_master_id'] . '/' . $this->AliquotInternalUse->getLastInsertId() . '/');
				}else if(count($aliquot_data_to_save) == 1){
					$aliquot_data = $this->AliquotMaster->find('first', array(
						'conditions' => array('AliquotMaster.id' => $aliquot_data_to_save[0]['id']),
						'recursive' => -1
					));
					$this->atimFlash('your data has been saved', '/inventorymanagement/aliquot_masters/detail/' . $aliquot_data['AliquotMaster']['collection_id'] . '/' . $aliquot_data['AliquotMaster']['sample_master_id'].'/'.$aliquot_data['AliquotMaster']['id'].'/');
				}else{
					//batch
					$last_id = $this->AliquotInternalUse->getLastInsertId();
					$_SESSION['tmp_batch_set']['BatchId'] = range($last_id - count($uses_to_save) + 1, $last_id);
					foreach($_SESSION['tmp_batch_set']['BatchId'] as &$batch_id){
						//add the "6" suffix to work with the view
						$batch_id = $batch_id."6";
					}
					
					$datamart_structure = AppModel::getInstance("datamart", "DatamartStructure", true);
					$_SESSION['tmp_batch_set']['datamart_structure_id'] = $datamart_structure->getIdByModelName('ViewAliquotUse');
					
					$this->atimFlash('your data has been saved', '/datamart/batch_sets/listall/0/');
					
				}
			}else{
				$this->AliquotInternalUse->validationErrors = $errors;
			}
		}
	}
	
	function redirectToAliquotUseDetail($url) {
		$this->redirect(str_replace('|', '/', $url));
	}
	
	function detailAliquotInternalUse($aliquot_master_id, $aliquot_use_id) {
		if((!$aliquot_master_id) || (!$aliquot_use_id)) { 
			$this->redirect('/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); 
		}
			
 		// MANAGE DATA

		// Get the use data
		$use_data = $this->AliquotInternalUse->find('first', array(
			'fields' => array('*'),
			'conditions' => array('AliquotInternalUse.aliquot_master_id' => $aliquot_master_id, 'AliquotInternalUse.id' => $aliquot_use_id),
			'joins' => array(AliquotMaster::joinOnAliquotDup('AliquotInternalUse.aliquot_master_id'), AliquotMaster::$join_aliquot_control_on_dup))
		);
		if(empty($use_data)) { 
			$this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		}		
		$this->data = $use_data;		
		
		// Get Sample Data
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $use_data['AliquotMaster']['collection_id'], 'SampleMaster.id' => $use_data['AliquotMaster']['sample_master_id']), 'recursive' => '0'));
		if(empty($sample_data)) { 
			$this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		}	
		
		// Set aliquot volume unit
		$aliquot_volume_unit = empty($use_data['AliquotControl']['volume_unit'])? 'n/a': $use_data['AliquotControl']['volume_unit'];

		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Get the current menu object.
		$atim_menu_link = ($sample_data['SampleControl']['sample_category'] == 'specimen')? 
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
		if( $hook_link ) { 
			require($hook_link); 
		}
	}	
	
	function editAliquotInternalUse($aliquot_master_id, $aliquot_use_id) {
		if((!$aliquot_master_id) || (!$aliquot_use_id)) { $this->redirect('/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); }
			
 		// MANAGE DATA

		// Get the use data
		$use_data = $this->AliquotInternalUse->find('first', array('conditions' => array('AliquotInternalUse.aliquot_master_id' => $aliquot_master_id, 'AliquotInternalUse.id' => $aliquot_use_id)));
		if(empty($use_data)) { $this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); }	
		
		// Get Sample Data
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $use_data['AliquotMaster']['collection_id'], 'SampleMaster.id' => $use_data['AliquotMaster']['sample_master_id']), 'recursive' => '-1'));
		if(empty($sample_data)) { $this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); }	
		
		// Set aliquot volume unit
		$aliquot_volume_unit = empty($use_data['AliquotMaster']['aliquot_volume_unit'])? 'n/a': $use_data['AliquotMaster']['aliquot_volume_unit'];

		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Get the current menu object.
		$this->setAliquotMenu(array_merge($sample_data, $use_data));
			
		// Set structure
		$this->Structures->set('aliquotinternaluses');
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
					
		// MANAGE DATA RECORD
		
		if(empty($this->data)) {
			$this->data = $use_data;
			
			$hook_link = $this->hook('initial_display');
			if($hook_link){
				require($hook_link);
			}
			
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
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) {
						require($hook_link);
					}
					if(!$this->AliquotMaster->updateAliquotUseAndVolume($aliquot_master_id, true, false)) { 
						$this->redirect('/pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true); 
					}
					$this->atimFlash('your data has been saved', '/inventorymanagement/aliquot_masters/detailAliquotInternalUse/' . $aliquot_master_id . '/' . $aliquot_use_id . '/');
				} 
			}
		}
	}
	
	function deleteAliquotInternalUse($aliquot_master_id, $aliquot_use_id) {
		if((!$aliquot_master_id) || (!$aliquot_use_id)) { $this->redirect('/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); }	
		
 		// MANAGE DATA
		
		// Get the use data
		$use_data = $this->AliquotInternalUse->find('first', array('conditions' => array('AliquotInternalUse.aliquot_master_id' => $aliquot_master_id, 'AliquotInternalUse.id' => $aliquot_use_id)));
		if(empty($use_data)) { $this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); }	
		
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
		if((!$collection_id) || (!$sample_master_id)) { 
			$this->redirect('/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); 
		}
		
		// MANAGE DATA

		// Get Sample data
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id), 'recursive' => '0'));
		if(empty($sample_data)) { 
			$this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		}	
		
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
			'AliquotMaster.sample_master_id' => $sample_data['SampleMaster']['parent_id'],
			'OR' => array(array('AliquotMaster.aliquot_volume_unit' => ''), array('AliquotMaster.aliquot_volume_unit' => NULL)),
			'NOT' => array('AliquotMaster.id' => $existing_source_aliquot_ids)
		);
		$available_sample_aliquots_wo_volume = $this->AliquotMaster->find('all', array('conditions' => $criteria, 'order' => 'AliquotMaster.barcode ASC', 'recursive' => '0'));
		unset($criteria['OR']);
		$criteria['NOT']['OR'] = array(array('AliquotMaster.aliquot_volume_unit' => ''), array('AliquotMaster.aliquot_volume_unit' => NULL));
		$available_sample_aliquots_w_volume = $this->AliquotMaster->find('all', array('conditions' => $criteria, 'order' => 'AliquotMaster.barcode ASC', 'recursive' => '0'));
		
		if(empty($available_sample_aliquots_w_volume) && empty($available_sample_aliquots_wo_volume)){
			$this->flash('no new sample aliquot could be actually defined as source aliquot', '/inventorymanagement/aliquot_masters/listAllSourceAliquots/' . $collection_id . '/' . $sample_master_id);
		}
		$available_sample_aliquots = array(
			'vol' 		=> $available_sample_aliquots_w_volume,
			'no_vol'	=> $available_sample_aliquots_wo_volume
		);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/aliquot_masters/listAllSourceAliquots/%%Collection.id%%/%%SampleMaster.id%%'));	
		
		// Get the current menu object.
		$this->set( 'atim_menu_variables', 
			array('Collection.id' => $sample_data['SampleMaster']['collection_id'], 
			'SampleMaster.id' => $sample_master_id,
			'SampleMaster.initial_specimen_sample_id' => $sample_data['SampleMaster']['initial_specimen_sample_id']) );

		// Set structure
		$this->Structures->set('sourcealiquots', 'sourcealiquots');
		$this->Structures->set('sourcealiquots,sourcealiquots_volume', 'sourcealiquots_volume');

		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
					
		// MANAGE DATA RECORD

		if (empty($this->data)) {
			$this->data = $available_sample_aliquots;
			
			$hook_link = $this->hook('initial_display');
			if($hook_link){
				require($hook_link);
			}

		} else {
			// Launch validation
			$submitted_data_validates = true;	
			
			$aliquots_defined_as_source_pointers = array();
			$unified_data_pointers = array();
			$errors = array();	
			$line_counter = 0;
			foreach($this->data as &$types_array_pointers){
				foreach($types_array_pointers as &$data_unit_pointer){
					$unified_data_pointers[] = &$data_unit_pointer;
				}
			}
			foreach($unified_data_pointers as &$studied_aliquot_pointer){
				$line_counter++;
				
				if($studied_aliquot_pointer['FunctionManagement']['use']){
					// New aliquot defined as source
				
					// Check volume
					if((!empty($studied_aliquot_pointer['SourceAliquot']['used_volume'])) && empty($studied_aliquot_pointer['AliquotMaster']['aliquot_volume_unit'])) {
						// No volume has to be recored for this aliquot type				
						$errors['SourceAliquot']['used_volume']['no volume has to be recorded for this aliquot type'][] = $line_counter; 
						$submitted_data_validates = false;			
					} else if(empty($studied_aliquot_pointer['SourceAliquot']['used_volume'])) {
						// Change '0' to null
						$studied_aliquot_pointer['SourceAliquot']['used_volume'] = null;
					}
					
					// Launch Aliquot Master validation
					$this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
					unset($studied_aliquot_pointer['StorageMaster']);
					unset($studied_aliquot_pointer['AliquotMaster']['storage_coord_x']);
					unset($studied_aliquot_pointer['AliquotMaster']['storage_coord_y']);
					$this->AliquotMaster->set($studied_aliquot_pointer);
					$this->AliquotMaster->id = $studied_aliquot_pointer['AliquotMaster']['id'];
					$submitted_data_validates = ($this->AliquotMaster->validates()) ? $submitted_data_validates : false;
					foreach($this->AliquotMaster->invalidFields() as $field => $error) { 
						$errors['AliquotMaster'][$field][$error][] = $line_counter; 
					}					
					
					// Reset data to get position data (not really required for this function)
					$studied_aliquot_pointer = $this->AliquotMaster->data;				

					// Launch Aliquot Source validation
					$this->SourceAliquot->set($studied_aliquot_pointer);
					$submitted_data_validates = ($this->SourceAliquot->validates()) ? $submitted_data_validates : false;
					foreach($this->SourceAliquot->invalidFields() as $field => $error) { 
						$errors['SourceAliquot'][$field][$error][] = $line_counter; 
					}
					
					// Add record to array of tested aliquots
					$aliquots_defined_as_source_pointers[] = $studied_aliquot_pointer;		
				}
			}
			
			if(empty($aliquots_defined_as_source_pointers)) { 
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
				
				foreach($aliquots_defined_as_source_pointers as $source_aliquot_pointer) {
					// Get Source Aliquot Master Id
					$aliquot_master_id = $source_aliquot_pointer['AliquotMaster']['id'];
					
					// Set aliquot master data					
					if($source_aliquot_pointer['FunctionManagement']['remove_from_storage'] || ($source_aliquot_pointer['AliquotMaster']['in_stock'] == 'no')) {
						// Delete aliquot storage data
						$source_aliquot_pointer['AliquotMaster']['storage_master_id'] = null;
						$source_aliquot_pointer['AliquotMaster']['storage_coord_x'] = null;
						$source_aliquot_pointer['AliquotMaster']['storage_coord_y'] = null;	
					}
					
					// Save data:
					// - AliquotMaster
					$this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
					$this->AliquotMaster->id = $aliquot_master_id;
					if(!$this->AliquotMaster->save($source_aliquot_pointer, false)) { 
						$this->redirect('/pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true); 
					}
					
					// - SourceAliquot
					$this->SourceAliquot->id = null;
					$source_aliquot_pointer['SourceAliquot']['aliquot_master_id'] = $aliquot_master_id;
					$source_aliquot_pointer['SourceAliquot']['sample_master_id'] = $sample_master_id;
					if(!$this->SourceAliquot->save($source_aliquot_pointer)) { 
						$this->redirect('/pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true); 
					}

					// - Update aliquot current volume
					if(!$this->AliquotMaster->updateAliquotUseAndVolume($aliquot_master_id, true, true)) { 
						$this->redirect('/pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true); 
					}
				}
				
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) { 
					require($hook_link); 
				}
				$this->atimFlash(__('your data has been saved',true).'<br>'.__('aliquot storage data were deleted (if required)',true), 
					'/inventorymanagement/aliquot_masters/listAllSourceAliquots/' . $collection_id . '/' . $sample_master_id); 
			}
		}
	}
	
	function listAllSourceAliquots($collection_id, $sample_master_id) {
		if((!$collection_id) || (!$sample_master_id)) { 
			$this->redirect('/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); 
		}

		// MANAGE DATA

		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id), 'recursive' => '-1'));
		if(empty($sample_data)) { 
			$this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		}	
		
		$joins = array(array(
				'table' => 'source_aliquots',
				'alias' => 'SourceAliquot',
				'type' => 'INNER',
				'conditions' => array('AliquotMaster.id = SourceAliquot.aliquot_master_id', 'SourceAliquot.sample_master_id' => $sample_master_id)
			)
		);
		
		$this->data = $this->AliquotMaster->find('all', array(
			'fields' => '*',
			'conditions' => array('AliquotMaster.collection_id'=>$collection_id),
			'joins'	=> $joins)
		);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Get the current menu object.
		$this->set('atim_menu_variables', 
			array('Collection.id' => $sample_data['SampleMaster']['collection_id'], 
			'SampleMaster.id' => $sample_master_id,
			'SampleMaster.initial_specimen_sample_id' => $sample_data['SampleMaster']['initial_specimen_sample_id']));
		
		// Set structure
		$this->Structures->set('sourcealiquots,sourcealiquots_volume');

		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
	}
	
	function deleteSourceAliquot($sample_master_id, $aliquot_master_id, $source) {
		if((!$sample_master_id) || (!$aliquot_master_id) || (!$source)) { $this->redirect('/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); }	

 		// MANAGE DATA
		
		// Get the realiquoting data
		$source_data = $this->SourceAliquot->find('first', array('conditions' => array('SourceAliquot.sample_master_id' => $sample_master_id, 'SourceAliquot.aliquot_master_id' => $aliquot_master_id)));
		if(empty($source_data)) { $this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); }				
			
		$flash_url = '';
		switch($source) {
			case 'aliquot_source':
				$flash_url = '/inventorymanagement/aliquot_masters/detail/' . $source_data['AliquotMaster']['collection_id'] . '/' . $source_data['AliquotMaster']['sample_master_id'] . '/' . $source_data['AliquotMaster']['id'];
				break;
			case 'sample_derivative':
				$flash_url = '/inventorymanagement/aliquot_masters/listAllSourceAliquots/' . $source_data['SampleMaster']['collection_id'] . '/' . $source_data['SampleMaster']['id'];
				break;
			default:
				$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		
		
		$hook_link = $this->hook('delete');
		if( $hook_link ) { 
			require($hook_link); 
		}
			
		// LAUNCH DELETION
		// -> Delete Realiquoting
		$deletion_done = $this->SourceAliquot->atim_delete($source_data['SourceAliquot']['id']);	
		
		// -> Update volume
		if($deletion_done) {
			$deletion_done = $this->AliquotMaster->updateAliquotUseAndVolume($source_data['AliquotMaster']['id'], true, true);
		}
		
		if($deletion_done) {
			$this->atimFlash('your data has been deleted - update the aliquot in stock data', $flash_url); 
		} else {
			$this->flash('error deleting data - contact administrator', $flash_url); 
		}
	}

		/* ------------------------------ REALIQUOTING ------------------------------ */

	function realiquotInit($process_type, $aliquot_id = null){	
					
		// Get ids of the studied aliquots
		$ids = array();
		if(!empty($aliquot_id)){
			$ids = array($aliquot_id);
		}else if(isset($this->data['BatchSet'])|| isset($this->data['node'])){
			if(isset($this->data['AliquotMaster'])) {
				$ids = $this->data['AliquotMaster']['id'];
			} else if(isset($this->data['ViewAliquot'])) {
				$ids = $this->data['ViewAliquot']['aliquot_master_id'];
			} else {
				$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}
			if(!is_array($ids) && strpos($ids, ',')){
				//User launched action from databrowser but the number of items was bigger than DatamartAppController->display_limit
				$this->flash(__("batch init - number of submitted records too big", true), "javascript:history.back();", 5);
				return;
			}
			$ids = array_filter($ids);	
		} else {
			$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}		
		$ids[] = 0;
		
		// Find parent(s) aliquot
		$this->AliquotMaster->unbindModel(array(
			'hasOne' => array('SpecimenDetail'),
			'belongsTo' => array('Collection','StorageMaster')));
		$aliquots = $this->AliquotMaster->findAllById($ids);
		if(empty($aliquots)){
			$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		
		$this->set('aliquot_id', $aliquot_id);
		
		// Set url to redirect
		$url_to_cancel = null;
		if(!empty($aliquot_id)){		
			$url_to_cancel = '/inventorymanagement/aliquot_masters/detail/' . $aliquots[0]['AliquotMaster']['collection_id'] . '/' . $aliquots[0]['AliquotMaster']['sample_master_id'] . '/' . $aliquots[0]['AliquotMaster']['id'] . '/';				
		}else if(isset($this->data['BatchSet'])|| isset($this->data['node'])){
			$url_to_cancel = isset($this->data['BatchSet'])?'/datamart/batch_sets/listall/' . $this->data['BatchSet']['id'] : '/datamart/browser/browse/' . $this->data['node']['id'];
		}
		$this->set('url_to_cancel', $url_to_cancel);
		
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
		
		// Build list of aliquot type that could be created from the sources for display
		$possible_ctrl_ids = $this->RealiquotingControl->getAllowedChildrenCtrlId($sample_ctrl_id, $aliquot_ctrl_id);
		if(empty($possible_ctrl_ids)){
			$this->flash(__("you cannot realiquot those elements", true), "javascript:history.back();", 5);
			return;
		}
		
		$aliquot_ctrls = $this->AliquotControl->findAllById($possible_ctrl_ids);
		assert(!empty($aliquot_ctrls));
		foreach($aliquot_ctrls as $aliquot_ctrl){
			$dropdown[$aliquot_ctrl['AliquotControl']['id']] = __($aliquot_ctrl['AliquotControl']['aliquot_type'], true);
		}
		AliquotMaster::$aliquot_type_dropdown = $dropdown;
		
		// Set data
		$this->data = array();
		$this->data[0]['ids'] = implode(",", $ids);
		
		$this->set('realiquot_from', $aliquot_ctrl_id);
		$this->set('sample_ctrl_id', $sample_ctrl_id);
		
		switch($process_type) {
			case 'creation':
				$this->set('realiquoting_function', 'realiquot');
				break;
			case 'definition':
				$this->set('realiquoting_function', 'defineRealiquotedChildren');
				break;
			default:
				$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		$this->set('process_type', $process_type);
		
		// Set structure and menu
		$this->Structures->set('aliquot_type_selection');
		
		if(empty($aliquot_id)) {
			$this->set('atim_menu', $this->Menus->get('/inventorymanagement/'));
		} else {
			$this->setAliquotMenu($aliquots[0]);
		}
		
		$this->set('skip_lab_book_selection_step', false);
		
		// Hook Call
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
	}

	function realiquotInit2($process_type, $aliquot_id = null){
			
		if(!isset($this->data['sample_ctrl_id']) || !isset($this->data['realiquot_from']) || !isset($this->data[0]['realiquot_into']) || !isset($this->data[0]['ids'])){
			$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		} else if($this->data[0]['realiquot_into'] == ''){
			$this->flash(__("you must select an aliquot type", true), "javascript:history.back();", 5);
			return;
		}
		
		$this->set('sample_ctrl_id', $this->data['sample_ctrl_id']);
		$this->set('aliquot_id', $aliquot_id);
		$this->set('realiquot_from', $this->data['realiquot_from']);
		$this->set('realiquot_into', $this->data[0]['realiquot_into']);
		$this->set('ids', $this->data[0]['ids']);
		$this->set('url_to_cancel', (isset($this->data['url_to_cancel']) && !empty($this->data['url_to_cancel']))? $this->data['url_to_cancel'] : '/menus');
		
		switch($process_type) {
			case 'creation':
				$this->set('realiquoting_function', 'realiquot');
				break;
			case 'definition':
				$this->set('realiquoting_function', 'defineRealiquotedChildren');
				break;
			default:
				$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		
		$this->AliquotMaster->unbindModel(array(
			'hasOne' => array('SpecimenDetail'),
			'belongsTo' => array('Collection','StorageMaster')));
		$aliquot_data = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.id' => $this->data[0]['ids'])));
		$sample_ctrl_id = $aliquot_data['SampleMaster']['sample_control_id'];
		if($sample_ctrl_id != $this->data['sample_ctrl_id']) $this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		$lab_book_ctrl_id = $this->RealiquotingControl->getLabBookCtrlId($sample_ctrl_id, $this->data['realiquot_from'], $this->data[0]['realiquot_into']);
		
		if(is_numeric($lab_book_ctrl_id)){
			$this->set('lab_book_ctrl_id', $lab_book_ctrl_id);
			$this->Structures->set('realiquoting_lab_book');
			AppController::addWarningMsg(__('if no lab book has to be defined for this process, keep fields empty and click submit to continue', true));
		}else{
			$this->Structures->set('empty');
			AppController::addWarningMsg(__('no lab book can be defined for that realiquoting', true).' '.__('click submit to continue', true));
		}
		
		if(empty($aliquot_id)) {
			$this->set('atim_menu', $this->Menus->get('/inventorymanagement/'));
		} else {
			$this->setAliquotMenu($aliquot_data);
		}
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
	}
	
	function realiquot($aliquot_id = null){
		$initial_display = false;
		$parent_aliquots_ids = array();
		if(empty($this->data)){ 
			$this->redirect("/pages/err_inv_no_data", null, true); 
		} else if(isset($this->data[0]) && isset($this->data[0]['ids'])){ 
			if($this->data[0]['realiquot_into'] == ''){
				$this->flash(__("you must select an aliquot type", true), "javascript:history.back();", 5);
				return;
			}
			$initial_display = true;
			$parent_aliquots_ids = $this->data[0]['ids'];
		} else if(isset($this->data['ids'])) {
			$initial_display = false;
			$parent_aliquots_ids = $this->data['ids'];			
		} else {
			$this->redirect("/pages/err_inv_no_data", null, true); 
		}
		$this->set('parent_aliquots_ids', $parent_aliquots_ids);
		
		// Get parent an child control data
		$parent_aliquot_ctrl_id = isset($this->data['realiquot_from'])? $this->data['realiquot_from']: null;
		$child_aliquot_ctrl_id = isset($this->data[0]['realiquot_into'])? $this->data[0]['realiquot_into'] : (isset($this->data['realiquot_into'])? $this->data['realiquot_into'] : null);		
		$parent_aliquot_ctrl = $this->AliquotControl->findById($parent_aliquot_ctrl_id);
		$child_aliquot_ctrl = ($parent_aliquot_ctrl_id == $child_aliquot_ctrl_id)? $parent_aliquot_ctrl : $this->AliquotControl->findById($child_aliquot_ctrl_id);		
		if(empty($parent_aliquot_ctrl) || empty($child_aliquot_ctrl)) { 
			$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
		}
		
		// lab book management
		$lab_book = null;//lab book object
		$lab_book_expected_ctrl_id = null;
		$lab_book_code = null;
		$lab_book_id = null;
		$sync_with_lab_book = null;
		$lab_book_fields = array();
		if(isset($this->data['Realiquoting']) && isset($this->data['Realiquoting']['lab_book_master_code']) && (strlen($this->data['Realiquoting']['lab_book_master_code']) > 0 || $this->data['Realiquoting']['sync_with_lab_book'])){
			$lab_book = AppModel::getInstance("labbook", "LabBookMaster", true);
			$sample_ctrl_id = isset($this->data['sample_ctrl_id'])? $this->data['sample_ctrl_id']: null;
			$lab_book_expected_ctrl_id = $this->RealiquotingControl->getLabBookCtrlId($sample_ctrl_id, $parent_aliquot_ctrl_id, $child_aliquot_ctrl_id);
			$sync_response = $lab_book->syncData($this->data, array(), $this->data['Realiquoting']['lab_book_master_code'], $lab_book_expected_ctrl_id);
			if(is_numeric($sync_response)){
				$lab_book_id = $sync_response;
				$lab_book_fields = $lab_book->getFields($lab_book_expected_ctrl_id);
				$lab_book_code = $this->data['Realiquoting']['lab_book_master_code'];
				$sync_with_lab_book = $this->data['Realiquoting']['sync_with_lab_book']; 
			}else{
				$this->flash($sync_response, "javascript:history.back()", 5);
				return;
			}
		}
		$this->set('lab_book_code', $lab_book_code);
		$this->set('sync_with_lab_book', $sync_with_lab_book);
		$this->set('lab_book_fields', $lab_book_fields);
		
		// Structure and menu data
		$this->set('aliquot_id', $aliquot_id);
		if(empty($aliquot_id)) {
			$this->set('atim_menu', $this->Menus->get('/inventorymanagement/'));
		} else {
			$parent = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.id' => $aliquot_id), 'recursive' => '0'));
			if(empty($parent)){
				$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}
			$this->setAliquotMenu($parent);
		}
				
		$this->set('aliquot_type', $child_aliquot_ctrl['AliquotControl']['aliquot_type']);
		$this->set('realiquot_from', $parent_aliquot_ctrl_id);
		$this->set('realiquot_into', $child_aliquot_ctrl_id);
		$this->set('sample_ctrl_id', $this->data['sample_ctrl_id']);
		
		$this->Structures->set('in_stock_detail', 'in_stock_detail');
		$this->Structures->set('in_stock_detail,in_stock_detail_volume', 'in_stock_detail_volume');
		$this->Structures->set($child_aliquot_ctrl['AliquotControl']['form_alias'].(empty($parent_aliquot_ctrl['AliquotControl']['volume_unit'])? ',realiquot_without_vol': ',realiquot_with_vol'));
		
		$url_to_cancel = (isset($this->data['url_to_cancel']) && !empty($this->data['url_to_cancel']))? $this->data['url_to_cancel'] : '/menus';
		$this->set('url_to_cancel', $url_to_cancel);
		
		// set data for initial data to allow bank to override data
		$created_aliquot_override_data = array(
			'AliquotControl.aliquot_type' => $child_aliquot_ctrl['AliquotControl']['aliquot_type'],
			'AliquotMaster.storage_datetime' => date('Y-m-d G:i'),
			'AliquotMaster.in_stock' => 'yes - available',
	
			'Realiquoting.realiquoting_datetime' => date('Y-m-d G:i')
		);
		if(!empty($child_aliquot_ctrl['AliquotControl']['volume_unit'])){
			$created_aliquot_override_data['AliquotMaster.aliquot_volume_unit'] = $child_aliquot_ctrl['AliquotControl']['volume_unit'];
		}
		if(!empty($parent_aliquot_ctrl['AliquotControl']['volume_unit'])){
			$created_aliquot_override_data['GeneratedParentAliquot.aliquot_volume_unit'] = $parent_aliquot_ctrl['AliquotControl']['volume_unit'];
		}
		$this->set('created_aliquot_override_data', $created_aliquot_override_data);
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
		
		if($initial_display){
			
			//1- INITIAL DISPLAY
			$parent_aliquots = $this->AliquotMaster->find('all', array(
				'conditions' => array('AliquotMaster.id' => explode(",", $parent_aliquots_ids)),
				'recursive' => 0
			));
			if(empty($parent_aliquots)) { 
				$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
			}
			
			//build data array
			$this->data = array();
			foreach($parent_aliquots as $parent_aliquot){
				if($parent_aliquot_ctrl_id != $parent_aliquot['AliquotMaster']['aliquot_control_id']) { 
					$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
				}
				$this->data[] = array('parent' => $parent_aliquot, 'children' => array());
			}
			
			$hook_link = $this->hook('initial_display');
			if($hook_link){
				require($hook_link);
			}	
			
		}else{

			unset($this->data['sample_ctrl_id']);
			unset($this->data['realiquot_into']);
			unset($this->data['realiquot_from']);
			unset($this->data['ids']);
			unset($this->data['Realiquoting']);
			unset($this->data['url_to_cancel']);
			
			// 2- VALIDATE PROCESS
		
			$errors = array();
			$validated_data = array();
			$record_counter = 0;
			
			foreach($this->data as $parent_id => $parent_and_children) {
				$record_counter++;
				
				//A- Validate parent aliquot data
				
				$this->AliquotMaster->id = null;
				$this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
				
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
								$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
							}
							$child['AliquotMaster']['current_volume'] = $child['AliquotMaster']['initial_volume'];				
						}
						
						// Validate and update position data
						$this->AliquotMaster->id = null;
						$this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
						
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
			
			if(empty($errors) && !empty($lab_book_code)){
				//this time we do synchronize with the lab book
				foreach($this->data as $key => &$new_data_set) {
					$lab_book->syncData($new_data_set['children'], array('Realiquoting'), $lab_book_code);
				}	
			}
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}				
			
			// 3- SAVE PROCESS
			
			if(empty($errors)) { 

				$_SESSION['tmp_batch_set']['BatchId'] = array();	// Set session data to display batchset
				
				foreach($this->data as $parent_id => $parent_and_children){
					
					// A- Save parent aliquot data
					
					$this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
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
						$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
					}
					
					foreach($parent_and_children['children'] as $children) {
						
						$realiquoting_data = array('Realiquoting' => $children['Realiquoting']);
						unset($children['Realiquoting']);
						unset($children['FunctionManagement']);
						unset($children['GeneratedParentAliquot']);
						
						// B- Save children aliquot data	
						
						$this->AliquotMaster->id = null;
						$this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
						if(!$this->AliquotMaster->save($children, false)){ 
							$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
						} 

						$child_id = $this->AliquotMaster->getLastInsertId();
						if(empty($aliquot_id)){
							$_SESSION['tmp_batch_set']['BatchId'][] = $child_id;
						}
							
						// C- Save realiquoting data	
						
		  				$realiquoting_data['Realiquoting']['parent_aliquot_master_id'] = $parent_id;
		 				$realiquoting_data['Realiquoting']['child_aliquot_master_id'] = $child_id;
		  				$realiquoting_data['Realiquoting']['lab_book_master_id'] = $lab_book_id;
		 				$realiquoting_data['Realiquoting']['sync_with_lab_book'] = $sync_with_lab_book;
		 				
						$this->Realiquoting->id = NULL;
		  				if(!$this->Realiquoting->save($realiquoting_data, false)){
							$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
						}
					}
					
					// D- Update parent aliquot current volume
					$this->AliquotMaster->updateAliquotUseAndVolume($parent_id, true, (empty($parent_aliquot_ctrl['AliquotControl']['volume_unit'])? false : true), false);
				}
				
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) { 
					require($hook_link); 
				}
				
				if(empty($aliquot_id)) {
					$datamart_structure = AppModel::getInstance("datamart", "DatamartStructure", true);
					$_SESSION['tmp_batch_set']['datamart_structure_id'] = $datamart_structure->getIdByModelName('ViewAliquot');
					$this->flash(__('your data has been saved',true).'<br>'.__('aliquot storage data were deleted (if required)',true), '/datamart/batch_sets/listall/0');
				} else {
					$this->flash(__('your data has been saved',true).'<br>'.__('aliquot storage data were deleted (if required)',true), $url_to_cancel);
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
	
	function defineRealiquotedChildren($aliquot_master_id = null){
		$initial_display = false;
		$parent_aliquots_ids = array();
		if(empty($this->data)){ 
			$this->redirect("/pages/err_inv_no_data", null, true); 
		} else if(isset($this->data[0]) && isset($this->data[0]['ids'])){ 
			if($this->data[0]['realiquot_into'] == ''){
				$this->flash(__("you must select an aliquot type", true), "javascript:history.back();", 5);
				return;
			}
			$initial_display = true;
			$parent_aliquots_ids = $this->data[0]['ids'];
		} else if(isset($this->data['ids'])) {
			$initial_display = false;
			$parent_aliquots_ids = $this->data['ids'];			
		} else {
			$this->redirect("/pages/err_inv_no_data", null, true); 
		}
		$this->set('parent_aliquots_ids', $parent_aliquots_ids);

		// Get parent an child control data
		$parent_aliquot_ctrl_id = isset($this->data['realiquot_from'])? $this->data['realiquot_from']: null;
		$child_aliquot_ctrl_id = isset($this->data[0]['realiquot_into'])? $this->data[0]['realiquot_into'] : (isset($this->data['realiquot_into'])? $this->data['realiquot_into'] : null);		
		$parent_aliquot_ctrl = $this->AliquotControl->findById($parent_aliquot_ctrl_id);
		$child_aliquot_ctrl = ($parent_aliquot_ctrl_id == $child_aliquot_ctrl_id)? $parent_aliquot_ctrl : $this->AliquotControl->findById($child_aliquot_ctrl_id);		
		if(empty($parent_aliquot_ctrl) || empty($child_aliquot_ctrl)) { 
			$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
		}
	
		// lab book management
		$lab_book = null;//lab book object
		$lab_book_expected_ctrl_id = null;
		$lab_book_code = null;
		$lab_book_id = null;
		$sync_with_lab_book = null;
		$lab_book_fields = array();
		if(isset($this->data['Realiquoting']) && isset($this->data['Realiquoting']['lab_book_master_code']) && (strlen($this->data['Realiquoting']['lab_book_master_code']) > 0 || $this->data['Realiquoting']['sync_with_lab_book'])){
			$lab_book = AppModel::getInstance("labbook", "LabBookMaster", true);
			$sample_ctrl_id = isset($this->data['sample_ctrl_id'])? $this->data['sample_ctrl_id']: null;
			$lab_book_expected_ctrl_id = $this->RealiquotingControl->getLabBookCtrlId($sample_ctrl_id, $parent_aliquot_ctrl_id, $child_aliquot_ctrl_id);
			$sync_response = $lab_book->syncData($this->data, array(), $this->data['Realiquoting']['lab_book_master_code'], $lab_book_expected_ctrl_id);
			if(is_numeric($sync_response)){
				$lab_book_id = $sync_response;
				$lab_book_fields = $lab_book->getFields($lab_book_expected_ctrl_id);
				$lab_book_code = $this->data['Realiquoting']['lab_book_master_code'];
				$sync_with_lab_book = $this->data['Realiquoting']['sync_with_lab_book']; 
			}else{
				$this->flash($sync_response, "javascript:history.back()", 5);
				return;
			}
		}
		$this->set('lab_book_code', $lab_book_code);
		$this->set('sync_with_lab_book', $sync_with_lab_book);
		$this->set('lab_book_fields', $lab_book_fields);

		// Structure and menu data
		$this->set('aliquot_id', $aliquot_master_id);
		if(empty($aliquot_master_id)) {
			$this->set('atim_menu', $this->Menus->get('/inventorymanagement/'));
		} else {
			$parent = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.id' => $aliquot_master_id), 'recursive' => '0'));
			if(empty($parent)){
				$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}
			$this->setAliquotMenu($parent);
		}
					
		$this->set('realiquot_from', $parent_aliquot_ctrl_id);
		$this->set('realiquot_into', $child_aliquot_ctrl_id);
		$this->set('sample_ctrl_id', $this->data['sample_ctrl_id']);		
		
		$this->Structures->set('in_stock_detail,in_stock_detail_volume', 'in_stock_detail');
		$this->Structures->set('children_aliquots_selection,children_aliquots_selection_volume', 'atim_structure_for_children_aliquots_selection');
		
		// Set url to cancel
		$url_to_cancel = (isset($this->data['url_to_cancel']) && !empty($this->data['url_to_cancel']))? $this->data['url_to_cancel'] : '/menus';
		$this->set('url_to_cancel', $url_to_cancel);
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
			
		if($initial_display){
			
			// BUILD DATA FOR INTIAL DISPLAY
			
			$this->data = array();
			$excluded_parent_aliquot = array();
			
			// Get parent aliquot data
			$this->AliquotMaster->unbindModel(array(
				'hasOne' => array('SpecimenDetail', 'DerivativeDetail'),
				'belongsTo' => array('Collection','StorageMaster')));
			$has_many_details = array(
				'hasMany' => array( 
					'RealiquotingParent' => array(
						'className' => 'Inventorymanagement.Realiquoting',
						'foreignKey' => 'child_aliquot_master_id'),
					'RealiquotingChildren' => array(
						'className' => 'Inventorymanagement.Realiquoting',
						'foreignKey' => 'parent_aliquot_master_id')));
			$this->AliquotMaster->bindModel($has_many_details);	
			$parent_aliquots = $this->AliquotMaster->find('all', array('conditions' => array('AliquotMaster.id' => explode(",", $parent_aliquots_ids))));
			if(empty($parent_aliquots)){
				$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}
			
			foreach($parent_aliquots as $parent_aliquot_data){				
				// Get aliquots already defined as children
				$aliquot_to_exclude = array($parent_aliquot_data['AliquotMaster']['id']);
				foreach($parent_aliquot_data['RealiquotingChildren'] as $realiquoting_data) {
					$aliquot_to_exclude[] = $realiquoting_data['child_aliquot_master_id'];
				}
				
				// Get aliquots already defined as  parent of the studied parent
				$existing_parents = array();
				foreach($parent_aliquot_data['RealiquotingParent'] as $realiquoting_data) {
					$aliquot_to_exclude[] = $realiquoting_data['parent_aliquot_master_id'];
				}
				
				// Search Sample Aliquots could be defined as children aliquot
				$criteria = array(
					'AliquotMaster.sample_master_id' => $parent_aliquot_data['AliquotMaster']['sample_master_id'],
					'AliquotMaster.aliquot_control_id' => $child_aliquot_ctrl_id,
					'NOT' => array('AliquotMaster.id' => $aliquot_to_exclude));
				
				$exclude_aliquot = false;
				$aliquot_data_for_selection = $this->AliquotMaster->find('all', array(
					'conditions' => $criteria, 
					'order' => array('AliquotMaster.in_stock_order', 'AliquotMaster.storage_datetime DESC'), 
					'recursive' => '0')
				);
				
				if(empty($aliquot_data_for_selection)) {
					// No aliquot can be defined as child
					$excluded_parent_aliquot[] = $parent_aliquot_data;
				} else {
					//Set default data
					$default_use_datetime = $this->AliquotMaster->getDefaultRealiquotingDate($parent_aliquot_data);
					foreach($aliquot_data_for_selection as &$children_aliquot) {
						$children_aliquot['GeneratedParentAliquot']['aliquot_volume_unit'] = empty($parent_aliquot_data['AliquotMaster']['aliquot_volume_unit'])? '': $parent_aliquot_data['AliquotMaster']['aliquot_volume_unit'];
						$children_aliquot['Realiquoting']['realiquoting_datetime'] = $default_use_datetime;
					}
					
					// Set data
					$this->data[] = array('parent' => $parent_aliquot_data, 'children' => $aliquot_data_for_selection);				
				}
			}
			
			// Manage exculded parents
			if(!empty($excluded_parent_aliquot)) {
				$tmp_barcode = array();
				foreach($excluded_parent_aliquot as $new_aliquot) {
					$tmp_barcode[] = $new_aliquot['AliquotMaster']['barcode'];
				}
				$msg = __('no new aliquot could be actually defined as realiquoted child for the following parent aliquot(s)',true).': ['.implode(",", $tmp_barcode).']';
				
				if(empty($this->data)) {
					$this->flash($msg, $url_to_cancel);
					return;
				} else {
					$this->AliquotMaster->validationErrors[] = $msg;
				}
			}

			$hook_link = $this->hook('initial_display');
			if($hook_link){
				require($hook_link);
			}
			
		} else {
			
			// LAUNCH VALIDATE & SAVE PROCESSES

			unset($this->data['sample_ctrl_id']);
			unset($this->data['realiquot_into']);
			unset($this->data['realiquot_from']);
			unset($this->data['ids']);
			unset($this->data['Realiquoting']);
			unset($this->data['url_to_cancel']);
			
			$errors = array();
			$validated_data = array();
			$record_counter = 0;
			$relations = array();
					
			foreach($this->data as $parent_id => $parent_and_children){
				$record_counter++;
				
				//A- Validate parent aliquot data
				
				$this->AliquotMaster->id = null; 
				$this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
				
				$parent_aliquot_data = $parent_and_children['AliquotMaster'];
				$parent_aliquot_data["id"] = $parent_id;
				$parent_aliquot_data["aliquot_control_id"] = $parent_aliquot_ctrl_id;
				
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
				
				//B- Validate realiquoting data
				
				$children_has_been_defined = false;
				foreach($parent_and_children as $tmp_id => $children_aliquot){
					if(is_numeric($tmp_id)) {
						if($children_aliquot['FunctionManagement']['use']) {
							$children_has_been_defined = true;
							
							if(isset($relations[$children_aliquot['AliquotMaster']['id']])){
								$errors[][sprintf(__("circular assignation with [%s]", true), $children_aliquot['AliquotMaster']['barcode'])][] = $record_counter;
							}
							$relations[$parent_id] = $children_aliquot['AliquotMaster']['id'];
							
							$this->Realiquoting->set(array('Realiquoting' => $children_aliquot['Realiquoting']));
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
						$validated_data[$parent_id]['children'][$tmp_id] = $children_aliquot;
					}
				}
				if(!$children_has_been_defined) $errors[]['at least one child has not been defined'][] = $record_counter;	
			}
			
			$this->data = $validated_data;
			
			if(empty($errors) && !empty($lab_book_code)){
				//this time we do synchronize with the lab book
				foreach($this->data as $key => &$new_data_set) {
					$lab_book->syncData($new_data_set['children'], array('Realiquoting'), $lab_book_code);
				}	
			}
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}
			
			if(empty($errors)) {
				
				//C- Save Process
			
				$_SESSION['tmp_batch_set']['BatchId'] = array();	// Set session data to display batchset
				
				foreach($this->data as $parent_id => $parent_and_children){
					
					// Save parent aliquot data
					
					$this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
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
						$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
					}
					
					// Save realiquoting data
					
					foreach($parent_and_children['children'] as $children_aliquot) {
						if($children_aliquot['FunctionManagement']['use']){
			  				//save realiquoting
			  				$children_aliquot['Realiquoting']['parent_aliquot_master_id'] = $parent_id;
			 				$children_aliquot['Realiquoting']['child_aliquot_master_id'] = $children_aliquot['AliquotMaster']['id'];
		  					$children_aliquot['Realiquoting']['lab_book_master_id'] = $lab_book_id;
		 					$children_aliquot['Realiquoting']['sync_with_lab_book'] = $sync_with_lab_book;
			 					
							$this->Realiquoting->id = NULL;
			  				if(!$this->Realiquoting->save(array('Realiquoting' => $children_aliquot['Realiquoting'], false))){
								$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
							}
								
							// Set data for batchset
							$_SESSION['tmp_batch_set']['BatchId'][] = $children_aliquot['AliquotMaster']['id'];	
						}
					}
					
					// Update parent aliquot current volume
					
					$this->AliquotMaster->updateAliquotUseAndVolume($parent_id, true, true, false);
				}
				
				$datamart_structure = AppModel::getInstance("datamart", "DatamartStructure", true);
				$_SESSION['tmp_batch_set']['datamart_structure_id'] = $datamart_structure->getIdByModelName('ViewAliquot');

				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) { 
					require($hook_link); 
				}
				
				//redirect
				
				if($aliquot_master_id == null){
					$this->flash(__('your data has been saved',true).'<br>'.__('aliquot storage data were deleted (if required)',true), '/datamart/batch_sets/listall/0');
				}else{
					$this->flash(__('your data has been saved',true).'<br>'.__('aliquot storage data were deleted (if required)',true), $url_to_cancel);
				}
			
			} else {
				// Errors have been detected => rebuild form data
				$this->AliquotMaster->validationErrors = array();
				$this->Realiquoting->validationErrors = array();
				foreach($errors as $field => $msg_and_lines) {
					foreach($msg_and_lines as $msg => $lines) {
						$this->AliquotMaster->validationErrors[$field][] = __($msg, true) .(empty($aliquot_id)? ' - ' . str_replace('%s', implode(",", $lines), __('see # %s',true)) : '');					
					} 
				}				
			}
		}
		
		if(empty($this->data[0]['parent']['AliquotControl']['volume_unit'])){
			//switch to volumeless structures
			$this->Structures->set('children_aliquots_selection', 'atim_structure_for_children_aliquots_selection');
			$this->Structures->set('in_stock_detail', 'in_stock_detail');
		}
	}
	
	function listAllRealiquotedParents($collection_id, $sample_master_id, $aliquot_master_id) {
		if((!$collection_id) || (!$sample_master_id) || (!$aliquot_master_id)) { $this->redirect('/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); }

		// MANAGE DATA
		
		// Get the aliquot data
		$current_aliquot_data = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.collection_id' => $collection_id, 'AliquotMaster.sample_master_id' => $sample_master_id, 'AliquotMaster.id' => $aliquot_master_id)));
		if(empty($current_aliquot_data)) { $this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); }		
		
		// Get/Manage Parent Aliquots
		$this->data = $this->paginate($this->Realiquoting, array('Realiquoting.child_aliquot_master_id '=> $aliquot_master_id));
		
		// Manage data to build URL to access la book
		$this->set('display_lab_book_url', true);
		foreach($this->data as &$new_record) {
			$new_record['Realiquoting']['generated_lab_book_master_id'] = '-1';
			if(array_key_exists('lab_book_master_id',$new_record['Realiquoting']) && !empty($new_record['Realiquoting']['lab_book_master_id'])) {
				$new_record['Realiquoting']['generated_lab_book_master_id'] = $new_record['Realiquoting']['lab_book_master_id'];
			}
		}
		
		// MANAGE FORM, MENU AND ACTION BUTTONS

		// Get the current menu object.
		$this->setAliquotMenu($current_aliquot_data);
		
		// Set structure
		$this->Structures->set('realiquotedparent');
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
	}
	
	function deleteRealiquotingData($parent_id, $child_id, $source) {
		if((!$parent_id) || (!$child_id) || (!$source)) { $this->redirect('/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); }	

 		// MANAGE DATA
		
		// Get the realiquoting data
		$realiquoting_data = $this->Realiquoting->find('first', array('conditions' => array('Realiquoting.parent_aliquot_master_id' => $parent_id, 'Realiquoting.child_aliquot_master_id' => $child_id)));
		if(empty($realiquoting_data)) { $this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); }				
		
		$flash_url = '';
		switch($source) {
			case 'parent':
				$flash_url = '/inventorymanagement/aliquot_masters/detail/' . $realiquoting_data['AliquotMaster']['collection_id'] . '/' . $realiquoting_data['AliquotMaster']['sample_master_id'] . '/' . $realiquoting_data['AliquotMaster']['id'];
				break;
			case 'child':
				$flash_url = '/inventorymanagement/aliquot_masters/listAllRealiquotedParents/' . $realiquoting_data['AliquotMasterChildren']['collection_id'] . '/' . $realiquoting_data['AliquotMasterChildren']['sample_master_id'] . '/' . $realiquoting_data['AliquotMasterChildren']['id'];
				break;
			default:
				$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
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
			$this->redirect('/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); 
		}
		if($is_ajax){
			$this->layout = 'ajax';
			Configure::write('debug', 0);
		}
		$atim_structure['AliquotMaster'] = $this->Structures->get('form','aliquot_masters_for_collection_tree_view');
		$this->set('atim_structure', $atim_structure);
		$this->set("collection_id", $collection_id);
		$this->set("is_ajax", $is_ajax);
		
		// Unbind models
		$this->SampleMaster->unbindModel(array('belongsTo' => array('Collection'),'hasOne' => array('SpecimenDetail','DerivativeDetail'),'hasMany' => array('AliquotMaster')),false);
		$this->AliquotMaster->unbindModel(array('belongsTo' => array('Collection','SampleMaster'),'hasOne' => array('SpecimenDetail')),false);
		
		$ids = $this->Realiquoting->find('list', array('fields' => array('Realiquoting.child_aliquot_master_id'), 'conditions' => array('Realiquoting.parent_aliquot_master_id' => $aliquot_master_id)));
		$aliquot_ids_has_child = array_flip($this->AliquotMaster->hasChild($ids));
		
		$ids[] = 0;//counters Eventum 1353
		$this->data = $this->AliquotMaster->find('all', array('conditions' => array('AliquotMaster.id' => $ids, 'AliquotMaster.collection_id' => $collection_id)));
		foreach($this->data as &$aliquot){
			$aliquot['children'] = array_key_exists($aliquot['AliquotMaster']['id'], $aliquot_ids_has_child);
			$aliquot['css'][] = $aliquot['AliquotMaster']['in_stock'] == 'no' ? 'disabled' : '';
		}
	}
}

?>
