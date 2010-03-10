<?php

	// --------------------------------------------------------------------------------
	// Set Default Aliquot Barcode
	// --------------------------------------------------------------------------------
	if(isset($default_aliquot_barcode)) {
		$final_options['override' ]['AliquotMaster.barcode'] = $default_aliquot_barcode;
	}

	
?>
