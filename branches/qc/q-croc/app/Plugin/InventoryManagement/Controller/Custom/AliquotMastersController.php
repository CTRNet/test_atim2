<?php
class AliquotMastersControllerCustom extends AliquotMastersController {
	
	function addAliquotTransfer($aliquot_master_id = null) { 
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

// *** QCROC CUSTOM : CHANGED FROM addAliquotInternalUSe ***
		//$this->Structures->set('aliquotinternaluses', 'aliquotinternaluses_structure');
		//$this->Structures->set('aliquotinternaluses_volume,aliquotinternaluses', 'aliquotinternaluses_volume_structure');
		$this->Structures->set('qcroc_aliquot_transfer', 'aliquotinternaluses_structure');
		$this->Structures->set('qcroc_aliquot_transfer', 'aliquotinternaluses_volume_structure');		
// --- QCROC CUSTOM ---
		
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

// *** QCROC CUSTOM : CHANGED FROM addAliquotInternalUSe ***
			if(empty($errors)) {
				foreach($uses_to_save as &$new_use) $new_use['AliquotInternalUse']['qcroc_is_transfer'] = 1;
				$this->AliquotInternalUse->addWritableField(array('qcroc_is_transfer'));
			}
// --- QCROC CUSTOM ---
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
// *** QCROC CUSTOM : CHANGED FROM addAliquotInternalUSe ***
					$tmp_collection_ids = $this->AliquotMaster->find('all', array('conditions' => array('AliquotMaster.id' => $aliquot_ids), 'fields' => 'DISTINCT AliquotMaster.collection_id'));								
					if(sizeof($tmp_collection_ids) == 1) {
						$this->atimFlash('your data has been saved', '/InventoryManagement/Collections/detail/'.$tmp_collection_ids[0]['AliquotMaster']['collection_id']);
					} else {
// --- QCROC CUSTOM ---
						
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
	
}
