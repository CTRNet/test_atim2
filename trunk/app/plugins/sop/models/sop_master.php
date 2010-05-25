<?php

class SopMaster extends SopAppModel
{
	var $name = 'SopMaster';
    var $useTable = 'sop_masters';

	var $belongsTo = array(        
	   'SopControl' => array(            
	       'className'    => 'Sop.SopControl',            
	       'foreignKey'    => 'sop_control_id'        
	   )    
	);
	
	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['SopMaster.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('SopMaster.id'=>$variables['SopMaster.id'])));
			
			$return = array(
				'Summary' => array(
					'menu'			=>	array( NULL, __($result['SopMaster']['title'], TRUE)),
					'title'			=>	array( NULL, __($result['SopMaster']['title'], TRUE)),
					
					'description'	=>	array(
						__('version', TRUE) 	=> __($result['SopMaster']['version'], TRUE),
						__('status', TRUE)  	=> __($result['SopMaster']['status'], TRUE),
						__('expiry date', TRUE)	=> __($result['SopMaster']['expiry_date'], TRUE),
						__('notes', TRUE)	    => __($result['SopMaster']['notes'], TRUE)
					)
				)
			);
		}
		
		return $return;
	}
	
	function getTmaBlockSopList() {
		return array();
		
	}
	
	function getTmaSlideSopList() {
		return array();
		
	}
	
}

?>