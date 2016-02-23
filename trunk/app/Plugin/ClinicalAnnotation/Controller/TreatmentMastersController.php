<?php

class TreatmentMastersController extends ClinicalAnnotationAppController {

	var $uses = array(
		'ClinicalAnnotation.Participant',
		'ClinicalAnnotation.TreatmentMaster', 
		'ClinicalAnnotation.TreatmentExtendMaster', 
		'ClinicalAnnotation.TreatmentControl', 
		'ClinicalAnnotation.TreatmentExtendControl', 
		'ClinicalAnnotation.DiagnosisMaster',
		'Protocol.ProtocolMaster'
	);
	
	var $paginate = array('TreatmentMaster'=>array('limit' => pagination_amount,'order'=>'TreatmentMaster.start_date ASC'));

	function listall($participant_id, $treatment_control_id = null){
		// MANAGE DATA
		$participant_data = $this->Participant->getOrRedirect($participant_id);
		
		$search_criteria = array();
		if(!$treatment_control_id) {
			// 1 - MANAGE DISPLAY
			$treatment_controls = $this->TreatmentControl->find('all', array('conditions'=>array('TreatmentControl.flag_active' => '1' )));
			$controls_for_subform_display = array();
			foreach($treatment_controls as $new_ctrl) {
				if($new_ctrl['TreatmentControl']['use_detail_form_for_index']) {
					// Controls that should be listed using detail form
					$controls_for_subform_display[$new_ctrl['TreatmentControl']['id']] = $new_ctrl;
					$controls_for_subform_display[$new_ctrl['TreatmentControl']['id']]['TreatmentControl']['tx_header'] = __($new_ctrl['TreatmentControl']['tx_method']) . (empty($treatment_control['TreatmentControl']['disease_site'])? '' : ' - ' . __($treatment_control['TreatmentControl']['disease_site']));
				} else {
					$controls_for_subform_display['-1']['TreatmentControl'] = array('id' => '-1', 'tx_header' => null);
				}
			}
			ksort($controls_for_subform_display);
			$this->set('controls_for_subform_display', $controls_for_subform_display);
			// find all TXCONTROLS, for ADD form
			$this->set('add_links', $this->TreatmentControl->getAddLinks($participant_id));
			// Set structure
			$this->Structures->set('treatmentmasters');
		} else if($treatment_control_id == '-1') {
			// 2 - DISPLAY ALL TREATMENTS THAT SHOULD BE DISPLAYED IN MASTER VIEW
			// Set search criteria
			$search_criteria['TreatmentMaster.participant_id'] = $participant_id;
			$search_criteria['TreatmentControl.use_detail_form_for_index'] = '0';
			// Set structure
			$this->Structures->set('treatmentmasters');		
		} else {
			// 3 -  DISPLAY ALL TREATMENTS THAT SHOULD BE DISPLAYED IN DETAILED VIEW
			// Set search criteria
			$search_criteria['TreatmentMaster.participant_id'] = $participant_id;
			$search_criteria['TreatmentControl.id'] = $treatment_control_id;
			// Set structure
			$control_data = $this->TreatmentControl->getOrRedirect($treatment_control_id);
			$this->Structures->set($control_data['TreatmentControl']['form_alias']);
			self::buildDetailBinding($this->TreatmentMaster,
					$search_criteria, $control_data['TreatmentControl']['form_alias']);
		}
		
		// MANAGE DATA
		$this->request->data = $treatment_control_id? $this->paginate($this->TreatmentMaster, $search_criteria) : array();
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id));
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }		
	}
	
	function detail($participant_id, $tx_master_id){
		// MANAGE DATA
		$treatment_master_data = $this->TreatmentMaster->find('first',array('conditions'=>array('TreatmentMaster.id'=>$tx_master_id, 'TreatmentMaster.participant_id'=>$participant_id)));
		if(empty($treatment_master_data)) { 
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}		
		$this->request->data = $treatment_master_data;
		
		$this->set('diagnosis_data', $this->DiagnosisMaster->getRelatedDiagnosisEvents($this->request->data['TreatmentMaster']['diagnosis_master_id']));
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id,'TreatmentMaster.id'=>$tx_master_id));
		
		// set structure alias based on control data
		$this->Structures->set($treatment_master_data['TreatmentControl']['form_alias']);
		$this->Structures->set('view_diagnosis,diagnosis_event_relation_type', 'diagnosis_structure');
		$this->set('is_ajax', $this->request->is('ajax'));
			
		if($treatment_master_data['TreatmentControl']['treatment_extend_control_id']){
			$treatment_extend_control_data = $this->TreatmentExtendControl->getOrRedirect($treatment_master_data['TreatmentControl']['treatment_extend_control_id']);
			$this->set('tx_extend_data', $this->TreatmentExtendMaster->find('all', array('conditions' => array('TreatmentExtendMaster.treatment_master_id' => $tx_master_id, 'TreatmentExtendMaster.treatment_extend_control_id' => $treatment_master_data['TreatmentControl']['treatment_extend_control_id']))));
			$this->Structures->set($treatment_extend_control_data['TreatmentExtendControl']['form_alias'], 'extend_form_alias');
			if(!empty($treatment_master_data['TreatmentControl']['extended_data_import_process'])) {
				$this->set('extended_data_import_process', $treatment_master_data['TreatmentControl']['extended_data_import_process']);
			}
		}
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}		
	}
	
	function edit( $participant_id, $tx_master_id ) {
		// MANAGE DATA
		$treatment_master_data = $this->TreatmentMaster->find('first',array('conditions'=>array('TreatmentMaster.id'=>$tx_master_id, 'TreatmentMaster.participant_id'=>$participant_id)));
		if(empty($treatment_master_data)) { 
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}		

		if(!empty($treatment_master_data['TreatmentControl']['applied_protocol_control_id'])) {
			$available_protocols = array();
			$this->ProtocolMaster;
			ProtocolMaster::$protocol_dropdown = $this->ProtocolMaster->getProtocolPermissibleValuesFromId($treatment_master_data['TreatmentControl']['applied_protocol_control_id']);
		}
		
		// Set diagnosis data for diagnosis selection (radio button)
		$dx_data = $this->DiagnosisMaster->find('threaded', array('conditions'=>array('DiagnosisMaster.participant_id'=>$participant_id), 'order' => array('DiagnosisMaster.dx_date ASC')));
		$dx_id = isset($this->request->data['TreatmentMaster']['diagnosis_master_id']) ? $this->request->data['TreatmentMaster']['diagnosis_master_id'] : $treatment_master_data['TreatmentMaster']['diagnosis_master_id'];
		$this->DiagnosisMaster->arrangeThreadedDataForView($dx_data, $dx_id, 'TreatmentMaster');
		
		$this->set('radio_checked', $dx_id > 0);
		$this->set('data_for_checklist', $dx_data);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id,'TreatmentMaster.id'=>$tx_master_id) );
		
		// set FORM ALIAS based off VALUE from MASTER table
		$this->Structures->set($treatment_master_data['TreatmentControl']['form_alias']);
		$this->Structures->Set('empty', 'empty_structure');
		$this->Structures->set('view_diagnosis', 'diagnosis_structure');
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }

		if(empty($this->request->data)) {
			$this->request->data = $treatment_master_data;
		} else {
			// LAUNCH SPECIAL VALIDATION PROCESS	
			$submitted_data_validates = true;
			// ... special validations
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}
						
			if($submitted_data_validates) {
				$this->TreatmentMaster->id = $tx_master_id;
				$this->TreatmentMaster->addWritableField(array('diagnosis_master_id'));
				if ($this->TreatmentMaster->save($this->request->data)) {
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) {
						require($hook_link);
					}
					$this->atimFlash(__('your data has been updated'),'/ClinicalAnnotation/TreatmentMasters/detail/'.$participant_id.'/'.$tx_master_id);
				}
			}
		}
	}
	
	function add($participant_id, $tx_control_id, $diagnosis_master_id = null) {
		if(!AppController::checkLinkPermission('/ClinicalAnnotation/DiagnosisMasters/listall/')){
			$this->flash(__('you need privileges to access this page'), 'javascript:history.back()');
		}
		
		// MANAGE DATA
		$participant_data = $this->Participant->getOrRedirect($participant_id);
		
		$tx_control_data = $this->TreatmentControl->getOrRedirect($tx_control_id);

		if(!empty($tx_control_data['TreatmentControl']['applied_protocol_control_id'])) {
			$available_protocols = array();
			$this->ProtocolMaster;//lazy load
			ProtocolMaster::$protocol_dropdown = $this->ProtocolMaster->getProtocolPermissibleValuesFromId($tx_control_data['TreatmentControl']['applied_protocol_control_id']);
		}
		
		// Set diagnosis data for diagnosis selection (radio button)
		$dx_data = $this->DiagnosisMaster->find('threaded', array('conditions'=>array('DiagnosisMaster.participant_id'=>$participant_id), 'order' => array('DiagnosisMaster.dx_date ASC')));
		if(isset($this->request->data['TreatmentMaster']['diagnosis_master_id'])){
			$this->DiagnosisMaster->arrangeThreadedDataForView($dx_data, $this->request->data['TreatmentMaster']['diagnosis_master_id'], 'TreatmentMaster');
		}else if($diagnosis_master_id){
			$this->DiagnosisMaster->arrangeThreadedDataForView($dx_data, $diagnosis_master_id, 'TreatmentMaster');
		}
		
		$this->set('data_for_checklist', $dx_data);		
		
		$this->set('initial_display', (empty($this->request->data)? true : false));
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'TreatmentControl.id'=>$tx_control_id));
		
		// Override generated menu to prevent selection of Administration menu item on ADD action
		$this->set('atim_menu', $this->Menus->get('/ClinicalAnnotation/TreatmentMasters/listall/%%Participant.id%%'));
		
		// Set trt header
		$this->set('tx_header', __($tx_control_data['TreatmentControl']['tx_method']) . (empty($tx_control_data['TreatmentControl']['disease_site'])? '' : ' - ' . __($tx_control_data['TreatmentControl']['disease_site'])));
		
		// set DIAGANOSES radio list form
		$this->Structures->set('view_diagnosis', 'diagnosis_structure');
		$this->Structures->set($tx_control_data['TreatmentControl']['form_alias'], 'atim_structure', array('model_table_assoc' => array('TreatmentDetail' => $tx_control_data['TreatmentControl']['detail_tablename']))); 			
		$this->Structures->Set('empty', 'empty_structure');
		$this->set('use_addgrid', $tx_control_data['TreatmentControl']['use_addgrid']);
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
		
		if ( empty($this->request->data)) {
			if($tx_control_data['TreatmentControl']['use_addgrid']) $this->request->data = array(array());
				
			$hook_link = $this->hook('initial_display');
			if($hook_link){
				require($hook_link);
			}
			
		} else {
			if(!$tx_control_data['TreatmentControl']['use_addgrid']) {
				
				// 1 - ** Single data save **
				
				$this->request->data['TreatmentMaster']['participant_id'] = $participant_id;
				$this->request->data['TreatmentMaster']['treatment_control_id'] = $tx_control_id;
				$this->TreatmentMaster->addWritableField(array('participant_id', 'treatment_control_id', 'diagnosis_master_id'));
				$this->TreatmentMaster->addWritableField('treatment_master_id', $tx_control_data['TreatmentControl']['detail_tablename']);
					
				// LAUNCH SPECIAL VALIDATION PROCESS
				$submitted_data_validates = true;
				// ... special validations
					
				// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
				$hook_link = $this->hook('presave_process');
				if( $hook_link ) {
					require($hook_link);
				}
				
				if($submitted_data_validates) {
					if ( $this->TreatmentMaster->save($this->request->data) ) {
						$hook_link = $this->hook('postsave_process');
						if( $hook_link ) {
							require($hook_link);
						}
						$this->atimFlash(__('your data has been saved'),'/ClinicalAnnotation/TreatmentMasters/detail/'.$participant_id.'/'.$this->TreatmentMaster->getLastInsertId());
					}
				}
							
			} else {
				
				// 2 - ** Multi lines save **
				
				$errors_tracking = array();
				
				// Launch Structure Fields Validation
				$diagnosis_master_id = (array_key_exists('TreatmentMaster', $this->request->data) && array_key_exists('diagnosis_master_id', $this->request->data['TreatmentMaster']))? $this->request->data['TreatmentMaster']['diagnosis_master_id'] : null;
				unset($this->request->data['TreatmentMaster']);
				
				$row_counter = 0;
				foreach($this->request->data as &$data_unit){
					$row_counter++;
				
					$data_unit['TreatmentMaster']['treatment_control_id'] = $tx_control_id;
					$data_unit['TreatmentMaster']['participant_id'] = $participant_id;
					$data_unit['TreatmentMaster']['diagnosis_master_id'] = $diagnosis_master_id;
						
					$this->TreatmentMaster->id = null;
					$this->TreatmentMaster->set($data_unit);
					if(!$this->TreatmentMaster->validates()){
						foreach($this->TreatmentMaster->validationErrors as $field => $msgs) {
							$msgs = is_array($msgs)? $msgs : array($msgs);
							foreach($msgs as $msg)$errors_tracking[$field][$msg][] = $row_counter;
						}
					}
					$data_unit = $this->TreatmentMaster->data;
				}
				unset($data_unit);
				
				$hook_link = $this->hook('presave_process');
				if( $hook_link ) {
					require($hook_link);
				}
				
				// Launch Save Process
				if(empty($this->request->data)) {
					$this->TreatmentMaster->validationErrors[][] = 'at least one record has to be created';
				} else if(empty($errors_tracking)){
					AppModel::acquireBatchViewsUpdateLock();
					//save all
					$this->TreatmentMaster->addWritableField(array('participant_id', 'treatment_control_id', 'diagnosis_master_id'));
					$this->TreatmentMaster->addWritableField('treatment_master_id', $tx_control_data['TreatmentControl']['detail_tablename']);
					foreach($this->request->data as $new_data_to_save) {
						$this->TreatmentMaster->id = null;
						$this->TreatmentMaster->data = array();
						if(!$this->TreatmentMaster->save($new_data_to_save, false)) $this->redirect( '/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, NULL, TRUE );
					}
					$hook_link = $this->hook('postsave_process_batch');
					if( $hook_link ) {
						require($hook_link);
					}
					AppModel::releaseBatchViewsUpdateLock();
					$this->atimFlash(__('your data has been updated'), '/ClinicalAnnotation/TreatmentMasters/listall/'.$participant_id.'/');
				} else {
					$this->TreatmentMaster->validationErrors = array();
					foreach($errors_tracking as $field => $msg_and_lines) {
						foreach($msg_and_lines as $msg => $lines) {
							$this->TreatmentMaster->validationErrors[$field][] = $msg . ' - ' . str_replace('%s', implode(",", $lines), __('see line %s'));
						}
					}
				}
			}
		}
	}

	function delete( $participant_id, $tx_master_id ) {

		// MANAGE DATA
		$treatment_master_data = $this->TreatmentMaster->find('first',array('conditions'=>array('TreatmentMaster.id'=>$tx_master_id, 'TreatmentMaster.participant_id'=>$participant_id)));
		if(empty($treatment_master_data)) { 
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}		
		
		$this->TreatmentMaster->set($treatment_master_data);
		$arr_allow_deletion = $this->TreatmentMaster->allowDeletion($tx_master_id);
						
		// CUSTOM CODE		
		$hook_link = $this->hook('delete');
		if ($hook_link) { 
			require($hook_link); 
		}
		
		if ($arr_allow_deletion['allow_deletion']) {
			if( $this->TreatmentMaster->atimDelete( $tx_master_id ) ) {
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) { 
					require($hook_link); 
				}
				$this->atimFlash(__('your data has been deleted'), '/ClinicalAnnotation/TreatmentMasters/listall/'.$participant_id );
			} else {
				$this->flash(__('error deleting data - contact administrator'), '/ClinicalAnnotation/TreatmentMasters/listall/'.$participant_id );
			}
		} else {
			$this->flash(__($arr_allow_deletion['msg']), '/ClinicalAnnotation/TreatmentMasters/detail/'.$participant_id.'/'.$tx_master_id);
		}
	}
}

?>