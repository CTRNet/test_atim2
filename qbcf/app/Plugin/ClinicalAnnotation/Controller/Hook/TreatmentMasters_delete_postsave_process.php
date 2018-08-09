<?php 

if($treatmentMasterData['TreatmentControl']['tx_method'] == 'breast diagnostic event') {
	$this->DiagnosisMaster->setBreastDxLaterality($participantId);
	$this->TreatmentMaster->calculateTimesTo($participantId);
}