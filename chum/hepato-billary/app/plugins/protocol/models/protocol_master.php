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
				'Summary'	 => array(
					'menu'			=>	array( NULL, __($result['ProtocolMaster']['name'], TRUE)),
					'title'			=>	array( NULL, __($result['ProtocolMaster']['name'], TRUE)),
					
					'description'	=>	array(
						__('code', TRUE)		=>	__($result['ProtocolMaster']['code'], TRUE),
						__('type', TRUE)	    =>  __($result['ProtocolMaster']['type'], TRUE),
						__('status', TRUE) 		=> __($result['ProtocolMaster']['status'], TRUE),
						__('notes', TRUE) 		=> __($result['ProtocolMaster']['notes'], TRUE)
					)
				)
			);
		}
		
		return $return;
	}
}

?>