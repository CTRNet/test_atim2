<?php

class TreatmentControl extends ClinicalAnnotationAppModel {
	
	var $master_form_alias = 'treatmentmasters';
	
	/**
	 * Get permissible values array gathering all existing treatment disease sites.
	 *
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  	
	function getDiseaseSitePermissibleValues() {
		$result = array();
		
		// Build tmp array to sort according translation
		foreach($this->find('all', array('conditions' => array('flag_active = 1'))) as $tx_ctrl) {
			$result[$tx_ctrl['TreatmentControl']['disease_site']] = __($tx_ctrl['TreatmentControl']['disease_site']);
		}
		asort($result);
		
		return $result;
	}
	
	/**
	 * Get permissible values array gathering all existing treatment method.
	 *
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  	
	function getMethodPermissibleValues() {
		$result = array();
				
		// Build tmp array to sort according translation
		foreach($this->find('all', array('conditions' => array('flag_active = 1'))) as $tx_ctrl) {
			$result[$tx_ctrl['TreatmentControl']['tx_method']] = __($tx_ctrl['TreatmentControl']['tx_method']);
		}
		asort($result);
		
		return $result;
	}
	
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

?>