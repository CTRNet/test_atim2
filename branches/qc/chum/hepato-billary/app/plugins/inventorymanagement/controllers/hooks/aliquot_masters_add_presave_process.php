<?php
	
	// --------------------------------------------------------------------------------
	// Generate default barcode
	// -------------------------------------------------------------------------------- 	
	if(empty($errors)){
		$this->AliquotMaster->generateDefaultAliquotBarcode($this->data); 
	}
	
?>