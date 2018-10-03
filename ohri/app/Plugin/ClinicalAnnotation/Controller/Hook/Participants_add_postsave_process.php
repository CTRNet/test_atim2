<?php

// --------------------------------------------------------------------------------
// Manage Participant creation to generate participant identifier
// --------------------------------------------------------------------------------
$this->Participant->data = array();
$this->Participant->id = $this->Participant->getLastInsertId();
$participantDataToUpdate = array();
$this->Participant->addWritableField(array(
    'participant_identifier'
));
$participantDataToUpdate['Participant']['participant_identifier'] = $this->Participant->id;
if (! $this->Participant->save($participantDataToUpdate, false)) {
    $this->redirect('/pages/err_clin_system_error', null, true);
}