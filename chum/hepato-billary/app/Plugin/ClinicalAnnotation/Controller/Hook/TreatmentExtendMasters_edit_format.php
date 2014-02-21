<?php
	
	$tx_control_data = $this->TreatmentControl->find('first', array('conditions' => array('TreatmentControl.id' => $tx_extend_data['TreatmentMaster']['treatment_control_id'])));
	$atim_menu = $this->Menus->get('/ClinicalAnnotation/TreatmentMasters/preOperativeDetail/%%Participant.id%%/%%TreatmentMaster.id%%');
	$atim_menu = $this->TreatmentMaster->inactivatePreOperativeDataMenu($atim_menu, $tx_control_data['TreatmentControl']['detail_tablename']);
	$this->set('atim_menu', $atim_menu);
	