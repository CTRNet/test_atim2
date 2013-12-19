<?php

class QualityCtrlsController extends InventoryManagementAppController {
	
	var $components = array();
	
	var $uses = array(
		'InventoryManagement.Collection',
		'InventoryManagement.SampleMaster',
		'InventoryManagement.AliquotMaster',
		'InventoryManagement.QualityCtrl'
	);
	
	var $paginate = array('QualityCtrl' => array('limit' => pagination_amount, 'order' => 'QualityCtrl.date ASC'));
	
	function listAll($collection_id, $sample_master_id) {
		// MANAGE DATA
		
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id), 'recursive' => 0));
		if(empty($sample_data)) { 
			$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		}	
		
		$this->request->data = $this->paginate($this->QualityCtrl, array('QualityCtrl.sample_master_id'=>$sample_master_id));
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$sample_id_parameter = ($sample_data['SampleControl']['sample_category'] == 'specimen')? '%%SampleMaster.initial_specimen_sample_id%%': '%%SampleMaster.id%%';
		$this->set('atim_menu', $this->Menus->get('/InventoryManagement/QualityCtrls/listAll/%%Collection.id%%/' . $sample_id_parameter));		

		$this->set( 'atim_menu_variables', 
			array('Collection.id' => $sample_data['SampleMaster']['collection_id'], 
			'SampleMaster.id' => $sample_master_id,
			'SampleMaster.initial_specimen_sample_id' => $sample_data['SampleMaster']['initial_specimen_sample_id']) );
			
		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) {
			require($hook_link);
		}
	}
	
	function addInit($collection_id, $sample_master_id){
		$this->setBatchMenu(array('SampleMaster' => $sample_master_id));
		$this->set('aliquot_data_no_vol', $this->AliquotMaster->find('all', array('conditions' => array('AliquotMaster.sample_master_id' => $sample_master_id, AliquotMaster::$volume_condition))));
		$this->set('aliquot_data_vol', $this->AliquotMaster->find('all', array('conditions' => array('AliquotMaster.sample_master_id' => $sample_master_id, 'NOT' => AliquotMaster::$volume_condition))));
		$this->Structures->set('aliquot_masters,aliquotmasters_volume', 'aliquot_structure_vol');
		$this->Structures->set('aliquot_masters', 'aliquot_structure_no_vol');
		$this->Structures->set('empty', 'empty_structure');
		
		$hook_link = $this->hook('format');
		if( $hook_link ) {
			require($hook_link);
		}
	}
	
	function add($sample_master_id = null){
		$this->Structures->set('view_sample_joined_to_collection', "samples_structure");
		$this->Structures->set('used_aliq_in_stock_details', "aliquots_structure");
		$this->Structures->set('used_aliq_in_stock_details,used_aliq_in_stock_detail_volume', 'aliquots_volume_structure');
		$this->Structures->set('qualityctrls', 'qc_structure');
		$this->Structures->set('qualityctrls,qualityctrls_volume', 'qc_volume_structure');
		$this->set('sample_master_id_parameter', $sample_master_id);
		
		$menu_data = null;
		$this->setUrlToCancel();
		$cancel_button = $this->request->data['url_to_cancel'];
		unset($this->request->data['url_to_cancel']);
		
		if($sample_master_id != null){
			// User click on add QC from collection
			$menu_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.id' => $sample_master_id)));
			$menu_data = $menu_data['SampleMaster'];
			$cancel_button = '/InventoryManagement/QualityCtrls/listAll/'.$menu_data['collection_id'].'/'.$sample_master_id;
			
		}else if(array_key_exists('ViewAliquot', $this->request->data)){
			if(isset($this->request->data['node']) && $this->request->data[ 'ViewAliquot' ][ 'aliquot_master_id' ] == 'all') {
				$this->BrowsingResult = AppModel::getInstance('Datamart', 'BrowsingResult', true);
				$browsing_result = $this->BrowsingResult->find('first', array('conditions' => array('BrowsingResult.id' => $this->request->data['node']['id'])));
				$this->request->data[ 'ViewAliquot' ][ 'aliquot_master_id' ] = explode(",", $browsing_result['BrowsingResult']['id_csv']);
			}
			$aliquot_sample_ids = $this->AliquotMaster->find('all', array(
				'conditions'	=> array('AliquotMaster.id' => $this->request->data['ViewAliquot']['aliquot_master_id']),
				'fields'		=> array('AliquotMaster.sample_master_id'),
				'recursive'		=> -1)
			);
			$menu_data = array();
			foreach($aliquot_sample_ids as $aliquot_sample_id){
				$menu_data[] = $aliquot_sample_id['AliquotMaster']['sample_master_id'];
			}
			
		}else if(array_key_exists('ViewSample', $this->request->data)){
			if(isset($this->request->data['node']) && $this->request->data[ 'ViewSample' ][ 'sample_master_id' ] == 'all') {
				$this->BrowsingResult = AppModel::getInstance('Datamart', 'BrowsingResult', true);
				$browsing_result = $this->BrowsingResult->find('first', array('conditions' => array('BrowsingResult.id' => $this->request->data['node']['id'])));
				$this->request->data[ 'ViewSample' ][ 'sample_master_id' ] = explode(",", $browsing_result['BrowsingResult']['id_csv']);
			}
			$menu_data = $this->request->data['ViewSample']['sample_master_id']; 
			
		}else if(!empty($this->request->data)){
			//submitted data
			$tmp_data = current($this->request->data);
			$model = array_key_exists('AliquotMaster', $tmp_data) ? 'AliquotMaster' : 'SampleMaster';
			$menu_data = array_keys($this->request->data);
			if($model == 'AliquotMaster'){
				$aliquot_sample_ids = $this->AliquotMaster->find('all', array(
					'conditions'	=> array('AliquotMaster.id' => $menu_data),
					'fields'		=> array('AliquotMaster.sample_master_id'),
					'recursive'		=> -1)
				);
				$menu_data = array();
				foreach($aliquot_sample_ids as $aliquot_sample_id){
					$menu_data[] = $aliquot_sample_id['AliquotMaster']['sample_master_id'];
				}
			}
		}else{
			$this->flash((__('you have been redirected automatically').' (#'.__LINE__.')'), $cancel_button, 5);
			return;
		}
		$this->setBatchMenu(array('SampleMaster' => $menu_data));
		$this->set('cancel_button', $cancel_button);
		
		$joins = array(array(
				'table' => 'view_samples',
				'alias' => 'ViewSample',
				'type' => 'INNER',
				'conditions' => array('AliquotMaster.sample_master_id = ViewSample.sample_master_id')
			)
		);

		if(isset($this->request->data['ViewAliquot']) || isset($this->request->data['ViewSample'])){
			if(empty($this->request->data['ViewAliquot']['aliquot_master_id']) && $sample_master_id != null){
				$this->request->data['ViewSample']['sample_master_id'] = array($sample_master_id);
				unset($this->request->data['ViewAliquot']);
			}
			//initial access
			$data = null;
			if(isset($this->request->data['ViewAliquot'])){
				if(!is_array($this->request->data['ViewAliquot']['aliquot_master_id'])){
					$this->request->data['ViewAliquot']['aliquot_master_id'] = array($this->request->data['ViewAliquot']['aliquot_master_id']);
				}
				$aliquot_ids = array_filter($this->request->data['ViewAliquot']['aliquot_master_id']);
				$this->AliquotMaster->unbindModel(array('belongsTo' => array('SampleMaster')));
				$data = $this->AliquotMaster->find('all', array(
					'fields'		=> array('*'),
					'conditions'	=> array('AliquotMaster.id' => $aliquot_ids),
					'recursive'		=> 0,
					'joins'			=> $joins)
				);
				$this->AliquotMaster->sortForDisplay($data, $aliquot_ids);
			}else{
				if(!is_array($this->request->data['ViewSample']['sample_master_id'])){
					$this->request->data['ViewSample']['sample_master_id'] = array($this->request->data['ViewSample']['sample_master_id']);
				}
				$sample_ids = array_filter($this->request->data['ViewSample']['sample_master_id']);
				$view_sample_model = AppModel::getInstance("InventoryManagement", "ViewSample", true);
				$data = $view_sample_model->find('all', array(
					'conditions'	=> array('ViewSample.sample_master_id' => $sample_ids),
					'recursive'		=> -1)
				);
				$view_sample_model->sortForDisplay($data, $sample_ids);
			}
			
			
			$this->request->data = array();
			foreach($data as $data_unit){
				$this->request->data[] = array('parent' => $data_unit, 'children' => array());
			}
			
			$hook_link = $this->hook('format');
			if($hook_link){
				require($hook_link);
			}
		}else if(!empty($this->request->data)){
			//post
			$display_data = array();
			$sample_data = null;
			$aliquot_data = null;
			$remove_from_storage = null;
			$record_counter = 0;
			$errors = array();
			$aliquot_data_to_save = array();
			$qc_data_to_save = array();
			
			foreach($this->request->data as $key => $data_unit){
				$record_counter++;
				
				//validate
				$studied_sample_master_id = null;
				$sample_data = $data_unit['ViewSample'];
				unset($data_unit['ViewSample']);
				
				$aliquot_master_id = null;
				if(isset($data_unit['AliquotMaster'])){
					$studied_sample_master_id = $data_unit['AliquotMaster']['sample_master_id'];
					
					$aliquot_master = $this->AliquotMaster->getOrRedirect($key);
					if($aliquot_master['AliquotMaster']['sample_master_id'] != $studied_sample_master_id){
						//HACK attempt
						$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
					}
					$aliquot_master_id = $key;
					
					$aliquot_data = array();
					$aliquot_data['AliquotMaster'] = $data_unit['AliquotMaster'];
					$aliquot_data['AliquotMaster']['id'] = $aliquot_master_id;
					
					$aliquot_data['AliquotControl'] = $data_unit['AliquotControl'];
					$aliquot_data['StorageMaster'] = $data_unit['StorageMaster'];
					$aliquot_data['FunctionManagement'] = $data_unit['FunctionManagement'];
					
					unset($data_unit['AliquotControl']);
					unset($data_unit['StorageMaster']);
					unset($data_unit['FunctionManagement']);
					
					$this->AliquotMaster->data = null;
					unset($aliquot_data['AliquotMaster']['storage_coord_x']);
					unset($aliquot_data['AliquotMaster']['storage_coord_y']);
					$this->AliquotMaster->set($aliquot_data);
					if(!$this->AliquotMaster->validates()){
						foreach($this->AliquotMaster->validationErrors as $field => $msgs){						
							$msgs = is_array($msgs)? $msgs : array($msgs);
							foreach($msgs as $msg) $errors[$field][$msg][] = $record_counter;
						}
					}
					$aliquot_data = $this->AliquotMaster->data;

					$aliquot_data['AliquotMaster']['storage_coord_x'] = $data_unit['AliquotMaster']['storage_coord_x'];
					$aliquot_data['AliquotMaster']['storage_coord_y'] = $data_unit['AliquotMaster']['storage_coord_y'];
					
					unset($data_unit['AliquotMaster']);
					
					$display_data[] = array('parent' => array_merge($aliquot_data, array('ViewSample' => $sample_data)), 'children' => $data_unit);
					
					if($aliquot_data['FunctionManagement']['remove_from_storage'] || ($aliquot_data['AliquotMaster']['in_stock'] == 'no')){
						$aliquot_data['AliquotMaster']['storage_master_id'] = null;
						$aliquot_data['AliquotMaster']['storage_coord_x'] = null;
						$aliquot_data['AliquotMaster']['storage_coord_y'] = null;
						$this->AliquotMaster->addWritableField(array('storage_coord_x', 'storage_coord_y', 'storage_master_id'));
					}
					
					
					$aliquot_data_to_save[] = $aliquot_data['AliquotMaster'];
					
				}else{
					$studied_sample_master_id = $key;
					$sample_data['sample_master_id'] = $key;
					$display_data[] = array('parent' => array('ViewSample' => $sample_data), 'children' => $data_unit);
				}
				
				if(empty($data_unit)){
					$errors['']['at least one quality control has to be created for each item'][] = $record_counter;
				}else{
					foreach($data_unit as $quality_control){
						$this->QualityCtrl->data = null;
						$this->QualityCtrl->set($quality_control);
						if(!$this->QualityCtrl->validates()){
							foreach($this->QualityCtrl->validationErrors as $field => $msgs){
								$msgs = is_array($msgs)? $msgs : array($msgs);
								foreach($msgs as $msg) $errors[$field][$msg][] = $record_counter;
							}
						}
						$quality_control = $this->QualityCtrl->data; 
						$quality_control['QualityCtrl']['aliquot_master_id'] = $aliquot_master_id;
						$quality_control['QualityCtrl']['sample_master_id'] = $studied_sample_master_id;
						$qc_data_to_save[] = $quality_control;
					}
				}
			}
	
			$is_batch_process = ($record_counter > 1)? true : false;
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}
			
			//save
			if(empty($errors) && !empty($qc_data_to_save)){
				$this->QualityCtrl->addWritableField(array('sample_master_id', 'aliquot_master_id'));
				$this->QualityCtrl->writable_fields_mode = 'addgrid';
				$this->QualityCtrl->saveAll($qc_data_to_save, array('validate' => false));
				$last_qc_id = $this->QualityCtrl->getLastInsertId();
				
				$this->QualityCtrl->generateQcCode();
				
				if(!empty($aliquot_data_to_save)){
					$this->AliquotMaster->pkey_safeguard = false;
					$this->AliquotMaster->saveAll($aliquot_data_to_save, array('validate' => false));
					$this->AliquotMaster->pkey_safeguard = true;
					foreach($aliquot_data_to_save as $aliquot_data){
						$this->AliquotMaster->updateAliquotUseAndVolume($aliquot_data['id'], true, true, false);
					}
				}
				
				$target = null;
				if($sample_master_id != null){
					$target = $cancel_button;
				
				}else{
					//different samples, show the result into a tmp batchset
					$datamart_structure = AppModel::getInstance("Datamart", "DatamartStructure", true);
					$batch_set_model = AppModel::getInstance('Datamart', 'BatchSet', true);
					$batch_set_data = array('BatchSet' => array(
						'datamart_structure_id' => $datamart_structure->getIdByModelName('QualityCtrl'),
						'flag_tmp' => true
					));
					$batch_set_model->saveWithIds($batch_set_data, range($last_qc_id - count($qc_data_to_save) + 1, $last_qc_id));
					$target = '/Datamart/BatchSets/listall/'.$batch_set_model->getLastInsertId();
				}
				
				
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) { 
					require($hook_link); 
				}
				
				$this->atimFlash( 'your data has been saved', $target);
				return;
			
			}else{
				$this->AliquotMaster->validationErrors = array();
				$this->QualityCtrl->validationErrors = array();
				if(!empty($errors)) {
					foreach($errors as $field => $msg_and_lines) {
						foreach($msg_and_lines as $msg => $lines) {
							$msg = __($msg);
							$lines_strg = implode(",", array_unique($lines));
							if(!empty($lines_strg) && $is_batch_process) {
								$msg .= ' - ' . str_replace('%s', $lines_strg, __('see # %s'));
							}
							$this->QualityCtrl->validationErrors[$field][] = $msg;
						}
					}
				}
				
				$this->request->data = $display_data;
			}
		}else{
			$this->flash((__('you have been redirected automatically').' (#'.__LINE__.')'), "javascript:history.back();", 5);
			return;
		}
	}
	
	function detail($collection_id, $sample_master_id, $quality_ctrl_id, $is_from_tree_view = false) {
		if((!$collection_id) || (!$sample_master_id) || (!$quality_ctrl_id)) { 
			$this->redirect('/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); 
		}

		// MANAGE DATA
		
		// Get Quality Control Data
		$this->SampleMaster;//lazy load
		$quality_ctrl_data = $this->QualityCtrl->find('first',array(
			'fields' => array('*'),
			'conditions'=>array('QualityCtrl.id' => $quality_ctrl_id,'SampleMaster.collection_id' => $collection_id,'SampleMaster.id' => $sample_master_id),
			'joins' => array(
				AliquotMaster::joinOnAliquotDup('QualityCtrl.aliquot_master_id'), 
				AliquotMaster::$join_aliquot_control_on_dup,
				SampleMaster::joinOnSampleDup('QualityCtrl.sample_master_id'), 
				SampleMaster::$join_sample_control_on_dup)
		));
		if(empty($quality_ctrl_data)) { 
			$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		}
		
		$structure_to_load = 'qualityctrls';
		if(!empty($quality_ctrl_data['AliquotControl']['volume_unit'])){
			$structure_to_load .= ",qualityctrls_volume_for_detail";
		}
		$this->Structures->set($structure_to_load);
		
		// Set aliquot data
		$this->set('quality_ctrl_data', $quality_ctrl_data);
		$this->request->data = array();
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$sample_id_parameter = ($quality_ctrl_data['SampleControl']['sample_category'] == 'specimen')? '%%SampleMaster.initial_specimen_sample_id%%': '%%SampleMaster.id%%';
		$this->set('atim_menu', $this->Menus->get('/InventoryManagement/QualityCtrls/detail/%%Collection.id%%/' . $sample_id_parameter . '/%%QualityCtrl.id%%'));	
		
		$this->set( 'atim_menu_variables', 
			array('Collection.id' => $quality_ctrl_data['SampleMaster']['collection_id'], 
			'SampleMaster.id' => $quality_ctrl_data['QualityCtrl']['sample_master_id'],
			'SampleMaster.initial_specimen_sample_id' => $quality_ctrl_data['SampleMaster']['initial_specimen_sample_id'],
			'QualityCtrl.id' => $quality_ctrl_id) );

		$this->set('is_from_tree_view',$is_from_tree_view);
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
	}
	
	function edit($collection_id, $sample_master_id, $quality_ctrl_id) {
		
		if((!$collection_id) || (!$sample_master_id) || (!$quality_ctrl_id)) { 
			$this->redirect('/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); 
		}		
 
		// MANAGE DATA
		$this->SampleMaster;//lazy load
		$qc_data = $this->QualityCtrl->find('first',array(
			'fields' => array('*'),
			'conditions'=>array('QualityCtrl.id'=>$quality_ctrl_id, 'SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id),
			'joins' => array(
				SampleMaster::joinOnSampleDup('QualityCtrl.sample_master_id'), 
				SampleMaster::$join_sample_control_on_dup)
		));
		
		
		if(empty($qc_data)) { 
			$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		}
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
				
		$sample_id_parameter = ($qc_data['SampleControl']['sample_category'] == 'specimen')? '%%SampleMaster.initial_specimen_sample_id%%': '%%SampleMaster.id%%';
		$this->set('atim_menu', $this->Menus->get('/InventoryManagement/QualityCtrls/detail/%%Collection.id%%/' . $sample_id_parameter . '/%%QualityCtrl.id%%'));	
		
		$this->set( 'atim_menu_variables', 
			array('Collection.id' => $qc_data['SampleMaster']['collection_id'], 
			'SampleMaster.id' => $qc_data['QualityCtrl']['sample_master_id'],
			'SampleMaster.initial_specimen_sample_id' =>  $qc_data['SampleMaster']['initial_specimen_sample_id'],
			'QualityCtrl.id' => $quality_ctrl_id) );

		$this->Structures->set('aliquot_masters,aliquotmasters_volume', 'aliquot_structure');
	
		$hook_link = $this->hook('format');
		if( $hook_link ) {
			require($hook_link);
		}
								
		// MANAGE DATA RECORD
			
		if ( empty($this->request->data) ) {
			$this->request->data = $qc_data;
						
		} else {
			// Launch save process
			
			// Launch validation
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}
			
			$update_new_aliquot_id = null;
			$update_old_aliquot_id = null;
			if(is_numeric($this->request->data['QualityCtrl']['aliquot_master_id'])){
				$update_new_aliquot_id = $this->request->data['QualityCtrl']['aliquot_master_id'];
				$aliquot_data = $this->AliquotMaster->findById($this->request->data['QualityCtrl']['aliquot_master_id']);
				if((empty($aliquot_data) || empty($aliquot_data['AliquotControl']['volume_unit'])) && !empty($this->request->data['QualityCtrl']['used_volume'])){
					$this->request->data['QualityCtrl']['used_volume'] = null;
					AppController::addWarningMsg(__('this aliquot has no recorded volume').". ".__('the inputed volume was automatically removed').".");
				}
			}else{
				$this->request->data['QualityCtrl']['aliquot_master_id'] = null;
			}
			
			if(!empty($qc_data['QualityCtrl']['aliquot_master_id']) && $qc_data['QualityCtrl']['aliquot_master_id'] != $this->request->data['QualityCtrl']['aliquot_master_id']){
				//the aliquot changed, update the old one afterwards
				$update_old_aliquot_id = $qc_data['QualityCtrl']['aliquot_master_id'];
			}
			
			if(!array_key_exists('used_volume', $this->request->data['QualityCtrl'])){
				$this->request->data['QualityCtrl']['used_volume'] = null;
			}
			
			// Save data
			$this->QualityCtrl->id = $quality_ctrl_id;
			$this->QualityCtrl->addWritableField(array('aliquot_master_id'));
			if ($submitted_data_validates && $this->QualityCtrl->save( $this->request->data )) {
				if($update_new_aliquot_id != null){
					$this->AliquotMaster->updateAliquotUseAndVolume($update_new_aliquot_id, true, true, false);
				}
				if($update_old_aliquot_id != null){
					$this->AliquotMaster->updateAliquotUseAndVolume($update_old_aliquot_id, true, true, false);
				}
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) {
					require($hook_link);
				}
				$this->atimFlash( 'your data has been saved', '/InventoryManagement/QualityCtrls/detail/'.$collection_id.'/'.$sample_master_id.'/'.$quality_ctrl_id.'/' );
			}
		}
		
		
		$this->set('aliquot_data_no_vol', $this->AliquotMaster->find('all', array('conditions' => array('AliquotMaster.sample_master_id' => $sample_master_id, AliquotMaster::$volume_condition))));
		$this->set('aliquot_data_vol', $this->AliquotMaster->find('all', array('conditions' => array('AliquotMaster.sample_master_id' => $sample_master_id, 'NOT' => AliquotMaster::$volume_condition))));
	}
	
	function delete($collection_id, $sample_master_id, $quality_ctrl_id) {
		if((!$collection_id) || (!$sample_master_id) || (!$quality_ctrl_id)) { 
			$this->redirect('/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); 
		}		

		$qc_data = $this->QualityCtrl->find('first',array('conditions'=>array('QualityCtrl.id'=>$quality_ctrl_id, 'SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id)));
		if(empty($qc_data)) { 
			$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		}

		// Check deletion is allowed
		$arr_allow_deletion = $this->QualityCtrl->allowDeletion($quality_ctrl_id);
			
		$hook_link = $this->hook('delete');
		if( $hook_link ) { 
			require($hook_link); 
		}		
		
		if($arr_allow_deletion['allow_deletion']) {
			if($this->QualityCtrl->atimDelete($quality_ctrl_id)) {
				if($qc_data['QualityCtrl']['aliquot_master_id'] != null){
					$this->AliquotMaster->updateAliquotUseAndVolume($qc_data['QualityCtrl']['aliquot_master_id'], true, true, false);
				}
				$this->atimFlash( 'your data has been deleted', 
						'/InventoryManagement/QualityCtrls/listAll/'
						.$qc_data['SampleMaster']['collection_id'].'/'
						.$qc_data['QualityCtrl']['sample_master_id'].'/');
			} else {
				$this->flash(__('error deleting data - contact administrator'), '/InventoryManagement/QualityCtrls/listAll/' . $collection_id . '/' . $sample_master_id);
			}
		} else {
			$this->flash(__($arr_allow_deletion['msg']), '/InventoryManagement/QualityCtrls/detail/' . $collection_id . '/' . $sample_master_id . '/' . $quality_ctrl_id);
		}
	}
}
?>
