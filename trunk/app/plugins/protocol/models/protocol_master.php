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
					'menu'			=>	array( NULL, __($result['ProtocolMaster']['code'], TRUE)),
					'title'			=>	array( NULL, __($result['ProtocolMaster']['code'], TRUE)),
					
					'description'	=>	array(
						__('tumour group', TRUE)		=>	__($result['ProtocolMaster']['tumour_group'], TRUE),
						__('type', TRUE)		=>	__($result['ProtocolMaster']['type'], TRUE),
						__('name', TRUE)		=>	__($result['ProtocolMaster']['name'], TRUE),
						__('arm', TRUE)	    =>  __($result['ProtocolMaster']['arm'], TRUE)
					)
				)
			);
		}
		
		return $return;
	}
}

?>