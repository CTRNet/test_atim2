<?php 

	$model_Participant = AppModel::getInstance('ClinicalAnnotation', 'Participant', true);
	$model_Participant->updateParticipantLastEventRecorded($collection_data['Collection']['participant_id']);