<?php
 
 	// --------------------------------------------------------------------------------
	// Generate Sample Label
	// -------------------------------------------------------------------------------- 	
	if($submitted_data_validates) {
		$this->data['SampleMaster']['qc_cusm_sample_label'] = $this->createSampleLabel($collection_id, $this->data);
	}
	
?>
