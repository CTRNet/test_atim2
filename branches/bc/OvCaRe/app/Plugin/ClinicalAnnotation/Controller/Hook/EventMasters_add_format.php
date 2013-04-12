<?php

	if(empty($this->request->data) && $event_control_data['EventControl']['event_type'] == 'experimental tests') {
		$this->redirect( "/ClinicalAnnotation/EventMasters/addExperimentalTestsInBatch/$participant_id/$event_control_id/0/$diagnosis_master_id");
	}




