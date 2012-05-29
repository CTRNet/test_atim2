<?php
class TmaSlide extends StorageLayoutAppModel {
		
	var $belongsTo = array(       
		'StorageMaster' => array(           
			'className'    => 'StorageLayout.StorageMaster',            
			'foreignKey'    => 'storage_master_id'),
		'Block' => array(           
			'className'    => 'StorageLayout.StorageMaster',            
			'foreignKey'    => 'tma_block_storage_master_id'
		)	    
	);
	
	public static $storage = null;
		
	function validates($options = array()){
		pr('WARNING!!: tma slide data can be updated into TmaSlide->validates() function: be sure to reset data into controller using $this->TmaSlide->data!');
						
		$this->validateAndUpdateTmaSlideStorageData();
			
		if(isset($this->data['TmaSlide']['barcode'])){
			$this->isDuplicatedTmaSlideBarcode($this->data);
		}
		
		parent::validates($options);
		
		return empty($this->validationErrors);
	}
	
	function validateAndUpdateTmaSlideStorageData(){
		$tma_slide_data =& $this->data;
		// Load model
		if(self::$storage == null){
			self::$storage = AppModel::getInstance("StorageLayout", "StorageMaster", true);
		}
				
		// Launch validation		
		if(array_key_exists('FunctionManagement', $tma_slide_data) && array_key_exists('recorded_storage_selection_label', $tma_slide_data['FunctionManagement'])) {
			// Check the tma slide storage definition
			$arr_storage_selection_results = self::$storage->validateAndGetStorageData(
				$tma_slide_data['FunctionManagement']['recorded_storage_selection_label'], 
				$tma_slide_data['TmaSlide']['storage_coord_x'], 
				$tma_slide_data['TmaSlide']['storage_coord_y']
			);
			
			// Update aliquot data
			$tma_slide_data['TmaSlide']['storage_master_id'] = isset($arr_storage_selection_results['storage_data']['StorageMaster']['id']) ? $arr_storage_selection_results['storage_data']['StorageMaster']['id'] : null;
			if($arr_storage_selection_results['change_position_x_to_uppercase']){
				$tma_slide_data['TmaSlide']['storage_coord_x'] = strtoupper($tma_slide_data['TmaSlide']['storage_coord_x']);
			}
			if($arr_storage_selection_results['change_position_y_to_uppercase']){
				$tma_slide_data['TmaSlide']['storage_coord_y'] = strtoupper($tma_slide_data['TmaSlide']['storage_coord_y']);
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
			
			if(empty($this->validationErrors['recorded_storage_selection_label'])
				&& empty($this->validationErrors['storage_coord_x'])
				&& empty($this->validationErrors['storage_coord_y'])
				&& isset($arr_storage_selection_results['storage_data']['StorageControl'])
				&& $arr_storage_selection_results['storage_data']['StorageControl']['check_conflicts']
				&& (strlen($tma_slide_data['TmaSlide']['storage_coord_x']) > 0 || strlen($tma_slide_data['TmaSlide']['storage_coord_y']) > 0)
			){
				$exception = $this->id ? array("TmaSlide" => $this->id) : array();
				$position_status = $this->StorageMaster->positionStatusQuick(
					$arr_storage_selection_results['storage_data']['StorageMaster']['id'], 
					array(
						'x' => $tma_slide_data['TmaSlide']['storage_coord_x'], 
						'y' => $tma_slide_data['TmaSlide']['storage_coord_y']
					), $exception
				);
				$msg = null;
				if($position_status == StorageMaster::POSITION_OCCUPIED){
					$msg = __('the storage [%s] already contained something at position [%s, %s]');
				}else if($position_status == StorageMaster::POSITION_DOUBLE_SET){
					$msg = __('you have set more than one element in storage [%s] at position [%s, %s]');
				}
				if($msg != null){
					$msg = sprintf(
						$msg,
						$arr_storage_selection_results['storage_data']['StorageMaster']['selection_label'],
						$this->data['TmaSlide']['storage_coord_x'],
						$this->data['TmaSlide']['storage_coord_y']
					);
					if($arr_storage_selection_results['storage_data']['StorageControl']['check_conflicts'] == 1){
						AppController::addWarningMsg($msg);
					}else{
						$this->validationErrors['parent_storage_coord_x'][] = $msg;
					}
				}
			}

		} else if ((array_key_exists('storage_coord_x', $tma_slide_data['TmaSlide'])) || (array_key_exists('storage_coord_y', $tma_slide_data['TmaSlide']))) {
			AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
	}
	
	function isDuplicatedTmaSlideBarcode($tma_slide_data) {
		$barcode = $tma_slide_data['TmaSlide']['barcode'];
			
		// Check duplicated barcode into db
		$criteria = array('TmaSlide.barcode' => $barcode);
		$slides_having_duplicated_barcode = $this->find('all', array('conditions' => $criteria, 'recursive' => -1));;
		if(!empty($slides_having_duplicated_barcode)) {
			foreach($slides_having_duplicated_barcode as $duplicate) {
				if((!array_key_exists('id', $tma_slide_data['TmaSlide'])) || ($duplicate['TmaSlide']['id'] != $tma_slide_data['TmaSlide']['id'])) {
					$this->validationErrors['barcode'][] = 'barcode must be unique';
				}
				
			}			
		}
	}
}
?>
