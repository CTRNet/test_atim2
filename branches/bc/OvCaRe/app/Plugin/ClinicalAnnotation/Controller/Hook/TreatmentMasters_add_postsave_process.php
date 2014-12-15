<?php
	
	if($tx_control_data['TreatmentControl']['tx_method'] == 'procedure - surgery and biopsy') {
		$this->TreatmentMaster->updateCalculatedFields($participant_id, $this->TreatmentMaster->getLastInsertId());
		if(strlen($this->request->data['TreatmentDetail']['path_num'])) {
			$this->MiscIdentifier = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifier", true);
			$this->MiscIdentifier->updateParticipantPathoNumberList($participant_id);
		}
	}
