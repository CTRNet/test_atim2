<?php

	if($this->request->data['EventMaster']['diagnosis_master_id'] && in_array($event_master_data['EventControl']['event_type'], array('ovary or endometrium path report', 'other path report'))) {
		// Check types of the report and diagnosis
		$event_type = $event_master_data['EventControl']['event_type'];
		$selected_dx_data = $this->DiagnosisMaster->find('first', array('conditions'=>array('DiagnosisMaster.id'=>$this->request->data['EventMaster']['diagnosis_master_id'])));
		if($selected_dx_data['DiagnosisControl']['category'] != 'primary' 
		|| ($event_type == 'ovary or endometrium path report' && $selected_dx_data['DiagnosisControl']['controls_type'] != 'ovary or endometrium tumor')
		|| ($event_type == 'other path report' && $selected_dx_data['DiagnosisControl']['controls_type'] != 'other')) {
			$this->EventMaster->validationErrors[''][] = 'this type of path report can not be linked to this type of diagnosis';
			$submitted_data_validates = false;
		}
		// Check types of the report and diagnosis
		if($this->request->data['EventDetail']['diagnosis_report'] == 'y') {
			$custom_query = "SELECT count(*) as dx_report_count 
				FROM event_masters EventMaster INNER JOIN ovcare_ed_path_reports EventDetail ON EventMaster.id = EventDetail.event_master_id 
				WHERE EventMaster.diagnosis_master_id = ".$this->request->data['EventMaster']['diagnosis_master_id']." AND EventDetail.diagnosis_report = 'y' AND EventMaster.deleted <> 1 AND EventMaster.id != $event_master_id";
			$dx_report_count = $this->EventMaster->tryCatchQuery($custom_query);
			if($dx_report_count[0][0]['dx_report_count']) {
				$this->EventMaster->validationErrors['diagnosis_report'][] = 'only one report can be flagged as diagnosis report per diagnosis';
				$submitted_data_validates = false;
			}
		}
	}
	
?>