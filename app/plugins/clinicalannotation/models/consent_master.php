<?php

class ConsentMaster extends ClinicalannotationAppModel {
	var $belongsTo = array(        
		'ConsentControl' => array(            
		'className'    => 'Clinicalannotation.ConsentControl',            
		'foreignKey'    => 'consent_control_id'
		)    
	);
	
	var $hasMany = array(
		'ClinicalCollectionLink' => array(
			'className' => 'Clinicalannotation.ClinicalCollectionLink',
			'foreignKey' => 'consent_master_id'));
	
}

?>