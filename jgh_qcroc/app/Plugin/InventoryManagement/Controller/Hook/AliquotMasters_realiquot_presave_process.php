<?php
	
	// --------------------------------------------------------------------------------
	// If barcode is set manually, check this one is different than SYST#
	// -------------------------------------------------------------------------------- 	
	$record_counter = 0;
	foreach($this->request->data as $parent_and_children) {
		$record_counter++;
		foreach($parent_and_children['children'] as $new_aliquot) {
			if(!$this->AliquotMaster->validateBarcodeInput($new_aliquot)) {
				$errors['barcode'][str_replace('%s', $this->AliquotMaster->getSystemBarcodePattern(), __("the format of a barcode manualy enterred can not start by '%s'"))][$record_counter] = $record_counter;
			}
		}
	}
?>
