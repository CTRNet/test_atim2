<?php

class AdhocSaved extends DatamartAppModel {
	
	var $useTable = 'datamart_adhoc_saved';
	
	var $belongsTo = array(        
	   'Adhoc' => array(            
	       'className'    => 'Datamart.Adhoc',            
	       'foreignKey'    => 'adhoc_id'        
	   )    
	);
	
}

?>
