<?php 

	$this->Participant->updateParticipantLastEventRecorded($participant_id);	
	$this->DiagnosisMaster->updateAgeAtDxAndSurvival('Participant',$participant_id);
	