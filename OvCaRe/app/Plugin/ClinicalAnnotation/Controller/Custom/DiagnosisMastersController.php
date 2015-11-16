<?php
class DiagnosisMastersControllerCustom extends DiagnosisMastersController{
	
	function createOvcareDxInBatch($browse_csv = false) {
		
		$this->set('atim_variables', array());
		$this->set('atim_menu', $this->Menus->get('/ClinicalAnnotation/Participants/search'));
		
		$structure_aliases_to_create_dx = 'diagnosismasters,dx_primary,ovcare_dx_ovaries_endometriums,ovcare_ed_ovary_endometrium_path_reports_for_batch_creation';
		$this->Structures->set($browse_csv? 'ovcare_diagnosis_details_file' : $structure_aliases_to_create_dx);
		$this->set('browse_csv', $browse_csv);
		
		if(empty($this->request->data)) {
			
			// *** INITIAL DISPLAY ***
			
			if($browse_csv) $this->request->data['Config']['define_csv_separator'] = csv_separator;
		
		} else {
			
			if(array_key_exists('FunctionManagement', $this->request->data) && array_key_exists('ovcare_diagnosis_details_file', $this->request->data['FunctionManagement'])) {
				
				//-----------------------------------------------------------------------------------------------------------------------------------------
				// CSV FILE
				//-----------------------------------------------------------------------------------------------------------------------------------------
				
				// *** PARSE SUBMITTED FILE TO SET DEFAULT DATA ***
				
				$browsed_file_data = $this->request->data['FunctionManagement']['ovcare_diagnosis_details_file'];
				$csv_file_error = '';
				$csv_file_data_error = array();
				if($browsed_file_data['name']) {
					if(!preg_match('/((\.txt)|(\.csv))$/', $browsed_file_data['name'])) {
						$this->redirect('/Pages/err_submitted_file_extension', null, true);
					} else {
						$handle = fopen($browsed_file_data['tmp_name'], "r");
						if($handle) {
							$fields_matches = array(
								'voa#' => 'FunctionManagement.ovcare_participant_voa',
								'diagnosis date' => 'DiagnosisMaster.dx_date',
								'tumor site' => 'DiagnosisMaster.ovcare_tumor_site',
								'laterality' => 'DiagnosisDetail.laterality',
								'censor' => 'DiagnosisDetail.censor',
								'progression status' => 'DiagnosisDetail.progression_status',
								'clinical history' => 'DiagnosisMaster.ovcare_clinical_history',
								'clinical diagnosis' => 'DiagnosisMaster.ovcare_clinical_diagnosis',
								'diagnosis notes' => 'DiagnosisMaster.notes',
								'path report date' => 'EventMaster.event_date',
								'path report diagnosis' => 'EventDetail.diagnosis_report',
								'path report type' => 'EventDetail.path_report_type',
								'pathologist' => 'EventDetail.pathologist',
								'path report summary' => 'EventMaster.event_summary',
								'tumor grade' => 'EventDetail.tumour_grade',
								'figo' => 'EventDetail.figo',
								'general histopathology' => 'EventDetail.histopathology',
								'ovarian histopathology' => 'EventDetail.ovarian_histology',
								'uterine histopathology' => 'EventDetail.uterine_histology',
								'presence of benign lesions precursor' => 'EventDetail.benign_lesions_precursor_presence',
								'fallopian tube lesions' => 'EventDetail.fallopian_tube_lesions');
							$headers_validation_done = false;
							$row_counter = 0;
							$submitted_data_to_display = array();
							while (($csv_data = fgetcsv($handle, 1000, $this->request->data['Config']['define_csv_separator'], '"')) !== FALSE) {	
								$row_counter++;
								if(array_filter($csv_data)) {
									if(!$headers_validation_done) {
										$missing_headers = array_diff(array_keys($fields_matches), array_map('strtolower', $csv_data));
										if($missing_headers) {
											$csv_file_error = __('wrong csv file format - check csv separator or the list of missing fields').' : '.implode(', ', $missing_headers);
											break;
										}
										$headers_validation_done = true;
									} else {
										$csv_data = array_combine($fields_matches, $csv_data);
										$new_data_set = array();
										foreach($csv_data as $model_field => $value) {
											list($model, $field) = explode('.', $model_field);
											$new_data_set[$model][$field] = utf8_encode($value);
										}
										list($new_data_set, $new_data_set_errors) = $this->DiagnosisMaster->validateDxCsvFileDataSubmitted($new_data_set, $structure_aliases_to_create_dx);			
										foreach($new_data_set_errors as $field => $msg) {
											$csv_file_data_error[$field][$msg][] = (sizeof($submitted_data_to_display)+1)." (Excel: $row_counter)";
										}							
										$submitted_data_to_display[] = $new_data_set;
									}
								}
							}
							$this->request->data = $submitted_data_to_display;
						} else {
							$this->redirect('/Pages/err_opening_submitted_file', null, true);
						}
					}				
				} else {
					$csv_file_error = 'no file has been selected';
				}
				$this->DiagnosisMaster->validationErrors = array();
				$this->EventMaster->validationErrors = array();
				if($csv_file_error) {
					$this->DiagnosisMaster->validationErrors[][] = __($csv_file_error);
					$this->Structures->set('ovcare_diagnosis_details_file');
					$this->set('browse_csv', true);
					$this->request->data = array('Config' => array('define_csv_separator'=> csv_separator));
				} else if($csv_file_data_error) {
					foreach($csv_file_data_error as $field => $msg_and_lines) {
						foreach($msg_and_lines as $msg => $lines) {
							$this->DiagnosisMaster->validationErrors[$field][] = __($msg) . ' - ' . str_replace('%s', implode(",", $lines), __('see line %s'));
						}
					}
				}
				
			} else {
				
				//-----------------------------------------------------------------------------------------------------------------------------------------
				// DIANGOSIS DATA
				//-----------------------------------------------------------------------------------------------------------------------------------------
				
				$this->MiscIdentifierControl = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifierControl", true);
				$this->MiscIdentifier = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifier", true);
				
				$mic_identifier_control = $this->MiscIdentifierControl->find('first', array('conditions' => array('MiscIdentifierControl.misc_identifier_name' => 'VOA#')));
				$diagnosis_control = $this->DiagnosisControl->find('first', array('conditions' => array('category' => 'primary', 'controls_type' => 'ovary or endometrium tumor')));
				$event_control = $this->EventControl->find('first', array('conditions' => array('event_type' => 'ovary or endometrium path report')));
				
				// *** VALIDATION ***
				
				$row_counter = 0;
				$studied_participant_ids = array();
				$errors_tracking = array();
				foreach($this->request->data as &$data_unit){
					$row_counter++;
						
					// Validate participant
					
					$misc_identifier = $this->MiscIdentifier->find('first', array('conditions' => array('MiscIdentifier.identifier_value' => $data_unit['FunctionManagement']['ovcare_participant_voa'], 'MiscIdentifier.misc_identifier_control_id' => $mic_identifier_control['MiscIdentifierControl']['id']), 'recursive' => '-1'));
					if(empty($misc_identifier)) {
						$errors_tracking['ovcare_participant_voa']['voa# unknown'][$data_unit['FunctionManagement']['ovcare_participant_voa']] = "$row_counter (VOA# ".$data_unit['FunctionManagement']['ovcare_participant_voa'].")";
						continue;
					} 
					$participant_id = $misc_identifier['MiscIdentifier']['participant_id'];
					if(in_array($participant_id, $studied_participant_ids)) {
						$errors_tracking['ovcare_participant_voa']['2 voa# are assigned to the same patient'][] = "$row_counter (VOA# ".$data_unit['FunctionManagement']['ovcare_participant_voa'].")";
						continue;
					}
					$studied_participant_ids[] = $participant_id;
					
					// Validate diagnosis
					
					$data_unit['DiagnosisMaster']['participant_id'] = $participant_id;
					$data_unit['DiagnosisMaster']['diagnosis_control_id'] = $diagnosis_control['DiagnosisControl']['id'];
					$this->DiagnosisMaster->id = null;
					$this->DiagnosisMaster->data = null;
					$this->DiagnosisMaster->set($data_unit);
					if(!$this->DiagnosisMaster->validates()){
						foreach($this->DiagnosisMaster->validationErrors as $field => $msgs) {
							$msgs = is_array($msgs)? $msgs : array($msgs);
							foreach($msgs as $msg) $errors_tracking[$field][$msg][] = $row_counter;
						}
					}
					$data_unit = array_merge($data_unit, $this->DiagnosisMaster->data);

					if(!in_array($data_unit['DiagnosisMaster']['ovcare_tumor_site'], array('female genital-ovary','female genital-endometrium','female genital-ovary and endometrium'))) {
						$errors_tracking['ovcare_tumor_site'][__('wrong selected tumor site').' : '.__('either ovary or endometrium tumor site should be selected')][] = $row_counter;
					}
										
					// Validate path report
					
					$empty_event_data_test = array('EventMaster' => $data_unit['EventMaster'], 'EventDetail' => $data_unit['EventDetail']);
					unset($empty_event_data_test['EventMaster']['event_date']['year_accuracy']);
					$empty_event_data_test['EventMaster']['event_date'] = array_filter($empty_event_data_test['EventMaster']['event_date']);
					$empty_event_data_test['EventMaster'] = array_filter($empty_event_data_test['EventMaster']);
					$empty_event_data_test['EventDetail'] = array_filter($empty_event_data_test['EventDetail']);
					if(empty($empty_event_data_test['EventMaster']) && empty($empty_event_data_test['EventDetail'])) {
						unset($data_unit['EventMaster']);
						unset($data_unit['EventDetail']);
					} else {
						$data_unit['EventMaster']['participant_id'] = $participant_id;
						$data_unit['EventMaster']['event_control_id'] = $event_control['EventControl']['id'];
						$this->EventMaster->id = null;
						$this->EventMaster->data = null;
						$this->EventMaster->set($data_unit);
						if(!$this->EventMaster->validates()){
							foreach($this->EventMaster->validationErrors as $field => $msgs) {
								$msgs = is_array($msgs)? $msgs : array($msgs);
								foreach($msgs as $msg) $errors_tracking[$field][$msg][] = $row_counter;
							}
						}
						$data_unit = array_merge($data_unit, $this->EventMaster->data);
					}
					
					
					// Validate field drop down list value
						
					list($data_unit, $new_data_set_errors) = $this->DiagnosisMaster->validateDxCsvFileDataSubmitted($data_unit, $structure_aliases_to_create_dx, false);
					foreach($new_data_set_errors as $field => $msg) {
						$errors_tracking[$field][$msg][] = $row_counter;
					}	
					
				}
				unset($data_unit);
				
				if($row_counter > 50) $errors_tracking['-1'][__("batch init - number of submitted records too big")." ( > 50)"][] = 'n/a';
				
				if(empty($errors_tracking)){
					
					// *** SAVE DATA ***
					
					AppModel::acquireBatchViewsUpdateLock();
					
					$this->DiagnosisMaster->addWritableField(array('participant_id', 'diagnosis_control_id'));
					$this->DiagnosisMaster->addWritableField('diagnosis_master_id', $diagnosis_control['DiagnosisControl']['detail_tablename']);
					$this->EventMaster->addWritableField(array('event_control_id','participant_id','diagnosis_master_id'));
					$this->EventMaster->writable_fields_mode = 'addgrid';
					
					$all_created_diagnosis_master_ids = array();
					$created_dx = 0;
					$created_path_report = 0;
					foreach($this->request->data as $new_data_to_save) {
						
						// Save diagnosis
						
						$this->DiagnosisMaster->id = null;
						$this->DiagnosisMaster->data = array(); // *** To guaranty no merge will be done with previous data ***
						if(!$this->DiagnosisMaster->save($new_data_to_save, false)) $this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
						$diagnosis_master_id = $this->DiagnosisMaster->getLastInsertId();
						$all_created_diagnosis_master_ids[] = $diagnosis_master_id;
						$created_dx++;
						
						// Save event
						
						if(array_key_exists('EventMaster', $new_data_to_save)) {
							$new_data_to_save['EventMaster']['diagnosis_master_id'] = $diagnosis_master_id;
							$this->EventMaster->id = null;
							$this->EventMaster->data = array(); // *** To guaranty no merge will be done with previous data ***
							if(!$this->EventMaster->save($new_data_to_save, false)) $this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
							$created_path_report++;
						}
					}
					
					if($all_created_diagnosis_master_ids) {
						// Set primary_id of diagnosis
						$query_to_update = "UPDATE diagnosis_masters SET diagnosis_masters.primary_id = diagnosis_masters.id WHERE diagnosis_masters.id IN (".implode(',', $all_created_diagnosis_master_ids).");";
						$this->DiagnosisMaster->tryCatchQuery($query_to_update);
						$this->DiagnosisMaster->tryCatchQuery(str_replace("diagnosis_masters", "diagnosis_masters_revs", $query_to_update));
					}
					
					AppModel::releaseBatchViewsUpdateLock();
					
					AppController::addWarningMsg(str_replace(array('%dx%','%pr%'), array($created_dx,$created_path_report), __('created %dx% diagnosis and %pr% path reports')));
					
					$datamart_structure = AppModel::getInstance("Datamart", "DatamartStructure", true);
					$batch_set_data = array('BatchSet' => array(
						'datamart_structure_id'	=> $datamart_structure->getIdByModelName('Participant'),
						'flag_tmp' => true));
					$batch_set_model = AppModel::getInstance('Datamart', 'BatchSet', true);
					$batch_set_model->saveWithIds($batch_set_data, $studied_participant_ids);
					
					$this->atimFlash(__('your data has been saved'), '/Datamart/BatchSets/listall/'.$batch_set_model->getLastInsertId());
					
				} else {
					
					// *** ERROR MESSAGE DISPLAY ***
					
					$this->DiagnosisMaster->validationErrors = array();
					$this->EventMaster->validationErrors = array();
					foreach($errors_tracking as $field => $msg_and_lines) {
						foreach($msg_and_lines as $msg => $lines) {
							$this->DiagnosisMaster->validationErrors[$field][] = __($msg) . ' - ' . str_replace('%s', implode(",", $lines), __('see line %s'));
						}
					}				
				}
			}
		}
	}
	
}