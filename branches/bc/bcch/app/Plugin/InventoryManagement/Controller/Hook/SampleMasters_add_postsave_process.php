<?php
	// Call custom model function to generate aliquot barcodes.
	if ($parent_sample_master_id != 0) {
		$collection_data = $this->Collection->getOrRedirect($collection_id);
	}

	$this->SampleMaster->generateSampleLabel($collection_data, $sample_control_data['SampleControl']['sample_type'], $sample_master_id);