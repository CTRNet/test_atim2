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
	
	/**
	 * Define if the coordinate 'x' list of a storage having a specific type
	 * can be set by the application user.
	 * 
	 * Note: Only storage having storage type including one dimension and a coordinate type 'x'
	 * equals to 'list' can support custom coordinate 'x' list. 
	 * 
	 * @param $storage_control_id Storage Control ID of the studied storage.
	 * @param $storage_control_data Storage Control Data of the studied storage (not required).
	 * 
	 * @return true when the coordinate 'x' list of a storage can be set by the user.
	 * 
	 * @author N. Luc
	 * @since 2008-02-04
	 * @updated A. Suggitt
	 */
	
	function allowCustomCoordinates($storage_control_id, $storage_control_data = null) {	
		// Check for storage control data, if none get the control data
		if(empty($storage_control_data)) {
			$storage_control_data = $this->find('first', array('conditions' => array('StorageControl.id' => $storage_control_id)));
			if(empty($storage_control_data)) { $this->controller->redirect('/pages/err_sto_no_data', null, true); }
		}
					
		if($storage_control_data['StorageControl']['id'] !== $storage_control_id) { $this->controller->redirect('/pages/err_sto_system_error', null, true); }
		
		// Check the control data and set boolean for return.
		if(!((strcmp($storage_control_data['StorageControl']['coord_x_type'], 'list') == 0) 
		&& empty($storage_control_data['StorageControl']['coord_x_size'])
		&& empty($storage_control_data['StorageControl']['coord_y_type'])
		&& empty($storage_control_data['StorageControl']['coord_y_size']))) {
			return false;
		} 

		return true;
	 }	
}

?>
