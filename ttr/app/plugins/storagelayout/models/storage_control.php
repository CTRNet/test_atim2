<?php

class StorageControl extends StoragelayoutAppModel {

 	/**
	 * Get permissible values array gathering all existing storage types.
	 *
	 * @return Array having following structure:
	 * 	array ('value' => 'StorageControl.storage_type', 'default' => (translated string describing storage type))
	 * 
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  	
	function getStorageTypePermissibleValues() {
		$result = array();
		$tmp_result = array();
		
		// Build tmp array to sort according to translated value
		foreach($this->find('all', array('conditions' => array('flag_active = 1'))) as $storage_control) {
			$tmp_result[$storage_control['StorageControl']['storage_type']] = __($storage_control['StorageControl']['storage_type'], true);
		}
		asort($tmp_result);
		
		// Build final array
		foreach($tmp_result as $value => $default) { $result[] = array('value' => $value, 'default' => $default); }
		
		return $result;
	}
}

?>
