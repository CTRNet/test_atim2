<?php

class StoragesComponent extends Object {
	
	function initialize(&$controller, $settings=array()) {
		$this->controller =& $controller;
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
			$storage_control_data = $this->controller->StorageControl->find('first', array('conditions' => array('StorageControl.id' => $storage_control_id)));
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
	 
	/**
	 * Using the id of a storage, the function will return formatted storages path 
	 * starting from the root to the studied storage.
	 * 
	 * @param $studied_storage_master_id ID of the studied storage.
	 * 
	 * @return Storage path (string).
	 * 
	 * @author N. Luc
	 * @since 2009-08-12
	 */ 
	 
	function getStoragePath($studied_storage_master_id) {
		$storage_path_data = $this->controller->StorageMaster->getpath($studied_storage_master_id);

		$path_to_display = '';
		$separator = '';
		if(!empty($storage_path_data)){
			foreach($storage_path_data as $new_parent_storage_data) { 
				$path_to_display .= $separator.$new_parent_storage_data['StorageMaster']['code']; 
				$separator = ' >> ';
			}
		}
			
		return $path_to_display;
	}	
}

?>