<?php
	
	if($tx_control_data['TreatmentControl']['tx_method'] == 'procedure - surgery biopsy') {
		$this->DiagnosisMaster->updateCalculatedFields($participant_id);
		$this->TreatmentMaster->updateCalculatedFields($participant_id, $this->TreatmentMaster->getLastInsertId());
	}
