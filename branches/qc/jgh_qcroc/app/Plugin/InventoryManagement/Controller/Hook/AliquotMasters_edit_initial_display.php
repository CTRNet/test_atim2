<?php
	
	// --------------------------------------------------------------------------------
	// Erase System Barcode
	// -------------------------------------------------------------------------------- 	
	if(preg_match('/^'.$this->AliquotMaster->getSystemBarcodePattern().'$/i', $this->request->data['AliquotMaster']['barcode'])) {
		$this->request->data['AliquotMaster']['barcode'] = '';
	}


?>
