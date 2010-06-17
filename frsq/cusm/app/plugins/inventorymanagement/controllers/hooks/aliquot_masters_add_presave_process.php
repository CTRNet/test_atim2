<?php
 	
 	// --------------------------------------------------------------------------------
	// Create default blocks for initial display
	//
	// (Custom code has been set in this file because there is a bug with data override 
	// in view: see eventum issue #958) 
	// -------------------------------------------------------------------------------- 	
	if($this->set_default_block_display) {	
		$submitted_data_validates = false;
		$errors = array();
	}
	
?>
