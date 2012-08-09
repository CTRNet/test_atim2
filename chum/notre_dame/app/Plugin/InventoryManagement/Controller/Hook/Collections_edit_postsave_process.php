<?php
	
	if($collection_data['Collection']['bank_id'] != $this->request->data['Collection']['bank_id']) {
		$this->Collection->updateCollectionSampleLabels($collection_id);
	}
