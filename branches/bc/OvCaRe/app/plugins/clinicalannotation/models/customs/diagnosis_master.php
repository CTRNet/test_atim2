<?php

class DiagnosisMasterCustom extends DiagnosisMaster {
	var $name = 'DiagnosisMaster';
	var $useTable = 'diagnosis_masters';
	
	var $ovcareIsDxDeletion = false;
	
	function beforeDelete() {
		if(empty($this->data)) {
			$this->data = $this->find('first', array('conditions' => array('DiagnosisMaster.id' => $this->id), 'recursive' => '0'));
		}
		if($this->id != $this->data['DiagnosisMaster']['id']) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		if($this->data['DiagnosisControl']['category'] == 'recurrence') {	
			// *** SET DATA FOR DIAGNOSES UPDATE ***
			// (User is deleting a reccurrence)
			$this->data['OvcareDiagFunctionManagement']['parent_id_of_reccurrence'] = $this->data['DiagnosisMaster']['parent_id'];
		}
		
		$this->ovcareIsDxDeletion = true;
		
		return true;
	}
	
	function beforeSave($options) {
	
		if(array_key_exists('dx_date', $this->data['DiagnosisMaster']) && (!$this->ovcareIsDxDeletion)) { 
			// User just clicked on submit button of diagnosis form (don't run follwing code when save is launched from other model)
			
			$diagnosis_control_data = array();
			
			$parent_id = null;
			if(array_key_exists('participant_id', $this->data['DiagnosisMaster'])) {
				// Diagnosis is just being created
				$diagnosis_control_model = AppModel::getInstance("Clinicalannotation", "DiagnosisControl", true);
				$diagnosis_control_data = $diagnosis_control_model->find('first', array('conditions' => array ('DiagnosisControl.id' => $this->data['DiagnosisMaster']['diagnosis_control_id'])));				
				$parent_id = $this->data['DiagnosisMaster']['parent_id'];
			} else {
				// Diagnosis is being updated
				$previous_diagnosis_data = $this->find('first', array('conditions' => array('DiagnosisMaster.id' => $this->id), 'recursive' => '0'));
				if(empty($previous_diagnosis_data)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				$diagnosis_control_data['DiagnosisControl'] = $previous_diagnosis_data['DiagnosisControl'];	
				$parent_id = $previous_diagnosis_data['DiagnosisMaster']['parent_id'];
			}
			if(empty($diagnosis_control_data)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			
			if($diagnosis_control_data['DiagnosisControl']['category'] == 'recurrence') {	
				// *** SET DATA FOR DIAGNOSES UPDATE ***
				$this->data['OvcareDiagFunctionManagement']['parent_id_of_reccurrence'] = $parent_id;
			}
		}
				
		return true;
	}
	
	function afterSave() {	
		if(array_key_exists('OvcareDiagFunctionManagement', $this->data)) {		
			// *** LAUNCH DIAGNOSES UPDATE : INTIAL RECURRENCE DATE ***									
			$tmp_id = $this->id;
			$tmp_data = $this->data;
			
			$parent_id_of_reccurrence = $this->data['OvcareDiagFunctionManagement']['parent_id_of_reccurrence'];
			unset($this->data['OvcareDiagFunctionManagement']['parent_id_of_reccurrence']);
			$this->setInitialRecurrenceDate($parent_id_of_reccurrence);
			
			$this->id = $tmp_id;
			$this->data = $tmp_data;
		}
	}

	function setInitialRecurrenceDate($diagnosis_master_id) {
		$diagnosis_data = $this->find('first',array('conditions' => array('DiagnosisMaster.id' => $diagnosis_master_id), 'recursive' => '0'));
		if(empty($diagnosis_data)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		
		if($diagnosis_data['DiagnosisControl']['controls_type'] == 'ovcare') {
            
			// *** SET INITIAL DIAGNOSIS RECURRENCE DATE ***
			
			$initial_recurrence_date = $diagnosis_data['DiagnosisDetail']['initial_recurrence_date'];
			$initial_recurrence_date_accuracy = $diagnosis_data['DiagnosisDetail']['initial_recurrence_date_accuracy'];
			
			$conditions =  array (
				'DiagnosisMaster.parent_id' => $diagnosis_master_id,
				'DiagnosisControl.category' => 'recurrence',
				"DiagnosisMaster.dx_date != ''",
				"DiagnosisMaster.dx_date IS NOT NULL"		
			);
			$recurrences_list = $this->find('first', array('conditions' =>$conditions, 'order' => array('DiagnosisMaster.dx_date ASC'),'recursive' => '0'));
		
			$new_min_recurrence_date = empty($recurrences_list)? '' : $recurrences_list['DiagnosisMaster']['dx_date'];
			$new_min_recurrence_date_accuracy = empty($recurrences_list)? '' : $recurrences_list['DiagnosisMaster']['dx_date_accuracy'];	
			
			if(($initial_recurrence_date.$initial_recurrence_date_accuracy) != ($new_min_recurrence_date.$new_min_recurrence_date_accuracy)) {
				$arr_new_min_recurrence_date = explode('-',$new_min_recurrence_date);
				
				$set_year_acc = false;
				switch($new_min_recurrence_date_accuracy) {
					case 'y':
						$set_year_acc = true;
					case 'm':
						$arr_new_min_recurrence_date[1] = '';
					case 'd':
						$arr_new_min_recurrence_date[2] = '';
						break;
					case 'c':
						break;
					case '':
						if(!empty($new_min_recurrence_date)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
						$arr_new_min_recurrence_date = array('','','');
						break;
					default:
						AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				}
				
				$arr_new_min_recurrence_date = array_combine(array('year','month','day'), $arr_new_min_recurrence_date);
				if($set_year_acc) $arr_new_min_recurrence_date['year_accuracy'] = 1;

				$new_diag_data = array();
				$new_diag_data['DiagnosisMaster']['id'] = $diagnosis_master_id;
				$new_diag_data['DiagnosisDetail']['initial_recurrence_date'] = $arr_new_min_recurrence_date;	
				$this->data = array();
				$this->id = $diagnosis_master_id;
				$this->save($new_diag_data,false);
					
				// *** LAUNCH DIAGNOSIS PROGRESSION FREE TIME CALCULATION ***
				
				$this->updateProgressionFreeTime($diagnosis_master_id);
			}
		}
	}
	
	function setInitialSurgeryDate($diagnosis_master_id) {
		if(empty($diagnosis_master_id)) return;

		$diagnosis_data = $this->find('first',array('conditions' => array('DiagnosisMaster.id' => $diagnosis_master_id), 'recursive' => '0'));
		if(empty($diagnosis_data)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		
		if($diagnosis_data['DiagnosisControl']['controls_type'] == 'ovcare') {
			
			// *** SET INITIAL DIAGNOSIS SURGERY DATE ***
			
			$initial_surgery_date = $diagnosis_data['DiagnosisDetail']['initial_surgery_date'];
			$initial_surgery_date_accuracy = $diagnosis_data['DiagnosisDetail']['initial_surgery_date_accuracy'];
			
			$treatment_master_model = AppModel::getInstance("Clinicalannotation", "TreatmentMaster", true);
			$conditions =  array (
				'TreatmentMaster.diagnosis_master_id' => $diagnosis_master_id,
				'TreatmentControl.disease_site' => 'ovcare',
				'TreatmentControl.tx_method' => 'surgery',
				"TreatmentMaster.start_date != ''",
				"TreatmentMaster.start_date IS NOT NULL"		
			);
			$surgeries_list = $treatment_master_model->find('first', array('conditions' =>$conditions, 'order' => array('TreatmentMaster.start_date ASC'),'recursive' => '0'));
			
			$new_min_surgery_date = empty($surgeries_list)? '' : $surgeries_list['TreatmentMaster']['start_date'];
			$new_min_surgery_date_accuracy = empty($surgeries_list)? '' : $surgeries_list['TreatmentMaster']['start_date_accuracy'];	

			if(($initial_surgery_date.$initial_surgery_date_accuracy) != ($new_min_surgery_date.$new_min_surgery_date_accuracy)) {
				$arr_new_min_surgery_date = explode('-',$new_min_surgery_date);
				
				$set_year_acc = false;
				switch($new_min_surgery_date_accuracy) {
					case 'y':
						$set_year_acc = true;
					case 'm':
						$arr_new_min_surgery_date[1] = '';
					case 'd':
						$arr_new_min_surgery_date[2] = '';
						break;
					case 'c':
						break;
					case '':
						if(!empty($new_min_surgery_date)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
						$arr_new_min_surgery_date = array('','','');
						break;
					default:
						AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				}
				
				$arr_new_min_surgery_date = array_combine(array('year','month','day'), $arr_new_min_surgery_date);
				if($set_year_acc) $arr_new_min_surgery_date['year_accuracy'] = 1;

				$new_diag_data = array();
				$new_diag_data['DiagnosisMaster']['id'] = $diagnosis_master_id;
				$new_diag_data['DiagnosisDetail']['initial_surgery_date'] = $arr_new_min_surgery_date;	
				$this->data = array();
				$this->id = $diagnosis_master_id;
				$this->save($new_diag_data,false);
				
				// *** LAUNCH DIAGNOSIS SURVIVAL TIME CALCULATION ***
				
				$this->updateSurvivalTime($diagnosis_master_id, false);
				
				// *** LAUNCH DIAGNOSIS PROGRESSION FREE TIME CALCULATION ***
				
				$this->updateProgressionFreeTime($diagnosis_master_id);
			}
		}
	}
	
	function updateAllSurvivaleTimes($participant_id) {
		$participant_model = AppModel::getInstance("Clinicalannotation", "Participant", true);
		$participant_data = $participant_model->find('first', array('conditions' => array ('Participant.id' => $participant_id), 'recursive' => '-1'));
		if(empty($participant_data)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		
		$diagnoses_list = $this->find('all',array('conditions' => array('DiagnosisMaster.participant_id' => $participant_id, 'DiagnosisControl.controls_type' => 'ovcare'), 'recursive' => '0'));
		foreach($diagnoses_list as $new_diagnosis) $this->updateSurvivalTime($new_diagnosis['DiagnosisMaster']['id'], true, $new_diagnosis, $participant_data);
	}	
	
	function updateSurvivalTime($diagnosis_master_id, $launch_update_progression_free_time,$diagnosis_data = array(), $participant_data = array()) {
		if(empty($diagnosis_data)) $diagnosis_data = $this->find('first',array('conditions' => array('DiagnosisMaster.id' => $diagnosis_master_id), 'recursive' => '0'));
		if(empty($diagnosis_data)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		
		if($diagnosis_data['DiagnosisControl']['controls_type'] == 'ovcare') {
			if(empty($participant_data)) {
				$participant_model = AppModel::getInstance("Clinicalannotation", "Participant", true);
				$participant_data = $participant_model->find('first', array('conditions' => array ('Participant.id' => $diagnosis_data['DiagnosisMaster']['participant_id']), 'recursive' => '-1'));
			}
			if(empty($participant_data)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);

			$previous_survival_time_months = $diagnosis_data['DiagnosisMaster']['survival_time_months'];
			$survival_time_months = '';
			if(!empty($participant_data['Participant']['ovcare_last_followup_date']) && !empty($diagnosis_data['DiagnosisDetail']['initial_surgery_date'])) {
				if((in_array($participant_data['Participant']['ovcare_last_followup_date_accuracy'], array('d','c')) || empty($participant_data['Participant']['ovcare_last_followup_date_accuracy'])) 
				&& (in_array($diagnosis_data['DiagnosisDetail']['initial_surgery_date_accuracy'], array('d','c')) || empty($diagnosis_data['DiagnosisDetail']['initial_surgery_date_accuracy']))) {
					$initialSurgeryDateObj = new DateTime($diagnosis_data['DiagnosisDetail']['initial_surgery_date']);
					$lastFollDateObj = new DateTime($participant_data['Participant']['ovcare_last_followup_date']);
					$interval = $initialSurgeryDateObj->diff($lastFollDateObj);
					$survival_time_months = $interval->format('%r%y')*12 + $interval->format('%r%m');				
					if($survival_time_months < 0) {
						$survival_time_months = '';
						AppController::addWarningMsg(str_replace('%%field%%', __('survival time months',true), __('error in the dates definitions: the field [%%field%%] can not be generated', true)));
					}
				} else {
					AppController::addWarningMsg(str_replace('%%field%%', __('survival time months',true), __('the dates accuracy is not sufficient: the field [%%field%%] can not be generated', true)));
				}
			}
							
			if($previous_survival_time_months != $survival_time_months) {
				
				// *** UPDATE SURVIVAL TIME ***
				
				$new_diag_data = array();
				$new_diag_data['DiagnosisMaster']['id'] = $diagnosis_master_id;
				$new_diag_data['DiagnosisMaster']['survival_time_months'] = $survival_time_months;	
				$this->data = array();
				$this->id = $diagnosis_master_id;
				$this->save($new_diag_data,false);
				
				// *** LAUNCH DIAGNOSIS PROGRESSION FREE TIME CALCULATION ***
				
				if($launch_update_progression_free_time) $this->updateProgressionFreeTime($diagnosis_master_id);
			}
		}
	}

	function updateProgressionFreeTime($diagnosis_master_id) {
		$diagnosis_data = $this->find('first',array('conditions' => array('DiagnosisMaster.id' => $diagnosis_master_id), 'recursive' => '0'));
		if(empty($diagnosis_data)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		
		if($diagnosis_data['DiagnosisControl']['controls_type'] == 'ovcare') {
			$previous_progression_free_time_months = $diagnosis_data['DiagnosisDetail']['progression_free_time_months'];
			
			$new_progression_free_time_months = '';
			if(!empty($diagnosis_data['DiagnosisDetail']['initial_surgery_date']) && !empty($diagnosis_data['DiagnosisDetail']['initial_recurrence_date'])) {
				if((in_array($diagnosis_data['DiagnosisDetail']['initial_surgery_date_accuracy'], array('d','c')) || empty($diagnosis_data['DiagnosisDetail']['initial_surgery_date_accuracy'])) 
				&& (in_array($diagnosis_data['DiagnosisDetail']['initial_recurrence_date_accuracy'], array('d','c')) || empty($diagnosis_data['DiagnosisDetail']['initial_recurrence_date_accuracy']))) {
					$initialSurgeryDateObj = new DateTime($diagnosis_data['DiagnosisDetail']['initial_surgery_date']);
					$initialRecurrenceDateObj = new DateTime($diagnosis_data['DiagnosisDetail']['initial_recurrence_date']);
					$interval = $initialSurgeryDateObj->diff($initialRecurrenceDateObj);
					$new_progression_free_time_months = $interval->format('%r%y')*12 + $interval->format('%r%m');				
					if($new_progression_free_time_months < 0) {
						$new_progression_free_time_months = '';
						AppController::addWarningMsg(str_replace('%%field%%', __('progression free time months',true), __('error in the dates definitions: the field [%%field%%] can not be generated', true)));
					}
				} else {
					AppController::addWarningMsg(str_replace('%%field%%', __('progression free time months',true), __('the dates accuracy is not sufficient: the field [%%field%%] can not be generated', true)));
				}
			} else {
				$new_progression_free_time_months = $diagnosis_data['DiagnosisMaster']['survival_time_months'];
			}
			
			if($new_progression_free_time_months != $previous_progression_free_time_months) {
				// *** UPDATE PROGRESSION FREE TIME ***
				$new_diag_data = array();
				$new_diag_data['DiagnosisMaster']['id'] = $diagnosis_master_id;
				$new_diag_data['DiagnosisDetail']['progression_free_time_months'] = $new_progression_free_time_months;
				$this->data = array();
				$this->id = $diagnosis_master_id;
				$this->save($new_diag_data,false);
			}
		}
	}
}
?>