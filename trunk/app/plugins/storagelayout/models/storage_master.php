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
				'Summary' => array(
					'menu'			=>	array( NULL, $result['StorageMaster']['storage_type'] ),
					'title'			=>	array( NULL, $result['StorageMaster']['storage_type'] ),
					
					'description'	=>	array(
						'barcode'	=>	$result['StorageMaster']['barcode'],
						'code'	=>	$result['StorageMaster']['code'],
						'selection label'	=>	$result['StorageMaster']['selection_label']
					)
				)
			);
		}
		
		return $return;
	}

}

?>
