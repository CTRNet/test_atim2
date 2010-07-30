<?php
	
	// --------------------------------------------------------------------------------
	// *.surgery: 
	//   Add surgery complication treatment
	// --------------------------------------------------------------------------------
	if(($tx_master_data['TreatmentControl']['tx_method'] == 'surgery') && (!empty($tx_master_data['TreatmentControl']['extend_tablename']))) {
		App::import('Model', 'Clinicalannotation.SurgeryComplicationTreatment');
		$this->SurgeryComplicationTreatment = new SurgeryComplicationTreatment();
	
		$complication_trts = $this->SurgeryComplicationTreatment->find('all', array('conditions' => array('SurgeryComplicationTreatment.qc_hb_txe_surgery_complication_id' => $tx_extend_id), 'order' => 'SurgeryComplicationTreatment.date DESC'));	
		$this->set('complication_trts', $complication_trts);

		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id, 'TreatmentMaster.id'=>$tx_master_id, 'TreatmentExtend.id'=>$tx_extend_id));
		$this->Structures->set('qc_hb_surgery_complication_treatments', 'surgery_complication_treatment_structure');
	}	


?>
