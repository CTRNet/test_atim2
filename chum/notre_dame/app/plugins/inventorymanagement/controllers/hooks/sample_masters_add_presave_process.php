<?php
 
 	if($submitted_data_validates) {
		// --------------------------------------------------------------------------------
		// Generate Sample Label
		// -------------------------------------------------------------------------------- 	
		$this->data['SampleControl'] = $sample_control_data['SampleControl'];
	 	$this->data['SampleMaster']['sample_label'] = $this->SampleMaster->createSampleLabel($collection_id,($this->data + $sample_control_data));
 	}

?>
