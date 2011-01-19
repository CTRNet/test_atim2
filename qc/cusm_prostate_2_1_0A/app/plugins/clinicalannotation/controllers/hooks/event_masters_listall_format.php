<?php
 	// --------------------------------------------------------------------------------
	// Override master structure using procure form alias
	// -------------------------------------------------------------------------------- 	
 	if(isset($event_controls[0]['EventControl']['form_alias'])) {
 		$this->Structures->set($event_controls[0]['EventControl']['form_alias']);
 	} 	
 	
?>
