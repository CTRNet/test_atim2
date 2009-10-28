<?php

class ConsentMaster extends ClinicalannotationAppModel {
	var $belongsTo = array(        
		'ConsentControl' => array(            
		'className'    => 'Clinicalannotation.ConsentControl',            
		'foreignKey'    => 'consent_control_id'
		)    
	);
}

?>