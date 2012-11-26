<?php

	if(!$need_to_save && !empty($collection_data) && !empty($collection_data['Participant']['muhc_participant_bank_id'])) {
		$this->set('default_collection_bank_id', $collection_data['Participant']['muhc_participant_bank_id']);		
	}
