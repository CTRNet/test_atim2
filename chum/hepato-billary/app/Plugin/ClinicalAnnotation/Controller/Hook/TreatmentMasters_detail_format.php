<?php
	
	$atim_menu = $this->Menus->get('/ClinicalAnnotation/TreatmentMasters/preOperativeDetail/%%Participant.id%%/%%TreatmentMaster.id%%');
	$atim_menu = $this->TreatmentMaster->inactivatePreOperativeDataMenu($atim_menu, $treatment_master_data['TreatmentControl']['detail_tablename']);
	$this->set('atim_menu', $atim_menu);
	
	$add_chemo_complication = false;
	if(in_array($treatment_master_data['TreatmentControl']['tx_method'], array('chemo-embolization','chemotherapy'))) {
		$add_chemo_complication = true;
		$tx_extend_control_data = $this->TreatmentExtendControl->find('first', array('conditions' => array('TreatmentExtendControl.type' => 'chemotherapy complications')));
		$this->set('tx_extend_data_2', $this->TreatmentExtendMaster->find('all', array('conditions' => array('TreatmentExtendMaster.treatment_master_id' => $tx_master_id, 'TreatmentExtendMaster.treatment_extend_control_id' => $tx_extend_control_data['TreatmentExtendControl']['id']))));
		$this->Structures->set($tx_extend_control_data['TreatmentExtendControl']['form_alias'], 'extend_form_alias_2');
	}
	$this->set('add_chemo_complication', $add_chemo_complication);
	