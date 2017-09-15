<?php
$this->Participant->updateParticipantLastEventRecorded($participantId);
$this->DiagnosisMaster->updateAgeAtDxAndSurvival('DiagnosisMaster', $diagnosisMasterId);