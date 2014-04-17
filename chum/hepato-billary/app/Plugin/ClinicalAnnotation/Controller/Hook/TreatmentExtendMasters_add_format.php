<?php
	
	$atim_menu = $this->Menus->get('/ClinicalAnnotation/TreatmentMasters/preOperativeDetail/%%Participant.id%%/%%TreatmentMaster.id%%');
	$atim_menu = $this->TreatmentMaster->inactivatePreOperativeDataMenu($atim_menu, $tx_master_data['TreatmentControl']['detail_tablename']);
	$this->set('atim_menu', $atim_menu);
	
	$is_chemo_complications = false;
	if(in_array('chemo_complications', $this->passedArgs)) {
		$tx_extend_control_data = $this->TreatmentExtendControl->find('first', array('conditions' => array('TreatmentExtendControl.type' => 'chemotherapy complications')));
		$tx_master_data['TreatmentControl']['treatment_extend_control_id'] = $tx_extend_control_data['TreatmentExtendControl']['id']; 
		$this->Structures->set($tx_extend_control_data['TreatmentExtendControl']['form_alias']);
		$is_chemo_complications = true;
	}
	$this->set('is_chemo_complications', $is_chemo_complications);	
	