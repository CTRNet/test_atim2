<?php

class TreatmentControl extends ClinicalannotationAppModel {
	var $useTable = 'tx_controls';
	
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
			$result[$tx_ctrl['TreatmentControl']['disease_site']] = __($tx_ctrl['TreatmentControl']['disease_site'], true);
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
			$result[$tx_ctrl['TreatmentControl']['tx_method']] = __($tx_ctrl['TreatmentControl']['tx_method'], true);
		}
		asort($result);
		
		return $result;
	}
	
}

?>