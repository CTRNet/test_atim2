<?php

class StorageMasterCustom extends StorageMaster {

	var $name = 'StorageMaster';
	var $useTable = 'storage_masters';

	var $belongsTo = array(       
		'StorageControl' => array(           
			'className'    => 'Storagelayout.StorageControl',            
			'foreignKey'    => 'storage_control_id'        
		)    
	);


	/*
		Override function
	  	- Set custom separator to ->
	  	- Use short label instead of system code 
	*/ 
	
	function getStoragePath($studied_storage_master_id) {
		$storage_path_data = $this->getpath($studied_storage_master_id, null, '0');

		$path_to_display = '';
		$separator = '';
		if(!empty($storage_path_data)){
			foreach($storage_path_data as $new_parent_storage_data) { 
				$path_to_display .= $separator.$new_parent_storage_data['StorageMaster']['short_label'] . " (".__($new_parent_storage_data['StorageControl']['storage_type'],true).")"; 
				$separator = ' -> ';
			}
		}
			
		return $path_to_display;
	}
	
	/*
		Override function
		- Drop separator value between storage entities

	*/
	
	function createSelectionLabel($storage_data, $parent_storage_data) {
		if(!array_key_exists('selection_label', $parent_storage_data['StorageMaster'])) { 
			AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
		}
		
		if(!array_key_exists('short_label', $storage_data['StorageMaster'])) { 
			AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
		}
		
		return ($parent_storage_data['StorageMaster']['selection_label'] . $storage_data['StorageMaster']['short_label']);
	}
	
}

?>