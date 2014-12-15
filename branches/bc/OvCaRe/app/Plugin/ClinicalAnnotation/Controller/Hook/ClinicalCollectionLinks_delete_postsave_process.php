<?php
	
	$this->MiscIdentifier = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifier", true);
	$this->MiscIdentifier->updateParticipantVoaList($participant_id);
	
?>