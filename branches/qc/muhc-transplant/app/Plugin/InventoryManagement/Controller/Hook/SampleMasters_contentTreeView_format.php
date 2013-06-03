<?php

	foreach($this->request->data as &$new_sample) {
		$new_sample['Generated']['muhc_tissue_precision'] = $this->SampleMaster->getMuhcTissuePrecision($new_sample);
	}
