<?php 

	// --------------------------------------------------------------------------------
	// Generate default barcode
	// -------------------------------------------------------------------------------- 
	if(isset($default_barcode)) {
		$final_options['override']['StorageMaster.barcode'] = $default_barcode;
	}
	
?>
