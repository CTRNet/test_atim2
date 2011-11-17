<?php

	if(empty($this->data)) {
		// --------------------------------------------------------------------------------
		// Generate default aliquot label
		// -------------------------------------------------------------------------------- 	
		$this->set('default_aliquot_label', $this->AliquotMaster->generateDefaultAliquotLabel($sample_master_id, $aliquot_control));

		// --------------------------------------------------------------------------------
		// Set default stored_by value
		// -------------------------------------------------------------------------------- 	
		$this->set("default_stored_by", "louise rousseau");
	}
?>