<?php

	if(empty($this->data)) {
		// --------------------------------------------------------------------------------
		// Generate default aliquot label
		// -------------------------------------------------------------------------------- 	
		$this->set('default_aliquot_label', $this->generateDefaultAliquotLabel($collection_id, $sample_master_id, $aliquot_control_data));

		// --------------------------------------------------------------------------------
		// Set default stored_by value
		// -------------------------------------------------------------------------------- 	
		$this->set("default_stored_by", "Urszula Krzemien");
	}
	
?>