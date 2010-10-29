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
				'Summary' => array(
					'menu' => array(null, (__($result['StorageMaster']['storage_type'], true) . ' : ' . $result['StorageMaster']['short_label'])),
					'title' => array(null, (__($result['StorageMaster']['storage_type'], true) . ' : ' . $result['StorageMaster']['short_label'])),
					
					'description' => array(
						__('storage type', true) => __($result['StorageMaster']['storage_type'], true),
						__('storage short label', true) => $result['StorageMaster']['short_label'],
						__('storage selection label', true) => $result['StorageMaster']['selection_label'],
						__('code', true) =>	$result['StorageMaster']['code'],
						__('temperature', true) =>	$result['StorageMaster']['temperature'] . ' ' . __($result['StorageMaster']['temp_unit'], true)
					)
				)
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
	 * @return Array having following structure:
	 * 	array ('value' => 'StorageMaster.id', 'default' => (translated string describing storage))
	 * 
	 * @author N. Luc
	 * @since 2007-05-22
	 * @updated A. Suggitt on 2009-07-22
	*/
	
	function getParentStoragePermissibleValues($excluded_storage_master_id = null) {	
		
		// Get all storage records according to following exclusion criteria
		$criteria = array();
		
		//1-Find control ID for all storages of type TMA: TMA will be removed from the returned array
		App::import('Model','Storagelayout.StorageControl');
		$storage_ctrl = new StorageControl();
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
		
		$formatted_data = array(array('value' => '0', 'default' => __('n/a', true)));
		if(!empty($arr_storages_list)) {
			foreach ($arr_storages_list as $storage_id => $storage_data) {
				$formatted_data[] = array(
					'value' => $storage_id, 
					'default' => $this->createStorageTitleForDisplay($storage_data));
			}
		}
		
		return $formatted_data;
	}
	
	/**
	 * Build storage title joining many storage information.
	 * 
	 * @param $storage_data Storages data
	 * 
	 * @return Storage title (string).
	 *
	 * @author N. Luc
	 * @since 2009-09-11
	 */		

	function createStorageTitleForDisplay($storage_data) {
		$formatted_data = '';
		
		if((!empty($storage_data)) && isset($storage_data['StorageMaster'])) {
			$formatted_data = $storage_data['StorageMaster']['selection_label'] . ' [' . $storage_data['StorageMaster']['code'] . ' ('.__($storage_data['StorageMaster']['storage_type'], TRUE) .')'. ']';
		}
	
		return $formatted_data;
	}

}

?>
