<?php
	$this->request->data['Collection']['collection_property'] = 'participant collection';
	if($collection_data) {	
		$this->Collection->addWritableField(array('collection_property', 'procure_chus_collection_specimen_sample_control_id'));
	} else {
		$this->Collection->addWritableField('collection_property');
	}

?>