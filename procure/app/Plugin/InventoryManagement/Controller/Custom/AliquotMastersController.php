<?php
class AliquotMastersControllerCustom extends AliquotMastersController {
	
	function addInternalUseToManyAliquots($storage_master_id = null) {
		$initial_display = false;
		$aliquot_ids = array();
		
		$this->setUrlToCancel();
		$url_to_cancel = $this->request->data['url_to_cancel'];
		unset($this->request->data['url_to_cancel']);
	
		//GET DATA
	
		if(isset($this->request->data['ViewAliquot']['aliquot_master_id'])){
			if($this->request->data['ViewAliquot']['aliquot_master_id'] == 'all' && isset($this->request->data['node'])) {
				$this->BrowsingResult = AppModel::getInstance('Datamart', 'BrowsingResult', true);
				$browsing_result = $this->BrowsingResult->find('first', array('conditions' => array('BrowsingResult.id' => $this->request->data['node']['id'])));
				$this->request->data['ViewAliquot']['aliquot_master_id'] = explode(",", $browsing_result['BrowsingResult']['id_csv']);
			}
			$aliquot_ids = array_filter($this->request->data['ViewAliquot']['aliquot_master_id']);
			$initial_display = true;
				
		} else if(isset($this->request->data['aliquot_ids'])) {
			$aliquot_ids = explode(',',$this->request->data['aliquot_ids']);
		}
		$this->set('aliquot_ids',implode(',',$aliquot_ids));
		
		$studied_aliquot_nbrs = $this->AliquotMaster->find('count', array('conditions' => array('AliquotMaster.id' => $aliquot_ids), 'recursive' => '-1'));		
		
		if(!$studied_aliquot_nbrs) {
			$this->flash((__('you have been redirected automatically').' (#'.__LINE__.')'), $url_to_cancel, 5);
			return;
		} else if($studied_aliquot_nbrs > $this->Collection->procure_transferred_aliquots_limit) {
			$this->flash((__("batch init - number of submitted records too big")." (".$this->Collection->procure_transferred_aliquots_limit.")"), $url_to_cancel, 5);
			return;
		}
				
		$aliquot_control_ids = array();
		foreach($this->AliquotMaster->find('all', array('conditions' => array('AliquotMaster.id' => $aliquot_ids), 'fields' => array('DISTINCT AliquotMaster.aliquot_control_id'), 'recursive' => '-1')) as $new_ctrl) $aliquot_control_ids[] = $new_ctrl['AliquotMaster']['aliquot_control_id']; 	
		$all_volume_units = $this->AliquotControl->find('all', array('conditions' => array('AliquotControl.id' => $aliquot_control_ids), 'fields' => array('DISTINCT AliquotControl.volume_unit'), 'recursive' => '-1'));
		$aliquot_volume_unit = null;
		if(sizeof($all_volume_units) == 1) {
			if(!empty($all_volume_units[0]['AliquotControl']['volume_unit'])) {
				$aliquot_volume_unit = $all_volume_units[0]['AliquotControl']['volume_unit'];
			}
		} else {
			AppController::addWarningMsg(__('aliquot(s) volume units are different - no used volume can be completed'));
		}
		$this->set('aliquot_volume_unit' , $aliquot_volume_unit);
		
		$unconsented_aliquots = $this->AliquotMaster->getUnconsentedAliquots(array('id' => $aliquot_ids));
		if(!empty($unconsented_aliquots)){
			AppController::addWarningMsg(__('aliquot(s) without a proper consent').": ".count($unconsented_aliquots));
		}
	
		$this->set('atim_menu', $this->Menus->get('/InventoryManagement/'));
	
		$this->set('url_to_cancel', $url_to_cancel);
		$this->set('storage_master_id', null);
		
		$this->Structures->set(($aliquot_volume_unit? 'aliquotinternaluses_volume,aliquotinternaluses' : 'aliquotinternaluses'));
	
		//MANAGE DATA
		
		if($initial_display) {
			
			$this->request->data = array();
				
		} else {
			
			$submitted_data_validates = true;
			
			$this->AliquotInternalUse->id = null;
			$this->AliquotInternalUse->data = null;
			$this->AliquotInternalUse->set($this->request->data);
			if(!$this->AliquotInternalUse->validates()) $submitted_data_validates = false;
			$this->request->data['AliquotInternalUse'] = $this->AliquotInternalUse->data['AliquotInternalUse'];
			
			if(isset($this->request->data['AliquotInternalUse']['used_volume']) && strlen($this->request->data['AliquotInternalUse']['used_volume']) && empty($aliquot_volume_unit)) {
				$this->SourceAliquot->validationErrors['use'][] = 'no used volume can be recorded'; 
				$submitted_data_validates = false;		
			}	
			
			if($submitted_data_validates){
			
				AppModel::acquireBatchViewsUpdateLock();
				
				//saving
				$aliquot_internal_use_data = array('AliquotInternalUse' => $this->request->data['AliquotInternalUse']);
				$this->AliquotInternalUse->addWritableField(array('aliquot_master_id'));
				$this->AliquotInternalUse->writable_fields_mode = 'add';
				foreach($aliquot_ids as $aliquot_master_id) {
					$this->AliquotInternalUse->id = null;
					$this->AliquotInternalUse->data = null;
					$aliquot_internal_use_data['AliquotInternalUse']['aliquot_master_id'] = $aliquot_master_id;
					if (!$this->AliquotInternalUse->save($aliquot_internal_use_data, false)) $this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
					if(!$this->AliquotMaster->updateAliquotUseAndVolume($aliquot_master_id, true, true)) $this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
				}
				
				//batch
				$batch_ids = $aliquot_ids;
				$datamart_structure = AppModel::getInstance("Datamart", "DatamartStructure", true);
					
				$batch_set_data = array('BatchSet' => array(
						'datamart_structure_id'	=> $datamart_structure->getIdByModelName('ViewAliquot'),
						'flag_tmp' => true
				));
					
				$batch_set_model = AppModel::getInstance('Datamart', 'BatchSet', true);
				$batch_set_model->saveWithIds($batch_set_data, $batch_ids);
					
				AppModel::releaseBatchViewsUpdateLock();
				
				$this->atimFlash(__('your data has been saved'), '/Datamart/BatchSets/listall/'.$batch_set_model->getLastInsertId());
			}
		}
	}
}
