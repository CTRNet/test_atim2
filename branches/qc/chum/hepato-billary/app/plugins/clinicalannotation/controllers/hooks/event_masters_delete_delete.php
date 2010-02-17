<?php

	// --------------------------------------------------------------------------------
	// hepatobiliary-clinical-medical_past_history: 
	//    Check event not linked to medical past history
	// --------------------------------------------------------------------------------		
	if ($arr_allow_deletion['allow_deletion']) {
		// Load Model
		App::import('Model', 'clinicalannotation.EventExtend');		
		$this->EventExtend = new EventExtend(false, 'ee_hepatobiliary_medical_past_history');
		
		// Check data
		$returned_nbr = $this->EventExtend->find('count', array('conditions' => array('EventExtend.event_master_id' => $event_master_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { $arr_allow_deletion = array('allow_deletion' => false, 'msg' => 'detail exists for the deleted medical past history'); }
	}
	
?>
