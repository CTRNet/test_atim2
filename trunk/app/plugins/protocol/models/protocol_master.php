<?php

class ProtocolMaster extends ProtocolAppModel {

	var $name = 'ProtocolMaster';
	var $useTable = 'protocol_masters';

	var $belongsTo = array(        
	   'ProtocolControl' => array(            
	       'className'    => 'Protocol.ProtocolControl',            
	       'foreignKey'    => 'protocol_control_id'        
	   )    
	);
	
	
	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['ProtocolMaster.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('ProtocolMaster.id'=>$variables['ProtocolMaster.id'])));
			
			$return = array(
				__('Summary', TRUE)	 => array(
					__('menu', TRUE)			=>	array( NULL, __($result['ProtocolMaster']['name'], TRUE)),
					__('title', TRUE)			=>	array( NULL, __($result['ProtocolMaster']['name'], TRUE)),
					
					__('description', TRUE)		=>	array(
						__('code', TRUE)		=>	__($result['ProtocolMaster']['code'], TRUE),
						__('type', TRUE)	    =>  __($result['ProtocolMaster']['type'], TRUE),
						__('staus', TRUE) 		=> __($result['ProtocolMaster']['status'], TRUE),
						__('notes', TRUE) 		=> __($result['ProtocolMaster']['notes'], TRUE)
					)
				)
			);
		}
		
		return $return;
	}
}

?>