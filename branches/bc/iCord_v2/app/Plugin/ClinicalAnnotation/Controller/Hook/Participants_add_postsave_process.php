<?php
$participantId = $this->Participant->getLastInsertID();
$participantType = $this->request->data['Participant']['participant_type'];
$this->Participant->generateSciCode($participantId, $participantType);