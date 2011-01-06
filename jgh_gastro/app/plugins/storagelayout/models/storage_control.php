<?php

class StorageControl extends StoragelayoutAppModel {

 	/**
	 * Get permissible values array gathering all existing storage types.
	 *
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  	
	function getStorageTypePermissibleValues() {
		$result = array();
		
		// Build tmp array to sort according to translated value
		foreach($this->find('all', array('conditions' => array('flag_active = 1'))) as $storage_control) {
			$result[$storage_control['StorageControl']['id']] = __($storage_control['StorageControl']['storage_type'], true);
		}
		asort($result);

		return $result;
	}
}

?>
