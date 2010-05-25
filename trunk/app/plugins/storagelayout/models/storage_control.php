<?php

class StorageControl extends StoragelayoutAppModel {
	
	function getStorageTypeList() {
		$result = array();
		$tmp_result = array();
		
		// Build tmp array to sort according to translated value
		foreach($this->find('all', array('conditions' => array('flag_active = 1'))) as $storage_control) {
			$tmp_result[$storage_control["StorageControl"]["storage_type"]] = __($storage_control["StorageControl"]["storage_type"], true);
		}
		asort($tmp_result);
		
		// Build final array
		foreach($tmp_result as $value => $default) { $result[] = array('value' => $value, 'default' => $default); }
		
		return $result;
	}
}

?>
