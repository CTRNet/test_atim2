<?php

	// --------------------------------------------------------------------------------
	// Override Menu For 'clinical' event_group 	 
	// --------------------------------------------------------------------------------
	if($event_group == 'clinical') {
		$this->set('atim_menu', $this->Menus->get('/clinicalannotation/event_masters/listall/clinical/%%Participant.id%%//'));
	}
			
	// --------------------------------------------------------------------------------
	// clinical.hepatobiliary.*** medical past history: 
	//   Set Medical Past History precisions list
	// --------------------------------------------------------------------------------
	$this->setMedicalPastHistoryPrecisions(array('EventControl' => $event_master_data['EventControl']));
	
	$this->Structures->set('QC_CHUM_HB_date', 'QC_CHUM_HB_date');
	
	$event_control_data = $this->EventControl->find('first',array('conditions'=>array('EventControl.id' => $event_master_data['EventMaster']['event_control_id'])));
	$this->setMedicalImaginStructures($event_control_data);
	
	if($event_control_data['EventControl']['form_alias'] == "ed_hepatobiliary_lab_report_biology"){
		$this->Structures->set('QC_CHUM_HB_dateNSummary', 'QC_CHUM_HB_dateNSummary');
	}
?>
