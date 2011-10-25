<?php
 
 	if($submitted_data_validates) {
		// --------------------------------------------------------------------------------
		// Generate Sample Label
		// -------------------------------------------------------------------------------- 	
	 	$this->data['SampleMaster']['sample_label'] = $this->SampleMaster->createSampleLabel($collection_id,($this->data + $sample_control_data));
 	}

?>
