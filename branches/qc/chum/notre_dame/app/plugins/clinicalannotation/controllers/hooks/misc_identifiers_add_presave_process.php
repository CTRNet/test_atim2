<?php
	
	// --------------------------------------------------------------------------------
	// Validate RAMQ format
	// -------------------------------------------------------------------------------- 
	if(isset($this->data['MiscIdentifier']['identifier_name']) && (strcmp($this->data['MiscIdentifier']['identifier_name'], 'ramq nbr') == 0)) {
		$tmp_ramq_nbr = strtoupper($this->data['MiscIdentifier']['identifier_value']);
		$ramq_pattern = '/^[A-Z]{4}[0-9]{8}$/';
		if(!preg_match($ramq_pattern, $tmp_ramq_nbr)) {
			$submitted_data_validates = false;
			$this->MiscIdentifier->validationErrors['identifier_value'] = 'ramq format error';
		}	
	}
	
?>