<?php

class ProtocolControl extends ProtocolAppModel {

   	var $useTable = 'protocol_controls';
	
	function getProtocolTypeList() {
		$result = array();
		$tmp_result = array();
		
		// Build tmp array to sort according translation
		foreach($this->find('all') as $protocol_control) {
			$tmp_result[$protocol_control["ProtocolControl"]["type"]] = __($protocol_control["ProtocolControl"]["type"], true);
		}
		asort($tmp_result);
		
		// Build final array
		foreach($tmp_result as $value => $default) { $result[] = array('value' => $value, 'default' => $default); }
		
		return $result;
	}
	
	function getProtocolTumourGroupList() {
		$result = array();
		$tmp_result = array();
		
		// Build tmp array to sort according translation
		foreach($this->find('all') as $protocol_control) {
			$tmp_result[$protocol_control["ProtocolControl"]["tumour_group"]] = __($protocol_control["ProtocolControl"]["tumour_group"], true);
		}
		asort($tmp_result);
		
		// Build final array
		foreach($tmp_result as $value => $default) { $result[] = array('value' => $value, 'default' => $default); }
		
		return $result;
	}
}

?>