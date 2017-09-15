<?php
$this->Participant->updateParticipantLastEventRecorded($participantId);
$this->DiagnosisMaster->updateAgeAtDxAndSurvival('Participant', $participantId);