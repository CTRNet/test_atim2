<?php

class TreatmentMastersControllerCustom extends TreatmentMastersController {

	function addInBatch( $participant_id, $tx_control_id, $already_displayed = false) {
		
		if(!AppController::checkLinkPermission('/ClinicalAnnotation/TreatmentMasters/listall/')){
			$this->flash(__('you need privileges on the following modules to manage participant inventory: %s', implode(', ', $error)), 'javascript:history.back()');
		}
		
		$participant_data = $this->Participant->getOrRedirect($participant_id);
		$tx_control_data = $this->TreatmentControl->getOrRedirect($tx_control_id);
		
		if($tx_control_data['TreatmentControl']['tx_method'] != 'procure follow-up worksheet - treatment') {
			$this->redirect( '/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, NULL, TRUE );
		}
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'TreatmentControl.id'=>$tx_control_id));
		$this->set('atim_menu', $this->Menus->get('/ClinicalAnnotation/TreatmentMasters/listall/%%Participant.id%%'));
		
		// Set trt header
		$this->set('tx_header', __($tx_control_data['TreatmentControl']['tx_method']));
		
		// set DIAGANOSES radio list form
		$this->Structures->set($tx_control_data['TreatmentControl']['form_alias']);
		
		$EventMaster = AppModel::getInstance('ClinicalAnnotation', 'EventMaster');
		$followup_identification_list = $EventMaster->getFollowupIdentificationFromId($participant_id);
		$this->set('followup_identification_list', $followup_identification_list);	
		
		if(empty($this->request->data)){
			if(!$already_displayed) {
				$default_data = array();
				if(sizeof($followup_identification_list) > 1) {
					$keys = array_keys($followup_identification_list);
					$default_data['TreatmentDetail']['followup_event_master_id'] = $keys[1];
				}
				$this->request->data = array($default_data, $default_data, $default_data, $default_data, $default_data);
			} else {
				if($already_displayed) $this->TreatmentDetail->validationErrors[''] = 'at least one record has to be created';
				$this->request->data = array(array());
			}
		}else{
			$errors_tracking = array();
		
			// Launch Structure Fields Validation
				
			$row_counter = 0;
			foreach($this->request->data as &$data_unit){
				$row_counter++;
		
				$data_unit['TreatmentMaster']['treatment_control_id'] = $tx_control_id;
				$data_unit['TreatmentMaster']['participant_id'] = $participant_id;
		
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
			
			// Launch Save Process
			if(empty($errors_tracking)){
				//save all
				$this->TreatmentMaster->addWritableField(array('participant_id', 'treatment_control_id'));
				$this->TreatmentMaster->writable_fields_mode = 'addgrid';
				foreach($this->request->data as $new_data_to_save) {
					$this->TreatmentMaster->id = null;
					$this->TreatmentMaster->data = array();
					if(!$this->TreatmentMaster->save($new_data_to_save, false)) $this->redirect( '/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, NULL, TRUE );
				}
				$this->atimFlash('your data has been updated', '/ClinicalAnnotation/TreatmentMasters/listall/'.$participant_id.'/');
					
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

?>