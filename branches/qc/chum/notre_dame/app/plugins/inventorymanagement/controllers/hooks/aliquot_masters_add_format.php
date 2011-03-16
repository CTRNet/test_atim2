<?php
	
	// --------------------------------------------------------------------------------
	// Generate default aliquot label
	// -------------------------------------------------------------------------------- 	
	if(empty($this->data)) {
		$this->set('default_aliquot_label', $this->AliquotMaster->generateDefaultAliquotLabel($sample_data, $aliquot_control_data));	
	}
	
?>
