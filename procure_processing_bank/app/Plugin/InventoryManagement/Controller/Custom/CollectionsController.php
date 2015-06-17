<?php
class CollectionsControllerCustom extends CollectionsController{
	
	//ATiM PROCURE PROCESSING BANK
	// Will create:
	//  - Participants
	//  - Collections
	//  - Samples
	//  - Aliquots
	// based on data linked to transferred aliquots (from one bank to the processing bank). 
	function add($browse_csv = true) {
		$this->set('atim_variables', array());
		$this->set('atim_menu', $this->Menus->get('/InventoryManagement/Collections/search'));
		
		$this->Structures->set($browse_csv? 'procure_processing_bank_transferred_aliquots_details_file' : 'procure_processing_bank_transferred_aliquots_details');
		$this->set('browse_csv', $browse_csv);
		
		if(empty($this->request->data)) {
			
			// *** INITIAL DISPLAY ***
			
			if($browse_csv) $this->request->data['Config']['define_csv_separator'] = csv_separator;
		
		} else {	
			$this->AliquotControl = AppModel::getInstance("InventoryManagement", "AliquotControl", true);
			if(array_key_exists('FunctionManagement', $this->request->data) && array_key_exists('procure_processing_bank_transferred_aliquots_details_file', $this->request->data['FunctionManagement'])) {
				
				// *** PARSE SUBMITTED FILE TO SET DEFAULT DATA ***
				
				$browsed_file_data = $this->request->data['FunctionManagement']['procure_processing_bank_transferred_aliquots_details_file'];
				if($browsed_file_data['name']) {
					if(!preg_match('/((\.txt)|(\.csv))$/', $browsed_file_data['name'])) {
						$this->redirect('/Pages/err_submitted_file_extension', null, true);
					} else {
						$handle = fopen($browsed_file_data['tmp_name'], "r");
						if($handle) {
							$row_counter = 0;
							$submitted_data  = array();
							$errors_tracking = array();
							$premissible_recevied_aliquots_descriptions_list = $this->AliquotControl->getTransferredAliquotsDescriptionsList();
							while (($csv_data = fgetcsv($handle, 1000, $this->request->data['Config']['define_csv_separator'], '"')) !== FALSE) {
								$row_counter++;
								$csv_data = array_values(array_filter($csv_data));
								if($csv_data) {
									if(sizeof($csv_data) != 4) {
										$errors_tracking['-1']['some aliquot data is missing - check csv separator'][] = $row_counter;
										$submitted_data[] = array('AliquotMaster' => array('barcode' => '?'));
									} else {
										list($participant_identifier, $visit, $aliquot_description, $aliquot_barcode) = $csv_data;
										$new_line_data = array();
										//Check Participant Identifier
										if(!preg_match("/^PS[1-4]P0([0-9]+)$/", $participant_identifier)) $errors_tracking['participant_identifier']['format of the participant identifier is wrong'][] = $row_counter;
										$new_line_data['Participant']['participant_identifier'] = $participant_identifier;
										//Check Visit
										$visit = strtoupper($visit);
										if(!preg_match('/^V((0[1-9])|(1[0-9]))$/', $visit)) {
											$visit = '';
											$errors_tracking['procure_visit']['format of the visite is wrong'][] = $row_counter;
										}
										$new_line_data['Collection']['procure_visit'] = $visit;
										//Check aliquot defintion
										$aliquot_description = strtolower($aliquot_description);
										if(!array_key_exists($aliquot_description, $premissible_recevied_aliquots_descriptions_list)) {
											$aliquot_description = '';
											$errors_tracking['procure_processing_bank_transferred_aliquots_description']['format of the aliquot description is wrong'][] = $row_counter;
										}
										$new_line_data['FunctionManagement']['procure_processing_bank_transferred_aliquots_description'] = $aliquot_description;
										//Barcode
										$new_line_data['AliquotMaster']['barcode'] = $aliquot_barcode;
										//Set Data
										$submitted_data[] = $new_line_data;
									}
								}
							}
							foreach($errors_tracking as $field => $lines_and_message) {
								foreach($lines_and_message as $msg => $lines) {
									$this->AliquotMaster->validationErrors[$field][] = __($msg) . ' - ' . str_replace('%s', implode(",", $lines), __('see CSV line(s) %s'));
								}
							}
							$this->request->data = $submitted_data;
						} else {
							$this->redirect('/Pages/err_opening_submitted_file', null, true);
						}
					}
				} else {
					AppController::addWarningMsg(__('no file has been selected'));
					$this->request->data = array(array());
				}
				
			} else {
				
				// *** CREATE PARTICIPANT THEN COLLECTION THEN SAMPLE THEN ALIQUOT ***
				
				$errors_tracking = array();
					
				// Validation
					
				$row_counter = 0;
				$studied_participants = array();
				foreach($this->request->data as &$data_unit){
					$row_counter++;
					//Check Participant Identifier
					if(!preg_match("/^PS[1-4]P0([0-9]+)$/", $data_unit['Participant']['participant_identifier'])) {
						$errors_tracking['participant_identifier']['format of the participant identifier is wrong'][] = $row_counter;
					} else {
						$studied_participants[$data_unit['Participant']['participant_identifier']] = '-1';
					}
					//Check Aliquot Not Duplicated
					$this->AliquotMaster->validationErrors = array();
					$this->AliquotMaster->checkDuplicatedAliquotBarcode($data_unit);
					foreach($this->AliquotMaster->validationErrors as $field => $msgs) {
						$msgs = is_array($msgs)? $msgs : array($msgs);
						foreach($msgs as $msg) $errors_tracking[$field][$msg][] = $row_counter;
					}
				}
				unset($data_unit);
				
				if(empty($errors_tracking)){
					
					AppModel::acquireBatchViewsUpdateLock();
					
					//Build Sample & Aliquot Control Ids Array
					
					$sample_and_aliquot_control_data_from_control_ids = array();
					$sample_and_aliquot_types_to_control_ids = array();
					foreach($this->ParentToDerivativeSampleControl->find('all', array('conditions' => array('ParentToDerivativeSampleControl.flag_active' => true))) as $new_parent_to_derivative_sample_control_link) {
						$sample_and_aliquot_control_data_from_control_ids[$new_parent_to_derivative_sample_control_link['DerivativeControl']['id']] = array('SampleControl' => $new_parent_to_derivative_sample_control_link['DerivativeControl'], 'AliquotControl' => null);
						$sample_and_aliquot_types_to_control_ids[$new_parent_to_derivative_sample_control_link['DerivativeControl']['sample_type']] = $new_parent_to_derivative_sample_control_link['DerivativeControl']['id'];
					}
					foreach($this->AliquotControl->find('all', array('conditions' => array('AliquotControl.sample_control_id' => $sample_and_aliquot_types_to_control_ids, 'AliquotControl.flag_active' => '1'))) as $new_aliquot_control) {
						$sample_control_id = $new_aliquot_control['AliquotControl']['sample_control_id'];
						if(!isset($sample_and_aliquot_control_data_from_control_ids[$sample_control_id])) $this->redirect( '/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, NULL, TRUE );
						$sample_type = $sample_and_aliquot_control_data_from_control_ids[$sample_control_id]['SampleControl']['sample_type'];
						$aliquot_control_id = $new_aliquot_control['AliquotControl']['id'];
						$aliquot_type = $new_aliquot_control['AliquotControl']['aliquot_type'];
						$sample_and_aliquot_control_data_from_control_ids["$sample_control_id-$aliquot_control_id"] = array_merge($sample_and_aliquot_control_data_from_control_ids[$sample_control_id], $new_aliquot_control);
						$sample_and_aliquot_types_to_control_ids["$sample_type-$aliquot_type"] = "$sample_control_id-$aliquot_control_id";
					}
					
					//Create participant or get participant id
					
					$this->Participant = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
					$atim_participants = $this->Participant->find('all', array('conditions' => array('Participant.participant_identifier' => array_keys($studied_participants)), 'fields' => array('Participant.id', 'Participant.participant_identifier'), 'recursive' => '-1'));			
					foreach($atim_participants as $new_participant) $studied_participants[$new_participant['Participant']['participant_identifier']] = $new_participant['Participant']['id'];
					$this->Participant->addWritableField(array('participant_identifier'));
					foreach($studied_participants as $participant_identifier => $participant_id) {
						if($participant_id == '-1') {
							$this->Participant->id = null;
							$this->Participant->data = array();
							if(!$this->Participant->save(array('participant_identifier' => $participant_identifier), false)) $this->redirect( '/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, NULL, TRUE );
							$studied_participants[$participant_identifier] = $this->Participant->getLastInsertId();							
						}
					}
					$atim_participants = $studied_participants;
					unset($studied_participants);
					
					//Get existing collections
					
					$atim_participant_collections = array();
					$atim_participants_from_id = array_flip($atim_participants);
					foreach($this->Collection->find('all', array('conditions' => array('Collection.participant_id' => $atim_participants), 'fields' => array('Collection.id', 'Collection.participant_id', 'Collection.procure_visit'), 'recursive' => '-1')) as $new_collection) {
						$atim_participant_collections[$atim_participants_from_id[$new_collection['Collection']['participant_id']].'-'.$new_collection['Collection']['procure_visit']] = $new_collection['Collection']['id'];
					}
					
					//Create collections, samples and aliquots
					
					$this->Collection->addWritableField(array('participant_id', 'procure_visit'));
					
					$aliquot_master_ids = array();
					
					foreach($this->request->data as $data_unit){
						
						//1 :: Manage collection
						
						$collection_id = null;
						$collection_key = $data_unit['Participant']['participant_identifier'].'-'.$data_unit['Collection']['procure_visit'];
						if(array_key_exists($collection_key, $atim_participant_collections)) {
							$collection_id = $atim_participant_collections[$collection_key];
						} else {						
							//Create collection
							$this->Collection->id = null;
							$this->Collection->data = array();
							if(!$this->Collection->save(array('participant_id' => $atim_participants[$data_unit['Participant']['participant_identifier']], 'procure_visit' => $data_unit['Collection']['procure_visit']), false)) $this->redirect( '/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, NULL, TRUE );
							$collection_id = $this->Collection->getLastInsertId();
							$atim_participant_collections[$collection_key] = $collection_id; 
						}
						
						//2 :: Create Samples and aliquots
						
						$initial_specimen_sample_id = null;
						$initial_specimen_sample_type = null;
						$parent_sample_master_id = null;
						$parent_sample_type = null;				
						$samples_and_aliquot_data = $this->AliquotControl->formatTransferredAliquotsDescriptionToArray($data_unit['FunctionManagement']['procure_processing_bank_transferred_aliquots_description']);
						while($new_sample_and_aliquot = array_shift($samples_and_aliquot_data)) {
							$sample_type = $new_sample_and_aliquot['sample_type'];
							$aliquot_type = $new_sample_and_aliquot['aliquot_type']? '-'.$new_sample_and_aliquot['aliquot_type'] : '';
							if(!isset($sample_and_aliquot_types_to_control_ids[$sample_type.$aliquot_type]) || !isset($sample_and_aliquot_control_data_from_control_ids[$sample_and_aliquot_types_to_control_ids[$sample_type.$aliquot_type]])) $this->redirect( '/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, NULL, TRUE );
							$sample_and_aliquot_control_data = $sample_and_aliquot_control_data_from_control_ids[$sample_and_aliquot_types_to_control_ids[$sample_type.$aliquot_type]];
							$is_specimen = ($sample_and_aliquot_control_data['SampleControl']['sample_category'] == 'specimen') ? true : false;
							if($is_specimen) {
								if($initial_specimen_sample_id || $initial_specimen_sample_type || $parent_sample_type || $parent_sample_master_id) $this->redirect( '/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, NULL, TRUE );
							} else {
								if(!$initial_specimen_sample_id || !$initial_specimen_sample_type || !$parent_sample_type || !$parent_sample_master_id) $this->redirect( '/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, NULL, TRUE );
							}
							
							//2-a :: Manage Sample
							
							$conditions = array(
								'SampleMaster.collection_id' => $collection_id, 
								'SampleMaster.sample_control_id' => $sample_and_aliquot_control_data['SampleControl']['id'],
								'SampleMaster.procure_processing_bank_created_by_system' => '1');
							if(!$is_specimen) $conditions['SampleMaster.parent_id'] = $parent_sample_master_id;
							$sample_master_id = null;
							$sample_data = $this->SampleMaster->find('first', array('conditions' => $conditions, 'recursive' => '-1'));
							if($sample_data) {
								$sample_master_id = $sample_data['SampleMaster']['id'];
							} else {
								//New Sample Master Data Record
								$this->SampleMaster->addWritableField(array('collection_id', 'sample_control_id', 'initial_specimen_sample_type', 'initial_specimen_sample_id', 'parent_id', 'parent_sample_type', 'procure_processing_bank_created_by_system'));
								$this->SampleMaster->addWritableField(array('sample_master_id'), $sample_and_aliquot_control_data['SampleControl']['detail_tablename']);
								$sample_data_to_record = array(
									'SampleMaster' => array(
										'collection_id' => $collection_id,
										'sample_control_id' => $sample_and_aliquot_control_data['SampleControl']['id'],
										'initial_specimen_sample_type' => $is_specimen? $sample_and_aliquot_control_data['SampleControl']['sample_type'] : $initial_specimen_sample_type,
										'initial_specimen_sample_id' => $initial_specimen_sample_id,	//NULL if specimen, will be set later
										'parent_sample_type' => $parent_sample_type,					//NULL if specimen
										'parent_id' => $parent_sample_master_id,						//NULL if specimen
										'procure_processing_bank_created_by_system' => '1'),
									'SampleDetail' => array());		
								$this->SampleMaster->id = null;	
								$this->SampleMaster->data = array();
								if(!$this->SampleMaster->save($sample_data_to_record, false)) $this->redirect( '/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, NULL, TRUE );
								$sample_master_id = $this->SampleMaster->getLastInsertId();
								$query_to_update = null;
								if($is_specimen){
									$query_to_update = "UPDATE sample_masters SET sample_masters.sample_code = sample_masters.id, sample_masters.initial_specimen_sample_id = sample_masters.id WHERE sample_masters.id = $sample_master_id;";
								}else{
									$query_to_update = "UPDATE sample_masters SET sample_masters.sample_code = sample_masters.id WHERE sample_masters.id = $sample_master_id;";
								}
								$this->SampleMaster->tryCatchQuery($query_to_update);
								$this->SampleMaster->tryCatchQuery(str_replace("sample_masters", "sample_masters_revs", $query_to_update));
								//New Specimen/Derivative Details Record
								$this->SampleMaster->addWritableField(array('sample_master_id'), $is_specimen? 'specimen_details' : 'derivative_details');
								if($is_specimen){
									// SpecimenDetail
									$this->SpecimenDetail->id = $sample_master_id;
									if(!$this->SpecimenDetail->save(array('sample_master_id' => $sample_master_id), false)) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
								} else {
									// DerivativeDetail
									$this->DerivativeDetail->id = $sample_master_id;
									if(!$this->DerivativeDetail->save(array('sample_master_id' => $sample_master_id), false)) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
								}
							}
							//Reset Sample Data
							if($is_specimen) {
								$initial_specimen_sample_id = $sample_master_id;
								$initial_specimen_sample_type = $sample_and_aliquot_control_data['SampleControl']['sample_type'];
							}
							$parent_sample_master_id = $sample_master_id;
							$parent_sample_type = $sample_and_aliquot_control_data['SampleControl']['sample_type'];
							
							//2-b :: Create Aliquot
							
							if($new_sample_and_aliquot['aliquot_type']) {
								if(!$sample_and_aliquot_control_data['AliquotControl']) $this->redirect( '/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, NULL, TRUE );
								$new_aliquot = array(
									'AliquotMaster' => array(
										'collection_id' => $collection_id,
										'sample_master_id' => $sample_master_id,
										'aliquot_control_id' => $sample_and_aliquot_control_data['AliquotControl']['id'],
										'barcode' => $data_unit['AliquotMaster']['barcode'],
										'in_stock' => 'yes - available',
										'use_counter' => '0',
										'procure_processing_bank_created_by_system' => '1'),
									'AliquotDetail' => array());
								if($new_sample_and_aliquot['aliquot_type'] == 'block') $new_aliquot['AliquotDetail']['block_type'] = $new_sample_and_aliquot['block_type'];
								$this->AliquotMaster->addWritableField(array('collection_id', 'sample_master_id', 'aliquot_control_id', 'barcode', 'in_stock', 'use_counter','procure_processing_bank_created_by_system'));
								$this->AliquotMaster->addWritableField(($new_sample_and_aliquot['aliquot_type'] == 'block'? array('aliquot_master_id'): array('aliquot_master_id', 'block_type')), $sample_and_aliquot_control_data['AliquotControl']['detail_tablename']);
								$this->AliquotMaster->id = null;
								$this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
								if(!$this->AliquotMaster->save($new_aliquot, false)) $this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
								$aliquot_master_ids[] = $this->AliquotMaster->getLastInsertId();
							}
						}
					}
					
					AppModel::releaseBatchViewsUpdateLock();
					
					$datamart_structure = AppModel::getInstance("Datamart", "DatamartStructure", true);
					$batch_set_data = array('BatchSet' => array(
						'datamart_structure_id'	=> $datamart_structure->getIdByModelName('ViewAliquot'),
						'flag_tmp' => true));
					$batch_set_model = AppModel::getInstance('Datamart', 'BatchSet', true);
					$batch_set_model->saveWithIds($batch_set_data, $aliquot_master_ids);
					
					$this->atimFlash(__('your data has been saved'), '/Datamart/BatchSets/listall/'.$batch_set_model->getLastInsertId());
				
				} else {

					$this->AliquotMaster->validationErrors = array();
					foreach($errors_tracking as $field => $msg_and_lines) {
						foreach($msg_and_lines as $msg => $lines) {
							$this->AliquotMaster->validationErrors[$field][] = __($msg) . ' - ' . str_replace('%s', implode(",", $lines), __('see line %s'));
						}
					}
					
				}
			}
		}
	}
}