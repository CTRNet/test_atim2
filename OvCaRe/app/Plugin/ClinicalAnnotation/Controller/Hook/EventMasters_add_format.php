<?php

	if(empty($this->request->data)) {
		$this->redirect( "/ClinicalAnnotation/EventMasters/addExperimentalTestsInBatch/$participant_id/$event_control_id/0/$diagnosis_master_id");
	}




