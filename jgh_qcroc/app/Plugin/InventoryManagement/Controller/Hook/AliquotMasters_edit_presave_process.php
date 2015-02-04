<?php
	
	// --------------------------------------------------------------------------------
	// If barcode is set manually, check this one is different than SYST#
	// -------------------------------------------------------------------------------- 	
	if(!$this->AliquotMaster->validateBarcodeInput($this->request->data)) {
		$submitted_data_validates = false;
		$this->AliquotMaster->validationErrors['barcode'][] = str_replace('%s', $this->AliquotMaster->getSystemBarcodePattern(), __("the format of a barcode manualy enterred can not start by '%s'"));
	}

?>
