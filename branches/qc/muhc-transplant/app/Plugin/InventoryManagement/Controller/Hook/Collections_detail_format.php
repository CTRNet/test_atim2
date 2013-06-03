<?php
	
	foreach($sample_data as &$new_sample) {
		$new_sample['Generated']['muhc_tissue_precision'] = $this->SampleMaster->getMuhcTissuePrecision($new_sample);
	}
	$this->set('sample_data', $sample_data);