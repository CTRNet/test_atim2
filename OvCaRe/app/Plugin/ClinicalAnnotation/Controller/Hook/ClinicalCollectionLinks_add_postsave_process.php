<?php
	if(!isset($this->request->data['Collection']['deleted'])) {
		$this->MiscIdentifier = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifier", true);
		$this->MiscIdentifier->updateParticipantVoaList($participant_id);
	}
	
?>