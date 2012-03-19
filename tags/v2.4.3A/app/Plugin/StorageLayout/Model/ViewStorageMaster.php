<?php

class ViewStorageMaster extends StorageLayoutAppModel {
	
	var $belongsTo = array(       
		'StorageControl' => array(           
			'className'    => 'StorageLayout.StorageControl',            
			'foreignKey'    => 'storage_control_id'        
		)    
	);
	
	var $alias = 'StorageMaster';
}

?>
