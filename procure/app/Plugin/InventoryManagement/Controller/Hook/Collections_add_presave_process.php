<?php 
	
	if(($collection_data && !$collection_data['Collection']['participant_id'])
	|| (!$collection_data && !isset($this->request->data['Collection']['participant_id']))){
		$submitted_data_validates = false;
		$this->Collection->validationErrors['partiicpant_id'][] = __('a created collection should be linked to a participant');
	}
