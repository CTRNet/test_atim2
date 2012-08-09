<?php
	
	if(!in_array('deleted',$this->request->data['Collection'])) {
		$this->Collection->updateCollectionSampleLabels($this->Collection->id);
	}
