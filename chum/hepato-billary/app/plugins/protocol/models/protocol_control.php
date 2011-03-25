<?php

class ProtocolControl extends ProtocolAppModel {

   	var $useTable = 'protocol_controls';
 
 	/**
	 * Get permissible values array gathering all existing protocol types.
	 *
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  	
	function getProtocolTypePermissibleValues() {
		$result = array();
		
		// Build tmp array to sort according translation
		foreach($this->find('all', array('conditions' => array('flag_active = 1'))) as $protocol_control) {
			$result[$protocol_control['ProtocolControl']['type']] = __($protocol_control['ProtocolControl']['type'], true);
		}
		asort($result);
		
		return $result;
	}
	
	/**
	 * Get array gathering all existing protocol tumour groups.
	 *
	 * @author N. Luc
	 * @since 2009-09-11
	 * @updated N. Luc
	 */
	function getProtocolTumourGroupPermissibleValues() {
		$result = array();
		
		// Build tmp array to sort according translation
		foreach($this->find('all', array('conditions' => array('flag_active = 1'))) as $protocol_control) {
			$result[$protocol_control['ProtocolControl']['tumour_group']] = __($protocol_control['ProtocolControl']['tumour_group'], true);
		}
		asort($result);
		
		return $result;
	}
}

?>