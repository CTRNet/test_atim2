<?php

class AdhocFavourite extends DatamartAppModel {
	
	var $useTable = 'datamart_adhoc_favourites';
	
	var $belongsTo = array(        
	   'Adhoc' => array(            
	       'className'    => 'Datamart.Adhoc',            
	       'foreignKey'    => 'adhoc_id'        
	   )    
	);
	
}

?>
