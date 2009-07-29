<?php

class StoragesComponent extends Object {
	
	function initialize( &$controller, $settings=array() ) {
		$this->controller =& $controller;
	}
	
	/**
	 * Verify the storage is a storage that supports storage coordinate values list 
	 * defined by user.
	 * 
	 * For this version, only storage having one dimension and a coordinate type 'x'
	 * equals to 'list' can support custom values list. 
	 * 
	 * @param $storage_control_id ID of the storage control.
	 * @param $storage_control_data Control Data of the studied storage (not required).
	 * 
	 * @return TRUE when storage properties have been validated/FALSE when storage 
	 * properties have not been validated
	 * 
	 * @author N. Luc
	 * @since 2008-02-04
	 * @updated A. Suggitt
	 * 
	 */
	
	function allowCustomCoordinates($storage_control_id, $storage_control_data = null) {	

		// Check for storage control data, if none get the control data
		if(empty($storage_control_data)) {
			$storage_control_data = $this->controller->StorageControl->find('first', array('conditions'=>array('StorageControl.id'=>$storage_control_id)));
			if(empty($storage_control_data)) {
				$this->redirect('/pages/err_sto_no_stor_cont_data'); 
				exit;
			}			
		}
		
		// Check the control data and set boolean for return.
		$allow_custom_coordinates = TRUE;
		if(!((strcmp($storage_control_data['StorageControl']['coord_x_type'], 'list') == 0) 
		&& empty($storage_control_data['StorageControl']['coord_x_size'])
		&& empty($storage_control_data['StorageControl']['coord_y_type'])
		&& empty($storage_control_data['StorageControl']['coord_y_size']))) {
			$allow_custom_coordinates = FALSE;
		} 

		return $allow_custom_coordinates;
	 }	
}

?>