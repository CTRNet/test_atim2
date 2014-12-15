<?php

	if($arr_allow_deletion['allow_deletion'] && $treatment_master_data['TreatmentControl']['tx_method'] == 'procedure - surgery and biopsy' && strlen($treatment_master_data['TreatmentDetail']['path_num'])) {
		$this->MiscIdentifier = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifier", true);
		$this->MiscIdentifier->updateParticipantPathoNumberList($participant_id, $tx_master_id);
	}
