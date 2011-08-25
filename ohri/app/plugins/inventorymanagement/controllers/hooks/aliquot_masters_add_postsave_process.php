<?php
 
 	// --------------------------------------------------------------------------------
	// Set Default Barcode
	// -------------------------------------------------------------------------------- 	

	$this->AliquotMaster->updateAll(
				array('AliquotMaster.barcode' => 'AliquotMaster.id'),
				array('AliquotMaster.barcode' => 'tmp'));
			
?>