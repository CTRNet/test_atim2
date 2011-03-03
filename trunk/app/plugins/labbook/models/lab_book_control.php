<?php

class LabBookControl extends LabBookAppModel {

	function getLabBookTypePermissibleValuesFromId() {
		$result = array();
		
		$conditions = array('LabBookControl.flag_active' => 1);
		$controls = $this->find('all', array('conditions' => $conditions));
		foreach($controls as $control) {
			$result[$control['LabBookControl']['id']] = __($control['LabBookControl']['group'], true) . ' - ' . __($control['LabBookControl']['book_type'], true);
		}
		asort($result);
		
		return $result;
	}
 
}

?>
