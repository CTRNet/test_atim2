<?php
	$this->request->data['Collection']['collection_property'] = 'participant collection';
	if($collection_data) {	
		$this->Collection->writable_fields_mode = 'add';
		if(empty($collection_data['Collection']['collection_property'])) {
			// To Fix A Bug
			$this->Collection->tryCatchQuery("UPDATE collections SET collection_property =  'participant collection' WHERE id = ".$collection_data['Collection']['id']);
			$this->Collection->tryCatchQuery("UPDATE collections_revs SET collection_property =  'participant collection' WHERE id = ".$collection_data['Collection']['id']);
		}
		$this->Collection->addWritableField('collection_property', 'procure_chus_collection_specimen_sample_control_id');
	} else {
		$this->Collection->addWritableField('collection_property');
	}

?>