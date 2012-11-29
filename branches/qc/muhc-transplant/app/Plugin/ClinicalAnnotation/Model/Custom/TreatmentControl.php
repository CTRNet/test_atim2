<?php

class TreatmentControlCustom extends TreatmentControl {
	
	var $useTable = 'treatment_controls';
	var $name = "TreatmentControl";
	
	function getAddLinks($participant_id, $diagnosis_master_id = ''){
		$treatment_controls = $this->find('all', array('conditions' => array('TreatmentControl.flag_active' => 1)));
		foreach ( $treatment_controls as $treatment_control ) {
			$trt_header = __($treatment_control['TreatmentControl']['disease_site']) . ' - ' . __($treatment_control['TreatmentControl']['tx_method']);
			$add_links[$trt_header] = '/ClinicalAnnotation/TreatmentMasters/add/'.$participant_id.'/'.$treatment_control['TreatmentControl']['id'].'/'.$diagnosis_master_id;
		}
		ksort($add_links);
		return $add_links;
	}
	
}
