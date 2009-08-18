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
					'menu' => array( NULL, (__($result['StorageMaster']['storage_type'], TRUE) . ' : ' . $result['StorageMaster']['short_label'])),
					'title' => array( NULL, (__($result['StorageMaster']['storage_type'], TRUE) . ' : ' . $result['StorageMaster']['short_label'])),
					
					'description' => array(
						__('storage type', TRUE) => __($result['StorageMaster']['storage_type'], TRUE),
						__('storage short label', TRUE) => $result['StorageMaster']['short_label'],
						__('storage selection label', TRUE) => $result['StorageMaster']['selection_label'],
						__('code', TRUE) =>	$result['StorageMaster']['code'],
						__('temperature', TRUE) =>	$result['StorageMaster']['temperature'] . ' ' . __($result['StorageMaster']['temp_unit'], TRUE)
					)
				)
			);
		}
		
		return $return;
	}

}

?>
