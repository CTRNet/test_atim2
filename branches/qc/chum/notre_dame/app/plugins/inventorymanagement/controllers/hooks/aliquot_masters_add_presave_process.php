<?php
	
	// --------------------------------------------------------------------------------
	// Generate default barcode
	// -------------------------------------------------------------------------------- 	
 	if($submitted_data_validates) { 
 		$this->AliquotMaster->generateDefaultAliquotBarcode($sample_data); 
 	}
	
?>
