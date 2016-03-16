<?php

class ProtocolExtendMaster extends ProtocolAppModel {

	var $belongsTo = array(        
	   'ProtocolExtendControl' => array(            
	       'className'    => 'Protocol.ProtocolExtendControl',            
	       'foreignKey'    => 'protocol_extend_control_id'        
	   )    
	);

}

?>