<?php

class ConsentControl extends ClinicalannotationAppModel {

	/**
	 * Get permissible values array gathering all existing consent types.
	 *
	 * @return Array having following structure:
	 * 	array ('value' => 'ConsentControl.id', 'default' => (translated string describing consent type))
	 * 
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  	
	function getConsentTypePermissibleValuesFromId() {
		$result = array();
		$tmp_result = array();
		
		// Build tmp array to sort according translation
		foreach($this->find('all', array('conditions' => array('flag_active = 1'))) as $consent_control) {
			$tmp_result[$consent_control['ConsentControl']['id']] = __($consent_control['ConsentControl']['controls_type'], true);
		}
		asort($tmp_result);
					
		// Build final array
		foreach($tmp_result as $value => $default) { $result[] = array('value' => $value, 'default' => $default); }
		
		return $result;
	}

}

?>