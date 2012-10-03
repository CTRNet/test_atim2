<?php

class ViewStorageMaster extends StorageLayoutAppModel {
	
	var $base_model = "StorageMaster";
	var $base_plugin = 'StorageLayout';
	
	var $belongsTo = array(       
		'StorageControl' => array(           
			'className'    => 'StorageLayout.StorageControl',            
			'foreignKey'    => 'storage_control_id'        
		)    
	);
	
	var $alias = 'StorageMaster';
	
	static $table_query = '
		SELECT StorageMaster.*, 
		IF(coord_x_size IS NULL AND coord_y_size IS NULL, NULL, IFNULL(coord_x_size, 1) * IFNULL(coord_y_size, 1) - COUNT(AliquotMaster.id) - COUNT(TmaSlide.id) - COUNT(ChildStorageMaster.id)) AS empty_spaces 
		FROM storage_masters AS StorageMaster
		INNER JOIN storage_controls AS StorageControl ON StorageMaster.storage_control_id=StorageControl.id
		LEFT JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.storage_master_id=StorageMaster.id AND AliquotMaster.deleted=0
		LEFT JOIN tma_slides AS TmaSlide ON TmaSlide.storage_master_id=StorageMaster.id AND TmaSlide.deleted=0
		LEFT JOIN storage_masters AS ChildStorageMaster ON ChildStorageMaster.parent_id=StorageMaster.id AND ChildStorageMaster.deleted=0
		WHERE StorageMaster.deleted=0 %%WHERE%% GROUP BY StorageMaster.id';
}

?>
