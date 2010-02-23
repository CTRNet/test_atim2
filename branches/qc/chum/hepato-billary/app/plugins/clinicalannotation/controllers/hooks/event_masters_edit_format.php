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
	
	$event_control_data = $this->EventControl->find('first',array('conditions'=>array('EventControl.id' => $event_master_data['EventMaster']['event_control_id'])));
	if(strpos($event_control_data['EventControl']['form_alias'], 'segment') > 0){
		//load segment
		$this->Structures->set('QC_CHUM_HB_segment', 'QC_CHUM_HB_segment');
	}

	if(strpos($event_control_data['EventControl']['form_alias'], 'other') > 0){
		//load other
		$this->Structures->set('QC_CHUM_HB_other_localisations', 'QC_CHUM_HB_other_localisations');
	}
	
	
	if(strpos($event_control_data['EventControl']['form_alias'], 'pancreas') > 0){
		$this->Structures->set('QC_CHUM_HB_pancreas', 'atim_structure');
	}else if(strpos($event_control_data['EventControl']['form_alias'], 'other') > 0){
		$this->Structures->set('QC_CHUM_HB_other_locaisations', 'atim_structure');
	}else if(strpos($event_control_data['EventControl']['form_alias'], 'segment') > 0){
		$this->Structures->set('QC_CHUM_HB_segment', 'atim_structure');
	}
	
?>
