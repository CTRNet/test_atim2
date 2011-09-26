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
	
	var $hasOne = array(
		'SpecimenDetail' => array(
			'className'   => 'Inventorymanagement.SpecimenDetail',
			 	'foreignKey'  => 'sample_master_id',
			 	'dependent' => true)
	);
	
	private static $warning_field = "barcode";//can be overriden into a custom model
	
	public static $aliquot_type_dropdown = array();
	public static $storage = null;
	
	private $barcodes = array();//barcode validation, key = barcode, value = id

	static public $volume_condition = array('OR' => array(array('AliquotMaster.aliquot_volume_unit' => NULL), array('AliquotMaster.aliquot_volume_unit' => ''))); 
		
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
				WHERE am.id='".$aliquot_master_id."' AND (
					(am.version_created >= sm.version_created AND 
					(am.version_created < smn.version_created OR smn.version_created IS NULL)) OR 
					(sm.version_created > am.version_created AND (sm.version_created <= amn.version_created OR amn.version_created IS NULL)) 
					OR am.storage_master_id IS NULL)";
		$storage_data_tmp = $this->query($qry);
		
		$previous = array_shift($storage_data_tmp);
		while($current = array_shift($storage_data_tmp)){
			if($previous['sm']['id'] != $current['sm']['id']){
				//filter 1 - new storage
				$storage_data[]['custom'] = array(
					'date' => $current['am']['version_created'], 
					'event' => __('new storage', true)." "
						.__('from', true).": [".(strlen($previous['sm']['selection_label']) > 0 ? $previous['sm']['selection_label'].", ".__('position', true).": (".$previous['am']['storage_coord_x'].", ".$previous['am']['storage_coord_y']."), ".__('temperature', true).": ".$previous['sm']['temperature'].__($previous['sm']['temp_unit'], true) : __('no storage', true))."] "
						.__('to', true).": [".(strlen($current['sm']['selection_label']) > 0 ? $current['sm']['selection_label'].", ".__('position', true).": (".$current['am']['storage_coord_x'].", ".$current['am']['storage_coord_y']."), ".__('temperature', true).": ".$current['sm']['temperature'].__($current['sm']['temp_unit'], true) : __('no storage', true))."]");
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
					'date' => $current['sm']['version_created'], 
					'event' => $event);
			}else if($previous['am']['storage_coord_x'] != $current['am']['storage_coord_x'] || $previous['am']['storage_coord_y'] != $current['am']['storage_coord_y']){
				//filter 3, aliquot position change
				$coord_from = $previous['am']['storage_coord_x'].", ".$previous['am']['storage_coord_y'];
				$coord_to = $current['am']['storage_coord_x'].", ".$current['am']['storage_coord_y'];
				$storage_data[]['custom'] = array(
					'date' => $current['am']['version_created'], 
					'event' => __('moved within storage', true)." ".__('from', true).": [".$coord_from."] ".__('to', true).": [".$coord_to."]. ");
			}
			
			$previous = $current;
		}
		
		return $storage_data;
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
	 
	function updateAliquotUseAndVolume($aliquot_master_id, $update_current_volume = true, $update_uses_counter = true, $remove_from_stock_if_empty_volume = false){
		if(empty($aliquot_master_id)){
			AppController::getInstance()->redirect('/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); 
		}

		// Get aliquot data
		$aliquot_data = $this->find('first', array('conditions' => array('AliquotMaster.id' => $aliquot_master_id)));
		if(empty($aliquot_data)){
			AppController::getInstance()->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		}

		// Set variables
		$aliquot_data_to_save = array();
		$aliquot_uses = null;
		
		if($update_current_volume) {
			
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
					AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
				}
						
				$total_used_volume = 0;
				$view_aliquot_use = AppModel::getInstance("inventorymanagement", "ViewAliquotUse", true);
				$aliquot_uses = $view_aliquot_use->findFastFromAliquotMasterId($aliquot_master_id);
				foreach($aliquot_uses as $id => $aliquot_use){
					$used_volume = $aliquot_use['ViewAliquotUse']['used_volume'];
					if(!empty($used_volume)){
						// Take used volume in consideration only when this one is not empty
						if((!is_numeric($used_volume)) || ($used_volume < 0)){
							AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
						}
						$total_used_volume += $used_volume;
					}
				}
				
				$current_volume = round(($initial_volume - $total_used_volume), 5);
				if($current_volume < 0){
					$current_volume = 0;
					$tmp_msg = __("the aliquot with barcode [%s] has reached a volume bellow 0", true);
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
		}
		
		if($update_uses_counter) {
			
			// UPDATE ALIQUOT USE COUNTER	
		
			if(is_null($aliquot_uses)) {
				$view_aliquot_use = AppModel::getInstance("inventorymanagement", "ViewAliquotUse", true);
				$aliquot_uses = $view_aliquot_use->findFastFromAliquotMasterId($aliquot_master_id);
			}
			
			$aliquot_data_to_save['use_counter'] = sizeof($aliquot_uses);
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
			if($this->data['AliquotMaster'][$key_to_save] != $value_to_save){
				$save_required = true;
			}
		}
		
		if($save_required && !$this->save(array("AliquotMaster" => $aliquot_data_to_save), false)){
			return false;
		}
		return true;
	}
	
	public function getRealiquotDropdown(){
		return self::$aliquot_type_dropdown;	
	}
	
	/**
	 * @desc Additional validation rule to validate stock status and storage.
	 * @see Model::validates()
	 */
	function validates($options = array()){
		pr('WARNING!!: aliquot storage data can be updated into AliquotMaster->validates() function: be sure to reset data into controller using $this->AliquotMaster->data!');
		
		if(isset($this->data['AliquotMaster']['in_stock']) && $this->data['AliquotMaster']['in_stock'] == 'no' 
		&& (!empty($this->data['AliquotMaster']['storage_master_id']) || !empty($this->data['FunctionManagement']['recorded_storage_selection_label']))){
			$this->validationErrors['in_stock'] = 'an aliquot being not in stock can not be linked to a storage';
		}
		
		$this->validateAndUpdateAliquotStorageData();
		
		if(isset($this->data['AliquotMaster']['barcode'])){
			$this->checkDuplicatedAliquotBarcode($this->data);
		}		
		parent::validates($options);
		
		return empty($this->validationErrors);
	}
	
	/**
	 * Check both aliquot storage definition and aliquot positions and set error if required.
	 */
	 
	function validateAndUpdateAliquotStorageData() {
		$aliquot_data =& $this->data;
		
		// check data structure
		$tmp_arr_to_check = array_values($aliquot_data);
		if((!is_array($aliquot_data)) || (is_array($tmp_arr_to_check) && isset($tmp_arr_to_check[0]['AliquotMaster']))) {
			AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		
		// Load model
		if(self::$storage == null){
			self::$storage = AppModel::getInstance("storagelayout", "StorageMaster", true);
		}
				
		// Launch validation		
		if(array_key_exists('FunctionManagement', $aliquot_data) && array_key_exists('recorded_storage_selection_label', $aliquot_data['FunctionManagement'])) {
			$is_sample_core = isset($aliquot_data['AliquotMaster']['aliquot_type']) && ($aliquot_data['AliquotMaster']['aliquot_type'] == 'core');
			
			// Check the aliquot storage definition
			$arr_storage_selection_results = self::$storage->validateAndGetStorageData($aliquot_data['FunctionManagement']['recorded_storage_selection_label'], $aliquot_data['AliquotMaster']['storage_coord_x'], $aliquot_data['AliquotMaster']['storage_coord_y'], $is_sample_core);
			
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
					$this->validationErrors['recorded_storage_selection_label'] = $arr_storage_selection_results['storage_definition_error'];
				}
				if(!empty($arr_storage_selection_results['position_x_error'])){
					$this->validationErrors['storage_coord_x'] = $arr_storage_selection_results['position_x_error'];
				}
				if(!empty($arr_storage_selection_results['position_y_error'])){
					$this->validationErrors['storage_coord_y'] = $arr_storage_selection_results['position_y_error'];
				}
				
				if(empty($this->validationErrors['storage_coord_x']) 
					&& empty($this->validationErrors['storage_coord_y'])
					&& array_key_exists('StorageControl', $arr_storage_selection_results['storage_data']) 
					&& $arr_storage_selection_results['storage_data']['StorageControl']['check_conficts']
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
						$msg = __('the storage [%s] already contained something at position [%s, %s]', true);
					}else if($position_status == StorageMaster::POSITION_DOUBLE_SET){
						$msg = __('you have set more than one element in storage [%s] at position [%s, %s]', true);
					}
					if($msg != null){
						$msg = sprintf($msg, 
							$arr_storage_selection_results['storage_data']['StorageMaster']['selection_label'],
							$aliquot_data['AliquotMaster']['storage_coord_x'],
							$aliquot_data['AliquotMaster']['storage_coord_y']
						);
						if($arr_storage_selection_results['storage_data']['StorageControl']['check_conficts'] == 1){
							AppController::addWarningMsg($msg);
						}else{
							$this->validationErrors['storage_coord_x'] = $msg;
						}
					}
				}
			}else{
				$aliquot_data['AliquotMaster']['storage_master_id'] = null;
			}

		} else if ((array_key_exists('storage_coord_x', $aliquot_data['AliquotMaster']) && !empty($aliquot_data['AliquotMaster']['storage_coord_x'])) 
			|| (array_key_exists('storage_coord_y', $aliquot_data['AliquotMaster']) && !empty($aliquot_data['AliquotMaster']['storage_coord_y'])) 
		){
			AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
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
			AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
				
		$barcode = $aliquot_data['AliquotMaster']['barcode'];
		
		// Check duplicated barcode into submited record
		if(empty($barcode)) {
			// Not studied
		} else if(isset($this->barcodes[$barcode])) {
			$this->validationErrors['barcode'] = str_replace('%s', $barcode, __('you can not record barcode [%s] twice', true));
		} else {
			$this->barcodes[$barcode] = '';
		}
		
		// Check duplicated barcode into db
		$criteria = array('AliquotMaster.barcode' => $barcode);
		$aliquots_having_duplicated_barcode = $this->find('all', array('conditions' => array('AliquotMaster.barcode' => $barcode), 'recursive' => -1));;
		if(!empty($aliquots_having_duplicated_barcode)) {
			foreach($aliquots_having_duplicated_barcode as $duplicate) {
				if((!array_key_exists('id', $aliquot_data['AliquotMaster'])) || ($duplicate['AliquotMaster']['id'] != $aliquot_data['AliquotMaster']['id'])) {
					$this->validationErrors['barcode'] = str_replace('%s', $barcode, __('the barcode [%s] has already been recorded', true));
				}
			}			
		}
	}
	
	function hasChild(array $aliquot_master_ids){
		$realiquoting = AppModel::getInstance("inventorymanagement", "Realiquoting", TRUE);
		return array_filter($realiquoting->find('list', array('fields' => array('Realiquoting.parent_aliquot_master_id'), 'conditions' => array('Realiquoting.parent_aliquot_master_id' => $aliquot_master_ids), 'group' => array('Realiquoting.parent_aliquot_master_id'))));
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
	 */
	function getDefaultStorageDate($sample_master_data) {
		$collection_model = AppModel::getInstance("Inventorymanagement", "Collection", true);
		$sample_master_model = AppModel::getInstance("Inventorymanagement", "SampleMaster", true);
		$derivative_detail_model = AppModel::getInstance("Inventorymanagement", "DerivativeDetail", true);
		switch($sample_master_data['SampleMaster']['sample_category']) {
			case 'specimen':
				// Default creation date will be the specimen reception date
				$collection_data = $collection_model->find('first', array('conditions' => array('Collection.id' => $sample_master_data['SampleMaster']['collection_id']), 'recursive' => '-1'));
				if(empty($collection_data)) { 
					$this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
				}
				$sample_master = $sample_master_model->find('first', array('conditions' => array('SampleMaster.id' => $sample_master_data['SampleMaster']['id'])));
				return $sample_master['SpecimenDetail']['reception_datetime'];
				
			case 'derivative':
				// Default creation date will be the derivative creation date or Specimen reception date
				$derivative_detail_data = $derivative_detail_model->find('first', array('conditions' => array('DerivativeDetail.sample_master_id' => $sample_master_data['SampleMaster']['id']), 'recursive' => '-1'));
				if(empty($derivative_detail_data)) { 
					$this->redirect('/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); 
				}
				
				return $derivative_detail_data['DerivativeDetail']['creation_datetime'];
				
			default:
				$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);			
		}
		
		return null;
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
		$aliquot_internal_use_model = AppModel::getInstance("Inventorymanagement", "AliquotInternalUse", true);	
		$returned_nbr = $aliquot_internal_use_model->find('count', array('conditions' => array('AliquotInternalUse.aliquot_master_id' => $aliquot_master_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { 
			return array('allow_deletion' => false, 'msg' => 'use exists for the deleted aliquot'); 
		}
	
		// Check aliquot is not linked to realiquoting process	
		$realiquoting_model = AppModel::getInstance("Inventorymanagement", "Realiquoting", true);
		$returned_nbr = $realiquoting_model->find('count', array('conditions' => array("OR" => array('Realiquoting.child_aliquot_master_id' => $aliquot_master_id, 'Realiquoting.parent_aliquot_master_id' => $aliquot_master_id)), 'recursive' => '-1'));
		if($returned_nbr > 0) { 
			return array('allow_deletion' => false, 'msg' => 'realiquoting data exists for the deleted aliquot'); 
		}

		// Check aliquot is not linked to review	
		$aliquot_review_master_model = AppModel::getInstance("Inventorymanagement", "AliquotReviewMaster", true);
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
		$quality_ctrl_model = AppModel::getInstance("Inventorymanagement", "QualityCtrl", true);
		$returned_nbr = $quality_ctrl_model->find('count', array('conditions' => array('QualityCtrl.aliquot_master_id' => $aliquot_master_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { 
			return array('allow_deletion' => false, 'msg' => 'quality control data exists for the deleted aliquot'); 
		}
		
		// Check aliquot is not linked to a derivative	
		$source_aliquot_model = AppModel::getInstance("Inventorymanagement", "SourceAliquot", true);
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
			if(!empty($aliquot['AliquotMaster']['storage_datetime'])) { return $aliquot['AliquotMaster']['storage_datetime']; }
		}

		return date('Y-m-d G:i');
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
		$collection_model = AppModel::getInstance("Inventorymanagement", "ViewCollection", true);
		$unconsented_collections = $collection_model->getUnconsentedParticipantCollections(array('id' => $collection_ids));
		
		//building the result array
		$results = array();
		foreach($unconsented_collections as $collection_id => $status){
			$results += array_fill_keys($collection_aliquot_assoc[$collection_id], $status);
		}
		
		return $results;
	}
}

?>
