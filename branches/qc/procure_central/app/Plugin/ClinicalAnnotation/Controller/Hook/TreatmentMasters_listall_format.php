<?php 
	
	if(!$treatment_control_id && isset($controls_for_subform_display)) {
	 	//Set procure add button
		$this->set('add_link_for_procure_forms',$this->Participant->buildAddProcureFormsButton($participant_id));
		//Separate treatment and medication
		$tmp_treatment_control = array();
		foreach($controls_for_subform_display as $tmp_key => $tmp_control) {
			if($tmp_control['TreatmentControl']['tx_method'] == 'treatment') {
				$tmp_treatment_control= $tmp_control;
				unset($controls_for_subform_display[$tmp_key]);
			}
		}
		$tmp_treatment_control = array($tmp_treatment_control, $tmp_treatment_control);
		$tmp_treatment_control[0]['TreatmentControl']['id'] .= '/procure_treatment_key';
		$tmp_treatment_control[1]['TreatmentControl']['tx_header'] = __('medication');
		$tmp_treatment_control[1]['TreatmentControl']['id'] .= '/procure_medication_key';
		$this->set('controls_for_subform_display', array_merge($controls_for_subform_display, $tmp_treatment_control));
	
	
	
	} else if($treatment_control_id && $treatment_control_id != '-1') {
		if(in_array('procure_treatment_key', $this->passedArgs)) {
			$search_criteria[] = "TreatmentDetail.treatment_type NOT LIKE '%medication%'";
		} 
		else if(in_array('procure_medication_key', $this->passedArgs)) {
			$search_criteria[] = "TreatmentDetail.treatment_type LIKE '%medication%'";
		}
		$this->request->data = $this->paginate($this->TreatmentMaster, $search_criteria);
	}