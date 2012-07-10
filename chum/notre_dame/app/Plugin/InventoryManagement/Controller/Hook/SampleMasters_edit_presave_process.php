<?php
 
 	// --------------------------------------------------------------------------------
	// Generate Sample Label
	// -------------------------------------------------------------------------------- 
	if($submitted_data_validates) {
		$working_data = $this->request->data;
		$working_data['SampleControl'] = $sample_data['SampleControl'];
		$working_data['SampleMaster']['initial_specimen_sample_id'] = $sample_data['SampleMaster']['initial_specimen_sample_id'];
		
		$this->SampleMaster->addWritableField('qc_nd_sample_label');
		$this->request->data['SampleMaster']['qc_nd_sample_label'] = $this->SampleMaster->createSampleLabel($collection_id, $working_data);
	}		
			
?>
