<?php 

	if($dx_control_data['DiagnosisControl']['controls_type'] == 'breast progression') $this->TreatmentMaster->calculateTimesTo($participant_id);
