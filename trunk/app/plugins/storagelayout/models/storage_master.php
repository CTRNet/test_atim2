<?php

class StorageMaster extends StoragelayoutAppModel {
	
	var $belongsTo = array(       
		'StorageControl' => array(           
			'className'    => 'Storagelayout.StorageControl',            
			'foreignKey'    => 'storage_control_id'        
		)    
	);
	
	var $actsAs = array('Tree');
	
	function summary($variables = array()) {
		$return = false;
		
		if (isset($variables['StorageMaster.id'])) {
			$result = $this->find('first', array('conditions' => array('StorageMaster.id' => $variables['StorageMaster.id'])));
			
			$return = array(
				'menu' => array(null, (__($result['StorageMaster']['storage_type'], true) . ' : ' . $result['StorageMaster']['short_label'])),
				'title' => array(null, (__($result['StorageMaster']['storage_type'], true) . ' : ' . $result['StorageMaster']['short_label'])),
				'data'				=> $result,
				'structure alias'	=> 'storagemasters'
			);
		}
		
		return $return;
	}
	
	/**
	 * Get permissible values array gathering storages, except those having TMA type. 
	 * 
	 * When a storage master id is passed in arguments, this storage 
	 * plus all its children storages will be removed from the array.
	 * 
	 * @param $excluded_storage_master_id ID of the storage to remove.
	 * 
	 * @return Storage list into array having following structure: 
	 * 	array($storage_master_id => $storage_title_built_by_function)
	 * 
	 * @author N. Luc
	 * @since 2007-05-22
	 * @updated A. Suggitt on 2009-07-22
	*/
	
	function getParentStoragePermissibleValues($excluded_storage_master_id = null) {	
		
		// Get all storage records according to following exclusion criteria
		$criteria = array();
		
		//1-Find control ID for all storages of type TMA: TMA will be removed from the returned array
		$storage_ctrl = AppModel::atimNew("Storagelayout", "StorageControl", true);
		$arr_tma_control_ids = $storage_ctrl->find('list', array('conditions' => array('StorageControl.is_tma_block' => 'TRUE')));
			
		$criteria['NOT'] = 	array('StorageMaster.storage_control_id' => $arr_tma_control_ids);
		
		//2-The storage defined as 'exclued' plus all its childrens will be removed from the array 
		if(!is_null($excluded_storage_master_id)){
			$excluded_storage = $this->find('first', array('conditions' => array('StorageMaster.id' => $excluded_storage_master_id), 'recursive' => '-1'));
			$criteria[] =  "StorageMaster.lft NOT BETWEEN ".$excluded_storage['StorageMaster']['lft']." AND ".$excluded_storage['StorageMaster']['rght'];
			$criteria[] =  "StorageMaster.rght NOT BETWEEN ".$excluded_storage['StorageMaster']['lft']." AND ".$excluded_storage['StorageMaster']['rght'];
		}
		
		$arr_storages_list = $this->atim_list(array('conditions' => $criteria, 'order' => array('StorageMaster.selection_label'), 'recursive' => '-1'));			
		if(empty($arr_storages_list)) {
			// No Storage exists in the system
			return array(array('value' => '0', 'default' => __('n/a', true)));	
		}					
		
		$formatted_data[0] = __('n/a', true);
		if(!empty($arr_storages_list)) {
			foreach ($arr_storages_list as $storage_id => $storage_data) {
				$formatted_data[$storage_id] = $this->getStorageLabelAndCodeForDisplay($storage_data);
			}
		}
		
		return $formatted_data;
	}
	
	static function getStoragesDropdown(){
		return array();
	}
	
	function validateAndGetStorageData($recorded_selection_label, $position_x, $position_y, $is_sample_core = false) {
		$storage_data = array();
		$storage_definition_error = null;
		
		$position_x_error = null;
		$change_position_x_to_uppercase = false;
		
		$position_y_error = null;
		$change_position_y_to_uppercase = false;
		
		if(!empty($recorded_selection_label)) {
			$storage_data = $this->getStorageDataFromStorageLabelAndCode($recorded_selection_label);
			
			if(isset($storage_data['StorageMaster']) && isset($storage_data['StorageControl'])) {
				// One storage has been found
				
				if((!$is_sample_core) && (strcmp($storage_data['StorageControl']['is_tma_block'], 'TRUE') == 0)) {
					// 1- Check defined storage is not a TMA Block when studied element is a sample core
					$storage_definition_error = 'only sample core can be stored into tma block';
					
				} else {
					// 2- Check position
					
					$position_x_validation = $this->validatePositionValue($storage_data, $position_x, 'x');
					$position_y_validation = $this->validatePositionValue($storage_data, $position_y, 'y');
						
					// Manage position x
					if(!$position_x_validation['validated']) {
						$position_x_error = 'an x coordinate does not match format';
					}else if($position_y_validation['validated'] && $storage_data['StorageControl']['coord_x_size'] > 0 && strlen($position_x) == 0 && strlen($position_y) > 0){
						$position_x_error = 'an x coordinate needs to be defined';
					}else if($position_x_validation['change_position_to_uppercase']) {
						$change_position_x_to_uppercase = true;
					}
					
					// Manage position y
					if(!$position_y_validation['validated']) {
						$position_y_error = 'an y coordinate does not match format';
					}else if($position_x_validation['validated'] && $storage_data['StorageControl']['coord_y_size'] > 0 && strlen($position_y) == 0 && strlen($position_x) > 0){
						$position_y_error = 'a y coordinate needs to be defined';
					}else if($position_y_validation['change_position_to_uppercase']) {
						$change_position_y_to_uppercase = true;
					}
				}
				
			} else {
				// An error has been detected
				$storage_definition_error = $storage_data['error'];
				$storage_data = array();		
			}
		
		} else {
			// No storage selected: no position should be set
			if(!empty($position_x)){
				$position_x_error = 'no x coordinate has to be recorded when no storage is selected';
			}
			if(!empty($position_y)){
				$position_y_error = 'no y coordinate has to be recorded when no storage is selected';
			}			
		}
		
		return array(
			'storage_data' => $storage_data,
			
			'storage_definition_error' => $storage_definition_error,
			'position_x_error' => $position_x_error,
			'position_y_error' => $position_y_error,
			
			'change_position_x_to_uppercase' => $change_position_x_to_uppercase,
			'change_position_y_to_uppercase' => $change_position_y_to_uppercase);
				
	}
	
	function validateStorageIdVersusSelectionLabel() {
		pr('deprecated');
		$this->redirect('/pages/err_sto_system_error', null, true);
	}
	
	function validatePositionWithinStorage($storage_master_id, $position_x, $position_y, $storage_data = null) {
		pr('deprecated');
		$this->redirect('/pages/err_sto_system_error', null, true);
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
	 * 	['change_position_to_uppercase'] => TRUE if position value should be changed to uppercase to be validated
	 * 
	 * @author N. Luc
	 * @since 2009-08-16
	 */
	
	function validatePositionValue($storage_data, $position, $coord) {
		$validation_results = array(
			'validated' => true,
			'change_position_to_uppercase' => false);
		
		// Launch validation
		if(empty($position)) {
			return $validation_results;
		}
		
		// Get allowed position for this storage coordinate
		$arr_allowed_position = $this->buildAllowedStoragePosition($storage_data, $coord);
		
		// Check position
		if(array_key_exists($position, $arr_allowed_position['array_to_display'])) {
			return $validation_results;
		} else {
			$upper_case_position = strtoupper($position);
			if(array_key_exists($upper_case_position, $arr_allowed_position['array_to_display'])) {
				$validation_results['change_position_to_uppercase'] = true;
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
		if(!array_key_exists('coord_' . $coord . '_type', $storage_data['StorageControl'])) {
			AppController::getInstance()->redirect('/pages/err_sto_system_error', null, true); 
		}
				
		// Build array
		$array_to_display = array();
		$array_to_order = array();
			
		if(!empty($storage_data['StorageControl']['coord_' . $coord . '_type'])) {
			if(!empty($storage_data['StorageControl']['coord_' . $coord . '_size'])) {
				// TYPE and SIZE are both defined for the studied coordinate: The system can build a list.
				$size = $storage_data['StorageControl']['coord_' . $coord . '_size'];
				if(!is_numeric($size)) {
					AppController::getInstance()->redirect('/pages/err_sto_system_error', null, true); 
				}
									
				if(strcmp($storage_data['StorageControl']['coord_' . $coord . '_type'], 'alphabetical') == 0){
					// Alphabetical drop down list
					$array_to_order = array_slice(range('A', 'Z'), 0, $size);		
				} else if(strcmp($storage_data['StorageControl']['coord_' . $coord . '_type'], 'integer') == 0){
					// Integer drop down list	
					$array_to_order = range('1', $size);
				} else {
					AppController::getInstance()->redirect('/pages/err_sto_system_error', null, true); 		
				}		
			} else {
				// Only TYPE is defined for the studied coordinate: The system can only return a custom coordinate list set by user.			
				if((strcmp($storage_data['StorageControl']['coord_' . $coord . '_type'], 'list') == 0) && (strcmp($coord, 'x') == 0)) {
					$coordinates = $this->atim_list(array('conditions' => array('StorageCoordinate.storage_master_id' => $storage_data['StorageMaster']['id'], 'StorageCoordinate.dimension' => $coord), 'order' => 'StorageCoordinate.order ASC', 'recursive' => '-1'));
					if(!empty($coordinates)) {
						foreach($coordinates as $new_coordinate) {
							$coordinate_value = $new_coordinate['StorageCoordinate']['coordinate_value'];
							$coordinate_order = $new_coordinate['StorageCoordinate']['order'];
							$array_to_order[$coordinate_order] = $coordinate_value;						
						}		
					}
				} else {
					AppController::getInstance()->redirect('/pages/err_sto_system_error', null, true); 				
				}
			}
		}
		if(!empty($array_to_order)) {
			$array_to_display = array_combine($array_to_order, $array_to_order); 
		}
		return array('array_to_display' => $array_to_display, 'array_to_order' => array_flip($array_to_order));
	}

	/**
	 * @desc Finds the storage id 
	 * @param String $storage_label_and_code a single string with the format "label [code]"
	 * @return storage data (array('StorageMaster' => array(), 'StorageControl' => array()) when found, array('error' => message) otherwise
	 */
	
	function getStorageDataFromStorageLabelAndCode($storage_label_and_code){
		
		//-- NOTE ----------------------------------------------------------------
		//
		// This function is linked to a function of the StorageMaster controller 
		// called autocompleteLabel() 
		// and to functions of the StorageMaster model
		// getStorageLabelAndCodeForDisplay().
		//
		// When you override the getStorageDataFromStorageLabelAndCode() function, 
		// check if you need to override these functions.
		//  
		//------------------------------------------------------------------------
		
		$matches = array();
		$selected_storages = array();
		if(preg_match_all("/([^\b]+)\[([^\[]+)\]/", $storage_label_and_code, $matches, PREG_SET_ORDER) > 0){
			// Auto complete tool has been used
			$selected_storages = $this->find('all', array('conditions' => array('selection_label' => $matches[0][1], 'code' => $matches[0][2])));
		} else {
			// consider $storage_label_and_code contains just seleciton label
			$selected_storages = $this->find('all', array('conditions' => array('selection_label' => $storage_label_and_code)));
		}
		
		if(sizeof($selected_storages) == 1) {
			return array('StorageMaster' => $selected_storages[0]['StorageMaster'], 'StorageControl' => $selected_storages[0]['StorageControl']);
		} else if(sizeof($selected_storages) > 1) {
			return array('error' => str_replace('%s', $storage_label_and_code, __('more than one storages matche the selection label [%s]', true)));
		}
		
		return  array('error' => str_replace('%s', $storage_label_and_code, __('no storage matches the selection label [%s]', true)));
	}
	
	function getStorageLabelAndCodeForDisplay($storage_data) {
		
		//-- NOTE ----------------------------------------------------------------
		//
		// This function is linked to a function of the StorageMaster controller 
		// called autocompleteLabel() 
		// and to functions of the StorageMaster model
		// getStorageDataFromStorageLabelAndCode().
		//
		// When you override the getStorageDataFromStorageLabelAndCode() function, 
		// check if you need to override these functions.
		//  
		//------------------------------------------------------------------------
		
		$formatted_data = '';
		
		if((!empty($storage_data)) && isset($storage_data['StorageMaster'])) {
			$formatted_data = $storage_data['StorageMaster']['selection_label'] . ' [' . $storage_data['StorageMaster']['code'] . ']';
		}
	
		return $formatted_data;
	}
	
}

?>
