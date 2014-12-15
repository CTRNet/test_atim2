<?php
	
	if($this->request->data['Collection']['ovcare_collection_voa_nbr'] != $collection_data['Collection']['ovcare_collection_voa_nbr']) { 
		$this->MiscIdentifier = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifier", true);
		$this->MiscIdentifier->updateParticipantVoaList($collection_data['Collection']['participant_id']);
	}

?>
