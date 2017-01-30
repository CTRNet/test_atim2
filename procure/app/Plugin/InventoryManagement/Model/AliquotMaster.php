<?php

class AliquotMaster extends InventoryManagementAppModel {
	
	var $actsAs = array('MinMax', 'StoredItem');

	var $belongsTo = array(       
		'AliquotControl' => array(           
			'className'    => 'InventoryManagement.AliquotControl',            
			'foreignKey'    => 'aliquot_control_id',
			'type'			=> 'INNER'), 
		'Collection' => array(           
			'className'    => 'InventoryManagement.Collection',            
			'foreignKey'    => 'collection_id',
			'type'			=> 'INNER'),          
		'SampleMaster' => array(           
			'className'    => 'InventoryManagement.SampleMaster',            
			'foreignKey'    => 'sample_master_id',
			'type'			=> 'INNER'),        
		'StorageMaster' => array(           
			'className'    => 'StorageLayout.StorageMaster',            
			'foreignKey'    => 'storage_master_id'),        
		'StudySummary' => array(           
			'className'    => 'Study.StudySummary',            
			'foreignKey'    => 'study_summary_id'));
	
	var $hasOne = array(
		'ViewAliquot' => array(
			'className'   => 'InventoryManagement.ViewAliquot',
		 	'foreignKey'  => 'aliquot_master_id',
		 	'dependent' => true
		)
	);
	
	var $virtualFields = array(
		'in_stock_order'	=> 'IF(AliquotMaster.in_stock = "yes - available", 1, IF(AliquotMaster.in_stock = "yes - not available", 2, 3))'
	);
	
	private static $warning_field = "barcode";//can be overriden into a custom model
	
	public static $aliquot_type_dropdown = array();
	public static $storage_model = null;
	public static $study_model = null;
	
	private $barcodes = array();//barcode validation, key = barcode, value = id

	static public $volume_condition = array('OR' => array(array('AliquotControl.volume_unit' => NULL), array('AliquotControl.volume_unit' => '')));

	static public $join_aliquot_control_on_dup = array('table' => 'aliquot_controls', 'alias' => 'AliquotControl', 'type' => 'LEFT', 'conditions' => array('aliquot_masters_dup.aliquot_control_id = AliquotControl.id'));
	
	var $registered_view = array(
		'InventoryManagement.ViewAliquot' => array('AliquotMaster.id'),
		'InventoryManagement.ViewAliquotUse' => array('AliquotMaster.id', 'AliquotMasterChild.id')
	);
		
	function summary($variables=array()) {
		$return = false;
		
		if (isset($variables['Collection.id']) && isset($variables['SampleMaster.id']) && isset($variables['AliquotMaster.id'])) {
			
			$result = $this->find('first', array('conditions'=>array('AliquotMaster.collection_id'=>$variables['Collection.id'], 'AliquotMaster.sample_master_id'=>$variables['SampleMaster.id'], 'AliquotMaster.id'=>$variables['AliquotMaster.id'])));
			if(!isset($result['AliquotMaster']['storage_coord_y'])){
				$result['AliquotMaster']['storage_coord_y'] = "";
			}
			$return = array(
					'menu'	        	=> array(null, __($result['AliquotControl']['aliquot_type']) . ' : '. $result['AliquotMaster']['barcode']),
					'title'		  		=> array(null, __($result['AliquotControl']['aliquot_type']) . ' : '. $result['AliquotMaster']['barcode']),
					'data'				=> $result,
					'structure alias'	=> 'aliquot_masters'
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
				WHERE am.id='".$aliquot_master_id."' AND (
					(am.version_created >= sm.version_created AND 
					(am.version_created < smn.version_created OR smn.version_created IS NULL)) OR 
					(sm.version_created > am.version_created AND (sm.version_created <= amn.version_created OR amn.version_created IS NULL)) 
					OR am.storage_master_id IS NULL)";
		$storage_data_tmp = $this->tryCatchQuery($qry);
		
		$previous = array_shift($storage_data_tmp);
		while($current = array_shift($storage_data_tmp)){
			if($previous['sm']['id'] != $current['sm']['id']){
				//filter 1 - new storage
				$storage_data[]['custom'] = array(
					'date' => $current['am']['version_created'], 
					'event' => __('new storage')." "
						.__('from').": [".(strlen($previous['sm']['selection_label']) > 0 ? $previous['sm']['selection_label'].", ".__('position').": (".$previous['am']['storage_coord_x'].", ".$previous['am']['storage_coord_y']."), ".__('temperature').": ".$previous['sm']['temperature'].__($previous['sm']['temp_unit']) : __('no storage'))."] "
						.__('to').": [".(strlen($current['sm']['selection_label']) > 0 ? $current['sm']['selection_label'].", ".__('position').": (".$current['am']['storage_coord_x'].", ".$current['am']['storage_coord_y']."), ".__('temperature').": ".$current['sm']['temperature'].__($current['sm']['temp_unit']) : __('no storage'))."]");
			}else if($previous['sm']['temperature'] != $current['sm']['temperature'] || $previous['sm']['selection_label'] != $current['sm']['selection_label']){
				//filter 2, storage changes (temperature, label)
				$event = "";
				if($previous['sm']['temperature'] != $current['sm']['temperature']){
					$event .= __('storage temperature changed').". "
						.__('from').": ".(strlen($previous['sm']['temperature']) > 0 ? $previous['sm']['temperature'] : "?").__($previous['sm']['temp_unit'])." "
						.__('to').": ".(strlen($current['sm']['temperature']) > 0 ? $current['sm']['temperature'] : "?").__($current['sm']['temp_unit']).". ";
				}
				if($previous['sm']['selection_label'] != $current['sm']['selection_label']){
					$event .= __("selection label updated").". ".__("from").": ".$previous['sm']['selection_label']." ".__("to").": ".$current['sm']['selection_label'].". ";
				}
				$storage_data[]['custom'] = array(
					'date' => $current['sm']['version_created'], 
					'event' => $event);
			}else if($previous['am']['storage_coord_x'] != $current['am']['storage_coord_x'] || $previous['am']['storage_coord_y'] != $current['am']['storage_coord_y']){
				//filter 3, aliquot position change
				$coord_from = $previous['am']['storage_coord_x'].", ".$previous['am']['storage_coord_y'];
				$coord_to = $current['am']['storage_coord_x'].", ".$current['am']['storage_coord_y'];
				$storage_data[]['custom'] = array(
					'date' => $current['am']['version_created'], 
					'event' => __('moved within storage')." ".__('from').": [".$coord_from."] ".__('to').": [".$coord_to."]. ");
			}
			
			$previous = $current;
		}
		
		return $storage_data;
	}
	
	/****
	 * @deprecated
	 */
	function updateAliquotUseAndVolume($aliquot_master_id, $update_current_volume = true, $update_uses_counter = true, $remove_from_stock_if_empty_volume = false){
		return $this->updateAliquotVolume($aliquot_master_id, $remove_from_stock_if_empty_volume);
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
	 
	function updateAliquotVolume($aliquot_master_id, $remove_from_stock_if_empty_volume = false){
		if(empty($aliquot_master_id)){
			AppController::getInstance()->redirect('/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); 
		}

		// Get aliquot data
		$aliquot_data = $this->getOrRedirect($aliquot_master_id);

		// Set variables
		$aliquot_data_to_save = array();
		$aliquot_uses = null;
			
		// MANAGE CURRENT VOLUME
		
		$initial_volume = $aliquot_data['AliquotMaster']['initial_volume'];
				
		// Manage new current volume
		if(empty($initial_volume)){	
			// Initial_volume is null or equal to 0
			// To be sure value and type of both variables are identical
			$current_volume = $initial_volume;
					
		}else {
			// A value has been set for the intial volume		
			if((!is_numeric($initial_volume)) || ($initial_volume < 0)){
				AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
			}
					
			$total_used_volume = 0;
			$view_aliquot_use = AppModel::getInstance("InventoryManagement", "ViewAliquotUse", true);
			$aliquot_uses = $this->tryCatchQuery(str_replace('%%WHERE%%', "AND AliquotMaster.id= $aliquot_master_id", $view_aliquot_use::$table_query));
			foreach($aliquot_uses as $aliquot_use){
				$used_volume = $aliquot_use['0']['used_volume'];
				if(!empty($used_volume)){
					// Take used volume in consideration only when this one is not empty
					if((!is_numeric($used_volume)) || ($used_volume < 0)){
						AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
					}
					$total_used_volume += $used_volume;
				}
			}
			
			$current_volume = round(($initial_volume - $total_used_volume), 5);
			if($current_volume < 0){
				$current_volume = 0;
				$tmp_msg = __("the aliquot with barcode [%s] has reached a volume below 0");
				AppController::addWarningMsg(sprintf($tmp_msg, $aliquot_data['AliquotMaster']['barcode']));
			}
		}
		
		$aliquot_data_to_save["current_volume"] = $current_volume;
		if($current_volume <= 0 && $remove_from_stock_if_empty_volume){
			$aliquot_data_to_save['storage_master_id'] = NULL;
			$aliquot_data_to_save['storage_coord_x'] = NULL;
			$aliquot_data_to_save['storage_coord_y'] = NULL;
			$aliquot_data_to_save['in_stock'] = 'no';
			$aliquot_data_to_save['in_stock_detail'] = 'empty';
		}	
		
		// SAVE DATA
		
		$aliquot_data_to_save['id'] = $aliquot_master_id;
		
		//---------------------------------------------------------
		// Set data to empty array to guaranty 
		// no merge will be done with previous AliquotMaster data
		// when AliquotMaster set() function will be called again.
		//---------------------------------------------------------
		$this->data = array();	//
		$this->id = $aliquot_master_id;
		$this->read();
		$save_required = false;
		foreach($aliquot_data_to_save as $key_to_save => $value_to_save){
			if($key_to_save == "current_volume") $this->data['AliquotMaster'][$key_to_save] = str_replace('0.00000', '0', $this->data['AliquotMaster'][$key_to_save]);
			if(strcmp($this->data['AliquotMaster'][$key_to_save], $value_to_save)){		
				$save_required = true;
			}
		}
		
		$prev_check_writable_fields = $this->check_writable_fields;
		$this->check_writable_fields = false;
		$result = $save_required && !$this->save(array("AliquotMaster" => $aliquot_data_to_save), false);
		$this->check_writable_fields = $prev_check_writable_fields;
		return !$result;
	}
	
	public function getRealiquotDropdown(){
		return self::$aliquot_type_dropdown;	
	}
	
	/**
	 * @desc Additional validation rule to validate stock status and storage.
	 * @see Model::validates()
	 */
	function validates($options = array()){
		if(isset($this->data['AliquotMaster']['in_stock']) && $this->data['AliquotMaster']['in_stock'] == 'no' 
		&& (!empty($this->data['AliquotMaster']['storage_master_id']) || !empty($this->data['FunctionManagement']['recorded_storage_selection_label']))){
			$this->validationErrors['in_stock'][] = 'an aliquot being not in stock can not be linked to a storage';
		}
		
		$this->validateAndUpdateAliquotStorageData();
		
		$this->validateAndUpdateAliquotStudyData();
		
		if(isset($this->data['AliquotMaster']['barcode'])){
			$this->checkDuplicatedAliquotBarcode($this->data);
		}	
		
		return parent::validates($options);
	}
	
	/**
	 * Check both aliquot storage definition and aliquot positions and set error if required.
	 */
	 
	function validateAndUpdateAliquotStorageData() {
		$aliquot_data =& $this->data;
		
		// check data structure
		$tmp_arr_to_check = array_values($aliquot_data);
		if((!is_array($aliquot_data)) || (is_array($tmp_arr_to_check) && isset($tmp_arr_to_check[0]['AliquotMaster']))) {
			AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		
		// Load model
		if(self::$storage_model == null){
			self::$storage_model = AppModel::getInstance("StorageLayout", "StorageMaster", true);
		}
				
		// Launch validation		
		if(array_key_exists('FunctionManagement', $aliquot_data) && array_key_exists('recorded_storage_selection_label', $aliquot_data['FunctionManagement'])) {
			if(!isset($aliquot_data['AliquotControl']['aliquot_type'])) {
				AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}
			$is_sample_core = ($aliquot_data['AliquotControl']['aliquot_type'] == 'core');
			
			// Check the aliquot storage definition
			$arr_storage_selection_results = self::$storage_model->validateAndGetStorageData($aliquot_data['FunctionManagement']['recorded_storage_selection_label'], $aliquot_data['AliquotMaster']['storage_coord_x'], $aliquot_data['AliquotMaster']['storage_coord_y'], $is_sample_core);
			
			$set_storage = false;
			foreach(array('storage_data', 'storage_definition_error', 'position_x_error', 'position_y_error', 'change_position_x_to_uppercase', 'change_position_y_to_uppercase') as $key){
				if(!empty($arr_storage_selection_results[$key])){
					$set_storage = true;
				}
			}
			
			if($set_storage){
				// Update aliquot data
				$aliquot_data['AliquotMaster']['storage_master_id'] = isset($arr_storage_selection_results['storage_data']['StorageMaster']['id'])? $arr_storage_selection_results['storage_data']['StorageMaster']['id'] : null;
				if($arr_storage_selection_results['change_position_x_to_uppercase']){
					$aliquot_data['AliquotMaster']['storage_coord_x'] = strtoupper($aliquot_data['AliquotMaster']['storage_coord_x']);
				}
				if($arr_storage_selection_results['change_position_y_to_uppercase']){
					$aliquot_data['AliquotMaster']['storage_coord_y'] = strtoupper($aliquot_data['AliquotMaster']['storage_coord_y']);
				}
				
				// Set error
				if(!empty($arr_storage_selection_results['storage_definition_error'])){
					$this->validationErrors['recorded_storage_selection_label'][] = $arr_storage_selection_results['storage_definition_error'];
				}
				if(!empty($arr_storage_selection_results['position_x_error'])){
					$this->validationErrors['storage_coord_x'][] = $arr_storage_selection_results['position_x_error'];
				}
				if(!empty($arr_storage_selection_results['position_y_error'])){
					$this->validationErrors['storage_coord_y'][] = $arr_storage_selection_results['position_y_error'];
				}
				
				if(empty($this->validationErrors['storage_coord_x']) 
					&& empty($this->validationErrors['storage_coord_y'])
					&& array_key_exists('StorageControl', $arr_storage_selection_results['storage_data']) 
					&& $arr_storage_selection_results['storage_data']['StorageControl']['check_conflicts']
					&& (strlen($aliquot_data['AliquotMaster']['storage_coord_x']) > 0 || strlen($aliquot_data['AliquotMaster']['storage_coord_y']) > 0)
				){
					$exception = $this->id ? array('AliquotMaster' => $this->id) : array();
					$position_status = $this->StorageMaster->positionStatusQuick(
						$arr_storage_selection_results['storage_data']['StorageMaster']['id'], 
						array(
							'x' => $aliquot_data['AliquotMaster']['storage_coord_x'], 
							'y' => $aliquot_data['AliquotMaster']['storage_coord_y']
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
							$arr_storage_selection_results['storage_data']['StorageMaster']['selection_label'],
							$aliquot_data['AliquotMaster']['storage_coord_x'],
							$aliquot_data['AliquotMaster']['storage_coord_y']
						);
						if($arr_storage_selection_results['storage_data']['StorageControl']['check_conflicts'] == 1){
							AppController::addWarningMsg($msg);
						}else{
							$this->validationErrors['storage_coord_x'][] = $msg;
						}
					}
				}
			}else{
				$aliquot_data['AliquotMaster']['storage_master_id'] = null;
			}

		} else if ((array_key_exists('storage_coord_x', $aliquot_data['AliquotMaster']) && !empty($aliquot_data['AliquotMaster']['storage_coord_x'])) 
			|| (array_key_exists('storage_coord_y', $aliquot_data['AliquotMaster']) && !empty($aliquot_data['AliquotMaster']['storage_coord_y'])) 
		){
			AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
	}
	
	/**
	 * Check aliquot study definition and set error if required.
	 */
	 
	function validateAndUpdateAliquotStudyData() {
		$aliquot_data =& $this->data;
		
		// check data structure
		$tmp_arr_to_check = array_values($aliquot_data);
		if((!is_array($aliquot_data)) || (is_array($tmp_arr_to_check) && isset($tmp_arr_to_check[0]['AliquotMaster']))) {
			AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		
		// Launch validation
		if(array_key_exists('FunctionManagement', $aliquot_data) && array_key_exists('autocomplete_aliquot_master_study_summary_id', $aliquot_data['FunctionManagement'])) {
			$aliquot_data['AliquotMaster']['study_summary_id'] = null;
			$aliquot_data['FunctionManagement']['autocomplete_aliquot_master_study_summary_id'] = trim($aliquot_data['FunctionManagement']['autocomplete_aliquot_master_study_summary_id']);
			if(strlen($aliquot_data['FunctionManagement']['autocomplete_aliquot_master_study_summary_id'])) {
				// Load model
				if(self::$study_model == null) self::$study_model = AppModel::getInstance("Study", "StudySummary", true);
					
				// Check the aliquot study definition
				$arr_study_selection_results = self::$study_model->getStudyIdFromStudyDataAndCode($aliquot_data['FunctionManagement']['autocomplete_aliquot_master_study_summary_id']);
				
				// Set study summary id
				if(isset($arr_study_selection_results['StudySummary'])){
					$aliquot_data['AliquotMaster']['study_summary_id'] = $arr_study_selection_results['StudySummary']['id'];
				}
				
				// Set error
				if(isset($arr_study_selection_results['error'])){
					$this->validationErrors['autocomplete_aliquot_master_study_summary_id'][] = $arr_study_selection_results['error'];
				}
			}
		
		}
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
	 
	function checkDuplicatedAliquotBarcode($aliquot_data) {
			
		// check data structure
		$tmp_arr_to_check = array_values($aliquot_data);
		if((!is_array($aliquot_data)) || (is_array($tmp_arr_to_check) && isset($tmp_arr_to_check[0]['AliquotMaster']))) {
			AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
				
		$barcode = $aliquot_data['AliquotMaster']['barcode'];
		
		// Check duplicated barcode into submited record
		if(!strlen($barcode)) {
			// Not studied
		} else if(isset($this->barcodes[$barcode])) {
			$this->validationErrors['barcode'][] = str_replace('%s', $barcode, __('you can not record barcode [%s] twice'));
		} else {
			$this->barcodes[$barcode] = '';
		}
		
		// Check duplicated barcode into db
		$criteria = array('AliquotMaster.barcode' => $barcode);
		$aliquots_having_duplicated_barcode = $this->find('all', array('conditions' => array('AliquotMaster.barcode' => $barcode), 'recursive' => -1));;
		if(!empty($aliquots_having_duplicated_barcode)) {
			foreach($aliquots_having_duplicated_barcode as $duplicate) {
				if((!array_key_exists('id', $aliquot_data['AliquotMaster'])) || ($duplicate['AliquotMaster']['id'] != $aliquot_data['AliquotMaster']['id'])) {
					$this->validationErrors['barcode'][] = str_replace('%s', $barcode, __('the barcode [%s] has already been recorded'));
				}
			}			
		}
	}
	
	function hasChild(array $aliquot_master_ids){
		$ViewAliquotUse = AppModel::getInstance("InventoryManagement", "ViewAliquotUse", TRUE);
		return array_unique(array_filter($ViewAliquotUse->find('list', array('fields' => array('ViewAliquotUse.aliquot_master_id'), 'conditions' => array('ViewAliquotUse.aliquot_master_id' => $aliquot_master_ids)))));
	}
	
	
	/**
	 * Get default storage date for a new created aliquot.
	 * 
	 * @param $sample_master_data Master data of the studied sample.
	 * 
	 * @return Default storage date.
	 *
	 * @author N. Luc
	 * @since 2009-09-11
	 * @updated N. Luc
	 * @deprecated
	 */
	function getDefaultStorageDate($sample_master_data) {
		list($date, $date_accuaracy) = $this->getDefaultStorageDateAndAccuracy($sample_master_data);
		return strlen($date)? $date : null;
	}
	
	/**
	 * Get default storage date and accuracy for a new created aliquot.
	 *
	 * @param $sample_master_data Master data of the studied sample.
	 *
	 * @return array(default storage date, accuracy).
	 *
	 * @author N. Luc
	 * @since 2016-09-29
	 * @updated N. Luc
	 */
	function getDefaultStorageDateAndAccuracy($sample_master_data) {
	
		$sample_master_model = AppModel::getInstance("InventoryManagement", "SampleMaster", true);
		$derivative_detail_model = AppModel::getInstance("InventoryManagement", "DerivativeDetail", true);
		switch($sample_master_data['SampleControl']['sample_category']) {
			case 'specimen':
				// Default creation date will be the specimen reception date
				$sample_master = $sample_master_model->getOrRedirect($sample_master_data['SampleMaster']['id']);
				return array($sample_master['SpecimenDetail']['reception_datetime'], $sample_master['SpecimenDetail']['reception_datetime_accuracy']);
	
			case 'derivative':
				// Default creation date will be the derivative creation date or Specimen reception date
				$derivative_detail_data = $derivative_detail_model->find('first', array('conditions' => array('DerivativeDetail.sample_master_id' => $sample_master_data['SampleMaster']['id']), 'recursive' => '-1'));
				if(empty($derivative_detail_data)) {
					$this->redirect('/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true);
				}
	
				return array($derivative_detail_data['DerivativeDetail']['creation_datetime'], $derivative_detail_data['DerivativeDetail']['creation_datetime_accuracy']);
	
			default:
				$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
	
		return array('', '');
	}
	
	/**
	 * Check if an aliquot can be deleted.
	 * 
	 * @param $aliquot_master_id Id of the studied sample.
	 * 
	 * @return Return results as array:
	 * 	['allow_deletion'] = true/false
	 * 	['msg'] = message to display when previous field equals false
	 * 
	 * @author N. Luc
	 * @since 2007-10-16
	 */
	function allowDeletion($aliquot_master_id){
		// Check aliquot has no use
		$aliquot_internal_use_model = AppModel::getInstance("InventoryManagement", "AliquotInternalUse", true);	
		$returned_nbr = $aliquot_internal_use_model->find('count', array('conditions' => array('AliquotInternalUse.aliquot_master_id' => $aliquot_master_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { 
			return array('allow_deletion' => false, 'msg' => 'use exists for the deleted aliquot'); 
		}
	
		// Check aliquot is not linked to realiquoting process	
		$realiquoting_model = AppModel::getInstance("InventoryManagement", "Realiquoting", true);
		$returned_nbr = $realiquoting_model->find('count', array('conditions' => array('Realiquoting.parent_aliquot_master_id' => $aliquot_master_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { 
			return array('allow_deletion' => false, 'msg' => 'realiquoting data exists for the deleted aliquot'); 
		}

		// Check aliquot is not linked to review	
		$aliquot_review_master_model = AppModel::getInstance("InventoryManagement", "AliquotReviewMaster", true);
		$returned_nbr = $aliquot_review_master_model->find('count', array('conditions' => array('AliquotReviewMaster.aliquot_master_id' => $aliquot_master_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { 
			return array('allow_deletion' => false, 'msg' => 'review exists for the deleted aliquot'); 
		}
	
		// Check aliquot is not linked to order
		$order_item_model = AppModel::getInstance("Order", "OrderItem", true);
		$returned_nbr = $order_item_model->find('count', array('conditions' => array('OrderItem.aliquot_master_id' => $aliquot_master_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { 
			return array('allow_deletion' => false, 'msg' => 'order exists for the deleted aliquot'); 
		}

		// Check aliquot is not linked to a qc	
		$quality_ctrl_model = AppModel::getInstance("InventoryManagement", "QualityCtrl", true);
		$returned_nbr = $quality_ctrl_model->find('count', array('conditions' => array('QualityCtrl.aliquot_master_id' => $aliquot_master_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { 
			return array('allow_deletion' => false, 'msg' => 'quality control data exists for the deleted aliquot'); 
		}
		
		// Check aliquot is not linked to a derivative	
		$source_aliquot_model = AppModel::getInstance("InventoryManagement", "SourceAliquot", true);
		$returned_nbr = $source_aliquot_model->find('count', array('conditions' => array('SourceAliquot.aliquot_master_id' => $aliquot_master_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { 
			return array('allow_deletion' => false, 'msg' => 'derivative creation data exists for the deleted aliquot'); 
		}

		return array('allow_deletion' => true, 'msg' => '');
	}
	
	/**
	 * Get the default realiquoting date.
	 * 
	 * @param $aliquot_data_for_selection Sample Aliquots that could be defined as child.
	 * 
	 * @return Default realiquoting date.
	 *
	 * @author N. Luc
	 * @since 2009-09-11
	 * @updated N. Luc
	 */
	function getDefaultRealiquotingDate($aliquot_data_for_selection) {
		// Get first found storage datetime
		foreach($aliquot_data_for_selection as $aliquot) {
			if(!empty($aliquot['AliquotMaster']['storage_datetime'])) { 
				return $aliquot['AliquotMaster']['storage_datetime']; 
			}
		}
		return null;
	}
	
	
	/**
	 * @param array $aliquot with either a key 'id' referring to an array
	 * of ids, or a key 'data' referring to AliquotMaster.
	 * @param $model_name If the aliquot array contains data, the model name
	 * to use.
	 * @return an array having unconsented aliquot as key and their consent 
	 * status as value. This function refers to 
	 * ViewCollection->getUnconsentedCollections.
	 */
	function getUnconsentedAliquots(array $aliquot, $model_name = 'AliquotMaster'){
		$data = null;
		$key_name = null;
		//preping to fetch the collection ids
		if(array_key_exists('id', $aliquot)){
			$data = $this->find('all', array(
				'fields' => array('AliquotMaster.id', 'AliquotMaster.collection_id'),
				'conditions' => array('AliquotMaster.id' => $aliquot['id']),
				'recursive' => -1
			));
			$model_name = 'AliquotMaster';
			$key_name = 'id';
		}else{
			$data = array_key_exists($model_name, $aliquot) ? array($aliquot) : $aliquot;
			if($model_name == 'ViewAliquot'){
				$key_name = $model_name == 'AliquotMaster' ? 'id' : 'aliquot_master_id'; 
			}
		}
		
		//collections ids and collection/aliquot assocs
		$collection_aliquot_assoc = array();
		$collection_ids = array();
		foreach($data as &$data_unit){
			$collection_aliquot_assoc[$data_unit[$model_name]['collection_id']][] = $data_unit[$model_name][$key_name];
			$collection_ids[] = $data_unit[$model_name]['collection_id']; 
		}
		
		//getting unconsented collections
		$collection_model = AppModel::getInstance("InventoryManagement", "ViewCollection", true);
		$unconsented_collections = $collection_model->getUnconsentedParticipantCollections(array('id' => $collection_ids));
		
		//building the result array
		$results = array();
		foreach($unconsented_collections as $collection_id => $status){
			$results += array_fill_keys($collection_aliquot_assoc[$collection_id], $status);
		}
		
		return $results;
	}
	
	function beforeFind($queryData){
		$queryData['joins'][] = array(
			'table' => 'sample_masters',
			'alias'	=> 'sample_master_dup',
			'type'	=> 'INNER',
			'conditions' => array('AliquotMaster.sample_master_id = sample_master_dup.id')
		);
		$queryData['joins'][] = array(
			'table' => 'sample_controls',
			'alias'	=> 'SampleControl',
			'type'	=> 'INNER',
			'conditions' => array('sample_master_dup.sample_control_id = SampleControl.id')
		);
		if(empty($queryData['fields'])){
			$queryData['fields'] = array('*');
		}
		
		return $queryData;
	}
	
	function atimDelete($model_id, $cascade = true){
		if(parent::atimDelete($model_id, $cascade)){
			//delete realiquotings where current id is child
			$realiquoting_model = AppModel::getInstance('InventoryManagement', 'Realiquoting', true);
			$realiquotings = $realiquoting_model->find('all', array('conditions' => array('Realiquoting.child_aliquot_master_id' => $model_id)));
			$parents = array();
			foreach($realiquotings as $realiquoting){
				$parents[] = $realiquoting['Realiquoting']['parent_aliquot_master_id'];
				$realiquoting_model->atimDelete($realiquoting['Realiquoting']['id']);
			}
			$parents = array_unique($parents);
			foreach($parents as $parent){
				$this->updateAliquotVolume($parent);
			}
			return true;
		}
		return false;
	}
	
	static function joinOnAliquotDup($on_field){
		return array('table' => 'aliquot_masters', 'alias' => 'aliquot_masters_dup', 'type' => 'LEFT', 'conditions' => array($on_field.' = aliquot_masters_dup.id'));
	}
	
	function validateAliquotMasterDataUpdateInBatch($function_management_data, $submitted_aliquot_master_data, $aliquot_ids) {
		//Set in_stock value	
		//Use of field 'FunctionManagement.in_stock' to support empty value that means 'in_stock' value has not to be changed 
		//(Can not use field AliquotMaster.in_stock value because this one is linked to a 'not empty' validation)
		$submitted_aliquot_master_data['in_stock'] = $function_management_data['in_stock'];	
		
		$validates = true;
			
		// Check submitted data conflicts
			
		if(strlen($function_management_data['recorded_storage_selection_label']) && (($function_management_data['remove_from_storage'] == '1') || ($submitted_aliquot_master_data['in_stock'] == 'no'))) {
			$validates = false;
			$this->validationErrors['recorded_storage_selection_label'][] = __('data conflict: you can not remove aliquot and set a storage');
			if($submitted_aliquot_master_data['in_stock'] == 'no') $this->validationErrors['in_stock'][] = __('data conflict: you can not remove aliquot and set a storage');
		}
		if(isset($function_management_data['autocomplete_aliquot_master_study_summary_id']) && strlen($function_management_data['autocomplete_aliquot_master_study_summary_id']) && $function_management_data['remove_study_summary_id'] == '1') {
			$validates = false;
			$this->validationErrors['autocomplete_aliquot_master_study_summary_id'][] = __('data conflict: you can not delete data and set a new one');
		}		
		foreach($submitted_aliquot_master_data as $key => $value) {
			if(strlen($submitted_aliquot_master_data[$key]) && array_key_exists('remove_'.$key, $function_management_data) && $function_management_data['remove_'.$key] == '1') {
				$validates = false;
				$this->validationErrors[$key][] = __('data conflict: you can not delete data and set a new one');
			}
		}
			
		// Set gerenated aliquot master data plus launch validation on this data set
		
		$aliquot_master_data_to_update = array('AliquotMaster' => array_filter($submitted_aliquot_master_data));
		$position_deletion_warning_message = null;
		
		if($validates){
			// Work on storage data
			if($function_management_data['recorded_storage_selection_label']) {
				$aliquot_master_data_to_update['FunctionManagement']['recorded_storage_selection_label'] = $function_management_data['recorded_storage_selection_label'];
				$aliquot_master_data_to_update['AliquotMaster']['storage_coord_x'] = null;
				$aliquot_master_data_to_update['AliquotMaster']['storage_coord_y'] = null;
				$this->addWritableField(array('storage_master_id', 'storage_coord_x', 'storage_coord_y'));
					
				$position_deletion_warning_message = 'aliquots positions have been deleted';
					
				if(empty($submitted_aliquot_master_data['in_stock'])) {
					//New stock value has not been set then won't be updated: Control above detected no conflict - Check data in db
					$condtions = array('AliquotMaster.id' => $aliquot_ids, 'AliquotMaster.in_stock' => 'no');
					$aliquot_not_in_stock = $this->find('count', array('conditions' => $condtions, 'recursive' => '-1'));
					if($aliquot_not_in_stock) {
						$validates = false;
						$position_deletion_warning_message = '';
						$this->validationErrors['recorded_storage_selection_label'][] = __('data conflict: at least one updated aliquot is defined as not in stock - please update in stock value');
					}
				}
					
			} else if(($function_management_data['remove_from_storage'] == '1') || ($submitted_aliquot_master_data['in_stock'] == 'no')) {
				//Aliquots not in stcok anymore : Erase storage data
				$aliquot_master_data_to_update['AliquotMaster']['storage_master_id'] = null;
				$aliquot_master_data_to_update['AliquotMaster']['storage_coord_x'] = null;
				$aliquot_master_data_to_update['AliquotMaster']['storage_coord_y'] = null;
				$this->addWritableField(array('storage_master_id', 'storage_coord_x', 'storage_coord_y'));
			}
			// Work on study
			if(isset($function_management_data['autocomplete_aliquot_master_study_summary_id']) && $function_management_data['autocomplete_aliquot_master_study_summary_id']) {
				$aliquot_master_data_to_update['FunctionManagement']['autocomplete_aliquot_master_study_summary_id'] = $function_management_data['autocomplete_aliquot_master_study_summary_id'];
				$this->addWritableField(array('study_summary_id'));					
			} else if(isset($function_management_data['remove_study_summary_id']) && ($function_management_data['remove_study_summary_id'] == '1')) {
				$aliquot_master_data_to_update['AliquotMaster']['study_summary_id'] = null;
				$this->addWritableField(array('study_summary_id'));
			}
			// Work on other data
			foreach($submitted_aliquot_master_data as $key => $value) {
				if(array_key_exists('remove_'.$key, $function_management_data) && $function_management_data['remove_'.$key] == '1') {
					$aliquot_master_data_to_update['AliquotMaster'][$key] = null;
				}
			}
		}
		if($validates){
			$aliquot_master_data_to_update['AliquotMaster']['aliquot_control_id'] = 1;//to allow validation, remove afterward
			$not_core_nbr = $this->find('count', array('conditions' => array('AliquotMaster.id' => $aliquot_ids, "AliquotControl.aliquot_type != 'core'")));
			$aliquot_master_data_to_update['AliquotControl']['aliquot_type'] = $not_core_nbr? 'not core' : 'core'; //to allow tma storage check (check aliquot != than core is not stored into TMA block), remove afterward
			$this->set($aliquot_master_data_to_update);
			if(!$this->validates()){
				$validates = false;
			}
			$aliquot_master_data_to_update= $this->data;
			unset($aliquot_master_data_to_update['AliquotMaster']['aliquot_control_id']);
			unset($aliquot_master_data_to_update['AliquotControl']['aliquot_type']);
		}
		
		if(sizeof($aliquot_master_data_to_update['AliquotMaster']) == '1' && array_key_exists('__validated__', $aliquot_master_data_to_update['AliquotMaster'])) $aliquot_master_data_to_update['AliquotMaster'] = array();	//No data to save
		
		return array($aliquot_master_data_to_update, $validates, $position_deletion_warning_message);	
	}
	
	function getAliquotDataStorageAndStockToApplyToAll($data) {
		$errors = array();
		$used_aliquot_data_to_apply_to_all = array();
		if(isset($data['FunctionManagement']) && array_key_exists('in_stock', $data['FunctionManagement'])) {
			if($data['FunctionManagement']['remove_in_stock_detail'] && strlen($data['AliquotMaster']['in_stock_detail'])) {
				$errors['in_stock_detail'][__('data conflict: you can not delete data and set a new one')][] = __('data to apply to all');
				$data['FunctionManagement']['remove_in_stock_detail'] = '';
				$data['AliquotMaster']['in_stock_detail'] = '';
			}
			//In stock detail of parent to apply to all
			foreach(array('FunctionManagement','AliquotMaster') as $tmp_model) {
				if(isset($data[$tmp_model])) {
					foreach($data[$tmp_model] as $tmp_field => $tmp_field_value) {
						if(!empty($data[$tmp_model][$tmp_field])) {
							if($tmp_model.'.'.$tmp_field == 'FunctionManagement.in_stock') {
								$used_aliquot_data_to_apply_to_all['AliquotMaster'][$tmp_field] = $data[$tmp_model][$tmp_field];
							} else if($tmp_model.'.'.$tmp_field == 'FunctionManagement.remove_in_stock_detail') {
								$used_aliquot_data_to_apply_to_all['AliquotMaster']['in_stock_detail'] = '';
							} else {
								$used_aliquot_data_to_apply_to_all[$tmp_model][$tmp_field] = $data[$tmp_model][$tmp_field];
							}
						}
					}
				}
			}
		}
		return array($used_aliquot_data_to_apply_to_all, $errors);
	}
		
}