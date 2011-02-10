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
		
}
?>
