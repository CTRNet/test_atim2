<?php

class AliquotControl extends InventorymanagementAppModel {

 	/**
	 * Get permissible values array gathering all existing aliquot types.
	 *
	 * @return Array having following structure:
	 * 	array ('value' => 'AliquotControl.id', 'default' => (translated string describing aliquot type))
	 * 
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  	
	function getAliquotTypePermissibleValuesFromId() {
		$result = array();
		$tmp_result = array();
		
		// Build tmp array to sort according translation
		foreach($this->find('all', array('conditions' => array('flag_active = 1'))) as $aliquot_control) {
			$tmp_result[$aliquot_control['AliquotControl']['id']] = __($aliquot_control['AliquotControl']['aliquot_type'], true);
		}
		asort($tmp_result);
		
		// Build final array
		foreach($tmp_result as $value => $default) { $result[] = array('value' => $value, 'default' => $default); }
		
		return $result;
	}
	
	/**
	 * Get permissible values array gathering all existing aliquot types.
	 *
	 * @return Array having following structure:
	 * 	array ('value' => 'AliquotControl.aliquot_type', 'default' => (translated string describing aliquot type))
	 * 
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  	
	function getAliquotTypePermissibleValues() {
		$result = array();
		$tmp_result = array();
		
		// Build tmp array to sort according translation
		foreach($this->find('all', array('conditions' => array('flag_active = 1'))) as $aliquot_control) {
			$tmp_result[$aliquot_control['AliquotControl']['aliquot_type']] = __($aliquot_control['AliquotControl']['aliquot_type'], true);
		}
		asort($tmp_result);
		
		// Build final array
		foreach($tmp_result as $value => $default) { $result[] = array('value' => $value, 'default' => $default); }
		
		return $result;
	}
	
}

?>
