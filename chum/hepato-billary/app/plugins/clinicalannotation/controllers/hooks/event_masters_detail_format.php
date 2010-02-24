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
	$this->setMedicalPastHistoryPrecisions(array('EventControl' => $this->data['EventControl']));
	
	$this->Structures->set('QC_CHUM_HB_date', 'QC_CHUM_HB_date');
	
	$event_control_data = $this->EventControl->find('first',array('conditions'=>array('EventControl.id' => $this->data['EventMaster']['event_control_id'])));
	if(strpos($event_control_data['EventControl']['form_alias'], 'segment') > 0){
		//load segment
		$QC_CHUM_HB_segment = $this->Structures->get('form', 'QC_CHUM_HB_segment');
	}

	if(strpos($event_control_data['EventControl']['form_alias'], 'other') > 0){
		//load other
		$QC_CHUM_HB_other_localisations = $this->Structures->get('form', 'QC_CHUM_HB_other_localisations');
	}
	
	if(strpos($event_control_data['EventControl']['form_alias'], 'pancreas') > 0){
		$this->Structures->set('QC_CHUM_HB_pancreas');
	}else if(strpos($event_control_data['EventControl']['form_alias'], 'other') > 0){
		$this->Structures->set('QC_CHUM_HB_other_localisations');
		unset($QC_CHUM_HB_other_localisations);
	}else if(strpos($event_control_data['EventControl']['form_alias'], 'segment') > 0){
		$this->Structures->set('QC_CHUM_HB_segment');
		unset($QC_CHUM_HB_segment);
	}
	
	if(isset($QC_CHUM_HB_segment)){
		$this->set('QC_CHUM_HB_segment', $QC_CHUM_HB_segment);
	}
	if(isset($QC_CHUM_HB_other_localisations)){
		$this->set('QC_CHUM_HB_other_localisations', $QC_CHUM_HB_other_localisations);
	}
		
?>
