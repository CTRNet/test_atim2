<?php

	if($this->request->data['EventMaster']['diagnosis_master_id'] && in_array($event_master_data['EventControl']['event_type'], array('ovary or endometrium path report', 'other path report'))) {
		// Check types of the report and diagnosis
		$event_type = $event_master_data['EventControl']['event_type'];
		$selected_dx_data = $this->DiagnosisMaster->find('first', array('conditions'=>array('DiagnosisMaster.id'=>$this->request->data['EventMaster']['diagnosis_master_id'])));
		if($selected_dx_data['DiagnosisControl']['category'] != 'primary' 
		|| ($event_type == 'ovary or endometrium path report' && !in_array($selected_dx_data['DiagnosisControl']['controls_type'], array('ovary or endometrium tumor', 'primary diagnosis unknown')))
		|| ($event_type == 'other path report' && !in_array($selected_dx_data['DiagnosisControl']['controls_type'], array('other', 'primary diagnosis unknown')))) {
			$this->EventMaster->validationErrors[''][] = 'this type of path report can not be linked to this type of diagnosis';
			$submitted_data_validates = false;
		}
	}
	
?>