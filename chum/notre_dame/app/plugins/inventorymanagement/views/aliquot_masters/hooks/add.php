<?php 

	// --------------------------------------------------------------------------------
	// Set custom initial data including default aliquot label(s)
	// -------------------------------------------------------------------------------- 
	if(isset($custom_initial_data)) {
		$this->data = $custom_initial_data;		
	}
	
	// --------------------------------------------------------------------------------
	// Prevent the paste operation on aliquot label 
	// -------------------------------------------------------------------------------- 
	$options_children['settings']['paste_disabled_fields'] = array('AliquotMaster.aliquot_label');	
	
?>
