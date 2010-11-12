<?php
 	
 	// --------------------------------------------------------------------------------
	// Set default value
	// -------------------------------------------------------------------------------- 
	if(empty($this->data) && ($dx_control_data['DiagnosisControl']['controls_type'] == 'diagnosis ohri - ovary')) {
		$this->set('default_ohri_tumor_site', 'female genital-ovary');
	}
	
?>
