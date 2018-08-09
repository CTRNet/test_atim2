<?php 

	if($dxMasterData['DiagnosisControl']['controls_type'] == 'breast progression') $this->TreatmentMaster->calculateTimesTo($participantId);