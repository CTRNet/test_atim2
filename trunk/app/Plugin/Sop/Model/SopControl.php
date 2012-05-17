<?php

class SopControl extends SopAppModel
{
	var $useTable = 'sop_controls';
	
	var $master_form_alias = 'sopmasters';
	
	function getTypePermissibleValues() {
		$result = array();
		
		// Build tmp array to sort according to translated value
		foreach($this->find('all', array('conditions' => array('flag_active = 1'))) as $sop_control) {
			$result[$sop_control['SopControl']['type']] = __($sop_control['SopControl']['type']);
		}
		asort($result);

		return $result;
	}

	function getGroupPermissibleValues() {
		$result = array();
		
		// Build tmp array to sort according to translated value
		foreach($this->find('all', array('conditions' => array('flag_active = 1'))) as $sop_control) {
			$result[$sop_control['SopControl']['sop_group']] = __($sop_control['SopControl']['sop_group']);
		}
		asort($result);

		return $result;
	}
	
}

?>