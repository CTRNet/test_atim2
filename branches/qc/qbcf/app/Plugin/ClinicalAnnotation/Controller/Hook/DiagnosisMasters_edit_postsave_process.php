<?php 

	if($dx_master_data['DiagnosisControl']['controls_type'] == 'breast progression') $this->TreatmentMaster->calculateTimesTo($participant_id);
