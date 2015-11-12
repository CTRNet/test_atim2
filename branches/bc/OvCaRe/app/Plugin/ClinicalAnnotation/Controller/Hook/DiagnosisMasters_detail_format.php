<?php
	
	if($dx_master_data['DiagnosisControl']['category'] == 'primary' && in_array($dx_master_data['DiagnosisControl']['controls_type'], array('other', 'ovary or endometrium tumor'))) {
		$this->set('report_event_type', $this->EventControl->find('first', array('conditions' => array('EventControl.event_type' => ($dx_master_data['DiagnosisControl']['controls_type'] == 'ovary or endometrium tumor'? 'ovary or endometrium path report' : 'other path report')))));
	}
	