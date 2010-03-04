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

}

?>
