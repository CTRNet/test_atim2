<?php 

	$model_Participant = AppModel::getInstance('ClinicalAnnotation', 'Participant', true);
	$model_Participant->updateParticipantLastEventRecorded(isset($this->request->data['Collection']['participant_id'])? $this->request->data['Collection']['participant_id'] : $collection_data['Collection']['participant_id']);