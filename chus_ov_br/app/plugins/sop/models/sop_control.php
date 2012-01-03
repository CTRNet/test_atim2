<?php

class SopControl extends SopAppModel
{
	var $useTable = 'sop_controls';
	
	function getTypePermissibleValues() {
		$result = array();
		
		// Build tmp array to sort according to translated value
		foreach($this->find('all', array('conditions' => array('flag_active = 1'))) as $sop_control) {
			$result[$sop_control['SopControl']['type']] = __($sop_control['SopControl']['type'], true);
		}
		asort($result);

		return $result;
	}

	function getGroupPermissibleValues() {
		$result = array();
		
		// Build tmp array to sort according to translated value
		foreach($this->find('all', array('conditions' => array('flag_active = 1'))) as $sop_control) {
			$result[$sop_control['SopControl']['sop_group']] = __($sop_control['SopControl']['sop_group'], true);
		}
		asort($result);

		return $result;
	}
	
}

?>