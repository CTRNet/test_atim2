<?php
class AliquotMastersControllerCustom extends AliquotMastersController{
	
	function editBarcodeAndLabel() {
		
		//GET DATA
		
		$initial_display = false;
		$aliquot_ids = array();
		
		$this->setUrlToCancel();
		$url_to_cancel = $this->request->data['url_to_cancel'];
		unset($this->request->data['url_to_cancel']);	
		
		if(isset($this->request->data['ViewAliquot']['aliquot_master_id'])) {
			//Action launched from the databrowser: 
			if($this->request->data['ViewAliquot']['aliquot_master_id'] == 'all' && isset($this->request->data['node'])) {
				$this->BrowsingResult = AppModel::getInstance('Datamart', 'BrowsingResult', true);
				$browsing_result = $this->BrowsingResult->find('first', array('conditions' => array('BrowsingResult.id' => $this->request->data['node']['id'])));
				$this->request->data['ViewAliquot']['aliquot_master_id'] = explode(",", $browsing_result['BrowsingResult']['id_csv']);
			}
			$aliquot_ids = array_filter($this->request->data['ViewAliquot']['aliquot_master_id']);
			$initial_display = true;
		} else if(isset($this->request->data['aliquot_ids_to_update'])) {
			//Data submited 
			$aliquot_ids = array_filter(explode(',',$this->request->data['aliquot_ids_to_update']));
			unset($this->request->data['aliquot_ids_to_update']);
		}
		
		$aliquot_data = $this->AliquotMaster->find('all', array('conditions' => array('AliquotMaster.id' => $aliquot_ids)));
		$display_limit = Configure::read('AliquotModification_processed_items_limit');
		if(empty($aliquot_data)){
			$this->flash((__('you have been redirected automatically').' (#'.__LINE__.')'), $url_to_cancel, 5);
			return;
		} else if(sizeof($aliquot_data) > $display_limit) {
			$this->flash(__("batch init - number of submitted records too big")." (>$display_limit)", $url_to_cancel, 5);
			return;
		}
		$this->AliquotMaster->sortForDisplay($aliquot_data, $aliquot_ids);
		
		$aliquots_used_barcode = array();
		$aliquots_used = $this->AliquotInternalUse->find('all', array('conditions' => array('AliquotInternalUse.aliquot_master_id' => $aliquot_ids, 'AliquotInternalUse.type' => 'sent to processing site')));	
		foreach($aliquots_used as $new_use) {
			$aliquots_used_barcode[] = $new_use['AliquotMaster']['barcode'];
		}
		if(!empty($aliquots_used_barcode)) AppController::addWarningMsg(__('you are editing aliquots that have already been sent to processing site').'. '.str_replace('%s', '['.implode('] ,[',$aliquots_used_barcode).']', __('see # %s')));
		
		$current_barcode_to_aliquot_master_id = array();
		foreach($aliquot_data as $new_aliquot) {
			if(isset($current_barcode_to_aliquot_master_id[$new_aliquot['AliquotMaster']['barcode']])) {
				$this->flash((__('you can not edit 2 aliquots with the same barcode')), $url_to_cancel, 5);
				return;
			}
			$current_barcode_to_aliquot_master_id[$new_aliquot['AliquotMaster']['barcode']] = $new_aliquot['AliquotMaster']['id'];
		}
		
		$this->set('aliquot_ids_to_update', implode(',', $aliquot_ids));
		
		// SET MENU AND STRUCTURE DATA
		
		$this->set('atim_menu', $this->Menus->get('/InventoryManagement/'));
		$this->Structures->set('procure_aliquot_barcode_and_label_update');
		
		$this->set('url_to_cancel', $url_to_cancel);
		
		//MANAGE DATA
		
		if($initial_display){
			
			// Initial Display
			$this->request->data = $aliquot_data;
				
		} else {
			
			// Launch validation
			$errors = array();
			$record_counter = 0;
			foreach($this->request->data as $key => $new_studied_aliquot){
				$record_counter++;
				// Get order item id
				if(!isset($current_barcode_to_aliquot_master_id[$new_studied_aliquot['ViewAliquot']['barcode']])) { $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); }
				$new_studied_aliquot['AliquotMaster']['id'] = $current_barcode_to_aliquot_master_id[$new_studied_aliquot['ViewAliquot']['barcode']];
				$this->AliquotMaster->data = array();	// *** To guaranty no merge will be done with previous data ***
				$this->AliquotMaster->id = $new_studied_aliquot['AliquotMaster']['id'];
				$this->AliquotMaster->set($new_studied_aliquot);
				$new_studied_aliquot = $this->AliquotMaster->data;
				if(!$this->AliquotMaster->validates()) {
					foreach($this->AliquotMaster->validationErrors as $field => $msgs) {
						$msgs = is_array($msgs)? $msgs : array($msgs);
						foreach($msgs as $msg) $errors['AliquotMaster'][$field][$msg][]= $record_counter;
					}
				}
				$barcode_error = $this->AliquotMaster->validateBarcode($new_studied_aliquot['AliquotMaster']['barcode'], $new_studied_aliquot['ViewAliquot']['participant_identifier'], $new_studied_aliquot['ViewAliquot']['procure_visit']);
				if($barcode_error) $errors['AliquotMaster']['barcode'][__($barcode_error)][] = $record_counter;
				// Reset data
				$this->request->data[$key] = $new_studied_aliquot;
			}		
			
			if (empty($errors)) {
				// Launch save process
				$this->AliquotMaster->writable_fields_mode = 'editgrid';
				foreach($this->request->data as $new_studied_aliquot_to_save){
					// Save data
					$this->AliquotMaster->data = array();	// *** To guaranty no merge will be done with previous data ***
					$this->AliquotMaster->id = $new_studied_aliquot_to_save['AliquotMaster']['id'];
					if(!$this->AliquotMaster->save($new_studied_aliquot_to_save['AliquotMaster'], false)) {
						$this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
					}
				}
				// Create batch set
				$datamart_structure = AppModel::getInstance("Datamart", "DatamartStructure", true);
				$batch_set_model = AppModel::getInstance('Datamart', 'BatchSet', true);
				$batch_set_data = array('BatchSet' => array(
						'datamart_structure_id' => $datamart_structure->getIdByModelName('ViewAliquot'),
						'flag_tmp' => true
				));
				$batch_set_model->check_writable_fields = false;
				$batch_set_model->saveWithIds($batch_set_data, $aliquot_ids);
				$this->atimFlash(__('your data has been saved'), '/Datamart/BatchSets/listall/'.$batch_set_model->getLastInsertId());
			} else {
				// Set error message
				foreach($errors as $model => $field_messages) {
					$this->{$model}->validationErrors = array();
					foreach($field_messages as $field => $messages) {
						foreach($messages as $message => $lines_nbr) {
							if(!array_key_exists($field, $this->{$model}->validationErrors)) {
								$this->{$model}->validationErrors[$field][] = $message.' - ' . str_replace('%s', implode(',',$lines_nbr), __('see line %s'));
							} else {
								$this->{$model}->validationErrors[][] = $message.' - ' . str_replace('%s', implode(',',$lines_nbr), __('see line %s'));
							}
						}
					}
				}
			}	
		}
	}

}