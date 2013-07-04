<?php

class StorageControl extends StorageLayoutAppModel {
	
	var $master_form_alias = 'storagemasters';

 	/**
	 * Get permissible values array gathering all existing storage types.
	 *
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  	
	function getStorageTypePermissibleValues() {
		$StructurePermissibleValuesCustom = AppModel::getInstance("", "StructurePermissibleValuesCustom", true);
		$translated_storage_types = $StructurePermissibleValuesCustom->getCustomDropdown(array('storage types'));
		$translated_storage_types = array_merge($translated_storage_types['defined'], $translated_storage_types['previously_defined']);
		
		// Build tmp array to sort according to translated value
		$result = array();
		foreach($this->find('all', array('conditions' => array('flag_active = 1'))) as $storage_control) {
			$result[$storage_control['StorageControl']['id']] = isset($translated_storage_types[$storage_control['StorageControl']['storage_type']])? $translated_storage_types[$storage_control['StorageControl']['storage_type']] : $storage_control['StorageControl']['storage_type'];
		}
		natcasesort($result);

		return $result;
	}
	
	function getTranslatedStorageControlsList() {		
		$StructurePermissibleValuesCustom = AppModel::getInstance("", "StructurePermissibleValuesCustom", true);
		$translated_storage_types = $StructurePermissibleValuesCustom->getCustomDropdown(array('storage types'));
		$translated_storage_types = array_merge($translated_storage_types['defined'], $translated_storage_types['previously_defined']);
		$translated_storage_controls_list = $this->find('all', array('conditions' => array('flag_active = 1')));
		foreach($translated_storage_controls_list as &$new_storage_control) {
			$storage_type = $new_storage_control['StorageControl']['storage_type'];
			$new_storage_control['Generated']['storage_type'] = isset($translated_storage_types[$storage_type])? $translated_storage_types[$storage_type] : $storage_type;
		}
		return $translated_storage_controls_list;
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
			$storage_control_data = $this->getOrRedirect($storage_control_id);
		}
					
		if($storage_control_data['StorageControl']['id'] !== $storage_control_id) { $this->controller->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); }
		
		// Check the control data and set boolean for return.
		if(!((strcmp($storage_control_data['StorageControl']['coord_x_type'], 'list') == 0) 
		&& empty($storage_control_data['StorageControl']['coord_x_size'])
		&& empty($storage_control_data['StorageControl']['coord_y_type'])
		&& empty($storage_control_data['StorageControl']['coord_y_size']))) {
			return false;
		} 

		return true;
	 }	
	 
	function getStorageLayoutDescription($storage_control_data) {
		$description = '';

		if(isset($storage_control_data['StorageControl']['coord_x_title'])) {
			// Set horizontal layout desciption
			$description .= __($storage_control_data['StorageControl']['coord_x_title']) . ' (' .
				(isset($storage_control_data['StorageControl']['coord_x_type'])? __('type'). ' ' . __($storage_control_data['StorageControl']['coord_x_type']): '').
				(isset($storage_control_data['StorageControl']['coord_x_size'])? ' / '. __('coordinate size'). ' ' . __($storage_control_data['StorageControl']['coord_x_size']): '').
				')';
				
				
			if(isset($storage_control_data['StorageControl']['coord_y_title'])) {
				// Set vertical layout desciption
				$description .= '<br>';
				$description .= __($storage_control_data['StorageControl']['coord_y_title']) . ' (' .
					(isset($storage_control_data['StorageControl']['coord_y_type'])? __('type'). ' ' . __($storage_control_data['StorageControl']['coord_y_type']): '').
					(isset($storage_control_data['StorageControl']['coord_y_size'])? ' / '. __('coordinate size'). ' ' . __($storage_control_data['StorageControl']['coord_y_size']): '').
					')';
			}
		}
		
		return (empty($description)? 'n/a' : $description);
	}
	
	function afterFind($results, $primary = false) {
		return $this->applyMasterFormAlias($results, $primary);
	}
}
