<?php
 
 	// --------------------------------------------------------------------------------
	// Generate Sample Label
	// -------------------------------------------------------------------------------- 
	if($submitted_data_validates) {
		$working_data = $this->data;
		$working_data['SampleControl'] = $sample_data['SampleControl'];
		$working_data['SampleMaster']['initial_specimen_sample_id'] = $sample_data['SampleMaster']['initial_specimen_sample_id'];
		
		$this->data['SampleMaster']['sample_label'] = $this->SampleMaster->createSampleLabel($collection_id, $working_data);

	 	// --------------------------------------------------------------------------------
		// Check selected type code for all specimen plus set read only fields for tissue
		// (tissue source, nature, laterality)
		// -------------------------------------------------------------------------------- 	
		if(!$this->SampleMaster->validateLabTypeCodeAndLaterality($this->data)){ 
			$submitted_data_validates = false; 
		}
	}		
			
?>
