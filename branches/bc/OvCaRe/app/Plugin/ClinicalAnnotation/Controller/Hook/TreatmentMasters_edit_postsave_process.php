<?php

	if($treatment_master_data['TreatmentControl']['tx_method'] == 'procedure - surgery and biopsy') {
		$this->TreatmentMaster->updateCalculatedFields($participant_id, $tx_master_id);
	}
