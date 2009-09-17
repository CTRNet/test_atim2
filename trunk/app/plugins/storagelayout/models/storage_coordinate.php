<?php

class StorageCoordinate extends StoragelayoutAppModel {
		
	var $belongsTo = array(        
		'StorageMaster' => array(            
			'className'    => 'Storagelayout.StorageMaster',            
			'foreignKey'    => 'storage_master_id'
		)	    
	);
	
}

?>
