<?php
	
	if(!empty($collection_data)) {
		$participant_model = AppModel::getInstance('ClinicalAnnotation', 'Participant', true);
		$participant_model->updateParticipantVOANumbers($collection_data['Collection']['participant_id']);
	} else if(isset($this->request->data['Collection']['participant_id'])) {
		$participant_model = AppModel::getInstance('ClinicalAnnotation', 'Participant', true);
		$participant_model->updateParticipantVOANumbers($this->request->data['Collection']['participant_id']);
	}

?>
