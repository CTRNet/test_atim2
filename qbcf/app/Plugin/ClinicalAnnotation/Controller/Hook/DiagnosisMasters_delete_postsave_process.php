<?php 

	if($diagnosis_master_data['DiagnosisControl']['controls_type'] == 'breast progression') $this->TreatmentMaster->calculateTimesTo($participant_id);
