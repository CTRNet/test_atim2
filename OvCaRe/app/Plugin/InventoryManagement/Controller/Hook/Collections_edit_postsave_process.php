<?php
	
	$participant_model = AppModel::getInstance('ClinicalAnnotation', 'Participant', true);
	$participant_model->updateParticipantVOANumbers($collection_data['Collection']['participant_id']);

?>
