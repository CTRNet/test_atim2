<?php

class MedicalPastHistoryCtrl extends ClinicalannotationAppModel {
  
  var $useTable = 'qc_chum_hb_hepatobiliary_medical_past_history_ctrls';
  
	var $belongsTo = array(        
	   'EventControl' => array(            
	       'className'    => 'Clinicalannotation.EventControl',            
	       'foreignKey'    => 'event_control_id'        
	   )    
	);
	
}

?>