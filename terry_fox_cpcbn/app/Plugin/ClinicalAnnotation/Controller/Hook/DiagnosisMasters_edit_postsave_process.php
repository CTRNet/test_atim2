<?php
if (isset($this->request->data['DiagnosisDetail']) && array_key_exists('first_biochemical_recurrence', $this->request->data['DiagnosisDetail'])) {
    $this->DiagnosisMaster->calculateSurvivalAndBcr($diagnosisMasterId);
}

$this->DiagnosisMaster->updateAgeAtDx('DiagnosisMaster', $diagnosisMasterId);