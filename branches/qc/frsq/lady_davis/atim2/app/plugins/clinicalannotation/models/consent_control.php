<?php

class ConsentControl extends ClinicalannotationAppModel {

	/**
	 * Get permissible values array gathering all existing consent types.
	 *
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  	
	function getConsentTypePermissibleValuesFromId() {
		$result = array();
		
		// Build tmp array to sort according translation
		foreach($this->find('all', array('conditions' => array('flag_active = 1'))) as $consent_control) {
			$result[$consent_control['ConsentControl']['id']] = __($consent_control['ConsentControl']['controls_type'], true);
		}
		asort($result);
					
		return $result;
	}

}

?>