<?php
 
 	if($submitted_data_validates) {
		// --------------------------------------------------------------------------------
		// Generate Sample Label
		// --------------------------------------------------------------------------------
		$this->request->data['SampleControl'] = $sample_control_data['SampleControl'];
		$this->SampleMaster->addWritableField('qc_nd_sample_label');
	 	$this->request->data['SampleMaster']['qc_nd_sample_label'] = $this->SampleMaster->createSampleLabel($collection_id,($this->request->data + $sample_control_data));
 	}

?>
