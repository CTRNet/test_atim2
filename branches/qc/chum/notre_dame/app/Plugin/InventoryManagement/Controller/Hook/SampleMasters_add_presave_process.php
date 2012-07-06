<?php
 
 	if($submitted_data_validates) {
		// --------------------------------------------------------------------------------
		// Generate Sample Label
		// --------------------------------------------------------------------------------
		$this->request->data['SampleControl'] = $sample_control_data['SampleControl'];
		$this->SampleMaster->addWritableField('sample_label');
	 	$this->request->data['SampleMaster']['sample_label'] = $this->SampleMaster->createSampleLabel($collection_id,($this->request->data + $sample_control_data));
 	}

?>
