<?php
if ($treatmentMasterData['TreatmentControl']['tx_method'] == 'breast diagnostic event') {
    $this->TreatmentMaster->calculateTimesTo($participantId);
    $this->DiagnosisMaster->setBreastDxLaterality($participantId);
}