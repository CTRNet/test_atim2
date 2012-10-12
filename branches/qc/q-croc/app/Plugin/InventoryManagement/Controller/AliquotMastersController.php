<?php
class AliquotMastersController extends InventoryManagementAppController {
	
	var $components = array();
	
	var $uses = array(
		'InventoryManagement.Collection',
		
		'InventoryManagement.SampleMaster', 
		'InventoryManagement.ViewSample',
		'InventoryManagement.DerivativeDetail',
		
		'InventoryManagement.SampleControl',
		
		'InventoryManagement.AliquotControl', 
		'InventoryManagement.AliquotMaster',
		'InventoryManagement.AliquotMastersRev', 
		'InventoryManagement.ViewAliquot',
		'InventoryManagement.AliquotDetail',			
		
		'InventoryManagement.RealiquotingControl',
		
		'InventoryManagement.ViewAliquotUse',
		'InventoryManagement.AliquotInternalUse',
		'InventoryManagement.Realiquoting',
		'InventoryManagement.SourceAliquot',
		'InventoryManagement.AliquotReviewMaster',
		'Order.OrderItem',
	
		'StorageLayout.StorageMaster',
		'StorageLayout.StorageCoordinate',
		
		'ExternalLink'
	);
	
	var $paginate = array(
		'AliquotMaster' => array('limit' => pagination_amount , 'order' => 'AliquotMaster.barcode DESC'), 
		'ViewAliquot' => array('limit' => pagination_amount , 'order' => 'ViewAliquot.barcode DESC')
	);

	/* --------------------------------------------------------------------------
	 * DISPLAY FUNCTIONS
	 * -------------------------------------------------------------------------- */

	/* ----------------------------- ALIQUOT MASTER ----------------------------- */
	
	function search($search_id = 0) {
		$this->set('atim_menu', $this->Menus->get('/InventoryManagement/Collections/search'));
		
		$this->searchHandler($search_id, $this->ViewAliquot, 'view_aliquot_joined_to_sample_and_collection', '/InventoryManagement/AliquotMasters/search');

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
	
	function addInit(){
		$url_to_cancel = 'javascript:history.go(-1)';
		
		// Get Data
		$model = null;
		$key = null;
		if(isset($this->request->data['BatchSet'])|| isset($this->request->data['node'])){
			if(isset($this->request->data['SampleMaster'])) {
				$model = 'SampleMaster';
				$key = 'id';
			} else if(isset($this->request->data['ViewSample'])) {
				$model = 'ViewSample';
				$key = 'sample_master_id';
			} else {
				$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}
		} else {
			$this->flash((__('you have been redirected automatically').' (#'.__LINE__.')'), $url_to_cancel, 5);
			return;
		}	
		
		// Set url to redirect
		if(isset($this->request->data['BatchSet']['id'])) {
			$url_to_cancel = '/Datamart/BatchSets/listall/' . $this->request->data['BatchSet']['id'];
		} else if(isset($this->request->data['node']['id'])) {
			$url_to_cancel = '/Datamart/Browser/browse/' . $this->request->data['node']['id'];
		}
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
			$this->flash(__($init_data['error']), $url_to_cancel, 5);
			return;
		}		
		
		// Manage structure and menus
		$this->AliquotMaster;//lazy load
		foreach($init_data['possibilities'] as $possibility){
			AliquotMaster::$aliquot_type_dropdown[$possibility['AliquotControl']['id']] = __($possibility['AliquotControl']['aliquot_type']);
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
		if($this->request->is('ajax')){
			$this->layout = 'ajax';
			ob_start();
		}
		
		$url_to_cancel = isset($this->request->data['url_to_cancel'])? $this->request->data['url_to_cancel'] : 'javascript:history.go(-1)';
		unset($this->request->data['url_to_cancel']);
					
		// CHECK PARAMETERS
		if(!empty($sample_master_id) && !empty($aliquot_control_id)) {
			// User just click on add aliquot button from sample detail form
			$this->request->data = array();
			$this->request->data[0]['ids'] = $sample_master_id;
			$this->request->data[0]['realiquot_into'] = $aliquot_control_id;
		} else if(empty($this->request->data)){ 
			$this->flash(__('you have been redirected automatically').' (#'.__LINE__.')', $url_to_cancel, 5);
			return;
		}

		$is_intial_display = isset($this->request->data[0]['ids'])? true : false;
		$is_batch_process = empty($sample_master_id);
		$this->set('is_batch_process', $is_batch_process);
		
		// GET ALIQUOT CONTROL DATA
		
		if($this->request->data[0]['realiquot_into'] == ""){
			$this->flash(__('you need to select an aliquot type'), $url_to_cancel);
			return;
		}
		
		$aliquot_control = $this->AliquotControl->findById($this->request->data[0]['realiquot_into']);
		if(empty($aliquot_control)){
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		
		$this->set('aliquot_control_id',$aliquot_control['AliquotControl']['id']);

		$template_init_id = null;
		if(isset($this->request->data['template_init_id'])){
			$template_init_id = $this->request->data['template_init_id'];
			unset($this->request->data['template_init_id']);
		}
		
		// GET SAMPLES DATA		
		
		$sample_master_ids = array();
		if($is_intial_display) {
			$sample_master_ids = explode(",", $this->request->data[0]['ids']);
			unset($this->request->data[0]);
		} else {
			unset($this->request->data[0]);
			if(!empty($this->request->data)) {
				$sample_master_ids = array_keys($this->request->data);
			} else {
				// User don't work in batch mode and deleted all aliquot rows
				if(empty($sample_master_id)){
					$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				}
				$sample_master_ids = array($sample_master_id);
			}
		}
		$samples = $this->ViewSample->find('all', array('conditions' => array('sample_master_id' => $sample_master_ids), 'recursive' => -1));
		$this->ViewSample->sortForDisplay($samples, $sample_master_ids);
		$samples_from_id = array();
		
		$is_specimen = (strcmp($samples[0]['ViewSample']['sample_category'], 'specimen') ==0)? true: false;
				
		// Sample checks
		if(sizeof($samples) != sizeof($sample_master_ids)) {
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		
		$sample_control_id = null;
		foreach($samples as $sample_master_data) {
			if(is_null($sample_control_id)) {
				$sample_control_id = $sample_master_data['ViewSample']['sample_control_id'];
			} else {
				if($sample_master_data['ViewSample']['sample_control_id'] != $sample_control_id) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}
			
			$samples_from_id[$sample_master_data['ViewSample']['sample_master_id']] = $sample_master_data;
		}
			
		$criteria = array(
			'AliquotControl.sample_control_id' => $sample_control_id,
			'AliquotControl.flag_active' => '1',
			'AliquotControl.id' => $aliquot_control['AliquotControl']['id']);
		if(!$this->AliquotControl->find('count', array('conditions' => $criteria))){
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('sample_master_id',$sample_master_id);
		
		// Set menu
		$atim_menu_link = '/InventoryManagement/';
		if($is_batch_process) {
			$this->setBatchMenu(array('SampleMaster' => $sample_master_ids));
		}else{
			$atim_menu_link = '/InventoryManagement/SampleMasters/detail/%%Collection.id%%/' . ($is_specimen? '%%SampleMaster.initial_specimen_sample_id%%': '%%SampleMaster.id%%');
			$this->set('atim_menu', $this->Menus->get($atim_menu_link));
			$this->set('atim_menu_variables', array(
				'Collection.id' => $samples[0]['ViewSample']['collection_id'], 
				'SampleMaster.id' => $sample_master_id, 
				'SampleMaster.initial_specimen_sample_id' => $samples[0]['ViewSample']['initial_specimen_sample_id']));
		}
		
		// set structure
		$this->Structures->set($aliquot_control['AliquotControl']['form_alias'], 'atim_structure', array('model_table_assoc' => array('AliquotDetail' => $aliquot_control['AliquotControl']['detail_tablename'])));
		if($is_batch_process) {
			$this->Structures->set('view_sample_joined_to_collection', 'sample_info');
		}
		$this->Structures->set('empty', 'empty_structure');
		
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
			$url_to_cancel = '/InventoryManagement/SampleMasters/detail/' . $samples[0]['ViewSample']['collection_id'] . '/' . $sample_master_id;
		}		
		$this->set('url_to_cancel', $url_to_cancel);
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link); 
		}
		
		if($is_intial_display){
			
			// 1- INITIAL DISPLAY
			$this->request->data = array();
			foreach($samples as $sample){
				$this->request->data[] = array('parent' => $sample, 'children' => array_fill(0, $quantity, array()));
			}
			
			$hook_link = $this->hook('initial_display');
			if($hook_link){
				require($hook_link);
			}
			
		}else{
					
			// 2- VALIDATE PROCESS
			$errors = array();
			$prev_data = $this->request->data;
			$this->request->data = array();
			$record_counter = 0;
			foreach($prev_data as $sample_master_id => $created_aliquots){
				$record_counter++;
				
				unset($created_aliquots['ViewSample']);
				if(!isset($samples_from_id[$sample_master_id])) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				$sample_master_data = $samples_from_id[$sample_master_id];
				
				$new_aliquot_created = false;
				$line_counter = 0;
				foreach($created_aliquots as $key => $aliquot){
					$line_counter++;
					$new_aliquot_created = true;
					
					// Set AliquotMaster.initial_volume
					if(array_key_exists('initial_volume', $aliquot['AliquotMaster'])){
						if(empty($aliquot_control['AliquotControl']['volume_unit'])){
							$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
						}
						$aliquot['AliquotMaster']['current_volume'] = $aliquot['AliquotMaster']['initial_volume'];				
					}
					
					// Validate and update position data
					$aliquot['AliquotMaster']['aliquot_control_id'] = $aliquot_control['AliquotControl']['id'];
					
					$this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
					$this->AliquotMaster->set($aliquot);				
					if(!$this->AliquotMaster->validates()){
						foreach($this->AliquotMaster->validationErrors as $field => $msgs) {
							$msgs = is_array($msgs)? $msgs : array($msgs);
							foreach($msgs as $msg) $errors[$field][$msg][] = ($is_batch_process? $record_counter : $line_counter);
						}
					}
					
					// Reset data to get position data
					$created_aliquots[$key] = $this->AliquotMaster->data;
				}
				$this->request->data[] = array('parent' => $sample_master_data, 'children' => $created_aliquots);//prep data in case validation fails
				if(!$new_aliquot_created){
					$errors[]['at least one aliquot has to be created'][] = ($is_batch_process? $record_counter : '');
				}
			}
			
			if(empty($this->request->data)) {
				$errors[]['at least one aliquot has to be created'][] = '';
				$this->request->data[] = array('parent' => $samples[0], 'children' => array());
			}
			
			$this->AliquotMaster->addWritableField(array('collection_id', 'sample_control_id', 'sample_master_id', 'aliquot_control_id', 'storage_master_id', 'current_volume'));
			$this->AliquotMaster->addWritableField(array('aliquot_master_id'), $aliquot_control['AliquotControl']['detail_tablename']);
			$this->AliquotMaster->writable_fields_mode = 'addgrid';
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}				
			
			// 3- SAVE PROCESS
			
			if(empty($errors)){
				
				//save
				$batch_ids = array();
				foreach($this->request->data as $created_aliquots){
					foreach($created_aliquots['children'] as $new_aliquot) {	
						$this->AliquotMaster->id = null;
						$this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
						unset($new_aliquot['AliquotMaster']['id']);
						$new_aliquot['AliquotMaster']['collection_id'] = $created_aliquots['parent']['ViewSample']['collection_id'];
						$new_aliquot['AliquotMaster']['sample_master_id'] = $created_aliquots['parent']['ViewSample']['sample_master_id'];
						if(!$this->AliquotMaster->save($new_aliquot, false)){ 
							$this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true); 
						} 
						
						if($is_batch_process){
							$batch_ids[] = $this->AliquotMaster->getLastInsertId();
						}
					}
				}
				
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) { 
					require($hook_link); 
				}
					
				if($is_batch_process) {
					$datamart_structure = AppModel::getInstance("Datamart", "DatamartStructure", true);
					$batch_set_data = array('BatchSet' => array(
						'datamart_structure_id'	=> $datamart_structure->getIdByModelName('ViewAliquot'),
						'flag_tmp'				=> true
					));
					$batch_set_model = AppModel::getInstance('Datamart', 'BatchSet', true);
					$batch_set_model->saveWithIds($batch_set_data, $batch_ids);
					
					$this->atimFlash('your data has been saved', '/Datamart/BatchSets/listall/'.$batch_set_model->getLastInsertId());
				} else {
					if($this->request->is('ajax')){
						ob_end_clean();
						echo json_encode(array('goToNext' => true, 'display' => '', 'id' => -1));
						exit;
					}else{
						$this->atimFlash('your data has been saved', '/InventoryManagement/SampleMasters/detail/' . $samples[0]['ViewSample']['collection_id'] . '/' . $sample_master_id);
					}
				}
				
			}else{
				$this->AliquotMaster->validationErrors = array();
				$this->AliquotDetail->validationErrors = array();
				foreach($errors as $field => $msg_and_lines) {
					foreach($msg_and_lines as $msg => $lines) {
						$msg = __($msg);
						$lines_strg = implode(",", array_unique($lines));
						if(!empty($lines_strg)) {
							$pattern = $is_batch_process? 'see # %s' : 'see line %s';
							$msg .= ' - ' . str_replace('%s', $lines_strg, __($pattern));
						} 
						$this->AliquotMaster->validationErrors[$field][] = $msg;					
					} 
				}
			}
		}
		$this->set('is_ajax', $this->request->is('ajax'));
	}
	
	/**
	 * @param unknown_type $collection_id
	 * @param unknown_type $sample_master_id
	 * @param unknown_type $aliquot_master_id
	 * @param unknown_type $is_from_tree_view_or_layout 0-Normal, 1-Tree view, 2-Stoarge layout
	 */
	function detail($collection_id, $sample_master_id, $aliquot_master_id, $is_from_tree_view_or_layout = 0) {
		if($is_from_tree_view_or_layout){
			Configure::write('debug', 0);
		}
		// MANAGE DATA
	
		// Get the aliquot data
		$joins = array(
			array('table' => 'specimen_details',
				'alias' => 'SpecimenDetail',
				'type' => 'LEFT',
				'conditions' => array('SpecimenDetail.sample_master_id = AliquotMaster.sample_master_id')),
			array('table' => 'derivative_details',
				'alias' => 'DerivativeDetail',
				'type' => 'LEFT',
				'conditions' => array('DerivativeDetail.sample_master_id = AliquotMaster.sample_master_id'))			
		);
    	$condtions = array('AliquotMaster.collection_id' => $collection_id, 'AliquotMaster.sample_master_id' => $sample_master_id, 'AliquotMaster.id' => $aliquot_master_id);
		$aliquot_data = $this->AliquotMaster->find('first', array('conditions' => $condtions, 'joins' => $joins));
		if(empty($aliquot_data)) { 
			$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		}		
		
		// Set aliquot data
		$this->set('aliquot_master_data', $aliquot_data);
		$this->request->data = array();
		
		// Set storage data
		$this->set('aliquot_storage_data', empty($aliquot_data['StorageMaster']['id'])? array(): array('StorageMaster' => $aliquot_data['StorageMaster']));
		
		// MANAGE FORM, MENU AND ACTION BUTTONS

		// Get the current menu object.
		$atim_menu_link = ($aliquot_data['SampleControl']['sample_category'] == 'specimen')? 
			'/InventoryManagement/AliquotMasters/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%AliquotMaster.id%%': 
			'/InventoryManagement/AliquotMasters/detail/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%';
		$this->set('atim_menu', $this->Menus->get($atim_menu_link));
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id, 'SampleMaster.id' => $sample_master_id, 'SampleMaster.initial_specimen_sample_id' => $aliquot_data['SampleMaster']['initial_specimen_sample_id'], 'AliquotMaster.id' => $aliquot_master_id));
		
		// Set structure
		$this->Structures->set($aliquot_data['AliquotControl']['form_alias']);
		$this->Structures->set('empty', 'empty_structure');

		// Define if this detail form is displayed into the collection content tree view, storage tree view, storage layout
		$this->set('is_from_tree_view_or_layout', $is_from_tree_view_or_layout);
		
		// Define if aliquot is included into an order
		$order_item = $this->OrderItem->find('first', array('conditions' => array('OrderItem.aliquot_master_id' => $aliquot_master_id)));
		if(!empty($order_item)){
			$this->set('order_line_id', $order_item['OrderLine']['id']);
			$this->set('order_id', $order_item['OrderLine']['order_id']);
		}
		
		$sample_master = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.id' => $sample_master_id), 'recursive' => -1));
		$ptdsc_model = AppModel::getInstance('InventoryManagement', 'ParentToDerivativeSampleControl', true);
		$ptdsc = $ptdsc_model->find('first', array('conditions' => array('ParentToDerivativeSampleControl.parent_sample_control_id' => $sample_master['SampleMaster']['sample_control_id']), 'recursive' => -1));
		$this->set('can_create_derivative', !empty($ptdsc));
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
	}
	
	function edit($collection_id, $sample_master_id, $aliquot_master_id) {
		// MANAGE DATA

		// Get the aliquot data
				
		$aliquot_data = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.collection_id' => $collection_id, 'AliquotMaster.sample_master_id' => $sample_master_id, 'AliquotMaster.id' => $aliquot_master_id)));
		if(empty($aliquot_data)){ 
			$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		}		
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Get the current menu object.
		$this->setAliquotMenu($aliquot_data);
		
		// Set structure
		$this->Structures->set($aliquot_data['AliquotControl']['form_alias'], 'atim_structure', array('model_table_assoc' => array('AliquotDetail' => $aliquot_data['AliquotControl']['detail_tablename'])));
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link); 
		}
		
		// MANAGE DATA RECORD
		
		if(empty($this->request->data)){
			$aliquot_data['FunctionManagement']['recorded_storage_selection_label'] = $this->StorageMaster->getStorageLabelAndCodeForDisplay(array('StorageMaster' => $aliquot_data['StorageMaster']));
			$this->request->data = $aliquot_data;
			
			$hook_link = $this->hook('initial_display');
			if($hook_link){
				require($hook_link);
			}
			
		}else{
			//Update data
			if(array_key_exists('initial_volume', $this->request->data['AliquotMaster']) && empty($aliquot_data['AliquotControl']['volume_unit'])) { 
				$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
			}

			// Launch validations
			
			$submitted_data_validates = true;
					
			// -> Fields validation
			//  --> AliquotMaster
			$this->request->data['AliquotMaster']['id'] = $aliquot_master_id;
			$this->request->data['AliquotMaster']['aliquot_control_id'] = $aliquot_data['AliquotMaster']['aliquot_control_id'];
			
			$this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
			$this->AliquotMaster->set($this->request->data);
			$this->AliquotMaster->id = $aliquot_master_id;
			$submitted_data_validates = ($this->AliquotMaster->validates()) ? $submitted_data_validates: false;
			
			// Reste data to get position data
			$this->request->data = $this->AliquotMaster->data;
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}
			
			// Save data
			if($submitted_data_validates) {
				$this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
				$this->AliquotMaster->id = $aliquot_master_id;
				$this->AliquotMaster->addWritableField('storage_master_id');
				
				if(!$this->AliquotMaster->save($this->request->data, false)) { 
					$this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true); 
				}
				if(!$this->AliquotMaster->updateAliquotUseAndVolume($aliquot_master_id, true, false)) { 
					$this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true); 
				}
				
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) { 
					require($hook_link); 
				}	
				
				$this->atimFlash('your data has been updated', '/InventoryManagement/AliquotMasters/detail/' . $collection_id . '/' . $sample_master_id. '/' . $aliquot_master_id);				
				return;
			}
		}
	}
	
	function removeAliquotFromStorage($collection_id, $sample_master_id, $aliquot_master_id) {
		if((!$collection_id) || (!$sample_master_id) || (!$aliquot_master_id)) { $this->redirect('/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); }		
		
		// MANAGE DATA

		// Get the aliquot data
		$aliquot_data = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.collection_id' => $collection_id, 'AliquotMaster.sample_master_id' => $sample_master_id, 'AliquotMaster.id' => $aliquot_master_id)));
		if(empty($aliquot_data)) { 
			$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		}		
		
		// Delete storage data
		$this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
		$this->AliquotMaster->id = $aliquot_master_id;
		$aliquot_data_to_save = array('AliquotMaster' => array(
			'storage_master_id' => null,
			'storage_coord_x' => '',
			'storage_coord_y' => ''
		));
		$this->AliquotMaster->addWritableField(array('storage_master_id', 'storage_coord_x', 'storage_coord_y'));
		if(!$this->AliquotMaster->save($aliquot_data_to_save, false)) {
			$this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		
		$this->atimFlash('your data has been updated', '/InventoryManagement/AliquotMasters/detail/' . $collection_id . '/' . $sample_master_id. '/' . $aliquot_master_id);				
	}
	
	function delete($collection_id, $sample_master_id, $aliquot_master_id) {
		if((!$collection_id) || (!$sample_master_id) || (!$aliquot_master_id)) { $this->redirect('/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); }		
	
		// Get the aliquot data
		$aliquot_data = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.collection_id' => $collection_id, 'AliquotMaster.sample_master_id' => $sample_master_id, 'AliquotMaster.id' => $aliquot_master_id)));
		if(empty($aliquot_data)) { 
			$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		}		
		
		// Check deletion is allowed
		$arr_allow_deletion = $this->AliquotMaster->allowDeletion($aliquot_master_id);
			
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }		
		
		if($arr_allow_deletion['allow_deletion']) {
			if($this->AliquotMaster->atimDelete($aliquot_master_id)) {
				
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) { require($hook_link); }
				
				$this->atimFlash('your data has been deleted', '/InventoryManagement/SampleMasters/detail/' . $collection_id . '/' . $sample_master_id);
			} else {
				$this->flash('error deleting data - contact administrator', '/InventoryManagement/SampleMasters/detail/' . $collection_id . '/' . $sample_master_id);
			}
		} else {
			$this->flash($arr_allow_deletion['msg'], '/InventoryManagement/AliquotMasters/detail/' . $collection_id . '/' . $sample_master_id . '/' . $aliquot_master_id);
		}		
	}
	
	/* ------------------------------ ALIQUOT INTERNAL USES ------------------------------ */

	function addAliquotInternalUse($aliquot_master_id = null) {
		//GET DATA
		
		$initial_display = false;
		$aliquot_ids = array();
		$this->setUrlToCancel();
		$url_to_cancel = $this->request->data['url_to_cancel'];
		unset($this->request->data['url_to_cancel']);
		
		if($aliquot_master_id != null){
			// User is workning on a collection
			$aliquot_ids = array($aliquot_master_id);
			if(empty($this->request->data)) $initial_display = true;
			
		} else if(isset($this->request->data['ViewAliquot']['aliquot_master_id'])){
			$aliquot_ids = array_filter($this->request->data['ViewAliquot']['aliquot_master_id']);
			$initial_display = true;
			
		}else{
			$aliquot_ids = array_keys($this->request->data);
			
		}
		
		$aliquot_data = $this->AliquotMaster->find('all', array('conditions' => array('AliquotMaster.id' => $aliquot_ids)));		
		if(empty($aliquot_data)){
			$this->flash((__('you have been redirected automatically').' (#'.__LINE__.')'), $url_to_cancel, 5);
			return;	
		}
		$this->AliquotMaster->sortForDisplay($aliquot_data, $aliquot_ids);
		
		// SET MENU AND STRUCTURE DATA
		
		$atim_menu_link = '/InventoryManagement/';
		if($aliquot_master_id != null){
			// User is working on a collection		
			$atim_menu_link = ($aliquot_data[0]['SampleControl']['sample_category'] == 'specimen')? 
				'/InventoryManagement/AliquotMasters/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%AliquotMaster.id%%': 
				'/InventoryManagement/AliquotMasters/detail/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%';
			$this->set('atim_menu_variables', array(
				'Collection.id' => $aliquot_data[0]['AliquotMaster']['collection_id'], 
				'SampleMaster.id' => $aliquot_data[0]['AliquotMaster']['sample_master_id'], 
				'SampleMaster.initial_specimen_sample_id' => $aliquot_data[0]['SampleMaster']['initial_specimen_sample_id'], 
				'AliquotMaster.id' => $aliquot_data[0]['AliquotMaster']['id'])
			);
			$url_to_cancel = '/InventoryManagement/AliquotMasters/detail/'.$aliquot_data[0]['AliquotMaster']['collection_id'].'/'.$aliquot_data[0]['AliquotMaster']['sample_master_id'].'/'.$aliquot_data[0]['AliquotMaster']['id'].'/';
			
		} else {
			
			$unconsented_aliquots = $this->AliquotMaster->getUnconsentedAliquots(array('id' => $aliquot_ids));
			if(!empty($unconsented_aliquots)){
				AppController::addWarningMsg(__('aliquot(s) without a proper consent').": ".count($unconsented_aliquots));
			} 
		}
		
		$this->set('atim_menu', $this->Menus->get($atim_menu_link));
		
		$this->set('url_to_cancel', $url_to_cancel);
		$this->set('aliquot_master_id', $aliquot_master_id);
			
		$this->Structures->set('used_aliq_in_stock_details', "aliquots_structure");
		$this->Structures->set('used_aliq_in_stock_details,used_aliq_in_stock_detail_volume', 'aliquots_volume_structure');
		$this->Structures->set('aliquotinternaluses', 'aliquotinternaluses_structure');
		$this->Structures->set('aliquotinternaluses_volume,aliquotinternaluses', 'aliquotinternaluses_volume_structure');
		
		//MANAGE DATA
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
		
		if($initial_display){
			// Force $this->request->data to empty array() to override AliquotMaster.aliquot_volume_unit 
			$this->request->data = array();
			
			foreach($aliquot_data as $aliquot_data_unit){
				$this->request->data[] = array('parent' => $aliquot_data_unit, 'children' => array());
			}
			
		} else {
			$previous_data = $this->request->data;
			$this->request->data = array();
			
			//validate
			$errors = array();
			$aliquot_data_to_save = array();
			$uses_to_save = array();
			$line = 0;
			
			$sorted_aliquot_data = array();
			foreach($aliquot_data as $key => $data) {
				$sorted_aliquot_data[$data['AliquotMaster']['id']] = $data;
			}
				
			$record_counter = 0;
			foreach($previous_data as $key_aliquot_master_id => $data_unit){
				$record_counter++;
				
				if(!array_key_exists($key_aliquot_master_id, $sorted_aliquot_data)){
					$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true);
				}
				$aliquot_data = $sorted_aliquot_data[$key_aliquot_master_id];
								
				$data_unit['AliquotMaster']['id'] = $key_aliquot_master_id;
				$aliquot_data['AliquotMaster'] = $data_unit['AliquotMaster'];
				$this->AliquotMaster->data = null;
				unset($aliquot_data['AliquotMaster']['storage_coord_x']);
				unset($aliquot_data['AliquotMaster']['storage_coord_y']);
				$this->AliquotMaster->set($aliquot_data);
				if(!$this->AliquotMaster->validates()){
					foreach($this->AliquotMaster->validationErrors as $field => $msgs) {
						$msgs = is_array($msgs)? $msgs : array($msgs);
						foreach($msgs as $msg) $errors[$field][$msg][$record_counter] = $record_counter;						
					}
				}		
				$aliquot_data_to_save[] = array(
					'id'				=> $key_aliquot_master_id,
					'aliquot_control_id'=> $aliquot_data['AliquotControl']['id'],
					'in_stock'			=> $data_unit['AliquotMaster']['in_stock'],
					'in_stock_detail'	=> $data_unit['AliquotMaster']['in_stock_detail'],
					
					'tmp_remove_from_storage' => $data_unit['FunctionManagement']['remove_from_storage']
				);
				
				$parent = array(
					'AliquotMaster' => $data_unit['AliquotMaster'],
					'StorageMaster'	=> $data_unit['StorageMaster'],
					'FunctionManagement' => $data_unit['FunctionManagement'],
					'AliquotControl' => isset($data_unit['AliquotControl']) ? $data_unit['AliquotControl'] : array() 
				);
				
				unset($data_unit['AliquotMaster']);
				unset($data_unit['StorageMaster']);
				unset($data_unit['FunctionManagement']);
				unset($data_unit['AliquotControl']);
				
				if(empty($data_unit)){
					$errors['']['you must define at least one use for each aliquot'][$record_counter] = $record_counter;
				}
				foreach($data_unit as &$use_data_unit){
					$use_data_unit['AliquotInternalUse']['aliquot_master_id'] = $key_aliquot_master_id;
					$this->AliquotInternalUse->data = null;
					$this->AliquotInternalUse->set($use_data_unit);
					if(!$this->AliquotInternalUse->validates()){
						foreach($this->AliquotInternalUse->validationErrors as $field => $msgs) {
							$msgs = is_array($msgs)? $msgs : array($msgs);
							foreach($msgs as $msg) $errors[$field][$msg][$record_counter] = $record_counter;
						}
					}
					$use_data_unit = $this->AliquotInternalUse->data;
				}
				$uses_to_save = array_merge($uses_to_save, $data_unit);
				$this->request->data[] = array('parent' => $parent, 'children' => $data_unit);
			}
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}
			
			if(empty($errors)){

				//saving
				$this->AliquotInternalUse->addWritableField(array('aliquot_master_id'));
				$this->AliquotInternalUse->writable_fields_mode = 'addgrid';
				$this->AliquotInternalUse->saveAll($uses_to_save, array('validate' => false));
					
				foreach($aliquot_data_to_save as $new_aliquot_to_save) {
					if($new_aliquot_to_save['tmp_remove_from_storage']  || ($new_aliquot_to_save['in_stock'] == 'no')){
						$new_aliquot_to_save += array(
								'storage_master_id' => null,
								'storage_coord_x' => '',
								'storage_coord_y' => ''
						);
						$this->AliquotMaster->addWritableField(array('storage_master_id', 'storage_coord_x', 'storage_coord_y'));
					} else {
						$this->AliquotMaster->removeWritableField(array('storage_master_id', 'storage_coord_x', 'storage_coord_y'));
					}
					unset($new_aliquot_to_save['tmp_remove_from_storage']);
					
					$this->AliquotMaster->id = $new_aliquot_to_save['id'];
					if(!$this->AliquotMaster->save($new_aliquot_to_save, false)) $this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
				}
				
				foreach($aliquot_ids as $tmp_aliquot_master_id){
					$this->AliquotMaster->updateAliquotUseAndVolume($tmp_aliquot_master_id, true, true, false);
				}
				
				$hook_link = $this->hook('post_process');
				if($hook_link){
					require($hook_link);
				}
				
				if($aliquot_master_id != null){
					$this->atimFlash('your data has been saved', $url_to_cancel);
				
				}else{
					//batch
					$last_id = $this->AliquotInternalUse->getLastInsertId();
					$batch_ids = range($last_id - count($uses_to_save) + 1, $last_id);
					foreach($batch_ids as &$batch_id){
						//add the "6" suffix to work with the view
						$batch_id = $batch_id."6";
					}
					
					$datamart_structure = AppModel::getInstance("Datamart", "DatamartStructure", true);
					
					$batch_set_data = array('BatchSet' => array( 
						'datamart_structure_id'	=> $datamart_structure->getIdByModelName('ViewAliquotUse'),
						'flag_tmp' => true
					));
					
					$batch_set_model = AppModel::getInstance('Datamart', 'BatchSet', true);
					$batch_set_model->saveWithIds($batch_set_data, $batch_ids);
					
					$this->atimFlash('your data has been saved', '/Datamart/BatchSets/listall/'.$batch_set_model->getLastInsertId());
					
				}
			}else{
				$this->AliquotMaster->validationErrors = array();
				$this->AliquotInternalUse->validationErrors = array();
				foreach($errors as $field => $msg_and_lines) {
					foreach($msg_and_lines as $msg => $lines) {
						$this->AliquotMaster->validationErrors[$field][] = __($msg) .(($record_counter != 1)? ' - ' . str_replace('%s', implode(",", $lines), __('see # %s')) : '');
					}
				}
			}
		}
	}
	
	function detailAliquotInternalUse($aliquot_master_id, $aliquot_use_id) {
		if((!$aliquot_master_id) || (!$aliquot_use_id)) { 
			$this->redirect('/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); 
		}
			
 		// MANAGE DATA

		// Get the use data
		
		$this->AliquotMaster;//lazy load
		$use_data = $this->AliquotInternalUse->find('first', array(
			'fields' => array('*'),
			'conditions' => array('AliquotInternalUse.aliquot_master_id' => $aliquot_master_id, 'AliquotInternalUse.id' => $aliquot_use_id),
			'joins' => array(AliquotMaster::joinOnAliquotDup('AliquotInternalUse.aliquot_master_id'), AliquotMaster::$join_aliquot_control_on_dup))
		);
		if(empty($use_data)) { 
			$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		}		
		$this->request->data = $use_data;		
		
		// Get Sample Data
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $use_data['AliquotMaster']['collection_id'], 'SampleMaster.id' => $use_data['AliquotMaster']['sample_master_id']), 'recursive' => '0'));
		if(empty($sample_data)) { 
			$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		}	
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Get the current menu object.
		$atim_menu_link = ($sample_data['SampleControl']['sample_category'] == 'specimen')? 
			'/InventoryManagement/AliquotMasters/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%AliquotMaster.id%%': 
			'/InventoryManagement/AliquotMasters/detail/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%';
		$this->set('atim_menu', $this->Menus->get($atim_menu_link));
		$this->set('atim_menu_variables', 
			array('Collection.id' => $use_data['AliquotMaster']['collection_id'], 
				'SampleMaster.id' => $use_data['AliquotMaster']['sample_master_id'], 
				'SampleMaster.initial_specimen_sample_id' => $sample_data['SampleMaster']['initial_specimen_sample_id'], 
				'AliquotMaster.id' => $aliquot_master_id));
			
		// Set structure
		$this->Structures->set(empty($use_data['AliquotControl']['volume_unit'])? 'aliquotinternaluses' : 'aliquotinternaluses,aliquotinternaluses_volume');
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
	}	
	
	function editAliquotInternalUse($aliquot_master_id, $aliquot_use_id) {
		if((!$aliquot_master_id) || (!$aliquot_use_id)) { $this->redirect('/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); }
			
 		// MANAGE DATA

		// Get the use data
		$this->AliquotMaster;//lazy load
		$use_data = $this->AliquotInternalUse->find('first', array(
			'fields' => array('*'),
			'conditions' => array('AliquotInternalUse.aliquot_master_id' => $aliquot_master_id, 'AliquotInternalUse.id' => $aliquot_use_id),
			'joins' => array(
				AliquotMaster::joinOnAliquotDup('AliquotInternalUse.aliquot_master_id'), 
				AliquotMaster::$join_aliquot_control_on_dup)
			)
		);
		if(empty($use_data)) { 
			$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		}	
		
		// Get Sample Data
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $use_data['AliquotMaster']['collection_id'], 'SampleMaster.id' => $use_data['AliquotMaster']['sample_master_id']), 'recursive' => '0'));
		if(empty($sample_data)) { 
			$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		}	
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Get the current menu object.
		$this->setAliquotMenu(array_merge($sample_data, $use_data));
			
		// Set structure
		$this->Structures->set('aliquotinternaluses');
		$this->Structures->set(empty($use_data['AliquotControl']['volume_unit'])? 'aliquotinternaluses' : 'aliquotinternaluses,aliquotinternaluses_volume');
		
		$this->set('aliquot_use_id', $aliquot_use_id);
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
					
		// MANAGE DATA RECORD
		
		if(empty($this->request->data)) {
			$this->request->data = $use_data;
			
			$hook_link = $this->hook('initial_display');
			if($hook_link){
				require($hook_link);
			}
			
		} else {
			
			// Launch validations		
			$submitted_data_validates = true;
			
			if((!empty($this->request->data['AliquotInternalUse']['used_volume'])) && empty($use_data['AliquotControl']['volume_unit'])) {
				// No volume has to be recored for this aliquot type				
				$this->AliquotInternalUse->validationErrors['used_volume'][] = 'no volume has to be recorded for this aliquot type';	
				$submitted_data_validates = false;			
			} else if(empty($this->request->data['AliquotInternalUse']['used_volume'])) {
				// Change '0' to null
				$this->request->data['AliquotInternalUse']['used_volume'] = null;
			}
			
			$this->AliquotInternalUse->writable_fields_mode = 'addgrid';
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link); 
			}
			
			// if data VALIDATE, then save data
			if ($submitted_data_validates) {
				$this->AliquotInternalUse->id = $aliquot_use_id;			
				if ($this->AliquotInternalUse->save($this->request->data)) {
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) {
						require($hook_link);
					}
					if(!$this->AliquotMaster->updateAliquotUseAndVolume($aliquot_master_id, true, false)) { 
						$this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true); 
					}
					$this->atimFlash('your data has been saved', '/InventoryManagement/AliquotMasters/detailAliquotInternalUse/' . $aliquot_master_id . '/' . $aliquot_use_id . '/');
				} 
			}
		}
	}
	
	function deleteAliquotInternalUse($aliquot_master_id, $aliquot_use_id) {
		if((!$aliquot_master_id) || (!$aliquot_use_id)) { $this->redirect('/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); }	
		
 		// MANAGE DATA
		
		// Get the use data
		$use_data = $this->AliquotInternalUse->find('first', array('conditions' => array('AliquotInternalUse.aliquot_master_id' => $aliquot_master_id, 'AliquotInternalUse.id' => $aliquot_use_id)));
		if(empty($use_data)) { 
			$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		}	
		
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }

		$flash_url = '/InventoryManagement/AliquotMasters/detail/' . $use_data['AliquotMaster']['collection_id'] . '/' . $use_data['AliquotMaster']['sample_master_id'] . '/' . $aliquot_master_id;		
		
		// LAUNCH DELETION
		$deletion_done = true;
		
		// -> Delete use
		if($deletion_done) {
			if(!$this->AliquotInternalUse->atimDelete($aliquot_use_id)) { $deletion_done = false; }	
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
		// MANAGE DATA

		// Get Sample data
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id), 'recursive' => '0'));
		if(empty($sample_data)) { 
			$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
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
			'OR' => array(array('AliquotControl.volume_unit' => ''), array('AliquotControl.volume_unit' => NULL)),
			'NOT' => array('AliquotMaster.id' => $existing_source_aliquot_ids)
		);
		$available_sample_aliquots_wo_volume = $this->AliquotMaster->find('all', array('conditions' => $criteria, 'order' => 'AliquotMaster.barcode ASC', 'recursive' => '0'));
		unset($criteria['OR']);
		$criteria['NOT']['OR'] = array(array('AliquotControl.volume_unit' => ''), array('AliquotControl.volume_unit' => NULL));
		$available_sample_aliquots_w_volume = $this->AliquotMaster->find('all', array('conditions' => $criteria, 'order' => 'AliquotMaster.barcode ASC', 'recursive' => '0'));
		
		if(empty($available_sample_aliquots_w_volume) && empty($available_sample_aliquots_wo_volume)){
			$this->flash('no new sample aliquot could be actually defined as source aliquot', '/InventoryManagement/SampleMasters/detail/' . $collection_id . '/' . $sample_master_id);
		}
		$available_sample_aliquots = array(
			'vol' 		=> $available_sample_aliquots_w_volume,
			'no_vol'	=> $available_sample_aliquots_wo_volume
		);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set('atim_menu', $this->Menus->get('/InventoryManagement/SampleMasters/detail/%%Collection.id%%/%%SampleMaster.id%%'));	
	
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

		if (empty($this->request->data)) {
			$this->request->data = $available_sample_aliquots;
			
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
			foreach($this->request->data as &$types_array_pointers){
				foreach($types_array_pointers as &$data_unit_pointer){
					$unified_data_pointers[] = &$data_unit_pointer;
				}
			}
			foreach($unified_data_pointers as &$studied_aliquot_pointer){
				$line_counter++;
				
				if($studied_aliquot_pointer['FunctionManagement']['use']){
					// New aliquot defined as source
				
					// Check volume
					
					if((!empty($studied_aliquot_pointer['SourceAliquot']['used_volume'])) && empty($studied_aliquot_pointer['AliquotControl']['volume_unit'])) {
						// No volume has to be recored for this aliquot type				
						$errors['SourceAliquot']['used_volume']['no volume has to be recorded for this aliquot type'][] = $line_counter; 
						$submitted_data_validates = false;			
					} else if(empty($studied_aliquot_pointer['SourceAliquot']['used_volume'])) {
						// Change '0' to null
						$studied_aliquot_pointer['SourceAliquot']['used_volume'] = null;
					}
					
					// Launch Aliquot Master validation
					$this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
					
					$tmp_StorageMaster = $studied_aliquot_pointer['StorageMaster'];
					$tmp_storage_coord_x = $studied_aliquot_pointer['AliquotMaster']['storage_coord_x'];
					$tmp_storage_coord_y = $studied_aliquot_pointer['AliquotMaster']['storage_coord_y'];				
					unset($studied_aliquot_pointer['StorageMaster']);
					unset($studied_aliquot_pointer['AliquotMaster']['storage_coord_x']);
					unset($studied_aliquot_pointer['AliquotMaster']['storage_coord_y']);
					
					$this->AliquotMaster->set($studied_aliquot_pointer);
					$this->AliquotMaster->id = $studied_aliquot_pointer['AliquotMaster']['id'];
					
					$submitted_data_validates = ($this->AliquotMaster->validates()) ? $submitted_data_validates : false;				
					foreach($this->AliquotMaster->validationErrors as $field => $msgs) {
						$msgs = is_array($msgs)? $msgs : array($msgs);
						foreach($msgs as $msg) $errors['AliquotMaster'][$field][$msg][] = $line_counter;
					}
										
					// Reset data to get position data (not really required for this function)
					$studied_aliquot_pointer = $this->AliquotMaster->data;	
					
					$studied_aliquot_pointer['StorageMaster'] = $tmp_StorageMaster;		
					$studied_aliquot_pointer['AliquotMaster']['storage_coord_x'] = $tmp_storage_coord_x;
					$studied_aliquot_pointer['AliquotMaster']['storage_coord_y'] = $tmp_storage_coord_y;	
					
					// Launch Aliquot Source validation
					$this->SourceAliquot->set($studied_aliquot_pointer);
					$submitted_data_validates = ($this->SourceAliquot->validates()) ? $submitted_data_validates : false;	
					foreach($this->SourceAliquot->validationErrors as $field => $msgs) {
						$msgs = is_array($msgs)? $msgs : array($msgs);
						foreach($msgs as $msg) $errors['SourceAliquot'][$field][$msg][] = $line_counter;
					}
					
					// Add record to array of tested aliquots
					$aliquots_defined_as_source_pointers[] = $studied_aliquot_pointer;		
				}
			}
			
			if(empty($aliquots_defined_as_source_pointers)) { 
				$this->SourceAliquot->validationErrors['use'][] = 'no aliquot has been defined as source aliquot';	
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
							$this->{$model}->validationErrors[$field][] = __($message) . ' - ' . str_replace('%s', implode(",", $lines), __('see line %s'));
						}
					}
				}
				
			} else {
				// Launch save process
				// Parse records to save
				
				$this->AliquotMaster->writable_fields_mode = 'editgrid';
				
				$this->SourceAliquot->addWritableField(array('aliquot_master_id', 'sample_master_id'));
				$this->SourceAliquot->writable_fields_mode = 'editgrid';
				
				foreach($aliquots_defined_as_source_pointers as $source_aliquot_pointer) {
					// Get Source Aliquot Master Id
					$aliquot_master_id = $source_aliquot_pointer['AliquotMaster']['id'];
					
					// Set aliquot master data					
					if($source_aliquot_pointer['FunctionManagement']['remove_from_storage'] || ($source_aliquot_pointer['AliquotMaster']['in_stock'] == 'no')) {
						// Delete aliquot storage data
						$source_aliquot_pointer['AliquotMaster']['storage_master_id'] = null;
						$source_aliquot_pointer['AliquotMaster']['storage_coord_x'] = '';
						$source_aliquot_pointer['AliquotMaster']['storage_coord_y'] = '';
						$this->AliquotMaster->addWritableField(array('storage_master_id', 'storage_coord_x', 'storage_coord_y'));
					}else{
						$this->AliquotMaster->removeWritableField(array('storage_master_id', 'storage_coord_x', 'storage_coord_y'));
					}
					
					// Save data:
					// - AliquotMaster
					$this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
					$this->AliquotMaster->id = $aliquot_master_id;

					if(!$this->AliquotMaster->save($source_aliquot_pointer, false)) { 
						$this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true); 
					}
					
					// - SourceAliquot
					$this->SourceAliquot->id = null;
					$source_aliquot_pointer['SourceAliquot']['aliquot_master_id'] = $aliquot_master_id;
					$source_aliquot_pointer['SourceAliquot']['sample_master_id'] = $sample_master_id;
					//barcode,aliquot_label,storage_coord_x,storage_coord_y
					if(!$this->SourceAliquot->save($source_aliquot_pointer)) { 
						$this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true); 
					}

					// - Update aliquot current volume
					if(!$this->AliquotMaster->updateAliquotUseAndVolume($aliquot_master_id, true, true)) { 
						$this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true); 
					}
				}
				
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) { 
					require($hook_link); 
				}
				$this->atimFlash(__('your data has been saved').'<br>'.__('aliquot storage data were deleted (if required)'), 
					'/InventoryManagement/SampleMasters/detail/' . $collection_id . '/' . $sample_master_id); 
			}
		}
	}
	
	function editSourceAliquot($sample_master_id, $aliquot_master_id){
		// Get the realiquoting data
		$source_data = $this->SourceAliquot->find('first', array('conditions' => array('SourceAliquot.sample_master_id' => $sample_master_id, 'SourceAliquot.aliquot_master_id' => $aliquot_master_id)));
		if(empty($source_data)) {
			$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		$source_data['AliquotControl'] = $this->AliquotControl->getOrRedirect($source_data['AliquotMaster']['aliquot_control_id']);
		$source_data['AliquotControl'] = $source_data['AliquotControl']['AliquotControl'];
	
		$flash_url = '/InventoryManagement/SampleMasters/detail/' . $source_data['SampleMaster']['collection_id'] . '/' . $source_data['SampleMaster']['id'];
		
		$show_submit_button = true;
		if(empty($source_data['AliquotControl']['volume_unit'])) {
			$this->Structures->set('sourcealiquots');
			$show_submit_button = false; //To allow custom code to display page
		} else {
			$this->Structures->set('sourcealiquots,sourcealiquots_volume');
		}
		$this->set('show_submit_button', $show_submit_button);
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
		
		if(!$show_submit_button) AppController::addWarningMsg(__('no source aliquot data has to be updated'));
		
		if($this->request->data){		
			$this->SourceAliquot->id = $source_data['SourceAliquot']['id'];
			$this->SourceAliquot->data = array();
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}
			
			if($this->SourceAliquot->save($this->request->data)){
				$this->AliquotMaster->updateAliquotUseAndVolume($source_data['AliquotMaster']['id'], true, false, false);
				
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) {
					require($hook_link);
				}				
				
				$this->atimFlash('your data has been saved', '/InventoryManagement/SampleMasters/detail/'.$source_data['SampleMaster']['collection_id'].'/'.$source_data['SampleMaster']['id']);
			}
		}else{
			$this->request->data = $source_data;
		}
		
		$this->set('atim_menu', $this->Menus->get('/InventoryManagement/SampleMasters/detail/%%Collection.id%%/%%SampleMaster.id%%'));
		$this->set('atim_menu_variables', array(
				'Collection.id' => $source_data['SampleMaster']['collection_id'],
				'SampleMaster.id' => $source_data['SampleMaster']['id'],
				'SampleMaster.initial_specimen_sample_id' => $source_data['SampleMaster']['initial_specimen_sample_id'],
				'AliquotMaster.id' => $source_data['AliquotMaster']['id'])
		);
	}
	
	function deleteSourceAliquot($sample_master_id, $aliquot_master_id) {
		if((!$sample_master_id) || (!$aliquot_master_id)) { $this->redirect('/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); }	

 		// MANAGE DATA
		
		// Get the realiquoting data
		$source_data = $this->SourceAliquot->find('first', array('conditions' => array('SourceAliquot.sample_master_id' => $sample_master_id, 'SourceAliquot.aliquot_master_id' => $aliquot_master_id)));
		if(empty($source_data)) { 
			$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		}				
			
		$hook_link = $this->hook('delete');
		if( $hook_link ) { 
			require($hook_link); 
		}
			
		// LAUNCH DELETION
		// -> Delete Realiquoting
		$deletion_done = $this->SourceAliquot->atimDelete($source_data['SourceAliquot']['id']);	
		
		// -> Update volume
		if($deletion_done) {
			$deletion_done = $this->AliquotMaster->updateAliquotUseAndVolume($source_data['AliquotMaster']['id'], true, true);
		}
		
		$flash_url = '/InventoryManagement/SampleMasters/detail/' . $source_data['SampleMaster']['collection_id'] . '/' . $source_data['SampleMaster']['id'];
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
			$aliquot = $this->AliquotMaster->getOrRedirect($aliquot_id);
			$aliquot = $aliquot['AliquotMaster'];
			$this->request->data['url_to_cancel'] = sprintf('/InventoryManagement/AliquotMasters/detail/%d/%d/%d', $aliquot['collection_id'], $aliquot['sample_master_id'], $aliquot['id']);
			$ids = array($aliquot_id);
		}else{
			if(isset($this->request->data['AliquotMaster'])) {
				$ids = $this->request->data['AliquotMaster']['id'];
			} else if(isset($this->request->data['ViewAliquot'])) {
				$ids = $this->request->data['ViewAliquot']['aliquot_master_id'];
			} else {
				$this->flash((__('you have been redirected automatically').' (#'.__LINE__.')'), "javascript:history.back();", 5);
				return;
			}
			if(!is_array($ids) && strpos($ids, ',')){
				//User launched action from databrowser but the number of items was bigger than DatamartAppController->display_limit
				$this->flash(__("batch init - number of submitted records too big"), "javascript:history.back();", 5);
				return;
			}
			$ids = array_filter($ids);	
		}		
		$ids[] = 0;
		
		// Find parent(s) aliquot
		$this->AliquotMaster->unbindModel(array(
			'hasOne' => array('SpecimenDetail'),
			'belongsTo' => array('Collection','StorageMaster')));
		$aliquots = $this->AliquotMaster->findAllById($ids);
		if(empty($aliquots)){
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		
		$this->set('aliquot_id', $aliquot_id);
		$this->setUrlToCancel();
		
		// Check aliquot & sample types of the selected aliquots are identical
		$aliquot_ctrl_id = $aliquots[0]['AliquotMaster']['aliquot_control_id'];
		$sample_ctrl_id = $aliquots[0]['SampleMaster']['sample_control_id'];
		if(count($aliquots) > 1){
			foreach($aliquots as $aliquot){
				if(($aliquot['AliquotMaster']['aliquot_control_id'] != $aliquot_ctrl_id) || ($aliquot['SampleMaster']['sample_control_id'] != $sample_ctrl_id)) {
					$this->flash(__("you cannot realiquot those elements together because they are of different types"), "javascript:history.back();");
					return;
				}
			}
		}
		
		// Build list of aliquot type that could be created from the sources for display
		$possible_ctrl_ids = $this->RealiquotingControl->getAllowedChildrenCtrlId($sample_ctrl_id, $aliquot_ctrl_id);
		if(empty($possible_ctrl_ids)){
			$this->flash(__("you cannot realiquot those elements"), "javascript:history.back();", 5);
			return;
		}
		
		$aliquot_ctrls = $this->AliquotControl->findAllById($possible_ctrl_ids);
		assert(!empty($aliquot_ctrls));
		foreach($aliquot_ctrls as $aliquot_ctrl){
			$dropdown[$aliquot_ctrl['AliquotControl']['id']] = __($aliquot_ctrl['AliquotControl']['aliquot_type']);
		}
		AliquotMaster::$aliquot_type_dropdown = $dropdown;
		
		// Set data
		$this->request->data = array();
		$this->request->data[0]['ids'] = implode(",", $ids);
		
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
				$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		$this->set('process_type', $process_type);
		
		// Set structure and menu
		$this->Structures->set('aliquot_type_selection');
		
		if(empty($aliquot_id)) {
			$this->set('atim_menu', $this->Menus->get('/InventoryManagement/'));
		} else {
			$this->setAliquotMenu($aliquots[0]);
		}
		
		$this->set('skip_lab_book_selection_step', true);
		
		// Hook Call
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
	}

	function realiquotInit2($process_type, $aliquot_id = null){
			
		if(!isset($this->request->data['sample_ctrl_id']) || !isset($this->request->data['realiquot_from']) || !isset($this->request->data[0]['realiquot_into']) || !isset($this->request->data[0]['ids'])){
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		} else if($this->request->data[0]['realiquot_into'] == ''){
			$this->flash(__("you must select an aliquot type"), "javascript:history.back();", 5);
			return;
		}
		
		$this->set('sample_ctrl_id', $this->request->data['sample_ctrl_id']);
		$this->set('aliquot_id', $aliquot_id);
		$this->set('realiquot_from', $this->request->data['realiquot_from']);
		$this->set('realiquot_into', $this->request->data[0]['realiquot_into']);
		$this->set('ids', $this->request->data[0]['ids']);
		$this->setUrlToCancel();
		
		switch($process_type) {
			case 'creation':
				$this->set('realiquoting_function', 'realiquot');
				break;
			case 'definition':
				$this->set('realiquoting_function', 'defineRealiquotedChildren');
				break;
			default:
				$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		
		$this->AliquotMaster->unbindModel(array(
			'hasOne' => array('SpecimenDetail'),
			'belongsTo' => array('Collection','StorageMaster')));
		$aliquot_data = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.id' => $this->request->data[0]['ids'])));
		$sample_ctrl_id = $aliquot_data['SampleMaster']['sample_control_id'];
		if($sample_ctrl_id != $this->request->data['sample_ctrl_id']) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		$lab_book_ctrl_id = $this->RealiquotingControl->getLabBookCtrlId($sample_ctrl_id, $this->request->data['realiquot_from'], $this->request->data[0]['realiquot_into']);
		
		if(is_numeric($lab_book_ctrl_id)){
			$this->set('lab_book_ctrl_id', $lab_book_ctrl_id);
			$this->Structures->set('realiquoting_lab_book');
			AppController::addWarningMsg(__('if no lab book has to be defined for this process, keep fields empty and click submit to continue'));
		}else{
			$this->Structures->set('empty');
			AppController::addWarningMsg(__('no lab book can be defined for that realiquoting').' '.__('click submit to continue'));
		}
		
		if(empty($aliquot_id)) {
			$this->set('atim_menu', $this->Menus->get('/InventoryManagement/'));
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
		if(empty($this->request->data)){ 
			$this->flash((__('you have been redirected automatically').' (#'.__LINE__.')'), "javascript:history.back();", 5);
			return;
		} else if(isset($this->request->data[0]) && isset($this->request->data[0]['ids'])){ 
			if($this->request->data[0]['realiquot_into'] == ''){
				$this->flash(__("you must select an aliquot type"), "javascript:history.back();", 5);
				return;
			}
			$initial_display = true;
			$parent_aliquots_ids = $this->request->data[0]['ids'];
		} else if(isset($this->request->data['ids'])) {
			$initial_display = false;
			$parent_aliquots_ids = $this->request->data['ids'];			
		} else {
			$this->redirect("/Pages/err_no_data?method='.__METHOD__.',line='.__LINE__", null, true); 
		}
		$this->set('parent_aliquots_ids', $parent_aliquots_ids);
		
		// Get parent an child control data
		$parent_aliquot_ctrl_id = isset($this->request->data['realiquot_from'])? $this->request->data['realiquot_from']: null;
		$child_aliquot_ctrl_id = isset($this->request->data[0]['realiquot_into'])? $this->request->data[0]['realiquot_into'] : (isset($this->request->data['realiquot_into'])? $this->request->data['realiquot_into'] : null);		
		$parent_aliquot_ctrl = $this->AliquotControl->findById($parent_aliquot_ctrl_id);
		$child_aliquot_ctrl = ($parent_aliquot_ctrl_id == $child_aliquot_ctrl_id)? $parent_aliquot_ctrl : $this->AliquotControl->findById($child_aliquot_ctrl_id);		
		if(empty($parent_aliquot_ctrl) || empty($child_aliquot_ctrl)) { 
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
		}
		
		// lab book management
		$lab_book = null;//lab book object
		$lab_book_expected_ctrl_id = null;
		$lab_book_code = null;
		$lab_book_id = null;
		$sync_with_lab_book = null;
		$lab_book_fields = array();
		if(isset($this->request->data['Realiquoting']) && isset($this->request->data['Realiquoting']['lab_book_master_code']) && (strlen($this->request->data['Realiquoting']['lab_book_master_code']) > 0 || $this->request->data['Realiquoting']['sync_with_lab_book'])){
			$lab_book = AppModel::getInstance("LabBook", "LabBookMaster", true);
			$sample_ctrl_id = isset($this->request->data['sample_ctrl_id'])? $this->request->data['sample_ctrl_id']: null;
			$lab_book_expected_ctrl_id = $this->RealiquotingControl->getLabBookCtrlId($sample_ctrl_id, $parent_aliquot_ctrl_id, $child_aliquot_ctrl_id);
			$sync_response = $lab_book->syncData($this->request->data, array(), $this->request->data['Realiquoting']['lab_book_master_code'], $lab_book_expected_ctrl_id);
			if(is_numeric($sync_response)){
				$lab_book_id = $sync_response;
				$lab_book_fields = $lab_book->getFields($lab_book_expected_ctrl_id);
				$lab_book_code = $this->request->data['Realiquoting']['lab_book_master_code'];
				$sync_with_lab_book = $this->request->data['Realiquoting']['sync_with_lab_book']; 
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
			$this->set('atim_menu', $this->Menus->get('/InventoryManagement/'));
		} else {
			$parent = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.id' => $aliquot_id), 'recursive' => '0'));
			if(empty($parent)){
				$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}
			$this->setAliquotMenu($parent);
		}
				
		$this->set('realiquot_from', $parent_aliquot_ctrl_id);
		$this->set('realiquot_into', $child_aliquot_ctrl_id);
		$this->set('sample_ctrl_id', $this->request->data['sample_ctrl_id']);
		
		//AliquotMaster is used for parent save and child save. The parent detail might change from parent to parent.
		//We need to manage writable fields
		$this->Structures->set('used_aliq_in_stock_details', 'in_stock_detail', array('model_table_assoc' => array('AliquotDetail' => 'tmp_detail_table')));
		$parent_no_vol_writable_fields = AppModel::$writable_fields;
		AppModel::$writable_fields = array();
		$this->Structures->set('used_aliq_in_stock_details,used_aliq_in_stock_detail_volume', 'in_stock_detail_volume', array('model_table_assoc' => array('AliquotDetail' => 'tmp_detail_table')));
		$parent_vol_writable_fields = AppModel::$writable_fields;
		AppModel::$writable_fields = array();
		$this->Structures->set($child_aliquot_ctrl['AliquotControl']['form_alias'].(empty($parent_aliquot_ctrl['AliquotControl']['volume_unit'])? ',realiquot_without_vol': ',realiquot_with_vol'), 'atim_structure', array('model_table_assoc' => array('AliquotDetail' => $child_aliquot_ctrl['AliquotControl']['detail_tablename'])));
		$child_writable_fields = AppModel::$writable_fields;
		AppModel::$writable_fields = array();
		$this->setUrlToCancel();
		
		$this->Structures->set('empty', 'empty_structure');
		
		// set data for initial data to allow bank to override data
		$created_aliquot_override_data = array(
			'AliquotControl.aliquot_type' => $child_aliquot_ctrl['AliquotControl']['aliquot_type'],
			'AliquotMaster.storage_datetime' => date('Y-m-d G:i'),
			'AliquotMaster.in_stock' => 'yes - available',
	
			'Realiquoting.realiquoting_datetime' => date('Y-m-d G:i')
		);
		if(!empty($child_aliquot_ctrl['AliquotControl']['volume_unit'])){
			$created_aliquot_override_data['AliquotControl.volume_unit'] = $child_aliquot_ctrl['AliquotControl']['volume_unit'];
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
				$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
			}
			
			$this->AliquotMaster->sortForDisplay($parent_aliquots, $parent_aliquots_ids);
			
			//build data array
			$this->request->data = array();
			foreach($parent_aliquots as $parent_aliquot){
				if($parent_aliquot_ctrl_id != $parent_aliquot['AliquotMaster']['aliquot_control_id']) { 
					$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
				}
				$this->request->data[] = array('parent' => $parent_aliquot, 'children' => array());
			}
			
			$hook_link = $this->hook('initial_display');
			if($hook_link){
				require($hook_link);
			}	
			
		}else{

			unset($this->request->data['sample_ctrl_id']);
			unset($this->request->data['realiquot_into']);
			unset($this->request->data['realiquot_from']);
			unset($this->request->data['ids']);
			unset($this->request->data['Realiquoting']);
			unset($this->request->data['url_to_cancel']);
			
			// 2- VALIDATE PROCESS
		
			$errors = array();
			$validated_data = array();
			$record_counter = 0;
			
			foreach($this->request->data as $parent_id => $parent_and_children) {
				$record_counter++;
				
				//A- Validate parent aliquot data
				
				$this->AliquotMaster->id = null;
				$this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
				
				$parent_aliquot_data = $parent_and_children['AliquotMaster'];
				$parent_aliquot_data['id'] = $parent_id;
				$parent_aliquot_data['aliquot_control_id'] = $parent_aliquot_ctrl_id;
				unset($parent_aliquot_data['storage_coord_x']);
				unset($parent_aliquot_data['storage_coord_y']);
				
				$this->AliquotMaster->set(array("AliquotMaster" => $parent_aliquot_data));
				if(!$this->AliquotMaster->validates()){
					foreach($this->AliquotMaster->validationErrors as $field => $msgs) {
						$msgs = is_array($msgs)? $msgs : array($msgs);
						foreach($msgs as $msg) $errors[$field][$msg][$record_counter] = $record_counter;
					}
				}
				
				// Set parent data to $validated_data
				$validated_data[$parent_id]['parent']['AliquotMaster'] = $parent_aliquot_data;
				$validated_data[$parent_id]['parent']['AliquotMaster']['storage_coord_x'] = $parent_and_children['AliquotMaster']['storage_coord_x'];
				$validated_data[$parent_id]['parent']['AliquotMaster']['storage_coord_y'] = $parent_and_children['AliquotMaster']['storage_coord_y'];
				
				$validated_data[$parent_id]['parent']['FunctionManagement'] = $parent_and_children['FunctionManagement'];
				$validated_data[$parent_id]['parent']['AliquotControl'] = $parent_and_children['AliquotControl'];
				$validated_data[$parent_id]['parent']['StorageMaster'] = $parent_and_children['StorageMaster'];
				
				$validated_data[$parent_id]['children'] = array();
				
				//B- Validate new aliquot created + realiquoting data
				
				$new_aliquot_created = false;
				$child_got_volume = false;
				foreach($parent_and_children as $tmp_id => $child) {
					
					if(is_numeric($tmp_id)) {
						$new_aliquot_created = true;
						
						// ** Aliquot **
							
						// Set AliquotMaster.initial_volume
						if(array_key_exists('initial_volume', $child['AliquotMaster'])){
							if(empty($child_aliquot_ctrl['AliquotControl']['volume_unit'])){
								$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
							}
							$child['AliquotMaster']['current_volume'] = $child['AliquotMaster']['initial_volume'];
							$child_got_volume = true;
						}
						
						// Validate and update position data
						$this->AliquotMaster->id = null;
						$this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
						
						$child['AliquotMaster']['id'] = null;
						$child['AliquotMaster']['aliquot_control_id'] = $child_aliquot_ctrl_id;
						$child['AliquotMaster']['sample_master_id'] = $validated_data[$parent_id]['parent']['AliquotMaster']['sample_master_id'];
						$child['AliquotMaster']['collection_id'] = $validated_data[$parent_id]['parent']['AliquotMaster']['collection_id'];
						
						$this->AliquotMaster->set($child);
						if(!$this->AliquotMaster->validates()){
							foreach($this->AliquotMaster->validationErrors as $field => $msgs) {
								$msgs = is_array($msgs)? $msgs : array($msgs);
								foreach($msgs as $msg) $errors[$field][$msg][$record_counter] = $record_counter;
							}
						}
						// Reset data to get position data
						$child = $this->AliquotMaster->data;						

						// ** Realiquoting **					
						$this->Realiquoting->set(array('Realiquoting' =>  $child['Realiquoting']));
						if(!$this->Realiquoting->validates()){
							foreach($this->Realiquoting->validationErrors as $field => $msgs) {
								$msgs = is_array($msgs)? $msgs : array($msgs);
								foreach($msgs as $msg) $errors[$field][$msg][$record_counter] = $record_counter;
							}
						}
						$child['Realiquoting'] = $this->Realiquoting->data['Realiquoting'];
						
						// Check volume can be completed
						if((!empty($child['Realiquoting']['parent_used_volume'])) && empty($child['GeneratedParentAliquot']['aliquot_volume_unit'])) {
							// No volume has to be recored for this aliquot type				
							$errors['parent_used_volume']['no volume has to be recorded when the volume unit field is empty'][$record_counter] = $record_counter;
						}
						
						// Set child data to $validated_data
						$validated_data[$parent_id]['children'][$tmp_id] = $child;
					}
				}
				
				if(!$new_aliquot_created){
					$errors[]['at least one child has to be created'][$record_counter] = $record_counter;
				}
			}
			
			$this->request->data = $validated_data;
			
			if(empty($errors) && !empty($lab_book_code)){
				//this time we do synchronize with the lab book
				foreach($this->request->data as $key => &$new_data_set) {
					$lab_book->syncData($new_data_set['children'], array('Realiquoting'), $lab_book_code);
				}	
			}

			$child_writable_fields['aliquot_masters']['addgrid'] = array_merge($child_writable_fields['aliquot_masters']['addgrid'], array('collection_id', 'sample_master_id', 'aliquot_control_id', 'storage_coord_x', 'storage_coord_y', 'storage_master_id'));
			$this->Realiquoting->writable_fields_mode = 'addgrid';
			$child_writable_fields['realiquotings']['addgrid'] = array_merge($child_writable_fields['realiquotings']['addgrid'], array('parent_aliquot_master_id', 'child_aliquot_master_id', 'lab_book_master_id', 'sync_with_lab_book'));
			if($child_got_volume){
				$child_writable_fields['aliquot_masters']['addgrid'][] = 'current_volume';
			}
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}				
			
			// 3- SAVE PROCESS
			
			if(empty($errors)) {
				$new_aliquot_ids = array(); 
				foreach($this->request->data as $parent_id => $parent_and_children){
					
					// A- Save parent aliquot data
					
					$this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
					$this->AliquotMaster->id = $parent_id;
					
					$parent_data = $parent_and_children['parent'];
					$storage_writable_fields = array();
					if($parent_data['FunctionManagement']['remove_from_storage'] || ($parent_data['AliquotMaster']['in_stock'] == 'no')) {
						// Delete storage data
						$parent_data['AliquotMaster']['storage_master_id'] = null;
						$parent_data['AliquotMaster']['storage_coord_x'] = '';
						$parent_data['AliquotMaster']['storage_coord_y'] = '';
						$storage_writable_fields = array('storage_master_id', 'storage_coord_x', 'storage_coord_y');
					}
					
					$parent_data['AliquotMaster']['id'] = $parent_id;
					$org_parent_data = $this->AliquotMaster->getOrRedirect($parent_id);
					AppModel::$writable_fields = $org_parent_data['AliquotControl']['volume_unit'] ? $parent_vol_writable_fields : $parent_no_vol_writable_fields;
					
					foreach($storage_writable_fields as $new_writable_field) AppModel::$writable_fields['aliquot_masters']['edit'][] = $new_writable_field;		
					
					if(isset(AppModel::$writable_fields['tmp_detail_table'])){
						AppModel::$writable_fields[$org_parent_data['AliquotControl']['detail_tablename']] = AppModel::$writable_fields['tmp_detail_table'];
					} 
					$this->AliquotMaster->data = array();
					
					$this->AliquotMaster->writable_fields_mode = 'edit';

					//clean data to prevent warnings
					$to_save = array();
					foreach(AppModel::$writable_fields['aliquot_masters']['edit'] as $field){
						$to_save[$field] = $parent_data['AliquotMaster'][$field];
					}
					if(!$this->AliquotMaster->save(array('AliquotMaster' => $to_save), false)){
						$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
					}

					$this->AliquotMaster->writable_fields_mode = 'addgrid';
					AppModel::$writable_fields = $child_writable_fields;
					foreach($parent_and_children['children'] as $children) {
						
						$realiquoting_data = array('Realiquoting' => $children['Realiquoting']);
						unset($children['Realiquoting']);
						unset($children['FunctionManagement']);
						unset($children['GeneratedParentAliquot']);
						
						// B- Save children aliquot data	
						$this->AliquotMaster->id = null;
						$this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
						
						unset($children['AliquotMaster']['id']);
						if(!$this->AliquotMaster->save($children, false)){
							$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
						}
						
						$child_id = $this->AliquotMaster->getLastInsertId();
						if(empty($aliquot_id)){
							$new_aliquot_ids[] = $child_id;
						}
													
						// C- Save realiquoting data	
						
		  				$realiquoting_data['Realiquoting']['parent_aliquot_master_id'] = $parent_id;
		 				$realiquoting_data['Realiquoting']['child_aliquot_master_id'] = $child_id;
		  				$realiquoting_data['Realiquoting']['lab_book_master_id'] = $lab_book_id;
		 				$realiquoting_data['Realiquoting']['sync_with_lab_book'] = $sync_with_lab_book;
		 				
						$this->Realiquoting->id = NULL;
		  				if(!$this->Realiquoting->save($realiquoting_data, false)){
							$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
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
					$datamart_structure = AppModel::getInstance("Datamart", "DatamartStructure", true);
					$batch_set_model = AppModel::getInstance('Datamart', 'BatchSet', true);
					$batch_set_data = array('BatchSet' => array(
						'datamart_structure_id' => $datamart_structure->getIdByModelName('ViewAliquot'),
						'flag_tmp' => true
					));
					$batch_set_model->check_writable_fields = false;
					$batch_set_model->saveWithIds($batch_set_data, $new_aliquot_ids);
					$this->atimFlash(__('your data has been saved').'<br>'.__('aliquot storage data were deleted (if required)'), '/Datamart/BatchSets/listall/'.$batch_set_model->getLastInsertId());
				} else {
					$aliquot = $this->AliquotMaster->findById($aliquot_id);
					$aliquot = $aliquot['AliquotMaster'];
					$this->atimFlash(__('your data has been saved').'<br>'.__('aliquot storage data were deleted (if required)'), '/InventoryManagement/AliquotMasters/detail/'.$aliquot['collection_id'].'/'.$aliquot['sample_master_id'].'/'.$aliquot['id']);
				}
					
			} else {
				$this->AliquotMaster->validationErrors = array();
				$this->AliquotDetail->validationErrors = array();
				$this->Realiquoting->validationErrors = array();
				foreach($errors as $field => $msg_and_lines) {
					foreach($msg_and_lines as $msg => $lines) {
						//Counter cake2 issue and use AliquotDetail model for validationErrors
						$this->AliquotMaster->validationErrors[$field][] = __($msg) .(empty($aliquot_id)? ' - ' . str_replace('%s', implode(",", $lines), __('see # %s')) : '');					
					} 
				}
			}
		}
	}
	
	function defineRealiquotedChildren($aliquot_master_id = null){
		$initial_display = false;
		$parent_aliquots_ids = array();
		if(empty($this->request->data)){ 
			$this->flash((__('you have been redirected automatically').' (#'.__LINE__.')'), "javascript:history.back();", 5);
			return;
		} else if(isset($this->request->data[0]) && isset($this->request->data[0]['ids'])){ 
			if($this->request->data[0]['realiquot_into'] == ''){
				$this->flash(__("you must select an aliquot type"), "javascript:history.back();", 5);
				return;
			}
			$initial_display = true;
			$parent_aliquots_ids = $this->request->data[0]['ids'];
		} else if(isset($this->request->data['ids'])) {
			$initial_display = false;
			$parent_aliquots_ids = $this->request->data['ids'];			
		} else {
			$this->flash((__('you have been redirected automatically').' (#'.__LINE__.')'), "javascript:history.back();", 5);
			return;
		}
		$this->set('parent_aliquots_ids', $parent_aliquots_ids);

		// Get parent an child control data
		$parent_aliquot_ctrl_id = isset($this->request->data['realiquot_from'])? $this->request->data['realiquot_from']: null;
		$child_aliquot_ctrl_id = isset($this->request->data[0]['realiquot_into'])? $this->request->data[0]['realiquot_into'] : (isset($this->request->data['realiquot_into'])? $this->request->data['realiquot_into'] : null);		
		$parent_aliquot_ctrl = $this->AliquotControl->findById($parent_aliquot_ctrl_id);
		$child_aliquot_ctrl = ($parent_aliquot_ctrl_id == $child_aliquot_ctrl_id)? $parent_aliquot_ctrl : $this->AliquotControl->findById($child_aliquot_ctrl_id);		
		if(empty($parent_aliquot_ctrl) || empty($child_aliquot_ctrl)) { 
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
		}
	
		// lab book management
		$lab_book = null;//lab book object
		$lab_book_expected_ctrl_id = null;
		$lab_book_code = null;
		$lab_book_id = null;
		$sync_with_lab_book = null;
		$lab_book_fields = array();
		if(isset($this->request->data['Realiquoting']) && isset($this->request->data['Realiquoting']['lab_book_master_code']) && (strlen($this->request->data['Realiquoting']['lab_book_master_code']) > 0 || $this->request->data['Realiquoting']['sync_with_lab_book'])){
			$lab_book = AppModel::getInstance("LabBook", "LabBookMaster", true);
			$sample_ctrl_id = isset($this->request->data['sample_ctrl_id'])? $this->request->data['sample_ctrl_id']: null;
			$lab_book_expected_ctrl_id = $this->RealiquotingControl->getLabBookCtrlId($sample_ctrl_id, $parent_aliquot_ctrl_id, $child_aliquot_ctrl_id);
			$sync_response = $lab_book->syncData($this->request->data, array(), $this->request->data['Realiquoting']['lab_book_master_code'], $lab_book_expected_ctrl_id);
			if(is_numeric($sync_response)){
				$lab_book_id = $sync_response;
				$lab_book_fields = $lab_book->getFields($lab_book_expected_ctrl_id);
				$lab_book_code = $this->request->data['Realiquoting']['lab_book_master_code'];
				$sync_with_lab_book = $this->request->data['Realiquoting']['sync_with_lab_book']; 
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
			$this->set('atim_menu', $this->Menus->get('/InventoryManagement/'));
		} else {
			$parent = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.id' => $aliquot_master_id), 'recursive' => '0'));
			if(empty($parent)){
				$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}
			$this->setAliquotMenu($parent);
		}
					
		$this->set('realiquot_from', $parent_aliquot_ctrl_id);
		$this->set('realiquot_into', $child_aliquot_ctrl_id);
		$this->set('sample_ctrl_id', $this->request->data['sample_ctrl_id']);
		
		if(empty($parent_aliquot_ctrl['AliquotControl']['volume_unit'])){
			$this->Structures->set('used_aliq_in_stock_details', 'in_stock_detail');
			$this->Structures->set('children_aliquots_selection', 'atim_structure_for_children_aliquots_selection');
		} else {
			$this->Structures->set('used_aliq_in_stock_details,used_aliq_in_stock_detail_volume', 'in_stock_detail');
			$this->Structures->set('children_aliquots_selection,children_aliquots_selection_volume', 'atim_structure_for_children_aliquots_selection');
		}
		$this->Structures->set('empty', 'empty_structure');
				
		$this->setUrlToCancel();
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
			
		if($initial_display){
			
			// BUILD DATA FOR INTIAL DISPLAY
			
			$this->request->data = array();
			$excluded_parent_aliquot = array();
			
			// Get parent aliquot data
			$this->AliquotMaster->unbindModel(array(
				'hasOne' => array('SpecimenDetail', 'DerivativeDetail'),
				'belongsTo' => array('Collection')));
			$has_many_details = array(
				'hasMany' => array( 
					'RealiquotingParent' => array(
						'className' => 'InventoryManagement.Realiquoting',
						'foreignKey' => 'child_aliquot_master_id'),
					'RealiquotingChildren' => array(
						'className' => 'InventoryManagement.Realiquoting',
						'foreignKey' => 'parent_aliquot_master_id')));
			$this->AliquotMaster->bindModel($has_many_details);	
			$parent_aliquots = $this->AliquotMaster->find('all', array('conditions' => array('AliquotMaster.id' => explode(",", $parent_aliquots_ids))));
			$this->AliquotMaster->sortForDisplay($parent_aliquots, $parent_aliquots_ids);
			if(empty($parent_aliquots)){
				$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
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
						$children_aliquot['GeneratedParentAliquot']['aliquot_volume_unit'] = empty($parent_aliquot_data['AliquotControl']['volume_unit'])? '': $parent_aliquot_data['AliquotControl']['volume_unit'];
						$children_aliquot['Realiquoting']['realiquoting_datetime'] = $default_use_datetime;
					}
					
					// Set data
					$this->request->data[] = array('parent' => $parent_aliquot_data, 'children' => $aliquot_data_for_selection);				
				}
			}
			
			// Manage exculded parents
			if(!empty($excluded_parent_aliquot)) {
				$tmp_barcode = array();
				foreach($excluded_parent_aliquot as $new_aliquot) {
					$tmp_barcode[] = $new_aliquot['AliquotMaster']['barcode'];
				}
				$msg = __('no new aliquot could be actually defined as realiquoted child for the following parent aliquot(s)').': ['.implode(",", $tmp_barcode).']';
				
				if(empty($this->request->data)) {
					$this->flash($msg, "javascript:history.back()", 5);
					return;
				} else {
					AppController::addWarningMsg($msg);
				}
			}
			
			$hook_link = $this->hook('initial_display');
			if($hook_link){
				require($hook_link);
			}
			
		} else {
			
			// LAUNCH VALIDATE & SAVE PROCESSES

			unset($this->request->data['sample_ctrl_id']);
			unset($this->request->data['realiquot_into']);
			unset($this->request->data['realiquot_from']);
			unset($this->request->data['ids']);
			unset($this->request->data['Realiquoting']);
			unset($this->request->data['url_to_cancel']);
			
			$errors = array();
			$validated_data = array();
			$record_counter = 0;
			$relations = array();
					
			foreach($this->request->data as $parent_id => $parent_and_children){
				$record_counter++;
				
				//A- Validate parent aliquot data
				
				$this->AliquotMaster->id = null; 
				$this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
				
				$parent_aliquot_data = $parent_and_children['AliquotMaster'];
				$parent_aliquot_data["id"] = $parent_id;
				$parent_aliquot_data["aliquot_control_id"] = $parent_aliquot_ctrl_id;
				unset($parent_aliquot_data['storage_coord_x']);
				unset($parent_aliquot_data['storage_coord_y']);
				
				$this->AliquotMaster->set(array("AliquotMaster" => $parent_aliquot_data));
				if(!$this->AliquotMaster->validates()){
					foreach($this->AliquotMaster->validationErrors as $field => $msgs) {
						$msgs = is_array($msgs)? $msgs : array($msgs);
						foreach($msgs as $msg) $errors[$field][$msg][] = $record_counter;						
					}
				}
			
				// Set parent data to $validated_data
				$validated_data[$parent_id]['parent']['AliquotMaster'] = $parent_aliquot_data;
				$validated_data[$parent_id]['parent']['AliquotMaster']['storage_coord_x'] = $parent_and_children['AliquotMaster']['storage_coord_x'];
				$validated_data[$parent_id]['parent']['AliquotMaster']['storage_coord_y'] = $parent_and_children['AliquotMaster']['storage_coord_y'];
				
				$validated_data[$parent_id]['parent']['FunctionManagement'] = $parent_and_children['FunctionManagement'];
				$validated_data[$parent_id]['parent']['AliquotControl'] = $parent_and_children['AliquotControl'];
				$validated_data[$parent_id]['parent']['StorageMaster'] = $parent_and_children['StorageMaster'];
				
				
				$validated_data[$parent_id]['children'] = array();
				
				//B- Validate realiquoting data
				
				$children_has_been_defined = false;
				foreach($parent_and_children as $tmp_id => &$children_aliquot){
					if(is_numeric($tmp_id)) {
						if($children_aliquot['FunctionManagement']['use']) {
							$children_has_been_defined = true;
							
							if(isset($relations[$children_aliquot['AliquotMaster']['id']])){
								$errors[][__("circular assignation with [%s]", $children_aliquot['AliquotMaster']['barcode'])][] = $record_counter;
							}
							$relations[$parent_id] = $children_aliquot['AliquotMaster']['id'];
							
							$this->Realiquoting->set(array('Realiquoting' => $children_aliquot['Realiquoting']));
							if(!$this->Realiquoting->validates()){
								foreach($this->Realiquoting->validationErrors as $field => $msgs) {
									$msgs = is_array($msgs)? $msgs : array($msgs);
									foreach($msgs as $msg) $errors[$field][$msg][] = $record_counter;
								}
							}
							$children_aliquot['Realiquoting'] = $this->Realiquoting->data['Realiquoting']; 
							
							// Check volume can be completed
							if((!empty($children_aliquot['Realiquoting']['parent_used_volume'])) && empty($children_aliquot['GeneratedParentAliquot']['aliquot_volume_unit'])) {
								// No volume has to be recored for this aliquot type	
								$errors['parent_used_volume']['no volume has to be recorded when the volume unit field is empty'][] = $record_counter;					
							} 
						}
						$validated_data[$parent_id]['children'][$tmp_id] = $children_aliquot;
					}
				}
				if(!$children_has_been_defined){
					$errors[]['at least one child has to be defined'][] = $record_counter;	
				}
			}
			
			$this->request->data = $validated_data;
			
			if(empty($errors) && !empty($lab_book_code)){
				//this time we do synchronize with the lab book
				foreach($this->request->data as $key => &$new_data_set) {
					$lab_book->syncData($new_data_set['children'], array('Realiquoting'), $lab_book_code);
				}	
			}
			
			$this->AliquotMaster->addWritableField('current_volume');
			$this->Realiquoting->addWritableField(array('parent_aliquot_master_id', 'child_aliquot_master_id', 'lab_book_master_id', 'sync_with_lab_book'));
			$this->Realiquoting->writable_fields_mode = 'addgrid';
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}
			
			if(empty($errors)) {
				
				$new_aliquot_ids = array();
				
				//C- Save Process
				foreach($this->request->data as $parent_id => $parent_and_children){
					
					// Save parent aliquot data
					
					$this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
					$this->AliquotMaster->id = $parent_id;
					
					$parent_data = $parent_and_children['parent'];
					if($parent_data['FunctionManagement']['remove_from_storage'] || ($parent_data['AliquotMaster']['in_stock'] == 'no')) {
						// Delete storage data
						$parent_data['AliquotMaster']['storage_master_id'] = null;
						$parent_data['AliquotMaster']['storage_coord_x'] = '';
						$parent_data['AliquotMaster']['storage_coord_y'] = '';
						$this->AliquotMaster->addWritableField(array('storage_master_id', 'storage_coord_x', 'storage_coord_y'));
					}else{
						$this->AliquotMaster->removeWritableField(array('storage_master_id', 'storage_coord_x', 'storage_coord_y'));
					}
					$parent_data['AliquotMaster']['id'] = $parent_id;
					
					if(!$this->AliquotMaster->save(array('AliquotMaster' => $parent_data['AliquotMaster']), false)){
						$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
					}
					
					// Save realiquoting data
					foreach($parent_and_children['children'] as $children_aliquot_to_save) {		
						if($children_aliquot_to_save['FunctionManagement']['use']){
			  				//save realiquoting
			  				$children_aliquot_to_save['Realiquoting']['parent_aliquot_master_id'] = $parent_id;
			 				$children_aliquot_to_save['Realiquoting']['child_aliquot_master_id'] = $children_aliquot_to_save['AliquotMaster']['id'];
		  					$children_aliquot_to_save['Realiquoting']['lab_book_master_id'] = $lab_book_id;
		 					$children_aliquot_to_save['Realiquoting']['sync_with_lab_book'] = $sync_with_lab_book;
			 					
							$this->Realiquoting->id = NULL;
							$this->Realiquoting->data = null;
			  				if(!$this->Realiquoting->save(array('Realiquoting' => $children_aliquot_to_save['Realiquoting']), false)){
								$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
							}
								
							// Set data for batchset
							$new_aliquot_ids[] = $children_aliquot_to_save['AliquotMaster']['id'];	
						}
					}
					
					// Update parent aliquot current volume
					
					$this->AliquotMaster->updateAliquotUseAndVolume($parent_id, true, true, false);
				}
				
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) { 
					require($hook_link); 
				}
				
				//redirect
				if($aliquot_master_id == null){
					$datamart_structure = AppModel::getInstance("Datamart", "DatamartStructure", true);
					$batch_set_model = AppModel::getInstance('Datamart', 'BatchSet', true);
					$batch_set_data = array('BatchSet' => array(
						'datamart_structure_id' => $datamart_structure->getIdByModelName('ViewAliquot'),
						'flag_tmp' => true 
					));
					$batch_set_model->saveWithIds($batch_set_data, $new_aliquot_ids);
					$this->atimFlash(__('your data has been saved').'<br>'.__('aliquot storage data were deleted (if required)'), '/Datamart/BatchSets/listall/'.$batch_set_model->getLastInsertId());
				}else{
					$aliquot = $this->AliquotMaster->findById($aliquot_master_id);
					$aliquot = $aliquot['AliquotMaster'];
					$this->atimFlash(__('your data has been saved').'<br>'.__('aliquot storage data were deleted (if required)'), '/InventoryManagement/AliquotMasters/detail/'.$aliquot['collection_id'].'/'.$aliquot['sample_master_id'].'/'.$aliquot['id']);
				}
			
			} else {
				// Errors have been detected => rebuild form data
				$this->AliquotMaster->validationErrors = array();
				$this->AliquotDetail->validationErrors = array();
				$this->Realiquoting->validationErrors = array();
				foreach($errors as $field => $msg_and_lines) {
					foreach($msg_and_lines as $msg => $lines) {
						$this->AliquotMaster->validationErrors[$field][] = __($msg) .(empty($aliquot_id)? ' - ' . str_replace('%s', implode(",", $lines), __('see # %s')) : '');					
					} 
				}				
			}
		}
	}
	
	function listAllRealiquotedParents($collection_id, $sample_master_id, $aliquot_master_id) {
		// MANAGE DATA
		
		// Get the aliquot data
		$current_aliquot_data = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.collection_id' => $collection_id, 'AliquotMaster.sample_master_id' => $sample_master_id, 'AliquotMaster.id' => $aliquot_master_id)));
		if(empty($current_aliquot_data)) { 
			$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		}
		
		// Get/Manage Parent Aliquots
		$this->request->data = $this->Realiquoting->find('all', array(
			'limit' => pagination_amount , 
			'order' => 'Realiquoting.realiquoting_datetime DESC',
			'fields' => array('*'),
			'joins' => array(AliquotMaster::joinOnAliquotDup('Realiquoting.parent_aliquot_master_id'), AliquotMaster::$join_aliquot_control_on_dup),
			'conditions' => array('Realiquoting.child_aliquot_master_id'=> $aliquot_master_id)
		));
		
		// Manage data to build URL to access la book
		$this->set('display_lab_book_url', false);
		foreach($this->request->data as &$new_record) {
			$new_record['Realiquoting']['generated_lab_book_master_id'] = '-1';
			if(array_key_exists('lab_book_master_id',$new_record['Realiquoting']) && !empty($new_record['Realiquoting']['lab_book_master_id'])) {
				$new_record['Realiquoting']['generated_lab_book_master_id'] = $new_record['Realiquoting']['lab_book_master_id'];
			}
		}
		
		// MANAGE FORM, MENU AND ACTION BUTTONS

		// Get the current menu object.
		$this->setAliquotMenu($current_aliquot_data, true);
		
		// Set structure
		$this->Structures->set('realiquotedparent,realiquotedparent_vol');
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
	}
	
	function editRealiquoting($realiquoting_id){
		$data = $this->Realiquoting->getOrRedirect($realiquoting_id);
		$data['AliquotControl'] = $this->AliquotControl->getOrRedirect($data['AliquotMaster']['aliquot_control_id']);
		$data['AliquotControl'] = $data['AliquotControl']['AliquotControl'];
	
		$this->Structures->set(empty($data['AliquotControl']['volume_unit'])? 'realiquotedparent': 'realiquotedparent,realiquotedparent_vol');
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
		
		if($this->request->data){
			$this->Realiquoting->id = $realiquoting_id;
			$this->Realiquoting->data = array();
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}
			
			if($this->Realiquoting->save($this->request->data)){
				$this->AliquotMaster->updateAliquotUseAndVolume($data['AliquotMaster']['id'], true, false, false);
				
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) {
					require($hook_link);
				}
				
				$this->atimFlash('your data has been saved', '/InventoryManagement/AliquotMasters/detail/'.$data['AliquotMasterChildren']['collection_id'].'/'.$data['AliquotMasterChildren']['sample_master_id'].'/'.$data['AliquotMasterChildren']['id']);
			}
		}else{
			$this->request->data = $data;
		}
		
		$this->SampleMaster->recursive = 0;
		$sample = $this->SampleMaster->getOrRedirect($data['AliquotMasterChildren']['sample_master_id']);
		$this->setAliquotMenu(array('AliquotMaster' => $data['AliquotMasterChildren'], 'SampleMaster' => $sample['SampleMaster'], 'SampleControl' => $sample['SampleControl']), false);
		$this->set('realiquoting_id', $realiquoting_id);
	}	
	
	function deleteRealiquotingData($parent_id, $child_id, $source) {
		if((!$parent_id) || (!$child_id) || (!$source)) { $this->redirect('/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); }	

 		// MANAGE DATA
		
		// Get the realiquoting data
		$realiquoting_data = $this->Realiquoting->find('first', array('conditions' => array('Realiquoting.parent_aliquot_master_id' => $parent_id, 'Realiquoting.child_aliquot_master_id' => $child_id)));
		if(empty($realiquoting_data)) { 
			$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		}				
		
		$flash_url = '';
		switch($source) {
			case 'parent':
				$flash_url = '/InventoryManagement/AliquotMasters/detail/' . $realiquoting_data['AliquotMaster']['collection_id'] . '/' . $realiquoting_data['AliquotMaster']['sample_master_id'] . '/' . $realiquoting_data['AliquotMaster']['id'];
				break;
			case 'child':
				$flash_url = '/InventoryManagement/AliquotMasters/detail/' . $realiquoting_data['AliquotMasterChildren']['collection_id'] . '/' . $realiquoting_data['AliquotMasterChildren']['sample_master_id'] . '/' . $realiquoting_data['AliquotMasterChildren']['id'];
				break;
			default:
				$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		
		
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }
			
		// LAUNCH DELETION
		$deletion_done = true;
		
		// -> Delete Realiquoting
		if(!$this->Realiquoting->atimDelete($realiquoting_data['Realiquoting']['id'])) { $deletion_done = false; }	
		
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
			$this->redirect('/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); 
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
		$this->request->data = $this->AliquotMaster->find('all', array('conditions' => array('AliquotMaster.id' => $ids, 'AliquotMaster.collection_id' => $collection_id)));
		foreach($this->request->data as &$aliquot){
			$aliquot['children'] = array_key_exists($aliquot['AliquotMaster']['id'], $aliquot_ids_has_child);
			$aliquot['css'][] = $aliquot['AliquotMaster']['in_stock'] == 'no' ? 'disabled' : '';
		}
	}
	
	function editInBatch(){
		$this->set('atim_menu', $this->Menus->get('/InventoryManagement/Collections/search'));
		$this->Structures->set('aliquot_master_edit_in_batchs');
		
		if(isset($this->request->data['aliquot_ids'])){
			$aliquot_ids = explode(',', $this->request->data['aliquot_ids']);
			$to_update['AliquotMaster'] = array_filter($this->request->data['AliquotMaster']);
			
			$warning_messages = null;
			$validates = true;
			
			// Check data conflict
			
			if($this->request->data['FunctionManagement']['recorded_storage_selection_label'] && (($this->request->data['FunctionManagement']['remove_from_storage'] == 'y') || ($this->request->data['AliquotMaster']['in_stock'] == 'no'))) {
				$validates = false;
				$this->AliquotMaster->validationErrors['recorded_storage_selection_label'][] = __('data conflict: you can not remove aliquot and set a storage');
				if($this->request->data['AliquotMaster']['in_stock'] == 'no') $this->AliquotMaster->validationErrors['in_stock'][] = __('data conflict: you can not remove aliquot and set a storage');
			}

			foreach($this->request->data['AliquotMaster'] as $key => $value) {
				if(strlen($this->request->data['AliquotMaster'][$key]) && array_key_exists('remove_'.$key, $this->request->data['FunctionManagement']) && $this->request->data['FunctionManagement']['remove_'.$key] == 'y') {
					$validates = false;
					$this->AliquotMaster->validationErrors[$key][] = __('data conflict: you can not delete data and set a new one');
				}
			}
			
			// Manage FunctionManagement
			
			if($validates){			
				// Storage
				if($this->request->data['FunctionManagement']['recorded_storage_selection_label']){
					$to_update['FunctionManagement']['recorded_storage_selection_label'] = $this->request->data['FunctionManagement']['recorded_storage_selection_label'];
					$to_update['AliquotMaster']['storage_coord_x'] = null;
					$to_update['AliquotMaster']['storage_coord_y'] = null;
					$this->AliquotMaster->addWritableField(array('storage_master_id', 'storage_coord_x', 'storage_coord_y'));
					
					$warning_messages = 'aliquots positions have been deleted';
					
					if(empty($this->request->data['AliquotMaster']['in_stock'])) {
						$condtions = array('AliquotMaster.id' => $aliquot_ids, 'AliquotMaster.in_stock' => 'no');
						$aliquot_not_in_stock = $this->AliquotMaster->find('count', array('conditions' => $condtions, 'recursive' => '-1'));
						if($aliquot_not_in_stock) {
							$validates = false;
							$warning_messages = '';
							$this->AliquotMaster->validationErrors['recorded_storage_selection_label'][] = __('data conflict: at least one updated aliquot is defined as not in stock - please update in stock value');					
						}
					}
					
				} else if(($this->request->data['FunctionManagement']['remove_from_storage'] == 'y') || ($this->request->data['AliquotMaster']['in_stock'] == 'no')) {
					//batch edit
					$to_update['AliquotMaster']['storage_master_id'] = null;
					$to_update['AliquotMaster']['storage_coord_x'] = null;
					$to_update['AliquotMaster']['storage_coord_y'] = null;
					$this->AliquotMaster->addWritableField(array('storage_master_id', 'storage_coord_x', 'storage_coord_y'));
				}
				
				// Other data
				foreach($this->request->data['AliquotMaster'] as $key => $value) {
					if(array_key_exists('remove_'.$key, $this->request->data['FunctionManagement']) && $this->request->data['FunctionManagement']['remove_'.$key] == 'y') {
						$to_update['AliquotMaster'][$key] = null;
					}
				}			
			}	

		// Validation

			if($validates){
				$to_update['AliquotMaster']['aliquot_control_id'] = 1;//to allow validation, remove afterward
				$not_core_nbr = $this->AliquotMaster->find('count', array('conditions' => array('AliquotMaster.id' => $aliquot_ids, "AliquotControl.aliquot_type != 'core'")));
				$to_update['AliquotControl']['aliquot_type'] = $not_core_nbr? 'not core' : 'core';//to allow tma storage check, remove afterward
								
				$this->AliquotMaster->set($to_update);
				if($this->AliquotMaster->validates()){
					if(!empty($this->AliquotMaster->data['AliquotMaster']['storage_master_id'])) $to_update['AliquotMaster']['storage_master_id'] = $this->AliquotMaster->data['AliquotMaster']['storage_master_id'];
				}else{
					$validates = false;
				}
				unset($to_update['AliquotMaster']['aliquot_control_id']);	
				unset($to_update['AliquotControl']['aliquot_type']);				
			}
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) {
				require($hook_link);
			}

			if($validates){		
				if($to_update['AliquotMaster']){
					$datamart_structure = AppModel::getInstance("Datamart", "DatamartStructure", true);
					$batch_set_model = AppModel::getInstance('Datamart', 'BatchSet', true);
										
					foreach($aliquot_ids as $aliquot_id){
						$this->AliquotMaster->id = $aliquot_id;
						$this->AliquotMaster->data = null;
						$this->AliquotMaster->save($to_update, false);
					}
					
					$batch_set_data = array('BatchSet' => array(
							'datamart_structure_id'	=> $datamart_structure->getIdByModelName('ViewAliquot'),
							'flag_tmp'				=> true
					));		
					
					$batch_set_model->check_writable_fields = false;
					$batch_set_model->saveWithIds($batch_set_data, $aliquot_ids);
					
					if($warning_messages) AppController::addWarningMsg(__($warning_messages));
					
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) {
						require($hook_link);
					}
					
 					$this->atimFlash('your data has been saved', '/Datamart/BatchSets/listall/'.$batch_set_model->getLastInsertId());
				}else{
					$this->AliquotMaster->validationErrors[][] = 'you need to at least update a value';
					$this->request->data['ViewAliquot']['aliquot_master_id'] = $aliquot_ids;
					$this->set('cancel_link', $this->request->data['cancel_link']);
				}
			}
		
		} else if(!isset($this->request->data['ViewAliquot']['aliquot_master_id'])){
			$this->flash((__('you have been redirected automatically').' (#'.__LINE__.')'), "javascript:history.back();", 5);
			return;			
		}
		
		$this->set('cancel_link', AppController::getCancelLink($this->request->data));
		
		$hook_link = $this->hook('format');
		if( $hook_link ) {
			require($hook_link);
		}
	}
	
	/**
	 * List all aliquot uses
	 * @param int $collection_id
	 * @param int $sample_master_id
	 * @param int $aliquot_master_id
	 */
	function listallUses($collection_id, $sample_master_id, $aliquot_master_id){
		$aliquot = $this->AliquotMaster->getOrRedirect($aliquot_master_id);
		if($aliquot['AliquotMaster']['sample_master_id'] != $sample_master_id || $aliquot['AliquotMaster']['collection_id'] != $collection_id){
			$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		$this->request->data = $this->ViewAliquotUse->findFastFromAliquotMasterId($aliquot_master_id);
		$this->Structures->set('viewaliquotuses');
		$hook_link = $this->hook('format');
		if( $hook_link ) {
			require($hook_link);
		}
		$this->render('listall_uses');
	}
	
	function storageHistory($collection_id, $sample_master_id, $aliquot_master_id){
		$aliquot = $this->AliquotMaster->getOrRedirect($aliquot_master_id);
		if($aliquot['AliquotMaster']['sample_master_id'] != $sample_master_id || $aliquot['AliquotMaster']['collection_id'] != $collection_id){
			$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		
		$this->request->data = $this->AliquotMaster->getStorageHistory($aliquot_master_id);
		$this->Structures->set('custom_aliquot_storage_history');
		$hook_link = $this->hook();
		if( $hook_link ) {
			require($hook_link);
		}
			
	}
	
	function printBarcodes(){
		$this->layout = false;
		Configure::write('debug', 0);
		$conditions = array();
		switch($this->passedArgs['model']){
			case 'Collection':
				$conditions['AliquotMaster.collection_id'] = isset($this->request->data['ViewCollection']['collection_id']) ? $this->request->data['ViewCollection']['collection_id'] : $this->passedArgs['id'];  
				break;
			case 'SampleMaster':
				$conditions['AliquotMaster.sample_master_id'] = isset($this->request->data['ViewSample']['sample_master_id']) ? $this->request->data['ViewSample']['sample_master_id'] : $this->passedArgs['id'];
				break;
			case 'AliquotMaster':
			default:
				$conditions['AliquotMaster.id'] = isset($this->request->data['ViewAliquot']['aliquot_master_id']) ? $this->request->data['ViewAliquot']['aliquot_master_id'] : $this->passedArgs['id'];
				break;
		}
		
		$this->Structures->set('aliquot_barcode', 'result_structure');
		$this->set('csv_header', true);
		$offset = 0;
		AppController::atimSetCookie(false);
		$at_least_once = false;
		while($this->request->data = $this->AliquotMaster->find('all', array('conditions' => $conditions, 'limit' => 300, 'offset' => $offset))){
			$this->render('../../../Datamart/View/Csv/csv');
			$this->set('csv_header', false);
			$offset += 300;
			$at_least_once = true;
		}
		if($at_least_once){
			$this->render(false);
		}else{
			$this->flash(__('there are no barcodes to print'), 'javascript:history.back();');
		}
	}
}
