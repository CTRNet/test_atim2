<?php
	
	// --------------------------------------------------------------------------------
	// If barcode is set manually, check this one is different than SYST#
	// -------------------------------------------------------------------------------- 	
	$record_counter = 0;
	foreach($this->request->data as $created_aliquots){
		$record_counter++;
		$line_counter = 0;
		foreach($created_aliquots['children'] as $new_aliquot) {
			$line_counter++;
			if(!$this->AliquotMaster->validateBarcodeInput($new_aliquot)) {
				$errors['barcode'][str_replace('%s', $this->AliquotMaster->getSystemBarcodePattern(), __("the format of a barcode manualy enterred can not start by '%s'"))][] = ($is_batch_process? $record_counter : $line_counter);
			}
		}
	}

?>
