<?php

	// --------------------------------------------------------------------------------
	// Set default stored_by value
	// -------------------------------------------------------------------------------- 
	if(isset($default_stored_by)){
		$final_options['override']['AliquotMaster.qc_hb_stored_by'] = $default_stored_by;
	}
	// --------------------------------------------------------------------------------
	// Generate default aliquot label
	// -------------------------------------------------------------------------------- 
	if(isset($default_aliquot_label)) {
		$final_options['override']['AliquotMaster.qc_hb_label'] = $default_aliquot_label;		
	}
	
?>