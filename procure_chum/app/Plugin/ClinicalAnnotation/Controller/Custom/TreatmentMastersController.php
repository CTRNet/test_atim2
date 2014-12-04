<?php

class TreatmentMastersControllerCustom extends TreatmentMastersController {

	var $paginate = array('TreatmentMaster'=>array('limit' => pagination_amount,'order'=>'TreatmentMaster.start_date ASC, TreatmentMaster.procure_form_identification ASC'));
	
	function listall($participant_id, $treatment_control_id = null, $interval_start_date = null, $interval_start_date_accuracy = '', $interval_finish_date = null, $interval_finish_date_accuracy = ''){
		$participant_data = $this->Participant->getOrRedirect($participant_id);
		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id));
		if(!$treatment_control_id) {
			//*** Manage all lists display ***
			$this->set('all_treatment_controls', $this->TreatmentControl->find('all', array('conditions' => array('TreatmentControl.flag_active' => 1), 'order' => array('TreatmentControl.tx_method ASC'))));
			$this->set('add_link_for_procure_forms',$this->Participant->buildAddProcureFormsButton($participant_id));
			$this->request->data = array();
		} else {
			//*** Specific list display based on control_id
			$treatment_control = $this->TreatmentControl->getOrRedirect($treatment_control_id);
			//Limit fields of medication worksheet and display all field for the other one
			$this->Structures->set(($treatment_control['TreatmentControl']['tx_method'] == 'procure medication worksheet')? '': $treatment_control['TreatmentControl']['form_alias']);
			if(is_null($interval_start_date) && is_null($interval_finish_date)) {
				// 1- No Date Restriction (probably generic listall form)
				$this->request->data = $this->paginate($this->TreatmentMaster, array('TreatmentMaster.participant_id' => $participant_id, 'TreatmentMaster.treatment_control_id' => $treatment_control_id));
				$this->set('display_edit_button', false);
			} else {
				// 2- Date Restriction (probaby list linked to Medication Worksheet detail display or Follow-up Worksheet detail display)
				$this->set('display_edit_button', true);
				$interval_start_date = preg_match('/^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$/', $interval_start_date)? $interval_start_date : '';
				$interval_finish_date = preg_match('/^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$/', $interval_finish_date)? $interval_finish_date : '';
				$drugs_list_conditions = array(
					'TreatmentMaster.participant_id' => $participant_id, 
					'TreatmentMaster.treatment_control_id' => $treatment_control_id);
				$msg = '';
				if($interval_start_date && $interval_finish_date) {
					$drugs_list_conditions[]['OR'] = array(
						"TreatmentMaster.start_date IS NULL AND TreatmentMaster.finish_date IS NULL",
						"TreatmentMaster.start_date IS NOT NULL AND '$interval_start_date' <= TreatmentMaster.start_date  AND TreatmentMaster.start_date <= '$interval_finish_date'",
						"TreatmentMaster.finish_date IS NOT NULL AND '$interval_start_date' <= TreatmentMaster.finish_date AND TreatmentMaster.finish_date <= '$interval_finish_date'",
						"TreatmentMaster.start_date IS NULL AND TreatmentMaster.finish_date IS NOT NULL AND '$interval_finish_date' < TreatmentMaster.finish_date",
						"TreatmentMaster.finish_date IS NULL AND TreatmentMaster.start_date IS NOT NULL AND TreatmentMaster.start_date < '$interval_start_date'",
						"TreatmentMaster.start_date < $interval_start_date AND '$interval_finish_date' < TreatmentMaster.finish_date");
					$msg = "treatments list from %start% to %end%";
				} else if($interval_start_date){
					$drugs_list_conditions[]['OR'] = array(
						"TreatmentMaster.start_date IS NULL AND TreatmentMaster.finish_date IS NULL",
						"TreatmentMaster.finish_date IS NOT NULL AND TreatmentMaster.finish_date >= '$interval_start_date'");
					$msg = "treatments list after %start%";
				} else if($interval_finish_date){
					$drugs_list_conditions[]['OR'] = array(
						"TreatmentMaster.start_date IS NULL AND TreatmentMaster.finish_date IS NULL",
						"TreatmentMaster.start_date IS NOT NULL AND TreatmentMaster.start_date <= '$interval_finish_date'");
					$msg = "treatments list before %end%";
				} else {
					$msg = "unable to limit treatments list to a dates interval";				
				}
				AppController::addWarningMsg(str_replace(array('%start%', '%end%'), array($interval_start_date,$interval_finish_date),__($msg)));
				if(($interval_finish_date_accuracy.$interval_start_date_accuracy) != 'cc') AppController::addWarningMsg(__("at least one of the studied interval date is inaccurate"));				
				$this->request->data = $this->paginate($this->TreatmentMaster, $drugs_list_conditions);
			}
		}
	}	
	
	function addInBatch( $participant_id, $tx_control_id, $already_displayed = false) {
		
		if(!AppController::checkLinkPermission('/ClinicalAnnotation/TreatmentMasters/listall/')){
			$this->flash(__('you need privileges on the following modules to manage participant inventory: %s', implode(', ', $error)), 'javascript:history.back()');
		}
		
		$participant_data = $this->Participant->getOrRedirect($participant_id);
		$tx_control_data = $this->TreatmentControl->getOrRedirect($tx_control_id);
		
		if(!in_array($tx_control_data['TreatmentControl']['tx_method'], array('procure follow-up worksheet - treatment', 'procure medication worksheet - drug'))) {
			$this->redirect( '/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, NULL, TRUE );
		}
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id, 'TreatmentControl.id'=>$tx_control_id));
		$this->set('atim_menu', $this->Menus->get('/ClinicalAnnotation/TreatmentMasters/listall/%%Participant.id%%'));
		
		// Set trt header
		$this->set('tx_header', __($tx_control_data['TreatmentControl']['tx_method']));
		
		// set DIAGANOSES radio list form
		$this->Structures->set($tx_control_data['TreatmentControl']['form_alias']);
		
		$EventMaster = AppModel::getInstance('ClinicalAnnotation', 'EventMaster');
		$default_procure_form_identification = '';
		switch($tx_control_data['TreatmentControl']['tx_method']) {
			case'procure medication worksheet - drug':
				$default_procure_form_identification =  $participant_data['Participant']['participant_identifier'].' Vx -MEDx';
				break;
			case'procure follow-up worksheet - treatment':
				$default_procure_form_identification =  $participant_data['Participant']['participant_identifier'].' Vx -FSPx';
				break;
		}
		$this->set('default_procure_form_identification', $default_procure_form_identification);
		
		if(empty($this->request->data)){
			if(!$already_displayed) {
				$this->request->data = array();
				if($tx_control_data['TreatmentControl']['tx_method'] == 'procure medication worksheet - drug') {
					$ordered_drugs_to_dispay = array(
						'prostate' => array('avodart' => null,'proscar'=> null,'flomax'=> null,'xatral'=> null,'cipro'=> null),
						'open sale' => array('aspirine'=> null, 'advil'=> null, 'tylenol'=> null, 'vitamines'=> null));
					$drug_model = AppModel::getInstance("Drug", "Drug", true);
					$all_drugs = $drug_model->find('all', array('conditions' => array('Drug.type' => array('prostate','open sale','other diseases')), 'order' => array('Drug.generic_name')));
					foreach($all_drugs as $new_drug) {
						$type = $new_drug['Drug']['type'];
						$generic_name = strtolower($new_drug['Drug']['generic_name']);
						if(array_key_exists($type, $ordered_drugs_to_dispay) && array_key_exists($generic_name, $ordered_drugs_to_dispay[$type])) $ordered_drugs_to_dispay[$type][$generic_name] = $new_drug['Drug']['id'];
					}
					
					$this->request->data = array();
					foreach($ordered_drugs_to_dispay as $drug_sets) {
						foreach($drug_sets as $generic_name => $drug_id) {
							if($drug_id) $this->request->data[]['TreatmentDetail']['drug_id'] = $drug_id;
						}
					}
				} else {
					for($id=0; $id<5;$id++) $this->request->data[] = array();
				}
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