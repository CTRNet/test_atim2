<?php 
	if($tx_control_data['TreatmentControl']['tx_method'] == 'surgery' && $tx_control_data['TreatmentControl']['disease_site'] == 'RP') {
		$participant_RPs = $this->TreatmentMaster->find('count', array('conditions' => array('TreatmentMaster.participant_id'=> $participant_id, 'TreatmentControl.id' => $tx_control_id)));
		pr($participant_RPs);
		if($participant_RPs) {
			$this->flash(__('a RP can not be created twice for the same participant'), '/ClinicalAnnotation/TreatmentMasters/listall/'.$participant_id);
			return;
		}
	}
