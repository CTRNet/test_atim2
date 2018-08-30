<?php

// --------------------------------------------------------------------------------
// Save Participant Identifier
// --------------------------------------------------------------------------------
$queryToUpdate = "UPDATE participants SET participants.participant_identifier = participants.id WHERE participants.id = " . $this->Participant->id . ";";
$this->Participant->tryCatchQuery($queryToUpdate);
$this->Participant->tryCatchQuery(str_replace("participants", "participants_revs", $queryToUpdate));

// --------------------------------------------------------------------------------
// Redirect to participant bank number creation
// --------------------------------------------------------------------------------

$miscIdentifierControlId = $this->MiscIdentifierControl->find('first', array(
    'conditions' => array(
        'MiscIdentifierControl.misc_identifier_name' => 'kidney transplant bank no lab'
    )
));
if ($miscIdentifierControlId) {
    $miscIdentifierControlId = $miscIdentifierControlId['MiscIdentifierControl']['id'];
    $urlToFlash = '/ClinicalAnnotation/MiscIdentifiers/add/' . $this->Participant->getLastInsertID() . "/$miscIdentifierControlId";
}