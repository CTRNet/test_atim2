<?php

class EventControlCustom extends EventControl {
	var $useTable = 'event_controls';
	var $name = 'EventControl';	
	  	
	function getEventTypePermissibleValues() {
		$result = array();
		$tmp_result = array();
			
		// Build tmp array to sort according translation
		foreach($this->find('all', array('conditions' => array('OR' => array('flag_active = 1', 'EventControl.detail_tablename' => 'qc_hb_ed_hepatobilary_medical_imagings')))) as $event_control) {
			$tmp_result[$event_control['EventControl']['event_type']] = __($event_control['EventControl']['event_type'], true);
		}
		asort($tmp_result);
							
		// Build final array
		foreach($tmp_result as $value => $default) { $result[] = array('value' => $value, 'default' => $default); }
		
		return $result;
	}
}

?>