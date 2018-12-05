<?php
class StorageMaster extends StorageLayoutAppModel {
	
	var $belongsTo = array(       
		'StorageControl' => array(           
			'className'    => 'StorageLayout.StorageControl',            
			'foreignKey'    => 'storage_control_id'        
		)    
	);
	
	var $actsAs = array('Tree', 'StoredItem');
	
	var $registered_view = array(
		'InventoryManagement.ViewAliquot' => array('StorageMaster.id'),
		'StorageLayout.ViewStorageMaster' => array('StorageMaster.id')
	);
	
	var $used_storage_pos = array();
	const POSITION_FREE = 1;//the position is free
	const POSITION_OCCUPIED = 2;//the position is already occupied (in the db)
	const POSITION_DOUBLE_SET = 3;//the position is being defined more than once
	
	const CONFLICTS_IGNORE = 0;
	const CONFLICTS_WARN = 1;
	const CONFLICTS_ERR = 2;
	
	function summary($variables = array()) {
		$return = false;
		
		if (isset($variables['StorageMaster.id'])) {
			$result = $this->find('first', array('conditions' => array('StorageMaster.id' => $variables['StorageMaster.id'])));
			$title = '';
			if($result['StorageControl']['is_tma_block']) {
				$title = __('TMA-blc');
			} else {
				$StructurePermissibleValuesCustom = AppModel::getInstance("", "StructurePermissibleValuesCustom", true);
				$translated_storage_type = $StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('storage types', $result['StorageControl']['storage_type']);
				$title = ($translated_storage_type !== false)? $translated_storage_type : $result['StorageControl']['storage_type'];	
			}
			
			$return = array(
				'menu' => array(null, ($title . ' : ' . $result['StorageMaster']['short_label'])),
				'title' => array(null, ($title . ' : ' . $result['StorageMaster']['short_label'])),
				'data'				=> $result,
				'structure alias'	=> 'storagemasters'
			);
		}
		
		return $return;
	}
	
	private function insideItself(){
		$parent_id = $this->data['StorageMaster']['parent_id'];
		while(!empty($parent_id)){
			$parent = $this->find('first', array('conditions' => array('StorageMaster.id' => $parent_id)));
			assert(!empty($parent));
			if($parent['StorageMaster']['id'] == $this->data['StorageMaster']['id']){
				return true;
			}
			$parent_id = $parent['StorageMaster']['parent_id'];
		}
		return false;
	}
	
	function validates($options = array()){
		if(!(array_key_exists('FunctionManagement', $this->data) && array_key_exists('recorded_storage_selection_label', $this->data['FunctionManagement']))) {
			AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}		
		
		// Check parent storage definition
		$parent_storage_selection_results = $this->validateAndGetStorageData($this->data['FunctionManagement']['recorded_storage_selection_label'], $this->data['StorageMaster']['parent_storage_coord_x'], $this->data['StorageMaster']['parent_storage_coord_y']);
		$parent_storage_data = $parent_storage_selection_results['storage_data'];
					
		// Update storage data
		$this->data['StorageMaster']['parent_id'] = isset($parent_storage_data['StorageMaster']['id'])? $parent_storage_data['StorageMaster']['id'] : null;
		
		if(array_key_exists('id', $this->data['StorageMaster']) && $this->insideItself()){
			$this->validationErrors['recorded_storage_selection_label'][] = 'you can not store your storage inside itself';

		} else if(!empty($parent_storage_data) && ($parent_storage_data['StorageControl']['is_tma_block'])) {
			$this->validationErrors['recorded_storage_selection_label'][] = 'you can not define a tma block as a parent storage';
					
		} else {
			if($parent_storage_selection_results['change_position_x_to_uppercase']){
				$this->data['StorageMaster']['parent_storage_coord_x'] = strtoupper($this->data['StorageMaster']['parent_storage_coord_x']);
			}
			if($parent_storage_selection_results['change_position_y_to_uppercase']){
				$this->data['StorageMaster']['parent_storage_coord_y'] = strtoupper($this->data['StorageMaster']['parent_storage_coord_y']);
			}
			
			// Set error
			if(!empty($parent_storage_selection_results['storage_definition_error'])){
				$this->validationErrors['recorded_storage_selection_label'][] = $parent_storage_selection_results['storage_definition_error'];
			}
			if(!empty($parent_storage_selection_results['position_x_error'])){
				$this->validationErrors['parent_storage_coord_x'][] = $parent_storage_selection_results['position_x_error'];
			}
			if(!empty($parent_storage_selection_results['position_y_error'])){
				$this->validationErrors['parent_storage_coord_y'][] = $parent_storage_selection_results['position_y_error'];
			}
			
			
			if(empty($this->validationErrors['recorded_storage_selection_label'])
				&& empty($this->validationErrors['parent_storage_coord_x'])
				&& empty($this->validationErrors['parent_storage_coord_y'])
				&& isset($parent_storage_selection_results['storage_data']['StorageControl'])
				&& $parent_storage_selection_results['storage_data']['StorageControl']['check_conflicts']
				&& (strlen($this->data['StorageMaster']['parent_storage_coord_x']) > 0 || strlen($this->data['StorageMaster']['parent_storage_coord_y']) > 0)
			){
				$exception = $this->id ? array("StorageMaster" => $this->id) : array();
				$position_status = $this->positionStatusQuick(
					$parent_storage_selection_results['storage_data']['StorageMaster']['id'], 
					array(
						'x' => $this->data['StorageMaster']['parent_storage_coord_x'], 
						'y' => $this->data['StorageMaster']['parent_storage_coord_y']
					), $exception
				);
				
				$msg = null;
				if($position_status == StorageMaster::POSITION_OCCUPIED){
					$msg = __('the storage [%s] already contained something at position [%s, %s]');
				}else if($position_status == StorageMaster::POSITION_DOUBLE_SET){
					$msg = __('you have set more than one element in storage [%s] at position [%s, %s]');
				}
				
				if($msg != null){
					$msg = sprintf($msg, 
						$parent_storage_selection_results['storage_data']['StorageMaster']['selection_label'],
						$this->data['StorageMaster']['parent_storage_coord_x'],
						$this->data['StorageMaster']['parent_storage_coord_y']
					);
					if($parent_storage_selection_results['storage_data']['StorageControl']['check_conflicts'] == self::CONFLICTS_WARN){
						AppController::addWarningMsg($msg);
					}else{
						$this->validationErrors['parent_storage_coord_x'][] = $msg;
					}
				}
			}
		}	
			
		$this->isDuplicatedStorageBarCode($this->data);

		if(isset($this->data['StorageMaster']['temperature']) && !empty($this->data['StorageMaster']['temperature'])
			&& (!isset($this->data['StorageMaster']['temp_unit']) || empty($this->data['StorageMaster']['temp_unit'])))
		{
			$this->validationErrors['temp_unit'][] = 'when defining a temperature, the temperature unit is required';
		}
		
		parent::validates($options);
		return empty($this->validationErrors);
	}
	
	function isDuplicatedStorageBarCode($storage_data) {
		if(empty($storage_data['StorageMaster']['barcode'])) {
			return false;
		}
		
		// Check duplicated barcode into db
		$barcode = $storage_data['StorageMaster']['barcode'];
		$criteria = array('StorageMaster.barcode' => $barcode);
		$storage_having_duplicated_barcode = $this->find('all', array('conditions' => $criteria, 'recursive' => -1));
		if(!empty($storage_having_duplicated_barcode)) {
			foreach($storage_having_duplicated_barcode as $duplicate) {
				if((!array_key_exists('id', $storage_data['StorageMaster'])) || ($duplicate['StorageMaster']['id'] != $storage_data['StorageMaster']['id'])) {
					$this->validationErrors['barcode'][] = 'barcode must be unique';
				}
				
			}			
		}
				
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

				if((!$is_sample_core) && ($storage_data['StorageControl']['is_tma_block'])) {
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
		$validation_results['validated'] = false;
				
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
			AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
		}
				
		// Build array
		$array_to_display = array();
		$array_to_order = array();
			
		if(!empty($storage_data['StorageControl']['coord_' . $coord . '_type'])) {
			if(!empty($storage_data['StorageControl']['coord_' . $coord . '_size'])) {
				// TYPE and SIZE are both defined for the studied coordinate: The system can build a list.
				$size = $storage_data['StorageControl']['coord_' . $coord . '_size'];
				if(!is_numeric($size)) {
					AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
				}
									
				if(strcmp($storage_data['StorageControl']['coord_' . $coord . '_type'], 'alphabetical') == 0){
					// Alphabetical drop down list
					$array_to_order = array_slice(range('A', 'Z'), 0, $size);		
				} else if(strcmp($storage_data['StorageControl']['coord_' . $coord . '_type'], 'integer') == 0){
					// Integer drop down list	
					$array_to_order = range('1', $size);
				} else {
					AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 		
				}		
			} else {
				// Only TYPE is defined for the studied coordinate: The system can only return a custom coordinate list set by user.			
				if((strcmp($storage_data['StorageControl']['coord_' . $coord . '_type'], 'list') == 0) && (strcmp($coord, 'x') == 0)) {
					$storage_coordinate = AppModel::getInstance("StorageLayout", "StorageCoordinate", true);
					$coordinates = $storage_coordinate->atim_list(array('conditions' => array('StorageCoordinate.storage_master_id' => $storage_data['StorageMaster']['id'], 'StorageCoordinate.dimension' => $coord), 'order' => 'StorageCoordinate.order ASC', 'recursive' => '-1'));
					if(!empty($coordinates)) {
						foreach($coordinates as $new_coordinate) {
							$coordinate_value = $new_coordinate['StorageCoordinate']['coordinate_value'];
							$coordinate_order = $new_coordinate['StorageCoordinate']['order'];
							$array_to_order[$coordinate_order] = $coordinate_value;						
						}		
					}
				} else {
					AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 				
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
			$selected_storages = $this->find('all', array('conditions' => array('StorageMaster.selection_label' => $matches[0][1], 'StorageMaster.code' => $matches[0][2])));
		} else {
			// consider $storage_label_and_code contains just seleciton label
			$selected_storages = $this->find('all', array('conditions' => array('StorageMaster.selection_label' => $storage_label_and_code)));
		}
		
		if(sizeof($selected_storages) == 1) {
			return array('StorageMaster' => $selected_storages[0]['StorageMaster'], 'StorageControl' => $selected_storages[0]['StorageControl']);
		} else if(sizeof($selected_storages) > 1) {
			return array('error' => str_replace('%s', $storage_label_and_code, __('more than one storages matche the selection label [%s]')));
		}
		
		return  array('error' => str_replace('%s', $storage_label_and_code, __('no storage matches the selection label [%s]')));
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
		
		if((!empty($storage_data)) && isset($storage_data['StorageMaster']['id']) && (!empty($storage_data['StorageMaster']['id']))) {
			$storage_control_model = AppModel::getInstance('StorageLayout', 'StorageControl', true);
			if(!array_key_exists('StorageControl', $storage_data)){
				$storage_data += $storage_control_model->findById($storage_data['StorageMaster']['storage_control_id']);
			}
			$storage_types_from_id = $this->StorageControl->getStorageTypePermissibleValues();
			$formatted_data = $storage_data['StorageMaster']['selection_label'] . ' [' . $storage_data['StorageMaster']['code'] . '] / '.(isset($storage_types_from_id[$storage_data['StorageControl']['id']])? $storage_types_from_id[$storage_data['StorageControl']['id']] : $storage_data['StorageControl']['storage_type']);
		}
		
		return $formatted_data;
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
		$storage_path_data = $this->getPath($studied_storage_master_id, null, '0');
				
		$storage_control_model = AppModel::getInstance('StorageLayout', 'StorageControl', true);
		$storage_types_from_id = $this->StorageControl->getStorageTypePermissibleValues();
		
		$path_to_display = '';
		$separator = '';
		if(!empty($storage_path_data)){
			foreach($storage_path_data as $new_parent_storage_data) { 
				$storage_type = isset($storage_types_from_id[$new_parent_storage_data['StorageControl']['id']])? $storage_types_from_id[$new_parent_storage_data['StorageControl']['id']] : $new_parent_storage_data['StorageControl']['storage_type'];
				$path_to_display .= $separator.$new_parent_storage_data['StorageMaster']['code'] . " ($storage_type)"; 
				$separator = ' > ';
			}
		}
			
		return $path_to_display;
	}
	
	/**
	 * @param array $storage_master_ids The storage master ids whom child existence will be verified
	 * @return array Returns the storage master ids having child
	 */
	function hasChild(array $storage_master_ids){
		//child can be a storage or an aliquot
		$result = array_filter($this->find('list', array('fields' => array("StorageMaster.parent_id"), 'conditions' => array('StorageMaster.parent_id' => $storage_master_ids), 'group' => array('StorageMaster.parent_id'))));
		$storage_master_ids = array_diff($storage_master_ids, $result);
		$aliquot_master = AppModel::getInstance("InventoryManagement", "AliquotMaster", true);
		return array_merge($result, array_filter($aliquot_master->find('list', array('fields' => array('AliquotMaster.storage_master_id'), 'conditions' => array('AliquotMaster.storage_master_id' => $storage_master_ids), 'group' => array('AliquotMaster.storage_master_id')))));
	}
	
	/**
	 * 
	 * Enter description here ...
	 * @param array $children_array
	 * @param unknown_type $type_key
	 * @param unknown_type $label_key
	 */
	function getLabel(array $children_array, $type_key, $label_key){
		return $children_array[$type_key][$label_key];
	}
	
	function allowDeletion($storage_master_id) {	
		// Check storage contains no chlidren storage
		$nbr_children_storages = $this->find('count', array('conditions' => array('StorageMaster.parent_id' => $storage_master_id), 'recursive' => '-1'));
		if($nbr_children_storages > 0) { 
			return array('allow_deletion' => false, 'msg' => 'children storage exists within the deleted storage'); 
		}
		
		// Check storage contains no aliquots
		$aliquot_master_model = AppModel::getInstance("InventoryManagement", "AliquotMaster", true);
		$nbr_storage_aliquots = $aliquot_master_model->find('count', array('conditions' => array('AliquotMaster.storage_master_id' => $storage_master_id), 'recursive' => '-1'));
		if($nbr_storage_aliquots > 0) { 
			return array('allow_deletion' => false, 'msg' => 'aliquot exists within the deleted storage'); 
		}

		// Check storage is not a block attached to tma slide
		$tma_slide_model = 	AppModel::getInstance("StorageLayout", "TmaSlide", true);
		$nbr_tma_slides = $tma_slide_model->find('count', array('conditions' => array('TmaSlide.tma_block_storage_master_id' => $storage_master_id), 'recursive' => '-1'));
		if($nbr_tma_slides > 0) { 
			return array('allow_deletion' => false, 'msg' => 'slide exists for the deleted tma'); 
		}
		
		// verify storage is not attached to tma slide
		$nbr_children_storages = $tma_slide_model->find('count', array('conditions' => array('TmaSlide.storage_master_id' => $storage_master_id), 'recursive' => '-1'));
		if($nbr_children_storages > 0) { 
			return array('allow_deletion' => false, 'msg' => 'slide exists within the deleted storage'); 
		}
					
		return array('allow_deletion' => true, 'msg' => '');
	}
	
	function manageTemperature(&$storage_data, $storage_control_data) {
		if($storage_data['StorageMaster']['storage_control_id'] != $storage_control_data['StorageControl']['id']) AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 

		// storage temperature	
		if(!$storage_control_data['StorageControl']['set_temperature']) {
			if(!empty($storage_data['StorageMaster']['parent_id'])) {
				$parent_storage_data = $this->find('first', array('conditions' => array('StorageMaster.id' => $storage_data['StorageMaster']['parent_id']), 'recursive' => '-1'));
				if(empty($parent_storage_data)) { 
					AppController::getInstance()->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
				}
				
				// Define storage surrounding temperature based on selected parent temperature
				$storage_data['StorageMaster']['temperature'] = $parent_storage_data['StorageMaster']['temperature'];
				$storage_data['StorageMaster']['temp_unit'] = $parent_storage_data['StorageMaster']['temp_unit'];				
			} else {
				$storage_data['StorageMaster']['temperature'] = null;
				$storage_data['StorageMaster']['temp_unit'] = null;					
			}
		}
	}
	
	/**
	 * Get the selection label of a storage.
	 *
	 * @param $storage_data Storage data including storage master, storage control, etc.
	 * 
	 * @return The new storage selection label.
	 * 
	 * @author N. Luc
	 * @since 2009-09-13
	 */
	function getSelectionLabel($storage_data) {
		if(empty($storage_data['StorageMaster']['parent_id'])) {
			// No parent exists: Selection Label equals short label
			return $storage_data['StorageMaster']['short_label'];
		
		}
		
		// Set selection label according to the parent selection label		
		$parent_storage_data = $this->find('first', array('conditions' => array('StorageMaster.id' => $storage_data['StorageMaster']['parent_id']), 'recursive' => '-1'));
		if(empty($parent_storage_data)) { 
			AppController::getInstance()->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		}
		
		return ($this->createSelectionLabel($storage_data, $parent_storage_data));
	}
	
	/**
	 * Create the selection label of a storage.
	 *
	 * @param $storage_data Storage data including storage master, storage control, etc.
	 * @param $storage_data Parent storage data including storage master, storage control, etc.
	 * 
	 * @return The created selection label.
	 * 
	 * @author N. Luc
	 * @since 2009-09-13
	 */
	function createSelectionLabel($storage_data, $parent_storage_data) {
		if(!array_key_exists('selection_label', $parent_storage_data['StorageMaster'])) { 
			AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
		}
		
		if(!array_key_exists('short_label', $storage_data['StorageMaster'])) { 
			AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
		}
		
		return ($parent_storage_data['StorageMaster']['selection_label'] . '-' . $storage_data['StorageMaster']['short_label']);
	}
	
		/**
	 * Manage the selection label of the children storages of a specific parent storage.
	 *
	 * @param $parent_storage_id ID of the parent storage that should be studied
	 * to update the selection labels of its children storages.
	 * @param $parent_storage_data Parent storage data.
	 * 
	 * @author N. Luc
	 * @since 2008-01-31
	 * @updated A. Suggitt
	 */
	function updateChildrenStorageSelectionLabel($parent_storage_id, $parent_storage_data){
		$arr_studied_parents_data = array($parent_storage_id => $parent_storage_data);
		
		while(!empty($arr_studied_parents_data)) {
			// Search 'direct' children to update
			$conditions = array();
			$conditions['StorageMaster.parent_id'] = array_keys($arr_studied_parents_data);
	
			$children_storage_to_update = $this->find('all', array('conditions' => $conditions, 'recursive' => '-1'));	
			$new_arr_studied_parents_data = array();
			foreach($children_storage_to_update as $new_children_to_update) {
				// New children to update
				$studied_children_id = $new_children_to_update['StorageMaster']['id'];
				$parent_storage_data = $arr_studied_parents_data[$new_children_to_update['StorageMaster']['parent_id']];
				
				$storage_data_to_update = array();
				$storage_data_to_update['StorageMaster']['selection_label'] = $this->createSelectionLabel($new_children_to_update, $parent_storage_data);
	
				$this->id = $studied_children_id;
				$this->data = null;
				if(!$this->save($storage_data_to_update, false)) { 
					AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
				}		
	
				// Re-populate the list of parent storages to study
				$new_children_to_update['StorageMaster']['selection_label'] = $storage_data_to_update['StorageMaster']['selection_label'];
				$new_arr_studied_parents_data[$studied_children_id] = $new_children_to_update;
			}
			
			$arr_studied_parents_data = $new_arr_studied_parents_data;			
		}

		return;		
	}

	/**
	 * Create code of a new storage. 
	 * 
	 * @param $storage_master_id Storage master id of the studied storage.
	 * @param $storage_data Storage data including storage master, storage control, etc.
	 * @param $storage_control_data Control data of the studied storage.
	 * 
	 * @return The new code.
	 * 
	 * @author N. Luc
	 * @since 2008-01-31
	 * @updated A. Suggitt
	 * @deprecated
	 */
	function createCode($storage_master_id, $storage_data, $storage_control_data) {
		AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
		$storage_code = $storage_master_id;
		
		return $storage_code;
	}
	
	/**
	 * Update the surrounding temperature and unit of children storages.
	 * 
	 * Note: only children storages having temperature or unit different than the parent will
	 * be updated.
	 * 
	 * @param $parent_storage_master_id Id of the parent storage. 
	 * @param $parent_temperature Parent storage temperature.
	 * @param $parent_temp_unit Parent storage temperature unit.
	 *
	 * @author N. Luc
	 * @since 2007-05-22
	 * @updated A. Suggitt
	 */
	 
	function updateChildrenSurroundingTemperature($parent_storage_master_id, $parent_temperature, $parent_temp_unit) {	
		$studied_parent_storage_ids = array($parent_storage_master_id => $parent_storage_master_id);
		
		while(!empty($studied_parent_storage_ids)) {
			// Search 'direct' children to update
			$conditions = array();
			$conditions['StorageMaster.parent_id'] = $studied_parent_storage_ids;
			$conditions['StorageControl.set_temperature'] = '0';
			$conditions['OR'] = array();
			
			if(empty($parent_temperature) && (!is_numeric($parent_temperature))) {
				$conditions['OR'][] = "StorageMaster.temperature IS NOT NULL";
			} else {
				$conditions['OR'][] = "StorageMaster.temperature IS NULL";				
				$conditions['OR'][] = "StorageMaster.temperature != '$parent_temperature'";				
			}
			
			if(empty($parent_temp_unit)) {
				$conditions['OR'][] = "StorageMaster.temp_unit IS NOT NULL";
				$conditions['OR'][] = "StorageMaster.temp_unit != ''";
			} else {
				$conditions['OR'][] = "StorageMaster.temp_unit IS NULL";				
				$conditions['OR'][] = "StorageMaster.temp_unit != '$parent_temp_unit'";				
			}

			$studied_parent_storage_ids = array();
			
			$children_storage_to_update = $this->find('all', array('conditions' => $conditions, 'recursive' => '0'));			
			foreach($children_storage_to_update as $new_children_to_update) {
				// New children to update
				$studied_children_id = $new_children_to_update['StorageMaster']['id'];
				
				$storage_data_to_update = array();
				$storage_data_to_update['StorageMaster']['temperature'] = $parent_temperature;
				$storage_data_to_update['StorageMaster']['temp_unit'] = $parent_temp_unit;
	
				$this->id = $studied_children_id;					
				if(!$this->save($storage_data_to_update, false)) { 
					AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
				}		
	
				// Re-populate the list of parent storages to study
				$studied_parent_storage_ids[$studied_children_id] = $studied_children_id;
			}
		}

		return;
	}
	
	/**
	 * Parses the data_array and updates it with the rcv_data array. Saves the modifications into the database and
	 * cleans it of the no longer related data. 
	 * @param data_array The data read from the database
	 * @param type The current type we are seeking
	 * @param x_key The name of the key for the x coordinate
	 * @param y_key The name of the key for the y coordinate
	 * @param storage_parent_key The name of the key of the parent storage id
	 * @param rcv_data The data received from the user
	 * @param updater_model The model to use to update the data
	 * @param storage_control
	 */
	function updateAndSaveDataArray($data_array, $type, $x_key, $y_key, $storage_parent_key, $rcv_data, $updater_model, array $storage_controls){
		foreach($data_array as &$init_data_unit){
			$init_data_id = $init_data_unit[$type]['id'];
			if(($init_data_unit[$type][$x_key] != $rcv_data[$type][$init_data_id]['x'] && !(in_array($rcv_data[$type][$init_data_id]['x'], array('u', 't')) && $init_data_unit[$type][$x_key] == ''))  
				|| ($init_data_unit[$type][$y_key] != $rcv_data[$type][$init_data_id]['y']  && !(in_array($rcv_data[$type][$init_data_id]['y'], array('u', 't')) && $init_data_unit[$type][$y_key] == ''))
				|| $init_data_unit[$type][$storage_parent_key] != $rcv_data[$type][$init_data_id]['s'] 
			){
				//only save what changed
				$update_temp_and_label = $init_data_unit[$type][$storage_parent_key] != $rcv_data[$type][$init_data_id]['s'] && $type == 'StorageMaster';
				//this is is a cell
				if($rcv_data[$type][$init_data_id]['x'] == 't'){
					//trash
					$init_data_unit[$type][$x_key] = '';
					$init_data_unit[$type][$y_key] = '';
					$init_data_unit[$type][$storage_parent_key] = null;
					
					if($type == "StorageMaster"){
						// Set new selection label 
						$init_data_unit[$type]['selection_label'] = $this->getSelectionLabel($init_data_unit);	
						
						// Set new temperature
						if(!$init_data_unit['StorageControl']['set_temperature']) {
							$init_data_unit[$type]['temperature'] = null;
							$init_data_unit[$type]['temp_unit'] = null;
						}
					}
					
				}else if($rcv_data[$type][$init_data_id]['x'] == 'u'){
					//unclassified
					$init_data_unit[$type][$x_key] = '';
					$init_data_unit[$type][$y_key] = '';
					$init_data_unit[$type][$storage_parent_key] = $rcv_data[$type][$init_data_id]['s'];
					
				}else{
					//positioned
					$storage_control = $storage_controls[$rcv_data[$type][$init_data_id]['s']]['StorageControl'];
					$init_data_unit[$type][$x_key] = ($storage_control['coord_x_size'] == null && $storage_control['coord_x_type'] != 'list' ? '' : $rcv_data[$type][$init_data_id]['x']); 
					$init_data_unit[$type][$y_key] = ($storage_control['coord_y_size'] == null && $storage_control['coord_y_type'] != 'list' ? '' : $rcv_data[$type][$init_data_id]['y']);
					$init_data_unit[$type][$storage_parent_key] = $rcv_data[$type][$init_data_id]['s'];
				}
				
				if($type == "StorageMaster"){
					//check if within itself
					$this->data = $init_data_unit;
					if($this->insideItself()){
						$init_data_unit[$type][$x_key] = '';
						$init_data_unit[$type][$y_key] = '';
						$init_data_unit[$type][$storage_parent_key] = '';
						$data = $this->findById($init_data_id);
						AppController::addWarningMsg(__('trying to put storage [%s] within itself failed', $this->getLabel($data, 'StorageMaster', 'selection_label')).' '.__('storage parent defined to none'));
					}
				}
				
				//clean the array asap to gain efficiency
				unset($rcv_data[$type][$init_data_id]);
	
				if($update_temp_and_label){
					$this->manageTemperature($init_data_unit, $init_data_unit);
					$init_data_unit['StorageMaster']['selection_label'] = $this->getSelectionLabel($init_data_unit);
				}
				
				$updater_model->pkey_safeguard = false;
				$updater_model->save($init_data_unit[$type], false);
				
				if($update_temp_and_label){
					$this->updateChildrenStorageSelectionLabel($init_data_id, $init_data_unit);
					
					if(!$init_data_unit['StorageControl']['set_temperature']) {
						$this->updateChildrenSurroundingTemperature($init_data_id, $init_data_unit['StorageMaster']['temperature'], $init_data_unit['StorageMaster']['temp_unit']);
					}
				}
			}
		}
	}
	
	function buildChildrenArray(&$children_array, $type_key, $x_key, $y_key, $label_key, $coordinate_list, $link, $icon_name = "detail"){
		$children_array['DisplayData']['id'] = $children_array[$type_key]['id'];
		$children_array['DisplayData']['y'] = strlen($children_array[$type_key][$y_key]) > 0 ? $children_array[$type_key][$y_key] : 1; 
		if($coordinate_list == null){
			$children_array['DisplayData']['x'] = $children_array[$type_key][$x_key];
		}else if(isset($coordinate_list[$children_array[$type_key][$x_key]])){
			$children_array['DisplayData']['x'] = $coordinate_list[$children_array[$type_key][$x_key]]['StorageCoordinate']['id'];
			$children_array['DisplayData']['y'] = 1;
		}else{
			$children_array['DisplayData']['x'] = "";
		}
		
		$children_array['DisplayData']['label'] = $this->getLabel($children_array, $type_key, $label_key);
		$children_array['DisplayData']['type'] = $type_key;
		$children_array['DisplayData']['link'] = $link;
		$children_array['DisplayData']['icon_name'] = $icon_name;
	}
	
	/**
	 * Checks wheter a storage position is already occupied or not. This is a
	 * quick check up that will not behave properly on bogus positions.
	 * @param int $storage_master_id
	 * @param array $position ("x" => int [, "y" => int])
	 * @param array $exception (model name => id). An exception to ommit when
	 * checking availability. Usefull when editing something.
	 * @return const POSITION_*
	 */
	function positionStatusQuick($storage_master_id, array $position, array $exception = array()){
		
		//check if an aliquot occupies the position
		$conditions = array(
			'AliquotMaster.storage_master_id' => $storage_master_id,
			'AliquotMaster.in_stock !='	=> "no"
		);
		foreach($position as $key => $val){
			$conditions['AliquotMaster.storage_coord_'.$key] = $val;
		}
		if(array_key_exists("AliquotMaster", $exception)){
			$conditions['AliquotMaster.id !='] = $exception['AliquotMaster'];
		}
		$aliquot_master_model = AppModel::getInstance("InventoryManagement", "AliquotMaster", true);
		$tmp = $aliquot_master_model->find('first', array('conditions' => $conditions, 'recursive' => -1));
		if(!empty($tmp)){
			return StorageMaster::POSITION_OCCUPIED;
		}
		
		
		//check if a storage occupies the position
		$conditions = array(
			'StorageMaster.parent_id' => $storage_master_id
		);
		foreach($position as $key => $val){
			$conditions['StorageMaster.parent_storage_coord_'.$key] = $val;
		}
		if(array_key_exists("StorageMaster", $exception)){
			$conditions['StorageMaster.id !='] = $exception['StorageMaster'];
		}
		
		$tmp = $this->find('first', array('conditions' => $conditions, 'recursive' => -1));
		if(!empty($tmp)){
			return StorageMaster::POSITION_OCCUPIED;
		}
		
		
		//check if a TMA occupies the position
		$conditions = array(
			'TmaSlide.storage_master_id' => $storage_master_id
		);
		foreach($position as $key => $val){
			$conditions['TmaSlide.storage_coord_'.$key] = $val;
		}
		if(array_key_exists("TmaSlide", $exception)){
			$conditions['TmaSlide.id !='] = $exception['TmaSlide'];
		}
		$tma_slide_model = AppModel::getInstance("StorageLayout", "TmaSlide", true);
		$tmp = $tma_slide_model->find('first', array('conditions' => $conditions, 'recursive' => -1));
		if(!empty($tmp)){
			return StorageMaster::POSITION_OCCUPIED;
		}
		
		
		//check if a current check occupies the position
		if(array_key_exists('y', $position) && !empty($position['y'])){
			if(isset($this->used_storage_pos[$storage_master_id][$position['x']][$position['y']])){
				return StorageMaster::POSITION_DOUBLE_SET;
			}
		}else if(isset($this->used_storage_pos[$storage_master_id][$position['x']])){
			return StorageMaster::POSITION_DOUBLE_SET;
		} 
		$this->used_storage_pos[$storage_master_id][$position['x']] = array_key_exists('y', $position) ? array($position['y']) : null;

		
		
		return StorageMaster::POSITION_FREE;
	}
	
	/**
	 * Checks conflicts for batch layout
	 */
	function checkBatchLayoutConflicts(&$data, $model_name, $label_name, &$cumul_storage_data){
		$conflicts_found = false;
		if(isset($data[$model_name])){
			foreach($data[$model_name] as &$model_data){
				$storage_id = $model_data['s'];
				if($model_data['x'] == 'u' || $model_data['x'] == 't'){
					continue;
				}
				if(!array_key_exists($storage_id, $cumul_storage_data)){
					$storage = $this->findById($storage_id);
					$cumul_storage_data[$storage_id] = $storage;
					$cumul_storage_data[$storage_id]['printed_label'] = $this->getLabel($storage, 'StorageMaster', 'selection_label');
				}
					
				if(isset($cumul_storage_data[$storage_id]['pos'][$model_data['x']][$model_data['y']])){
					$msg = __('conflict detected in storage [%s] at position [%s, %s]',
						$cumul_storage_data[$storage_id]['printed_label'],
						$model_data['x'],
						$model_data['y']
					);
					//react
					if($cumul_storage_data[$storage_id]['StorageControl']['check_conflicts'] == StorageMaster::CONFLICTS_WARN){
						AppController::addWarningMsg($msg);
						$conflicts_found = true;
					}else if($cumul_storage_data[$storage_id]['StorageControl']['check_conflicts'] == StorageMaster::CONFLICTS_ERR){
						$this->validationErrors[][] = ($msg.' '.__('unclassifying additional items'));
						$model_data['x'] = '';
						$model_data['y'] = '';
						$conflicts_found = true;
					}
				}else{
					//save the item label
					$model = AppModel::getInstance(null, $model_name, true);
					$model_full_data = $model->findById($model_data['id']);
					$cumul_storage_data[$storage_id]['pos'][$model_data['x']][$model_data['y']] = $this->getLabel($model_full_data, $model_name, $label_name);
				}
			}
		}
		
		return $conflicts_found;
	}
}

?>
