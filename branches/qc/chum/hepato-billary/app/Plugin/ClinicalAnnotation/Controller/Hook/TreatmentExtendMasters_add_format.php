<?php
	
	$atim_menu = $this->Menus->get('/ClinicalAnnotation/TreatmentMasters/preOperativeDetail/%%Participant.id%%/%%TreatmentMaster.id%%');
	$atim_menu = $this->TreatmentMaster->inactivatePreOperativeDataMenu($atim_menu, $tx_master_data['TreatmentControl']['detail_tablename']);
	$this->set('atim_menu', $atim_menu);
	