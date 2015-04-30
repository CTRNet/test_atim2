<?php

// PROCURE CHUS
	if($collection_data) {	
		$this->Collection->writable_fields_mode = 'add';
		$this->Collection->addWritableField('procure_chus_collection_specimen_sample_control_id');
	}
// END PROCURE CHUS
	
?>