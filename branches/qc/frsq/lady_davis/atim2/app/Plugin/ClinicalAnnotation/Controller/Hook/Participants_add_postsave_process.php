<?php
$this->Participant->id = $this->Participant->getLastInsertId();
$this->Participant->updateParticipantLastEventRecorded($this->Participant->id);