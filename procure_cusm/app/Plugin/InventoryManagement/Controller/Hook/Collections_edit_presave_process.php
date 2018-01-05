<?php 
	
	if($collection_data['Collection']['procure_visit'] == 'Controls') {
	    if($this->request->data['Collection']['procure_visit'] != $collection_data['Collection']['procure_visit'] || $this->request->data['Collection']['collection_datetime']['year']) {
	        $submitted_data_validates = false;
            $this->Collection->validationErrors['procure_visit'][] = 'control collection - no data can be updated';
	    }
	}
	