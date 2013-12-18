<?php

class TreatmentExtendControl extends ClinicalAnnotationAppModel {
	
	var $master_form_alias = 'treatment_extend_masters';
	
	function getPrecisionTypeValues() {
		$result = array();
	
		// Build tmp array to sort according translation
		foreach($this->find('all', array('conditions' => array('flag_active = 1'))) as $tx_extend_ctrl) {
			$result[$tx_extend_ctrl['TreatmentExtendControl']['type']] = __($tx_extend_ctrl['TreatmentExtendControl']['type']);
		}
		natcasesort($result);
	
		return $result;
	}
	
}
