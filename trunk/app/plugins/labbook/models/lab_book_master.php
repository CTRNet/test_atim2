<?php

class LabBookMaster extends LabBookAppModel {
	
	var $belongsTo = array(       
		'LabBookControl' => array(           
			'className'    => 'Labbook.LabBookControl',            
			'foreignKey'    => 'lab_book_control_id'        
		)    
	);
	
	function summary($variables = array()) {
		$return = false;
		
		if (isset($variables['LabBookMaster.id'])) {
			$result = $this->find('first', array('conditions' => array('LabBookMaster.id' => $variables['LabBookMaster.id'])));
			
			$return = array(
				'menu' => array(null, $result['LabBookMaster']['code']),
				'title' => array(null, $result['LabBookMaster']['code']),
				'data'				=> $result,
				'structure alias'	=> 'labbookmasters'
			);
		}
		
		return $return;
	}
	
}

?>
