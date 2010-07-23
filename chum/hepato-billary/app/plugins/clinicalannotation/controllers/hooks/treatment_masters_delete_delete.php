<?php

	// --------------------------------------------------------------------------------
	// Check surgeyr not linked to a lab report
	// --------------------------------------------------------------------------------
	if ($arr_allow_deletion['allow_deletion']) {
		if(!isset($this->EventDetail)) {
			App::import("Model", "Clinicalannotation.EventDetail");
			$this->EventDetail = new EventDetail(false, 'qc_hb_ed_hepatobilary_lab_report_biology');	
		}
		
		$nbr = $this->EventDetail->find('count', array('conditions' => array('EventDetail.surgery_tx_master_id' => $tx_master_id)));
		if ($nbr > 0) { 
			$arr_allow_deletion = array('allow_deletion' => false, 'msg' => 'at least one biology lab report is linked to this treatment'); 
		}
	}
	
		
	
?>