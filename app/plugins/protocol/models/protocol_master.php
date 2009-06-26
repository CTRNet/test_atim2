<?php

class ProtocolMaster extends ProtocolAppModel
{
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
				'Summary' => array(
					'menu'			=>	array( NULL, $result['ProtocolMaster']['name']),
					'title'			=>	array( NULL, $result['ProtocolMaster']['name']),
					
					'description'	=>	array(
						'code'		=>	$result['ProtocolMaster']['code'],
						'type'   =>  $result['ProtocolMaster']['type'],
						'staus'  => $result['ProtocolMaster']['status'],
						'notes'  => $result['ProtocolMaster']['notes']
					)
				)
			);
		}
		
		return $return;
	}
}

?>