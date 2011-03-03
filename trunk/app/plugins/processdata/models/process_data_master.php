<?php

class ProcessDataMaster extends ProcessDataAppModel {
	
	var $belongsTo = array(       
		'ProcessDataControl' => array(           
			'className'    => 'Processdata.ProcessDataControl',            
			'foreignKey'    => 'process_data_control_id'        
		)    
	);
	
	function summary($variables = array()) {
		$return = false;
		
		if (isset($variables['StorageMaster.id'])) {
			$result = $this->find('first', array('conditions' => array('StorageMaster.id' => $variables['StorageMaster.id'])));
			
			$return = array(
				'menu' => array(null, (__($result['StorageMaster']['storage_type'], true) . ' : ' . $result['StorageMaster']['short_label'])),
				'title' => array(null, (__($result['StorageMaster']['storage_type'], true) . ' : ' . $result['StorageMaster']['short_label'])),
				'data'				=> $result,
				'structure alias'	=> 'storagemasters'
			);
		}
		
		return $return;
	}
	
}

?>
