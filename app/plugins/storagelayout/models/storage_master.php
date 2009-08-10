<?php

class StorageMaster extends StoragelayoutAppModel {
    var $useTable = 'storage_masters';
	var $belongsTo = array(        
		'StorageControl' => array(            
			'className'    => 'Storagelayout.StorageControl',            
			'foreignKey'    => 'storage_control_id'        
		)    
	);
	
	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['StorageMaster.id']) ) {
			$result = $this->find('first', array('conditions'=>array('StorageMaster.id'=>$variables['StorageMaster.id'])));
			
			$return = array(
				__('Summary', TRUE)	 => array(
					__('menu', TRUE) =>	array( NULL, __($result['StorageMaster']['storage_type'], TRUE) ),
					__('title', TRUE)=>	array( NULL, __($result['StorageMaster']['storage_type'], TRUE) ),
					
					__('description', TRUE)		=>	array(
						__('barcode', TRUE)			=>	__($result['StorageMaster']['barcode'], TRUE),
						__('code', TRUE)			=>	__($result['StorageMaster']['code'], TRUE),
						__('selection label', TRUE)	=>	__($result['StorageMaster']['selection_label'], TRUE)
					)
				)
			);
		}
		
		return $return;
	}

}

?>
