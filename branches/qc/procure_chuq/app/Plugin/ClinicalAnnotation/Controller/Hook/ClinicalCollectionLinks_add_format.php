<?php 
	
	if(empty($this->request->data)) {
		if(!$this->Collection->find('count', array('conditions' => array('Collection.participant_id IS NULL', 'Collection.collection_property' => 'participant collection'), 'recursive' => '-1'))) {
			//To skip collection selection step
			$this->request->data['Collection']['id'] = null;
		}		
	}
	