<?php 

	if($tx_control_data['TreatmentControl']['tx_method'] == 'breast diagnostic event') {
		$this->TreatmentMaster->calculateTimesTo($participant_id);
		$this->DiagnosisMaster->setBreastDxLaterality($participant_id);
	}
