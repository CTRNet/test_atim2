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
					'menu'			=>	array( NULL, $result['ProtocolMaster']['code']),
					'title'			=>	array( NULL, $result['ProtocolMaster']['code']),
					
					'description'	=>	array(
						__('tumour group', TRUE)		=>	__($result['ProtocolMaster']['tumour_group'], TRUE),
						__('type', TRUE)		=>	__($result['ProtocolMaster']['type'], TRUE),
						__('name', TRUE)		=>	$result['ProtocolMaster']['name'],
						__('arm', TRUE)	    =>  $result['ProtocolMaster']['arm']
					)
				)
			);
		}
		
		return $return;
	}
	
	/**
	 * Get permissible values array gathering all existing protocol.
	 *
	 * @return Array having following structure:
	 * 	array ('value' => 'ProtocolMaster.id ', 'default' => (translated string describing protocol))
	 * 
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  	
	function getProtocolPermissibleValuesFromId() {
		$result = array();

		// Build tmp array to sort according translation
		foreach($this->find('all', array('order' => 'ProtocolMaster.code')) as $new_protocol) {
			$result[] = array('value' => $new_protocol['ProtocolMaster']['id'], 'default' => $new_protocol['ProtocolMaster']['code'] . ' : ' . (empty($new_protocol['ProtocolMaster']['name'])? '-' : $new_protocol['ProtocolMaster']['name']));
		}
				
		return $result;
	}	
	
}

?>