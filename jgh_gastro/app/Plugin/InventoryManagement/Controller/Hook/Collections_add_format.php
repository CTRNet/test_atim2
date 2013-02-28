<?php

	//Set default values
	if(!$need_to_save) {
		// Bank
		if(empty($copy_source)) $this->request->data['Collection']['bank_id'] = '1';
		
		// Collection ID
		$participant_id_for_next_id = '-1';
		if(!empty($collection_data) && $collection_data['Collection']['participant_id']) {
			$participant_id_for_next_id = $collection_data['Collection']['participant_id'];
		} else if(!empty($copy_source) && $this->request->data['Collection']['participant_id']) {
			$participant_id_for_next_id = $this->request->data['Collection']['participant_id'];
		}
		$last_acquisition_label = $this->Collection->find('first', array('conditions' =>  array('Collection.participant_id' => $participant_id_for_next_id), 'fields' => array('MAX(Collection.acquisition_label) AS max_val'), 'recursive' => '-1'));
		if(empty($last_acquisition_label[0]['max_val'])) {
			$this->request->data['Collection']['acquisition_label'] = '01';
		} else {	
			$next_val = $last_acquisition_label[0]['max_val'];
			$next_val++;
			$this->request->data['Collection']['acquisition_label'] = (strlen($next_val) == 1)? '0'.$next_val : $next_val;
		}
	}