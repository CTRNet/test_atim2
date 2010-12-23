<?php

class AliquotMaster extends InventoryManagementAppModel {

	var $belongsTo = array(       
		'AliquotControl' => array(           
			'className'    => 'Inventorymanagement.AliquotControl',            
			'foreignKey'    => 'aliquot_control_id'), 
		'Collection' => array(           
			'className'    => 'Inventorymanagement.Collection',            
			'foreignKey'    => 'collection_id'),          
		'SampleMaster' => array(           
			'className'    => 'Inventorymanagement.SampleMaster',            
			'foreignKey'    => 'sample_master_id'),        
		'StorageMaster' => array(           
			'className'    => 'Storagelayout.StorageMaster',            
			'foreignKey'    => 'storage_master_id'));
                                 
	var $hasMany = array(
		'AliquotUse' => array(
			'className'   => 'Inventorymanagement.AliquotUse',
			'foreignKey'  => 'aliquot_master_id'),
		'RealiquotingParent' => array(
			'className' => 'Inventorymanagement.Realiquoting',
			'foreignKey' => 'child_aliquot_master_id'),
		'RealiquotingChildren' => array(
			'className' => 'Inventorymanagement.Realiquoting',
			'foreignKey' => 'parent_aliquot_master_id'));
	
	var $hasOne = array(
		'SpecimenDetail' => array(
			'className'   => 'Inventorymanagement.SpecimenDetail',
			 	'foreignKey'  => 'sample_master_id',
			 	'dependent' => true)
	);
	
	public static $aliquot_type_dropdown = array();
	public static $storage = null;
	private $barcodes = array();//barcode validation, key = barcode, value = id
	
	function summary($variables=array()) {
		$return = false;
		
		if (isset($variables['Collection.id']) && isset($variables['SampleMaster.id']) && isset($variables['AliquotMaster.id'])) {
			
			$result = $this->find('first', array('conditions'=>array('AliquotMaster.collection_id'=>$variables['Collection.id'], 'AliquotMaster.sample_master_id'=>$variables['SampleMaster.id'], 'AliquotMaster.id'=>$variables['AliquotMaster.id'])));
			if(!isset($result['AliquotMaster']['storage_coord_y'])){
				$result['AliquotMaster']['storage_coord_y'] = "";
			}
			$return = array(
					'menu'	        	=> array(null, __($result['AliquotMaster']['aliquot_type'], true) . ' : '. $result['AliquotMaster']['barcode']),
					'title'		  		=> array(null, __($result['AliquotMaster']['aliquot_type'], true) . ' : '. $result['AliquotMaster']['barcode']),
					'data'				=> $result,
					'structure alias'	=> 'aliquotmasters'
			);
		}
		
		return $return;
	}
	
	function getStorageHistory($aliquot_master_id){
		$storage_data = array();

		$qry = "SELECT sm.*, am.* FROM aliquot_masters_revs AS am
				LEFT JOIN  aliquot_masters_revs AS amn ON amn.version_id=(SELECT version_id FROM aliquot_masters_revs WHERE id=am.id AND version_id > am.version_id ORDER BY version_id ASC LIMIT 1)
				LEFT JOIN storage_masters_revs AS sm ON am.storage_master_id=sm.id
				LEFT JOIN storage_masters_revs AS smn ON smn.version_id=(SELECT version_id FROM storage_masters_revs WHERE id=sm.id AND version_id > sm.version_id ORDER BY version_id ASC LIMIT 1)
				WHERE am.id='".$aliquot_master_id."' AND ((am.modified > sm.modified AND (am.modified < smn.modified OR smn.modified IS NULL)) OR (sm.modified > am.modified AND (sm.modified < amn.modified OR amn.modified IS NULL)) OR am.storage_master_id IS NULL)";
		$storage_data_tmp = $this->query($qry);
		
		$previous = array_shift($storage_data_tmp);
		while($current = array_shift($storage_data_tmp)){
			if($previous['sm']['id'] != $current['sm']['id']){
				//filter 1 - new storage
				$storage_data[]['custom'] = array(
					'date' => $current['am']['modified'], 
					'event' => __('new storage', true)." "
						.__('from', true).": [".(strlen($previous['sm']['selection_label']) > 0 ? $previous['sm']['selection_label']." ".__('temperature', true).": ".$previous['sm']['temperature'].__($previous['sm']['temp_unit'], true) : __('no storage', true))."] "
						.__('to', true).": [".(strlen($current['sm']['selection_label']) > 0 ? $current['sm']['selection_label']." ".__('temperature', true).": ".$current['sm']['temperature'].__($current['sm']['temp_unit'], true) : __('no storage', true))."]");
			}else if($previous['sm']['temperature'] != $current['sm']['temperature'] || $previous['sm']['selection_label'] != $current['sm']['selection_label']){
				//filter 2, storage changes (temperature, label)
				$event = "";
				if($previous['sm']['temperature'] != $current['sm']['temperature']){
					$event .= __('storage temperature changed', true).". "
						.__('from', true).": ".(strlen($previous['sm']['temperature']) > 0 ? $previous['sm']['temperature'] : "?").__($previous['sm']['temp_unit'], true)." "
						.__('to', true).": ".(strlen($current['sm']['temperature']) > 0 ? $current['sm']['temperature'] : "?").__($current['sm']['temp_unit'], true).". ";
				}
				if($previous['sm']['selection_label'] != $current['sm']['selection_label']){
					$event .= __("selection label updated", true).". ".__("from", true).": ".$previous['sm']['selection_label']." ".__("to", true).": ".$current['sm']['selection_label'].". ";
				}
				$storage_data[]['custom'] = array(
					'date' => $current['sm']['modified'], 
					'event' => $event);
			}else if($previous['am']['storage_coord_x'] != $current['am']['storage_coord_x'] || $previous['am']['storage_coord_y'] != $current['am']['storage_coord_y']){
				//filter 3, aliquot position change
				$coord_from = $previous['am']['storage_coord_x'].", ".$previous['am']['storage_coord_y'];
				$coord_to = $current['am']['storage_coord_x'].", ".$current['am']['storage_coord_y'];
				$storage_data[]['custom'] = array(
					'date' => $current['am']['modified'], 
					'event' => __('moved within storage', true)." ".__('from', true).": [".$coord_from."] ".__('to', true).": [".$coord_to."]. ");
			}
			
			$previous = $current;
		}
		
		return $storage_data;
	}
	
	/**
	 * Creates realiquoting links between aliquots
	 * @param array $data
	 * @param boolean $remove_from_stocks_if_empty If true, empty parents aliquots will be removed from storages and made unavailable
	 * @return array validation errors. If the array is empty, the realiquoting has been done, otherwise it's been aborted. On success,
	 * realiquoted children ids are put into $_SESSION['tmp_batch_set'] to allow the redirection to a temporary batch set.	 
	 */
	public function defineRealiquot(array $data, $remove_from_stocks_if_empty = false){
		$AliquotUse = AppModel::atimNew("inventorymanagement", "AliquotUse", true);
		$AliquotUse->validate = AliquotUse::$mValidate;
		$relations = array();
		$errors = array();
		$uses = array();
		$masters_to_update = array();
		foreach($data as $parent_aliquot_id => $children_aliquots){
			foreach($children_aliquots as $children_aliquot){
				if(!$children_aliquot['FunctionManagement']['use']){
					continue;
				}
				if(isset($relations[$children_aliquot['AliquotMaster']['id']])){
					$errors[] = sprintf(__("circular assignation with [%s]", true), $children_aliquot['AliquotMaster']['barcode']);
				}
				$relations[$parent_aliquot_id] = $children_aliquot['AliquotMaster']['id'];
				
				//validate
				$use = array(
					'AliquotUse' => array(
						'aliquot_master_id'			=> $parent_aliquot_id,
						'use_definition'			=> 'realiquoted to',
						'use_code'					=> $children_aliquot['AliquotMaster']['barcode'],
						'use_recorded_into_table'	=> 'realiquotings',
						'used_volume'				=> $children_aliquot['AliquotUse']['used_volume'],
						'use_datetime'				=> $children_aliquot['AliquotUse']['use_datetime'],
						'used_by'					=> $children_aliquot['AliquotUse']['used_by']
					),
					'AliquotMaster' => array(
						'id'	=> $children_aliquot['AliquotMaster']['id']
				));
				$AliquotUse->set($use);
				if(!$AliquotUse->validates()){
					$errors = array_merge($errors, $AliquotUse->validationErrors);
				}
				$uses[] = $use;
			}
		}
		
		if(count($errors) == 0){
			$Realiquoting = AppModel::atimNew("inventorymanagement", "Realiquoting", true);
			//no error, proceed!
			//create uses
			$_SESSION['tmp_batch_set']['BatchId'] = array();
			foreach($uses as $use){
				//save use
				$AliquotUse->id = NULL;
				$AliquotUse->set($use);
				$AliquotUse->save();

				//save realiquoting
				$Realiquoting->id = NULL;
				$Realiquoting->set(array('Realiquoting' => array(
					'parent_aliquot_master_id'	=> $use['AliquotUse']['aliquot_master_id'],
					'child_aliquot_master_id'	=> $use['AliquotMaster']['id'],
					'aliquot_use_id'			=> $AliquotUse->id
				)));
				$Realiquoting->save();
				
				//note parent_id to update
				$masters_to_update[$use['AliquotUse']['aliquot_master_id']] = NULL;
				$_SESSION['tmp_batch_set']['BatchId'][] = $use['AliquotMaster']['id'];
			}
			
			foreach($masters_to_update as $aliquot_id => $foo){
				$this->updateAliquotCurrentVolume($aliquot_id, $remove_from_stocks_if_empty);
			}
		}
		$_SESSION['tmp_batch_set']['datamart_structure_id'] = 1;//ViewAliquots
		
		if(count($errors)){
			unset($_SESSION['tmp_batch_set']);
		}
		return $errors;
	}
	
	/**
	 * Update the current volume of an aliquot.
	 * 
	 * Note:
	 *  - When the intial volume is null, the current volume will be set to null.
	 *  - Status and status reason won't be updated.
	 *
	 * @param $aliquot_master_id Master Id of the aliquot.
	 * @remove_from_stock_if_empty boolean Will set in stock to false and remove the aliquot from storage
	 * 
	 * @return FALSE when error has been detected
	 * 
	 * @author N. Luc
	 * @date 2007-08-15
	 */
	 
	function updateAliquotCurrentVolume($aliquot_master_id, $remove_from_stock_if_empty = false){
		if(empty($aliquot_master_id)){
			AppController::getInstance()->redirect('/pages/err_inv_funct_param_missing', null, true); 
		}
		
		$aliquot_data = $this->find('first', array('conditions' => array('AliquotMaster.id' => $aliquot_master_id)));
		
		if(empty($aliquot_data)){
			AppController::getInstance()->redirect('/pages/err_inv_no_data', null, true); 
		}
				
		$initial_volume = $aliquot_data['AliquotMaster']['initial_volume'];
		$current_volume = $aliquot_data['AliquotMaster']['current_volume'];
				
		// Manage new current volume
		if(empty($initial_volume)){	
			// Initial_volume is null or equal to 0
			if($initial_volume === $current_volume) {
				//Nothing to do
				return true;
			}
			
			// To be sure value and type of both variables are identical
			$current_volume = $initial_volume;
					
		}else {
			// A value has been set for the intial volume		
			if((!is_numeric($initial_volume)) || ($initial_volume < 0)){
				AppController::getInstance()->redirect('/pages/err_inv_system_error', null, true); 
			}
					
			$total_used_volume = 0;
			foreach($aliquot_data['AliquotUse'] as $id => $aliquot_use){
				$used_volume = $aliquot_use['used_volume'];
				if(!empty($used_volume)){
					// Take used volume in consideration only when this one is not empty
					if((!is_numeric($used_volume)) || ($used_volume < 0)){
						AppController::getInstance()->redirect('/pages/err_inv_system_error', null, true); 
					}
					$total_used_volume += $used_volume;
				}

			}
			$new_current_volume = round(($initial_volume - $total_used_volume), 5);
			if($new_current_volume < 0){
				$new_current_volume = 0;
				$tmp_msg = __("the aliquot with barcode [%s] has a reached a volume bellow 0", true);
				AppController::addWarningMsg(sprintf($tmp_msg, $aliquot_data['AliquotMaster']['barcode']));
			}

			if($new_current_volume === $current_volume) {
				//Nothing to do
				return true;
			}
			$current_volume = $new_current_volume;
		}
		
		$data["current_volume"] = $current_volume;
		if($current_volume <= 0 && $remove_from_stock_if_empty){
			$data['storage_master_id'] = NULL;
			$data['storage_coord_x'] = NULL;
			$data['storage_coord_y'] = NULL;
			$data['coord_x_order'] = NULL;
			$data['coord_y_order'] = NULL;
			$data['in_stock'] = 'no';
			$data['in_stock_detail'] = 'empty';
		}
		
		// Save Data
		$data['id'] = $aliquot_master_id;
		$this->id = $aliquot_master_id;
		if(!$this->save(array("AliquotMaster" => $data))){
			return false;
		}
		return true;
	}
	
	public function getRealiquotDropdown(){
		return self::$aliquot_type_dropdown;	
	}
	
	
	/**
	 * Defines Generated.aliquot_use_counter when AliquotMaster.id is defined
	 * @see Model::afterFind()
	 */
	public function afterFind($results){
		foreach($results as &$result){
			if(is_array($result) && isset($result['AliquotUse'])){
				$result['Generated']['aliquot_use_counter'] = count($result['AliquotUse']);
			}
		}
		return $results;
	}
	
	/**
	 * @desc Additional validation rule to validate stock status and storage.
	 * @see Model::validates()
	 */
	function validates($options = array()){
		$current_data = $this->data['AliquotMaster'];
		if(isset($current_data['in_stock']) && $current_data['in_stock'] == 'no' 
		&& (!empty($current_data['storage_master_id']) || !empty($this->data['FunctionManagement']['recorded_storage_selection_label']))){
			$this->validationErrors['in_stock'] = 'an aliquot being not in stock can not be linked to a storage';
		}
		$storage_validation = $this->validateAliquotStorageData($this->data);
		if(!$storage_validation['submitted_data_validates']){
			foreach($storage_validation['messages_sorted_per_field'] as $field => $msg){
				$this->validationErrors[$field] = $msg;
			}
		}
		
		if(isset($current_data['barcode'])){
			$dupe_data = $this->isDuplicatedAliquotBarcode($this->data);
			if($dupe_data['is_duplicated_barcode']){
				$this->validationErrors['barcode'] = $dupe_data['messages'];
			}
		}
		parent::validates($options);
		return empty($this->validationErrors);
	}
	
	/**
	 * Check both aliquot storage definition and aliquot positions and set error if required.
	 * 
	 * Note: 
	 *  - This function supports form data structure built by either 'add' form or 'datagrid' form.
	 *  - Has been created to allow customisation.
	 * 
	 * @param $aliquots_data Aliquots data stored into an array having structure like either:
	 * 	- $aliquots_data = array('AliquotMaster' => array(...))
	 * 	or
	 * 	- $aliquots_data = array(array('AliquotMaster' => array(...)))
	 *
	 * @return Following results array:
	 * 	array(
	 * 		'submitted_data_validates' => TRUE when data are validated,
	 * 		'messages_sorted_per_field' => array ($field_name => array($message_1, $message_2, ...))
	 * 	)
	 * 
	 * @author N. Luc
	 * @date 2007-08-15
	 */
	 
	function validateAliquotStorageData(&$aliquots_data) {
		$submitted_data_validates = true;
				
		$arr_preselected_storages = array();
		$storage_validation_errors = array('id' => array(), 'x' => array(), 'y' => array());
		
		// check data structure
		$is_multi_records_data = true;
		if(is_array($aliquots_data)) {
			if(isset($aliquots_data['AliquotMaster'])) {
				// Single record to manage as multi records
				$aliquots_data = array('0' => $aliquots_data);
				$is_multi_records_data = false;
			} else {
				$tmp_arr_to_test = array_values($aliquots_data);	// Use in case user created aliquots in batch and hidden the first row of the datagrid
				if(is_array($tmp_arr_to_test) && isset($tmp_arr_to_test[0]['AliquotMaster'])) {
					// Multi records: Nothing to do				
				} else {
					AppController::getInstance()->redirect('/pages/err_inv_system_error', null, true);
				}
			}
		} else {
			AppController::getInstance()->redirect('/pages/err_inv_system_error', null, true);
		}
		
		if(self::$storage == null){
			self::$storage = AppModel::atimNew("storagelayout", "StorageMaster", true);
		}
		
		// Launch validation		
		foreach ($aliquots_data as $key => $new_aliquot) {
			if(isset($new_aliquot['FunctionManagement']['recorded_storage_selection_label']) 
			|| isset($new_aliquot['AliquotMaster']['storage_master_id'])){
				$is_sample_core = isset($new_aliquot['AliquotMaster']['aliquot_type']) && ($new_aliquot['AliquotMaster']['aliquot_type'] == 'core');
				
				// Check the aliquot storage definition (selection label versus selected storage_master_id)
				$arr_storage_selection_results = self::$storage->validateStorageIdVersusSelectionLabel($new_aliquot['FunctionManagement']['recorded_storage_selection_label'], $new_aliquot['AliquotMaster']['storage_master_id'], $is_sample_core);
						
				$new_aliquot['AliquotMaster']['storage_master_id'] = $arr_storage_selection_results['selected_storage_master_id'];
				$arr_preselected_storages += $arr_storage_selection_results['matching_storage_list'];
		
				if(!empty($arr_storage_selection_results['storage_definition_error'])) {
					$submitted_data_validates = false;
					$error_msg = $arr_storage_selection_results['storage_definition_error'];
					$storage_validation_errors['id'][$error_msg] = $error_msg;		
				
				} else {
					// Check aliquot position within storage
					$storage_data = (empty($new_aliquot['AliquotMaster']['storage_master_id'])? null: $arr_storage_selection_results['matching_storage_list'][$new_aliquot['AliquotMaster']['storage_master_id']]);
					$arr_position_results = self::$storage->validatePositionWithinStorage($new_aliquot['AliquotMaster']['storage_master_id'], $new_aliquot['AliquotMaster']['storage_coord_x'], $new_aliquot['AliquotMaster']['storage_coord_y'], $storage_data);
								
					// Manage errors
					if(!empty($arr_position_results['position_definition_error'])) {
						$submitted_data_validates = false;
						$error = $arr_position_results['position_definition_error'];
						if($arr_position_results['error_on_x']){
							$storage_validation_errors['x'][$error] = $error; 
						} 
						if($arr_position_results['error_on_y']){
							$storage_validation_errors['y'][$error] = $error; 
						}	
					}
									
					// Reset aliquot storage data
					$new_aliquot['AliquotMaster']['storage_coord_x'] = $arr_position_results['validated_position_x'];
					$new_aliquot['AliquotMaster']['coord_x_order'] = $arr_position_results['position_x_order'];
					$new_aliquot['AliquotMaster']['storage_coord_y'] = $arr_position_results['validated_position_y'];
					$new_aliquot['AliquotMaster']['coord_y_order'] = $arr_position_results['position_y_order'];
				}
				
				// Update $aliquots_data for the studied record
				$aliquots_data[$key] = $new_aliquot;
			}
		}
		
		// Set preselected storage list		
		//TODO still good?
//		$this->StorageMaster->storage_dropdown = $this->formatPreselectedStoragesForDisplay($arr_preselected_storages);
				
		// Manage error message
		$messages = array();
		$messages['storage_master_id'] = $storage_validation_errors['id']; 
		$messages['storage_coord_x'] = $storage_validation_errors['x']; 
		$messages['storage_coord_y'] = $storage_validation_errors['y']; 
		
		if(!$is_multi_records_data) {
			// Reset correctly single record data
			$aliquots_data = $aliquots_data['0'];
		}
		
		return array('submitted_data_validates' => $submitted_data_validates, 'messages_sorted_per_field' => $messages);
	}
	
	/**
	 * Check created barcodes are not duplicated and set error if they are.
	 * 
	 * Note: 
	 *  - This function supports form data structure built by either 'add' form or 'datagrid' form.
	 *  - Has been created to allow customisation.
	 * 
	 * @param $aliquots_data Aliquots data stored into an array having structure like either:
	 * 	- $aliquots_data = array('AliquotMaster' => array(...))
	 * 	or
	 * 	- $aliquots_data = array(array('AliquotMaster' => array(...)))
	 *
	 * @return  Following results array:
	 * 	array(
	 * 		'is_duplicated_barcode' => TRUE when barcodes are duplicaed,
	 * 		'messages' => array($message_1, $message_2, ...)
	 * 	)
	 * 
	 * @author N. Luc
	 * @date 2007-08-15
	 */
	 
	function isDuplicatedAliquotBarcode($aliquots_data) {
		$is_duplicated_barcode = false;
		$duplicated_barcodes = array();
				
		// check data structure
		$is_multi_records_data = true;
		if(is_array($aliquots_data)) {
			if(isset($aliquots_data['AliquotMaster'])) {
				// Single record to manage as multi records
				$aliquots_data = array('0' => $aliquots_data);
				$is_multi_records_data = false;
			} else {
				$tmp_arr_to_test = array_values($aliquots_data);	// Use in case user created aliquots in batch and hidden the first row of the datagrid
				if(!is_array($tmp_arr_to_test) || !isset($tmp_arr_to_test[0]['AliquotMaster'])) {
					$this->redirect('/pages/err_inv_system_error', null, true);
				}
			}
		} else {
			$this->redirect('/pages/err_inv_system_error', null, true);
		}
		
		// Check duplicated barcode into submited record
		$new_barcodes = array();
		foreach($aliquots_data as $new_aliquot) {
			$barcode = $new_aliquot['AliquotMaster']['barcode'];
			if(empty($barcode)) {
				// Not studied
			} else if(isset($this->barcodes[$barcode])) {
				$duplicated_barcodes[$barcode] = $barcode;
			} else {
				$this->barcodes[$barcode] = isset($new_aliquot['AliquotMaster']['id']) ? $new_aliquot['AliquotMaster']['id'] : 0;
				$new_barcodes[] = $barcode;
			}
		}
		
		// Check duplicated barcode into db
		$criteria = array('AliquotMaster.barcode' => $new_barcodes);
		$aliquots_having_duplicated_barcode = $this->atim_list(array('conditions' => $criteria));
		if(!empty($aliquots_having_duplicated_barcode)) {
			foreach($aliquots_having_duplicated_barcode as $duplicate) {
				if($duplicate['AliquotMaster']['id'] != $this->barcodes[$duplicate['AliquotMaster']['barcode']]){
					//they are not the same id, this is really a dupe
					$duplicated_barcodes[$barcode] = $barcode;
				}
			}			
		}
		
		// Set errors
		$messages = array();
		if(!empty($duplicated_barcodes)) {
			// Set boolean
			$is_duplicated_barcode = true;
			
			// Set error message
			$str_barcodes_in_error = ' ';
			foreach($duplicated_barcodes as $barcode) {
				$str_barcodes_in_error .= '[' . $barcode . '] ';
			}
			$messages[]	= __('barcode must be unique', true) . ' ' . __('please check following barcode(s)', true) . $str_barcodes_in_error; 
		}
		
		return array('is_duplicated_barcode' => $is_duplicated_barcode, 'messages' => $messages);
	}
}

?>
