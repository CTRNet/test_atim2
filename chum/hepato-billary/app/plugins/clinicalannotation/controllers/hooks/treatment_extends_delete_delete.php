<?php
	
	// --------------------------------------------------------------------------------
	// *.surgery: 
	//   Check there is no complication treatment
	// --------------------------------------------------------------------------------	
	if(($tx_master_data['TreatmentControl']['tx_method'] == 'surgery') && (!empty($tx_master_data['TreatmentControl']['extend_tablename']))) {
	
		App::import('Model', 'Clinicalannotation.SurgeryComplicationTreatment');
		$this->SurgeryComplicationTreatment = new SurgeryComplicationTreatment();
			
		$nbr_complication_trts = $this->SurgeryComplicationTreatment->find('count', array('conditions' => array('SurgeryComplicationTreatment.qc_hb_txe_surgery_complication_id' => $tx_extend_id), 'recursive' => -1));	
		if ($nbr_complication_trts > 0) { 
			$arr_allow_deletion['allow_deletion'] = false;
			$arr_allow_deletion['msg'] = 'at least one treatment is defined as surgery complication treatment';
		}
	}	 


?>
