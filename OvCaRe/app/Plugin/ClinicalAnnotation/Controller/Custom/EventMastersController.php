<?php

class EventMastersControllerCustom extends EventMastersController {

	function addExperimentalTestsInBatch( $participant_id , $event_control_id, $display_all_tests = false, $diagnosis_master_id = null) {
		if(!AppController::checkLinkPermission('/ClinicalAnnotation/DiagnosisMasters/listall/')){
			$this->flash(__('you need privileges on the following modules to manage participant inventory: %s', implode(', ', $error)), 'javascript:history.back()');
		}
		
		// MANAGE DATA
		$participant_data = $this->Participant->getOrRedirect($participant_id);
		$event_control_data = $this->EventControl->getOrRedirect($event_control_id);
		if($event_control_data['EventControl']['event_type'] != 'experimental tests') $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true );
		$event_group = $event_control_data['EventControl']['event_group'];
		
		// Set diagnosis data for diagnosis selection (radio button)
		$dx_data = $this->DiagnosisMaster->find('threaded', array('conditions'=>array('DiagnosisMaster.participant_id'=>$participant_id), 'order' => array('DiagnosisMaster.dx_date ASC')));
		if(!empty($this->request->data) && isset($this->request->data['EventMaster']['diagnosis_master_id'])){
			$this->DiagnosisMaster->arrangeThreadedDataForView($dx_data, $this->request->data['EventMaster']['diagnosis_master_id'], 'EventMaster');
		}else if($diagnosis_master_id){
			$this->DiagnosisMaster->arrangeThreadedDataForView($dx_data, $diagnosis_master_id, 'EventMaster');
		}
		$this->set('data_for_checklist', $dx_data);
		$this->set('initial_display', (empty($this->request->data)));
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu', $this->Menus->get('/'.$this->params['plugin'].'/'.$this->params['controller'].'/listall/'.$event_group) );
		$this->set( 'atim_menu_variables', array('EventControl.event_group'=>$event_group,'Participant.id'=>$participant_id,'EventControl.id'=>$event_control_id) );
		$this->set('ev_header', __($event_control_data['EventControl']['event_type']));
		
		// set FORM ALIAS based off VALUE from CONTROL table
		$this->Structures->set('empty', 'empty_structure');
		$this->Structures->set($event_control_data['EventControl']['form_alias']);
		$this->Structures->set('view_diagnosis', 'diagnosis_structure');	
		
		if ( empty($this->data)) {
			$tests_data = array();
			if($display_all_tests) {
				// Build one row per test
				$StructurePermissibleValuesCustom = AppModel::getInstance("", "StructurePermissibleValuesCustom", true);
				$StructurePermissibleValuesCustomControl = AppModel::getInstance("", "StructurePermissibleValuesCustomControl", true);
				$control_data = $StructurePermissibleValuesCustomControl->find('first', array('conditions' => array('StructurePermissibleValuesCustomControl.name' => 'experimental tests'), 'recursive' => 0));
				if(empty($control_data)) $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); 
				$custom_tests_list = $StructurePermissibleValuesCustom->find('all', array('conditions' => array('StructurePermissibleValuesCustom.control_id' => $control_data['StructurePermissibleValuesCustomControl']['id'], 'StructurePermissibleValuesCustom.use_as_input' => '1'), 'order' => array('display_order', 'en'), 'recursive' => -1));
				foreach($custom_tests_list as $new_test) {
					$tests_data[]['EventDetail']['test'] = $new_test['StructurePermissibleValuesCustom']['value'];
				}
			
			}
			$this->request->data = $tests_data;
			//$this->set('tests_data', $tests_data);
			
		} else {
			$selected_diagnosis_id = $this->data['EventMaster']['diagnosis_master_id'];
			
			$event_master_data_to_merge = array(
				'participant_id' => $participant_id,
				'diagnosis_master_id' => $selected_diagnosis_id,
				'event_control_id' => $event_control_id,
				'event_group' => $event_group,
				'event_type' => $event_control_data['EventControl']['event_type'],
				'disease_site' => $event_control_data['EventControl']['disease_site']);
			
			$tests_data_to_save = array();
			$errors = array();
			$line_counter = 0;
			foreach($this->request->data as $new_test) {
				if(isset($new_test['EventDetail']) && strlen($new_test['EventDetail']['result'])) {
					$line_counter++;
					$new_test['EventMaster'] = array_merge($new_test['EventMaster'], $event_master_data_to_merge);
					$this->EventMaster->data = array(); // *** To guaranty no merge will be done with previous data ***				
					$this->EventMaster->set($new_test);
					if(!$this->EventMaster->validates()){
						foreach($this->EventMaster->validationErrors as $field => $msgs) {
							foreach($msgs as $new_message) $errors[$field][$new_message][] = $line_counter;
						}
					}
					$new_test = $this->EventMaster->data;
					$tests_data_to_save[] = $new_test;
				}
			}
			if(empty($tests_data_to_save)){
				$errors['result'][__('at least one test result has to be completed', true)][] = '';
			} else {
				$this->request->data = $tests_data_to_save;
			}
			
			if(empty($errors)) {	
				$this->EventMaster->addWritableField(array('participant_id', 'event_control_id', 'diagnosis_master_id'));
				$this->EventMaster->writable_fields_mode = 'addgrid';
				foreach($this->request->data as $new_test) {
					$this->EventMaster->id = null;
					$this->EventMaster->data = array(); // *** To guaranty no merge will be done with previous data ***
					$new_test['EventMaster']['id'] = null;
					if(!$this->EventMaster->save($new_test, false)) $this->redirect('/pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
				} 
				$this->atimFlash( 'your data has been updated','/ClinicalAnnotation/EventMasters/listall/'.$event_group.'/'.$participant_id);
		
			} else {
				$this->EventMaster->validationErrors = array();			
				foreach($errors as $field => $msg_and_lines) {
					foreach($msg_and_lines as $msg => $lines) {
						$msg = __($msg, true);
						if(!empty($lines)) {
							$lines_strg = implode(",", array_unique($lines));
							if(!empty($lines_strg)) $msg .= ' - ' . str_replace('%s', $lines_strg, __('see line %s'));
						}
						$this->EventMaster->validationErrors[$field][] = $msg;					
					}
				}
			}
		}
	}
}
	
?>
