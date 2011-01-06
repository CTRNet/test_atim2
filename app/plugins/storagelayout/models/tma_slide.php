<?php
class TmaSlide extends StoragelayoutAppModel {
		
	var $belongsTo = array(       
		'StorageMaster' => array(           
			'className'    => 'Storagelayout.StorageMaster',            
			'foreignKey'    => 'storage_master_id'),
		'Block' => array(           
			'className'    => 'Storagelayout.StorageMaster',            
			'foreignKey'    => 'tma_block_storage_master_id'
		)	    
	);
	
	public static $storage = null;
		
	function validates($options = array()){
		pr('WARNING!!: tma slide data can be updated into TmaSlide->validates() function: be sure to reset data into controller using $this->TmaSlide->data!');
						
		$this->data = $this->validateAndUpdateTmaSlideStorageData($this->data);
			
		if(isset($this->data['TmaSlide']['barcode'])){
			$this->isDuplicatedTmaSlideBarcode($this->data);
		}
		
		parent::validates($options);
		
		return empty($this->validationErrors);
	}
	
	function validateAndUpdateTmaSlideStorageData($tma_slide_data) {
		
		// Load model
		if(self::$storage == null){
			self::$storage = AppModel::atimNew("storagelayout", "StorageMaster", true);
		}
				
		// Launch validation		
		if(array_key_exists('FunctionManagement', $tma_slide_data) && array_key_exists('recorded_storage_selection_label', $tma_slide_data['FunctionManagement'])) {
			// Check the tma slide storage definition
			$arr_storage_selection_results = self::$storage->validateAndGetStorageData($tma_slide_data['FunctionManagement']['recorded_storage_selection_label'], $tma_slide_data['TmaSlide']['storage_coord_x'], $tma_slide_data['TmaSlide']['storage_coord_y']);
			
			// Update aliquot data
			$tma_slide_data['TmaSlide']['storage_master_id'] = isset($arr_storage_selection_results['storage_data']['StorageMaster']['id'])? $arr_storage_selection_results['storage_data']['StorageMaster']['id'] : null;
			if($arr_storage_selection_results['change_position_x_to_uppercase']) $tma_slide_data['TmaSlide']['storage_coord_x'] = strtoupper($tma_slide_data['TmaSlide']['storage_coord_x']);
			if($arr_storage_selection_results['change_position_y_to_uppercase']) $tma_slide_data['TmaSlide']['storage_coord_y'] = strtoupper($tma_slide_data['TmaSlide']['storage_coord_y']);
			
			// Set error
			if(!empty($arr_storage_selection_results['storage_definition_error'])) $this->validationErrors['recorded_storage_selection_label'] = $arr_storage_selection_results['storage_definition_error'];
			if(!empty($arr_storage_selection_results['position_x_error'])) $this->validationErrors['storage_coord_x'] = $arr_storage_selection_results['position_x_error'];
			if(!empty($arr_storage_selection_results['position_y_error'])) $this->validationErrors['storage_coord_y'] = $arr_storage_selection_results['position_y_error'];

		} else if ((array_key_exists('storage_coord_x', $tma_slide_data['TmaSlide'])) || (array_key_exists('storage_coord_y', $tma_slide_data['TmaSlide']))) {
			AppController::getInstance()->redirect('/pages/err_sto_system_error', null, true);
		}
		
		return $tma_slide_data;
	}
	
	function isDuplicatedTmaSlideBarcode($tma_slide_data) {
		$barcode = $tma_slide_data['TmaSlide']['barcode'];
			
		// Check duplicated barcode into db
		$criteria = array('TmaSlide.barcode' => $barcode);
		$slides_having_duplicated_barcode = $this->find('all', array('conditions' => array('TmaSlide.barcode' => $barcode), 'recursive' => -1));;
		if(!empty($slides_having_duplicated_barcode)) {
			foreach($slides_having_duplicated_barcode as $duplicate) {
				if((!array_key_exists('id', $tma_slide_data['TmaSlide'])) || ($duplicate['TmaSlide']['id'] != $tma_slide_data['TmaSlide']['id'])) {
					$this->validationErrors['barcode'] = 'barcode must be unique';
				}
				
			}			
		}
	}
}
?>
