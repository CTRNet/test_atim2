<?php

class MiscIdentifiersComponent extends Object {
	
	function initialize(&$controller, $settings=array()) {
		$this->controller =& $controller;
	}
	
	function getIdentiferNamesListForDisplay() {
		// Get all identifier controls
		$identifier_controls = $this->controller->MiscIdentifierControl->find('all', array('conditions' => array('status' => 'active')));
		
		$name = array();
		foreach($identifier_controls as $new_data) {
			$name[$new_data['MiscIdentifierControl']['misc_identifier_name']] = __($new_data['MiscIdentifierControl']['misc_identifier_name'], true);
		}
		
		return $name;
	}
}

?>