<?php

class StoragesComponent extends Object {
	
	function initialize(&$controller, $settings=array()) {
		$this->controller =& $controller;
	}
	
	/**
	 * This function builds an array of storage records, except those having TMA type. 
	 * 
	 * When a storage master id is passed in arguments, this storage 
	 * plus all its children storages will be removed from the array.
	 * 
	 * @param $excluded_storage_master_id ID of the storage to remove.
	 * 
	 * @return Array of storage records.
	 * 	[storage_master_id] => array('StorageMaster'=>array(), 'StorageControl'=>array(), etc))
	 * 
	 * @author N. Luc
	 * @since 2007-05-22
	 * @updated A. Suggitt on 2009-07-22
	*/
	
	function getStorageList($excluded_storage_master_id = null) {	
		// Find control ID for all storages of type TMA. These will be excluded from the returned array
		$arr_tma_control_ids = $this->controller->StorageControl->find('list', array('conditions' => array('StorageControl.is_tma_block' => 'TRUE')));
			
		// Get all storage records excluding those of type TMA
		$arr_storages_list = $this->controller->StorageMaster->atim_list(array('conditions' => array('NOT' => array('StorageMaster.storage_control_id' => $arr_tma_control_ids)), 'order' => array('StorageMaster.selection_label')));
		
		if(empty($arr_storages_list)) {
			// No Storage exists in the system
			return array();	
		}					
		
		// The defined storage plus all its childrens that should be removed from the array
		$ids_to_remove = array();
		if(!is_null($excluded_storage_master_id)){
			$ids_to_remove = array($excluded_storage_master_id => $excluded_storage_master_id);
		}
		$studied_parent_ids = $ids_to_remove;
		
		while(!empty($studied_parent_ids)){
			$children_ids = $this->controller->StorageMaster->find('list', array('conditions' => array('StorageMaster.parent_id' => $studied_parent_ids)));
			$ids_to_remove += $children_ids;
			$studied_parent_ids = $children_ids;
		}
		
		return array_diff_key($arr_storages_list, $ids_to_remove);
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
			if(empty($storage_control_data)) { $this->controller->redirect('/pages/err_sto_no_stor_cont_data', null, true); }
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
	 * Inactivate the storage coordinate menu.
	 * 
	 * @param $atim_menu ATiM menu.
	 * 
	 * @return Modified ATiM menu.
	 * 
	 * @author N. Luc
	 * @since 2009-08-12
	 */
		 
	 function inactivateStorageCoordinateMenu($atim_menu) {
 		foreach($atim_menu as $menu_group_id => $menu_group) {
			foreach($menu_group as $menu_id => $menu_data) {
				if(strpos($menu_data['Menu']['use_link'], '/storagelayout/storage_coordinates/listAll/') !== false) {
					$atim_menu[$menu_group_id][$menu_id]['Menu']['allowed'] = 0;
					return $atim_menu;
				}
			}
 		}	
 		
 		return $atim_menu;
	 }	
	 
	/**
	 * Inactivate the storage layout menu.
	 * 
	 * @param $atim_menu ATiM menu.
	 * 
	 * @return Modified ATiM menu.
	 * 
	 * @author N. Luc
	 * @since 2009-08-12
	 */
		 
	 function inactivateStorageLayoutMenu($atim_menu) {
 		foreach($atim_menu as $menu_group_id => $menu_group) {
			foreach($menu_group as $menu_id => $menu_data) {
				if(strpos($menu_data['Menu']['use_link'], '/storagelayout/storage_masters/seeStorageLayout/') !== false) {
					$atim_menu[$menu_group_id][$menu_id]['Menu']['allowed'] = 0;
					return $atim_menu;
				}
			}
 		}	
 		
 		return $atim_menu;
	 }
	 
	/**
	 * Inactivate the children storage menu.
	 * 
	 * @param $atim_menu ATiM menu.
	 * 
	 * @return Modified ATiM menu.
	 * 
	 * @author N. Luc
	 * @since 2009-08-12
	 */
		 
	 function inactivateChildrenStorageMenu($atim_menu) {
 		foreach($atim_menu as $menu_group_id => $menu_group) {
			foreach($menu_group as $menu_id => $menu_data) {
				if(strpos($menu_data['Menu']['use_link'], '/storagelayout/storage_masters/listChildrenStorages/') !== false) {
					$atim_menu[$menu_group_id][$menu_id]['Menu']['allowed'] = 0;
					return $atim_menu;
				}
			}
 		}	
 		
 		return $atim_menu;
	 }
	 
	/**
	 * Using the id of a storage, the function will return data of each of the parent storages 
	 * in turn plus the studied storage (starting from the root to the studied storage).
	 * 
	 * @param $studied_storage_master_id ID of the studied storage.
	 * 
	 * @return An array that contains master data of a storage plus all its parents storage odered from
	 * root to studied storage.
	 * 
	 * @author N. Luc
	 * @since 2009-08-12
	 */ 
	 
	function getStoragePathData($studied_storage_master_id) {
		return $this->controller->StorageMaster->getpath($studied_storage_master_id);
	}	
	
	/**
	 * Check both a storage selection label matches a storage master id and the defined storage is not a TMA. 
	 * 
	 * This function should be used to validate data entry when user is trying to set position of 
	 * either an aliquot or a children storage within a storage selecting a storage from a list
	 * and/or enterring a selection label.
	 * 
	 * @param $recorded_selection_label Recorded selection label.
	 * @param $selected_storage_master_id Selected storage master id.
	 * 
	 * @return Array containing results
	 * 	['selected_storage_master_id'] => Supposed master id of the searched storage
	 * 	['matching_storage_list'] => Data of storages matching selection label and/or storage master id (a same label could be defined for many storages)
	 * 	['storage_definition_error'] => storage defintion error (empty when no error)
	 */
	
	function validateStorageIdVersusSelectionLabel($recorded_selection_label, $selected_storage_master_id) {
		$matching_storage_list = array();
		$storage_definition_error = '';
		$check_tma = false;

		if(!empty($recorded_selection_label)) {
			// CASE_1: A storage selection label has been defined
			
			// Look for storage matching the storage selection label 
			$matching_storage_list = $this->controller->StorageMaster->atim_list(array('conditions' => array('StorageMaster.selection_label' => $recorded_selection_label)));			
			$matching_storage_list = empty($matching_storage_list)? array(): $matching_storage_list;			

			if(empty($selected_storage_master_id)) {	
				// CASE_1.a: No storage id has been defined: Define storage id using selection label
				
				if(empty($matching_storage_list)) {
					// No storage matches	
					$matching_storage_list = array();
					$storage_definition_error = 'no storage matches (at least one of) the selection label(s)';
				} else if(sizeof($matching_storage_list) > 1) {
					// More than one storage matche this storage selection label
					$storage_definition_error = 'more than one storages matche (at least one of) the selection label(s)';
				} else {
					// The selection label match only one storage: Get the storage_master_id
					$selected_storage_master_id = key($matching_storage_list);
					$check_tma = true;
				}
			
			} else {
				// CASE_1.b: A storage master id has been defined
				
				// Check the storage master id matches one of the storages matching the defined selection label
				if(!array_key_exists($selected_storage_master_id, $matching_storage_list)) {
					// Selected id not found: Set error
					$storage_definition_error = '(at least one of) the selected id does not match a selection label';						
					
					// Add the storage to the matching storage list
					$matching_storage_list[$selected_storage_master_id] = $this->controller->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $selected_storage_master_id)));			
				}
				
				$check_tma = true;
			}
		
		} else if(!empty($selected_storage_master_id)) {
			// CASE_2: Only storage_master_id has been defined (and should be right because selected from s system list)
						
			// Only storage id has been selected: Add this one in $arr_storage_list if an error is displayed
			$matching_storage_list[$selected_storage_master_id] = $this->controller->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $selected_storage_master_id)));			 

			$check_tma = true;
				
		} 	// else if { $selected_storage_master_id and $recorded_selection_label empty: Nothing to do }
		
		// Check defined storage is not a TMA
		if($check_tma && (strcmp($matching_storage_list[$selected_storage_master_id]['StorageControl']['is_tma_block'], 'TRUE') == 0)) {
			$storage_definition_error = 'the defined storage is a tma';
		}
		
		return array(
			'selected_storage_master_id' => $selected_storage_master_id,
			'matching_storage_list' => $matching_storage_list,
			'storage_definition_error' => $storage_definition_error);
	}
	
	/**
	 * Validate values set to define position (coordinate 'x', coordinate 'y') of either a children storage 
	 * or an aliquot within a storage. Return validated or corrected value (value changed to correct case when required)
	 * plus its display order.
	 * 
	 * @param $storage_master_id Master ID of the storage that will contain the studied entity.
	 * @param $position_x Position 'x' of the enity within the storage.
	 * @param $position_y Position 'y' of the enity within the storage.
	 * @param $storage_data Storage data including storage master, storage control, etc. (not required)
	 * 
	 * @return Array containing results
	 * 	['validated_position_x'] => Validated/Corrected storage coordinate X
	 * 		(changed to correct case if required, or including error sign '_err!')
	 * 	['position_x_order'] => Position order of the validated position (used for display)
	 * 	['error_on_x'] => True when error is on coordinate x
	 * 	['validated_position_y'] => Validated/Corrected storage coordinate Y
	 * 		(changed to correct case if required, or including error sign '_err!')
	 * 	['position_y_order'] => Position order of the validated position (used for display)
	 * 	['error_on_y'] => True when error is on coordinate y
	 * 	['position_definition_error'] => Message defining the position error (empty when no error)
	 */	
	
	function validatePositionWithinStorage($storage_master_id, $position_x, $position_y, $storage_data = null) {
		$validated_position_x = $position_x;
		$position_x_order = null;
		$error_on_x = false;
		
		$validated_position_y = $position_y;
		$position_y_order = null;
		$error_on_y = false;
		
		$position_definition_error = '';
		
		$error_sign = ' #err!#';
		
		if(empty($storage_master_id)){
			// No storage selected: no position should be set
			if(!empty($position_x)){
				$validated_position_x .= $error_sign;
				$error_on_x = true;
				$position_definition_error = 'no postion has to be recorded when no storage is selected';
			}
			if(!empty($position_y)){
				$validated_position_y .= $error_sign;
				$error_on_y = true;
				$position_definition_error = 'no postion has to be recorded when no storage is selected';
			}
			
		} else {
			// Check for storage data, if none get the storage data
			if(empty($storage_data)) {
				$storage_data = $this->controller->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $storage_master_id)));
				if(empty($storage_data)) { $this->controller->redirect('/pages/err_sto_no_stor_data', null, true); }
			}			
			
			// Check position values
			$position_x_validation = $this->validatePositionValue($storage_data, $position_x, 'x');
			$position_y_validation = $this->validatePositionValue($storage_data, $position_y, 'y');
				
			// Manage position x
			if(!$position_x_validation['validated']) {
				$validated_position_x .= $error_sign;
				$error_on_x = true;
				$position_definition_error = 'at least one position value does not match format';
			} else {
				$validated_position_x = $position_x_validation['validated_position'];
				$position_x_order = $position_x_validation['position_order'];
			}
			
			// Manage position y
			if(!$position_y_validation['validated']) {
				$validated_position_y .= $error_sign;
				$error_on_y = true;
				$position_definition_error = 'at least one position value does not match format';
			} else {
				$validated_position_y = $position_y_validation['validated_position'];
				$position_y_order = $position_y_validation['position_order'];
			}
		}
		
		return array(
			'validated_position_x' => str_replace($error_sign.$error_sign, $error_sign, $validated_position_x),
			'error_on_x' => $error_on_x,
			'position_x_order' => $position_x_order,
			
			'validated_position_y' => str_replace($error_sign.$error_sign, $error_sign, $validated_position_y),
			'error_on_y' => $error_on_y,
			'position_y_order' => $position_y_order,
			
			'position_definition_error' => $position_definition_error);
	}	
	
	/**
	 * Validate a value set to define position of an entity into a storage coordinate ('x' or 'y').
	 * 
	 * @param $storage_data Storage data including storage master, storage control, etc.
	 * @param $position Position value.
	 * @param $coord Studied storage coordinate ('x' or 'y').
	 * 
	 * @return Array containing results
	 * 	['validated'] => TRUE if validated
	 * 	['validated_position'] => Validated position (value changed to correct case when required)
	 * 	['position_order'] => Position order to display
	 * 
	 * @author N. Luc
	 * @since 2009-08-16
	 */
	
	function validatePositionValue($storage_data, $position, $coord) {
		$validation_results = array(
			'validated' => true,
			'validated_position' => $position,
			'position_order' => null);
		
		// Launch validation
		if(empty($position)) {
			return $validation_results;
		}
		
		// Get allowed position for this storage coordinate
		$arr_allowed_position = $this->buildAllowedStoragePosition($storage_data, $coord);
		
		// Check position
		if(array_key_exists($position, $arr_allowed_position['array_to_display'])) {
			$validation_results['position_order'] = $arr_allowed_position['array_to_order'][$position];
			return $validation_results;
		} else {
			$upper_case_position = strtoupper($position);
			if(array_key_exists($upper_case_position, $arr_allowed_position['array_to_display'])) {
				$validation_results['validated_position'] = $upper_case_position;
				$validation_results['position_order'] = $arr_allowed_position['array_to_order'][$upper_case_position];
				return $validation_results;
			}
		}
		
		// Position value has not been validated
		$validation_results['validated'] = 0;
				
		return $validation_results;
	}	
	
	/**
	 * Build list of values that could be selected to define position coordinate (X or Y) of a children
	 * storage within a studied storage. 
	 * 
	 * List creation is based on the coordinate information set into the control data of the storage.
	 * 
	 * When:
	 *   - TYPE = 'alphabetical' and SIZE is not null
	 *       System will build a list of alphabetical values ('A', 'B', 'C', etc) 
	 *       having a number of items defined by the coordinate SIZE.   
	 *  
	 *   - TYPE = 'integer' and SIZE is not null
	 *       System will build list of integer values ('1' + '2' + '3' + etc) 
	 *       having a number of items defined by the coordinate SIZE.   
	 *  
	 *   - TYPE = 'liste' and SIZE is null
	 *       System will search cutom coordinate values set by the user.
	 *       (This list is uniquely supported for coordinate 'X').
	 * 
	 * @param $storage_data Storage data including storage master, storage control, etc.
	 * @param $coord Coordinate flag that should be studied ('x', 'y').
	 *
	 * @return Array gathering 2 sub arrays:
	 * 	[array_to_display] = array($allowed_coordinate => $allowed_coordinate) 
	 * 		// key = value = 'allowed coordinate'
	 * 		// array_to_display should be used to get list of allowed coordinates and set drop down list for position selection
	 * 	[array_to_order] = array($coordinate_order => $allowed_coordinate) 
	 * 		// key = 'coordinate order', value = 'allowed coordinate') 
	 * 		// array_to_order should be used to build an ordered display
	 * 
	 * @author N. Luc
	 * @since 2007-05-22
	 * @updated A. Suggitt
	 */
	 
	function buildAllowedStoragePosition($storage_data, $coord) {
		if(!array_key_exists('coord_' . $coord . '_type', $storage_data['StorageControl'])) { $this->controller->redirect('/pages/err_sto_system_error', null, true); }
				
		// Build array
		$array_to_display = array();
		$array_to_order = array();
			
		if(!empty($storage_data['StorageControl']['coord_' . $coord . '_type'])) {
			if(!empty($storage_data['StorageControl']['coord_' . $coord . '_size'])) {
				// TYPE and SIZE are both defined for the studied coordinate: The system can build a list.
				$size = $storage_data['StorageControl']['coord_' . $coord . '_size'];
				if(!is_numeric($size)) { $this->controller->redirect('/pages/err_sto_system_error', null, true); }
									
				if(strcmp($storage_data['StorageControl']['coord_' . $coord . '_type'], 'alphabetical') == 0){
					// Alphabetical drop down list
					$array_to_order = array_slice(range('A', 'Z'), 0, $size);		
				} else if(strcmp($storage_data['StorageControl']['coord_' . $coord . '_type'], 'integer') == 0){
					// Integer drop down list	
					$array_to_order = range('1', $size);
				} else {
					$this->controller->redirect('/pages/err_sto_system_error', null, true); 		
				}	
						
			} else {
				// Only TYPE is defined for the studied coordinate: The system can only return a custom coordinate list set by user.			
				if((strcmp($storage_data['StorageControl']['coord_' . $coord . '_type'], 'list') == 0) && (strcmp($coord, 'x') == 0)) {
					$coordinates = $this->controller->StorageCoordinate->atim_list(array('conditions' => array('StorageCoordinate.storage_master_id' => $storage_data['StorageMaster']['id'], 'StorageCoordinate.dimension' => $coord), 'order' => 'StorageCoordinate.order ASC', 'recursive' => '-1'));
					if(!empty($coordinates)) {
						foreach($coordinates as $new_coordinate) {
							$coordinate_value = $new_coordinate['StorageCoordinate']['coordinate_value'];
							$coordinate_order = $new_coordinate['StorageCoordinate']['order'];
							$array_to_order[$coordinate_order] = $coordinate_value;						
						}		
					}
				} else {
					$this->controller->redirect('/pages/err_sto_system_error', null, true); 				
				}
			}
		}
		if(!empty($array_to_order)) { $array_to_display = array_combine($array_to_order, $array_to_order); }
		return array('array_to_display' => $array_to_display, 'array_to_order' => array_flip($array_to_order));
	}	
	 
}

?>