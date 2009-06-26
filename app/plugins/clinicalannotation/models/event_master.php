<?php

class EventMaster extends ClinicalannotationAppModel {
	
	var $belongsTo = array(        
	   'EventControl' => array(            
	       'className'    => 'Clinicalannotation.EventControl',            
	       'foreignKey'    => 'event_control_id'        
	   )    
	);
	
}

?>