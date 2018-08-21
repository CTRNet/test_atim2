<?php
if ($diagnosisMasterData['DiagnosisControl']['controls_type'] == 'breast progression')
    $this->TreatmentMaster->calculateTimesTo($participantId);