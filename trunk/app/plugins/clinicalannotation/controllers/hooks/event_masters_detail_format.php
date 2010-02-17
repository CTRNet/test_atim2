<?php

	// --------------------------------------------------------------------------------
	// hepatobiliary-clinical-medical_past_history : 
	//    Add Event Extend to add deases precisions
	// --------------------------------------------------------------------------------
	$event_type_title = 
		$this->data['EventMaster']['disease_site'].'-'.
		$event_group.'-'.
		$this->data['EventMaster']['event_type'];
	
	$specific_event_type_list = array('hepatobiliary-clinical-medical_past_history');
	if(in_array($event_type_title, $specific_event_type_list)) {
		// MANAGE DATA
		
		// load models
		App::import('Model', 'clinicalannotation.EventExtend');		
		$this->EventExtend = new EventExtend(false, 'ee_hepatobiliary_medical_past_history');
		
		App::import('Model', 'clinicalannotation.MedicalPastHistoryCtrl');		
		$this->MedicalPastHistoryCtrl = new MedicalPastHistoryCtrl();

		// Get Medical History Detail data
		$this->paginate = array_merge($this->paginate, array('EventExtend'=>array('limit'=>10,'order'=>'EventExtend.medical_history_date DESC')));
		$medical_history_details = $this->paginate($this->EventExtend, array('EventExtend.event_master_id'=>$event_master_id));
		$this->set('medical_history_details', $medical_history_details);
		
		// Get list of disease types
		$tmp_allowed_disease_types = $this->MedicalPastHistoryCtrl->find('all', array('fields' => 'DISTINCT MedicalPastHistoryCtrl.disease_type'));		
		$allowed_disease_types_list = array();
		foreach($tmp_allowed_disease_types as $new_type) {
			$allowed_disease_types_list[$new_type['MedicalPastHistoryCtrl']['disease_type']] = __($new_type['MedicalPastHistoryCtrl']['disease_type'], true);
		}
		$this->set('allowed_disease_types_list', $allowed_disease_types_list);
		
		// Get list of disease precisions
		$tmp_allowed_disease_precisions = $this->MedicalPastHistoryCtrl->find('all', array('fields' => 'DISTINCT MedicalPastHistoryCtrl.disease_precision'));
		$allowed_disease_precisions_list = array();
		foreach($tmp_allowed_disease_precisions as $new_type) {
			$allowed_disease_precisions_list[$new_type['MedicalPastHistoryCtrl']['disease_precision']] = __($new_type['MedicalPastHistoryCtrl']['disease_precision'], true);
		}		
		$this->set('allowed_disease_precisions_list', $allowed_disease_precisions_list);
						
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->Structures->set('ee_hepatobiliary_medical_past_history', 'medical_history_detail_structure');
	}
		
?>
