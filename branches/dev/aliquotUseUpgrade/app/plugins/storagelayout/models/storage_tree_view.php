<?php

/*
 * This Model has been created to build storage tree view including both TMAs and aliquots data contained
 * into the root storage and each children storages. Only Master data are included into the tree view whatever the data type is:
 * aliquot, storage, TMA.
 * 
 * This model helps for the tree view build that was complex using just StorageMaster model that will return details 
 * data all the time.
 */
 
class StorageTreeView extends StoragelayoutAppModel {
	
	var $useTable = 'storage_masters';
	
	var $hasMany = array(       
		'AliquotMaster' => array(           
			'className'    => 'Inventorymanagement.AliquotMaster',            
			'foreignKey'	=> 'storage_master_id',
			'order'	=>    'CAST(AliquotMaster.storage_coord_x AS signed), CAST(AliquotMaster.storage_coord_y AS signed)'    
		),
		'TmaSlide' => array(           
			'className'    => 'Storagelayout.TmaSlide',            
			'foreignKey'    => 'storage_master_id',
			'order'	=>     'CAST(TmaSlide.storage_coord_x AS signed), CAST(TmaSlide.storage_coord_y AS signed)'        
		)   
	);
	
	var $actsAs = array('Tree');

}

?>
