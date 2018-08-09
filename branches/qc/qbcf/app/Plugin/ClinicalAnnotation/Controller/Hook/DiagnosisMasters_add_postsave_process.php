<?php 

	if($dxControlData['DiagnosisControl']['controls_type'] == 'breast progression') $this->TreatmentMaster->calculateTimesTo($participantId);