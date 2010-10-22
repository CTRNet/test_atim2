<?php

class TreatmentControl extends ClinicalannotationAppModel {
	var $useTable = 'tx_controls';
	
	/**
	 * Get permissible values array gathering all existing treatment disease sites.
	 *
	 * @return Array having following structure:
	 * 	array ('value' => 'TreatmentControl.disease_site', 'default' => (translated string describing treatment disease site))
	 * 
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  	
	function getDiseaseSitePermissibleValues() {
		$result = array();
		$tmp_result = array();
		
		// Build tmp array to sort according translation
		foreach($this->find('all', array('conditions' => array('flag_active = 1'))) as $tx_ctrl) {
			$tmp_result[$tx_ctrl['TreatmentControl']['disease_site']] = __($tx_ctrl['TreatmentControl']['disease_site'], true);
		}
		asort($tmp_result);
					
		// Build final array
		foreach($tmp_result as $value => $default) { $result[] = array('value' => $value, 'default' => $default); }
		
		return $result;
	}
	
	/**
	 * Get permissible values array gathering all existing treatment method.
	 *
	 * @return Array having following structure:
	 * 	array ('value' => 'TreatmentControl.tx_method ', 'default' => (translated string describing treatment method))
	 * 
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  	
	function getMethodPermissibleValues() {
		$result = array();
		$tmp_result = array();
				
		// Build tmp array to sort according translation
		foreach($this->find('all', array('conditions' => array('flag_active = 1'))) as $tx_ctrl) {
			$tmp_result[$tx_ctrl['TreatmentControl']['tx_method']] = __($tx_ctrl['TreatmentControl']['tx_method'], true);
		}
		asort($tmp_result);
					
		// Build final array
		foreach($tmp_result as $value => $default) { $result[] = array('value' => $value, 'default' => $default); }
		
		return $result;
	}
	
}

?>