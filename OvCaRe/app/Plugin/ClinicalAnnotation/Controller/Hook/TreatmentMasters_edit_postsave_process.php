<?php

	if($treatment_master_data['TreatmentControl']['tx_method'] == 'procedure - surgery and biopsy') {
		$this->TreatmentMaster->updateCalculatedFields($participant_id, $tx_master_id);
		if($treatment_master_data['TreatmentDetail']['path_num'] != $this->request->data['TreatmentDetail']['path_num']) {
			$this->MiscIdentifier = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifier", true);
			$this->MiscIdentifier->updateParticipantPathoNumberList($participant_id);
		}
	}
