<?php
 
 	if($submitted_data_validates) {
		// --------------------------------------------------------------------------------
		// Generate Sample Label
		// -------------------------------------------------------------------------------- 	
	 	$this->data['SampleMaster']['sample_label'] = $this->createSampleLabel($collection_id,($this->data + $sample_control_data));
	
	 	// --------------------------------------------------------------------------------
		// Check selected type code for all specimen plus set read only fields for tissue
		// (tissue source, nature, laterality)
		// -------------------------------------------------------------------------------- 	
		if(!$this->manageLabTypeCodeAndLaterality()) { $submitted_data_validates = false; }	
 	}

?>
