<?php
	
class SampleMastersControllerCustom extends SampleMastersController {

	/*
	@author Stephen Fung
	@date 2015-08-24
	BB-28: "Create Derivaites" function from aliquots does not generate proper sample label
	*/
	
	function batchDerivative($aliquot_master_id = null){
		$url_to_cancel = isset($this->request->data['url_to_cancel'])? $this->request->data['url_to_cancel'] : 'javascript:history.go(-1)';
				
		$unique_aliquot_master_data = null;
		if(!is_null($aliquot_master_id)) {
			$unique_aliquot_master_data = $this->AliquotMaster->findById($aliquot_master_id);
			if(empty($unique_aliquot_master_data)) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			$url_to_cancel = '/InventoryManagement/AliquotMasters/detail/'.$unique_aliquot_master_data['AliquotMaster']['collection_id'].'/'.$unique_aliquot_master_data['AliquotMaster']['sample_master_id'].'/'.$aliquot_master_id;				
		}

		$this->set('url_to_cancel', $url_to_cancel);
		unset($this->request->data['url_to_cancel']);
		
		if(!isset($this->request->data['SampleMaster']['sample_control_id'])
			|| !isset($this->request->data['ParentToDerivativeSampleControl']['parent_sample_control_id'])
		){
			$this->flash((__('you have been redirected automatically').' (#'.__LINE__.')'), $url_to_cancel, 5);
			return;
		} else if($this->request->data['SampleMaster']['sample_control_id'] == ''){
			$this->flash(__("you must select a derivative type"), $url_to_cancel, 5);
			return;
		}
		
		$this->set('aliquot_master_id', $aliquot_master_id);
		
		$lab_book_master_code = null;
		$sync_with_lab_book = null;
		$lab_book_fields = null;
		$lab_book_id = null;
		$parent_sample_control_id = $this->request->data['ParentToDerivativeSampleControl']['parent_sample_control_id'];
		unset($this->request->data['ParentToDerivativeSampleControl']);
		if(isset($this->request->data['DerivativeDetail']['lab_book_master_code']) && !empty($this->request->data['DerivativeDetail']['lab_book_master_code'])){
			$lab_book_master_code = $this->request->data['DerivativeDetail']['lab_book_master_code'];
			$sync_with_lab_book = $this->request->data['DerivativeDetail']['sync_with_lab_book'];
			$lab_book = AppModel::getInstance("LabBook", "LabBookMaster", true);
			$lab_book_expected_ctrl_id = $this->ParentToDerivativeSampleControl->getLabBookControlId($parent_sample_control_id,$this->request->data['SampleMaster']['sample_control_id']); 
			$foo = array();
			$result = $lab_book->syncData($foo, array(), $lab_book_master_code, $lab_book_expected_ctrl_id);

			if(is_numeric($result)){
				$lab_book_id = $result;
			}else{
				$this->flash(__($result), $url_to_cancel, 5);
				return;
			}
			$lab_book_data = $lab_book->findById($lab_book_id);
			$lab_book_fields = $lab_book->getFields($lab_book_data['LabBookControl']['id']);
		}
		$this->set('lab_book_master_code', $lab_book_master_code);
		$this->set('sync_with_lab_book', $sync_with_lab_book);
		$this->set('lab_book_fields', $lab_book_fields);
		unset($this->request->data['DerivativeDetail']);
		
		// Set structures and menu
		$ids = array_key_exists('ids', $this->request->data['SampleMaster']) ? $this->request->data['SampleMaster']['ids'] : $this->request->data['sample_master_ids'];
		$this->set('sample_master_ids', $ids);
		unset($this->request->data['sample_master_ids']);
		
		if(is_null($aliquot_master_id)) {
			$this->setBatchMenu(array('SampleMaster' => $ids));
		} else {
			$this->setAliquotMenu($unique_aliquot_master_data);
		}
		
		$children_control_data = $this->SampleControl->findById($this->request->data['SampleMaster']['sample_control_id']);
		
		$this->Structures->set('view_sample_joined_to_collection', 'sample_info');
		$this->Structures->set(str_replace(",derivative_lab_book", "", $children_control_data['SampleControl']['form_alias']), 'derivative_structure', array('model_table_assoc' => array('SampleDetail' => $children_control_data['SampleControl']['detail_tablename'])));		
		$this->Structures->set(str_replace(",derivative_lab_book", "", $children_control_data['SampleControl']['form_alias']).",sourcealiquots_volume_for_batchderivative", 'derivative_volume_structure');
		$this->Structures->set('used_aliq_in_stock_details', 'sourcealiquots');
		$this->Structures->set('used_aliq_in_stock_details,used_aliq_in_stock_detail_volume', 'aliquots_volume_structure');
		$this->Structures->set('empty', 'empty_structure');
		
		$this->set('children_sample_control_id', $this->request->data['SampleMaster']['sample_control_id']);
		$this->set('created_sample_override_data', array('SampleControl.sample_type'		=> $children_control_data['SampleControl']['sample_type']));
		$this->set('parent_sample_control_id', $parent_sample_control_id);
		
		$joins = array(array(
				'table' => 'view_samples',
				'alias' => 'ViewSample',
				'type' => 'INNER',
				'conditions' => array('AliquotMaster.sample_master_id = ViewSample.sample_master_id')
			)
		);
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
		
		if(isset($this->request->data['SampleMaster']['ids'])){
			//1- INITIAL DISPLAY
			$parent_sample_data_for_display = array();
			$display_limit = Configure::read('SampleDerivativeCreation_processed_items_limit');
			if(!empty($this->request->data['AliquotMaster']['ids'])){
				$this->AliquotMaster->unbindModel(array('belongsTo' => array('SampleMaster')));
				$aliquots = $this->AliquotMaster->find('all', array(
					'conditions'	=> array('AliquotMaster.id' => explode(",", $this->request->data['AliquotMaster']['ids'])),
					'fields'		=> array('*'), 
					'recursive'		=> 0,
					'joins'			=> $joins)
				);
				if(sizeof($aliquots) > $display_limit) {
					$this->flash(__("batch init - number of submitted records too big")." (>$display_limit)", $url_to_cancel, 5);
					return;
				}
				$this->AliquotMaster->sortForDisplay($aliquots, $this->request->data['AliquotMaster']['ids']);
				$this->request->data = array();
				foreach($aliquots as $aliquot){
					$this->request->data[] = array('parent' => $aliquot, 'children' => array());
					$parent_sample_data_for_display[] = $aliquot;	
				}			
			}else{
				$samples = $this->ViewSample->find('all', array('conditions' => array('ViewSample.sample_master_id' => explode(",", $this->request->data['SampleMaster']['ids'])), 'recursive' => -1));
				if(sizeof($samples) > $display_limit) {
					$this->flash(__("batch init - number of submitted records too big")." (>$display_limit)", $url_to_cancel, 5);
					return;
				}
				$this->ViewSample->sortForDisplay($samples, $this->request->data['SampleMaster']['ids']);
				$this->request->data = array();
				foreach($samples as $sample){
					$parent_sample_data_for_display[] = $sample;
					$this->request->data[] = array('parent' => $sample, 'children' => array());				
				}
			}
			$this->set('parent_sample_data_for_display', $this->SampleMaster->formatParentSampleDataForDisplay($parent_sample_data_for_display));
						
			$hook_link = $this->hook('initial_display');
			if($hook_link){
				require($hook_link);
			}
			
		}else{
				
			// 2- VALIDATE PROCESS
			
			unset($this->request->data['SampleMaster']);
			
			$errors = array();
			$prev_data = $this->request->data;
			$this->request->data = array();
			$record_counter = 0;
			$aliquots_data = array();
			$validation_iterations = array('SampleMaster', 'DerivativeDetail', 'SourceAliquot');
			$set_source_aliquot = false;
			$parent_sample_data_for_display = array();			
			foreach($prev_data as $parent_id => &$children){
				$parent = null;
				$record_counter++;
				if(isset($children['AliquotMaster'])){
					$set_source_aliquot = true;					
					$this->AliquotMaster->unbindModel(array('belongsTo' => array('SampleMaster')));
					$parent = $this->AliquotMaster->find('first', array(
						'conditions'	=> array('AliquotMaster.id' => $parent_id),
						'fields'		=> array('*'), 
						'recursive'		=> 0,
						'joins'			=> $joins)
					);
					$parent['AliquotMaster'] = array_merge($parent['AliquotMaster'], $children['AliquotMaster']);
					$parent['FunctionManagement'] = $children['FunctionManagement'];
					$children['AliquotMaster']['id'] = $parent_id;				
					$tmp_storage_coord_x = $children['AliquotMaster']['storage_coord_x'];
					$tmp_storage_coord_y = $children['AliquotMaster']['storage_coord_y'];
					$this->AliquotMaster->data = array();
					unset($children['AliquotMaster']['storage_coord_x']);
					unset($children['AliquotMaster']['storage_coord_y']);
					$this->AliquotMaster->set($children['AliquotMaster']);
					$this->AliquotMaster->validates();
					foreach($this->AliquotMaster->validationErrors as $field => $msgs) {
						$msgs = is_array($msgs)? $msgs : array($msgs);
						foreach($msgs as $msg) $errors[$field][$msg][$record_counter] = $record_counter;
					}
					$this->AliquotMaster->data['AliquotMaster']['storage_coord_x'] = $tmp_storage_coord_x;
					$this->AliquotMaster->data['AliquotMaster']['storage_coord_y'] = $tmp_storage_coord_y;
					$aliquots_data[] = array('AliquotMaster' => $this->AliquotMaster->data['AliquotMaster'], 'FunctionManagement' => $children['FunctionManagement']);
					unset($children['AliquotMaster'], $children['FunctionManagement'], $children['AliquotControl'], $children['StorageMaster']);
				}else{
					$parent = $this->ViewSample->find('first', array('conditions' => array('ViewSample.sample_master_id' => $parent_id), 'recursive' => -1));
				}
				unset($children['ViewSample']);
				
				$new_derivative_created = !empty($children);
				$sample_control_id = $children_control_data['SampleControl']['id'];
				foreach($children as &$child){
					$child['SampleMaster']['sample_control_id'] = $sample_control_id;
					$child['SampleMaster']['collection_id'] = $parent['ViewSample']['collection_id'];
					
					$child['SampleMaster']['initial_specimen_sample_id'] = $parent['ViewSample']['initial_specimen_sample_id'];
					$child['SampleMaster']['initial_specimen_sample_type'] = $parent['ViewSample']['initial_specimen_sample_type'];
					
					$child['SampleMaster']['parent_sample_type'] = $parent['ViewSample']['sample_type'];
					
					$child['DerivativeDetail']['sync_with_lab_book'] = $sync_with_lab_book;
					$child['DerivativeDetail']['lab_book_master_id'] = $lab_book_id;
					
					foreach($validation_iterations as $validation_model_name){
						if(array_key_exists($validation_model_name, $child)) {
							$validation_model = $this->{$validation_model_name}; 
							$validation_model->data = array();
							$validation_model->set($child);
							if(!$validation_model->validates()){								
								foreach($validation_model->validationErrors as $field => $msgs) {
									$msgs = is_array($msgs)? $msgs : array($msgs);
									foreach($msgs as $msg) $errors[$field][$msg][$record_counter] = $record_counter;
								}
							}
							$child = $validation_model->data;
						}					
					}
				}
				
				if($lab_book_id != null){
					$lab_book->syncData($children, array("DerivativeDetail"), $lab_book_master_code);
				}
				$this->request->data[] = array('parent' => $parent, 'children' => $children);//prep data in case validation fails
				if(!$new_derivative_created){
					$errors[]['at least one child has to be created'][$record_counter] = $record_counter;
				}
				$parent_sample_data_for_display[] = $parent;
			}
			$this->set('parent_sample_data_for_display', $this->SampleMaster->formatParentSampleDataForDisplay($parent_sample_data_for_display));
			
			$this->SourceAliquot->validationErrors = null;
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}
			
			// 3- SAVE PROCESS
			
			// BB-28: Get the structure of Collection 
			$collection_data = $this->Collection->getOrRedirect($unique_aliquot_master_data['Collection']['id']);
			
			if(empty($errors)){
				unset($_SESSION['derivative_batch_process']);
				
				AppModel::acquireBatchViewsUpdateLock();
				
				//save
				$child_ids = array();
				
				$this->SampleMaster->addWritableField(array('parent_id', 'sample_control_id', 'collection_id', 'initial_specimen_sample_id', 'initial_specimen_sample_type', 'parent_sample_type'));
				$this->SampleMaster->addWritableField(array('sample_master_id'), $children_control_data['SampleControl']['detail_tablename']);
				$this->SampleMaster->addWritableField(array('sample_master_id'), 'derivative_details');				
				$this->DerivativeDetail->addWritableField(array('sync_with_lab_book', 'lab_book_master_id', 'sample_master_id'));
				$this->SourceAliquot->addWritableField(array('sample_master_id', 'aliquot_master_id', 'used_volume'));
				
				foreach($prev_data as $parent_id => &$children){
					unset($children['ViewSample']);
					unset($children['StorageMaster']);
					foreach($children as &$child_to_save){
						// save sample master
						$this->SampleMaster->id = null;
						if(!$this->SampleMaster->save($child_to_save, false)){ 
							$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
						} 							
						$child_id = $this->SampleMaster->getLastInsertId();

						// Update sample code
						// BB-28: Disabled the old procedure for updating specimen label for the new derivative
						/*
						$query_to_update = "UPDATE sample_masters SET sample_masters.sample_code = sample_masters.id WHERE sample_masters.id = $child_id;";
						$this->SampleMaster->tryCatchQuery($query_to_update); 
						$this->SampleMaster->tryCatchQuery(str_replace("sample_masters", "sample_masters_revs", $query_to_update));
						*/
						
						// BB-28: Generate specimen label code for the new derivative
						$this->SampleMaster->generateSampleLabel($collection_data, $child_to_save['SampleControl']['sample_type'], $child_id);

						// Save derivative detail
						$this->DerivativeDetail->id = $child_id;
						$child_to_save['DerivativeDetail']['sample_master_id'] = $child_id;
						if(!$this->DerivativeDetail->save($child_to_save, false)){ 
							$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
						}

						if($set_source_aliquot){
							//record aliquot use -> source_aliquots
							$this->SourceAliquot->id = null;
							$this->SourceAliquot->data = array();
							$this->SourceAliquot->save(array('SourceAliquot' => array(
								'sample_master_id'	=> $child_id,
								'aliquot_master_id'	=> $parent_id,
								'used_volume'		=> isset($child_to_save['SourceAliquot']['used_volume']) ? $child_to_save['SourceAliquot']['used_volume'] : null,
							)));
						}
													
						$child_ids[] = $child_id;
					}
				}
				
				foreach($aliquots_data as $aliquot){
					//update all used aliquots
					$this->AliquotMaster->data = array();
					if($aliquot['FunctionManagement']['remove_from_storage'] || ($aliquot['AliquotMaster']['in_stock'] == 'no')) {
						// Delete aliquot storage data
						$aliquot['AliquotMaster']['storage_master_id'] = null;
						$aliquot['AliquotMaster']['storage_coord_x'] = null;
						$aliquot['AliquotMaster']['storage_coord_y'] = null;
						$this->AliquotMaster->addWritableField(array('storage_master_id', 'storage_coord_x', 'storage_coord_y'));
					} else {
						$this->AliquotMaster->removeWritableField(array('storage_master_id', 'storage_coord_x', 'storage_coord_y'));
					}								
					$this->AliquotMaster->id = $aliquot['AliquotMaster']['id'];
					$this->AliquotMaster->save($aliquot, false);
					$this->AliquotMaster->updateAliquotUseAndVolume($aliquot['AliquotMaster']['id'], true, true, false);
				}

				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) { 
					require($hook_link); 
				}
				
				AppModel::releaseBatchViewsUpdateLock();
				
				if(is_null($unique_aliquot_master_data)) {
					$datamart_structure = AppModel::getInstance("Datamart", "DatamartStructure", true);
					$batch_set_model = AppModel::getInstance('Datamart', 'BatchSet', true);
					$batch_set_data = array('BatchSet' => array(
						'datamart_structure_id' => $datamart_structure->getIdByModelName('ViewSample'),
						'flag_tmp' => true
					));
					$batch_set_model->check_writable_fields = false;
					$batch_set_model->saveWithIds($batch_set_data, $child_ids);
					$this->atimFlash(__('your data has been saved'), '/Datamart/BatchSets/listall/'.$batch_set_model->getLastInsertId());
				} else {
					if(!isset($unique_aliquot_master_data['AliquotMaster'])){
						$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
					}
					$this->atimFlash(__('your data has been saved'),'/InventoryManagement/SampleMasters/detail/' .$unique_aliquot_master_data['AliquotMaster']['collection_id'] . '/' . $child_ids[0].'/');					
				}
				
			}else{
				$this->SampleMaster->validationErrors = array();				
				$this->SampleDetail->validationErrors = array();				
				$this->DerivativeDetail->validationErrors = array();				
				$this->AliquotMaster->validationErrors = array();				
				$this->SourceAliquot->validationErrors = array();				
				
				foreach($errors as $field => $msg_and_lines) {
					foreach($msg_and_lines as $msg => $lines) {
						$this->SampleMaster->validationErrors[$field][] = __($msg) . ' - ' . str_replace('%s', implode(",", $lines), __('see # %s'));					
					} 
				}
			}
		}
	}

	/**
	* @author: Stephen Fung
	* @since: 2016-12-13
	* BB-232 Custom View
	**/

	function printSampleLabels() {

		$this->layout = false;
		Configure::write('debug', 0);
		$conditions = array();
			
		switch($this->passedArgs['model']){

			case 'Collection':

				//Find the Sample Label of the Sample from the ViewSample Table using Collection ID
				$sample_code_result = $this->ViewSample->find('all', array(
					'conditions' => array('ViewSample.collection_id' => $this->passedArgs['id'], 'ViewSample.sample_type' => array('blood')),
					'fields' => array('ViewSample.sample_code')
				));

				// Return exception if sample can't be found
				if(empty($sample_code_result)) {
					return $this->flash(__('there are no blood sample labels to print'), 'javascript:history.back();');
				}

				$headers = array('Sample Labels');

				$csv_data = array($headers);

				foreach ($sample_code_result as $item) {
					//array_push($csv_data, array($item['ViewSample']['sample_code']));
					$trimmed_item = substr($item['ViewSample']['sample_code'], 1); //Remove the "C" from the sample code
					array_push($csv_data, array($trimmed_item));
				}

				$this->response->header(array(
					'Content-Type' => 'text/csv; charset=utf-8',
					'Content-Disposition' => 'attachment; filename=sample_labels.csv'
				));

				$output = fopen('php://output', 'w');

				for ($i = 0; $i < count($csv_data); $i++) {
					fputcsv($output, $csv_data[$i]);
				}

				fclose($output);

				return $this->response;
				
				break;

			default:

				//Find the Sample Label of the Sample from the ViewSample Table using Sample ID
				$sample_code_result = $this->ViewSample->find('first', array(
					'conditions' => array('ViewSample.sample_master_id' => $this->passedArgs['id'], 'ViewSample.sample_type' => array('blood')),
					'fields' => array('ViewSample.sample_code')
				));

				// Return exception if sample can't be found
				if(empty($sample_code_result)) {
					return $this->flash(__('there are no blood sample labels to print'), 'javascript:history.back();');
				}

				$headers = array('Sample Labels');

				$csv_data = array($headers);

				foreach ($sample_code_result as $item) {
					//array_push($csv_data, array($item['sample_code']));
					$trimmed_item = substr($item['sample_code'], 1); //Remove the "C" from the sample code
					array_push($csv_data, array($trimmed_item));
				}

				$this->response->header(array(
					'Content-Type' => 'text/csv; charset=utf-8',
					'Content-Disposition' => 'attachment; filename=sample_labels.csv'
				));

				$output = fopen('php://output', 'w');

				for ($i = 0; $i < count($csv_data); $i++) {
					fputcsv($output, $csv_data[$i]);
				}

				fclose($output);

				return $this->response;

				
			break;
		}



		//exit("At Print Sample Labels");
	}

}

	

