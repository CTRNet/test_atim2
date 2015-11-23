<?php 

	$this->Participant->updateParticipantLastEventRecorded($participant_id);
	$this->DiagnosisMaster->updateAgeAtDxAndSurvival('DiagnosisMaster', $diagnosis_master_id);
