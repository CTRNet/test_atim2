<?php

class ProtocolControl extends ProtocolAppModel {

   	var $useTable = 'protocol_controls';
 
 	/**
	 * Get permissible values array gathering all existing protocol types.
	 *
	 * @return Array having following structure:
	 * 	array ('value' => 'ProtocolControl.type', 'default' => (translated string describing protocol type))
	 * 
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  	
	function getProtocolTypePermissibleValues() {
		$result = array();
		$tmp_result = array();
		
		// Build tmp array to sort according translation
		foreach($this->find('all', array('conditions' => array('flag_active = 1'))) as $protocol_control) {
			$tmp_result[$protocol_control['ProtocolControl']['type']] = __($protocol_control['ProtocolControl']['type'], true);
		}
		asort($tmp_result);
		
		// Build final array
		foreach($tmp_result as $value => $default) { $result[] = array('value' => $value, 'default' => $default); }
		
		return $result;
	}
	
	/**
	 * Get array gathering all existing protocol tumour groups.
	 *
	 * @return Array having following structure:
	 * 	array ('value' => 'ProtocolControl.tumour_group', 'default' => (translated string describing tumour group))
	 * 
	 * @author N. Luc
	 * @since 2009-09-11
	 * @updated N. Luc
	 */
	function getProtocolTumourGroupPermissibleValues() {
		$result = array();
		$tmp_result = array();
		
		// Build tmp array to sort according translation
		foreach($this->find('all', array('conditions' => array('flag_active = 1'))) as $protocol_control) {
			$tmp_result[$protocol_control['ProtocolControl']['tumour_group']] = __($protocol_control['ProtocolControl']['tumour_group'], true);
		}
		asort($tmp_result);
		
		// Build final array
		foreach($tmp_result as $value => $default) { $result[] = array('value' => $value, 'default' => $default); }
		
		return $result;
	}
}

?>