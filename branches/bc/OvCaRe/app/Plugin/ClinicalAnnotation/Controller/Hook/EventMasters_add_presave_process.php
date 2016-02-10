<?php

	if($event_control_data['EventControl']['event_type'] == 'brca' 
	&& $this->EventMaster->find('count', array('conditions' => array('EventMaster.participant_id'=>$participant_id, 'EventControl.event_type' => 'brca')))) {
		$this->EventMaster->validationErrors[''][] = 'brca report can not be created twice for one patient';
		$submitted_data_validates = false;
	}
	
	if(isset($this->request->data['EventMaster']) && $this->request->data['EventMaster']['diagnosis_master_id'] && in_array($event_control_data['EventControl']['event_type'], array('ovary or endometrium path report', 'other path report'))) {
		// Check types of the report and diagnosis
		$event_type = $event_control_data['EventControl']['event_type'];
		$selected_dx_data = $this->DiagnosisMaster->find('first', array('conditions'=>array('DiagnosisMaster.id'=>$this->request->data['EventMaster']['diagnosis_master_id'])));
		if($selected_dx_data['DiagnosisControl']['category'] != 'primary' 
		|| ($event_type == 'ovary or endometrium path report' && !in_array($selected_dx_data['DiagnosisControl']['controls_type'], array('ovary or endometrium tumor', 'primary diagnosis unknown')))
		|| ($event_type == 'other path report' && !in_array($selected_dx_data['DiagnosisControl']['controls_type'], array('other', 'primary diagnosis unknown')))) {
			$this->EventMaster->validationErrors[''][] = 'this type of path report can not be linked to this type of diagnosis';
			$submitted_data_validates = false;
		}
	}
	
?>