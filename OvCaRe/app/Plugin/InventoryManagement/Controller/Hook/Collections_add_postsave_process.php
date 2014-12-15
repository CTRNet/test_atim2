<?php
	
	if(!empty($collection_data)) {
		$this->MiscIdentifier = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifier", true);
		$this->MiscIdentifier->updateParticipantVoaList($collection_data['Collection']['participant_id']);
	} else if(isset($this->request->data['Collection']['participant_id'])) {
		$this->MiscIdentifier = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifier", true);
		$this->MiscIdentifier->updateParticipantVoaList($this->request->data['Collection']['participant_id']);
	}

?>
