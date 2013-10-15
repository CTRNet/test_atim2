<?php

	if($treatment_master_data['TreatmentControl']['tx_method'] == 'procedure - surgery') {
		$this->DiagnosisMaster->updateCalculatedFields($participant_id);
		$this->TreatmentMaster->updateCalculatedFields($participant_id, $tx_master_id);
	}
