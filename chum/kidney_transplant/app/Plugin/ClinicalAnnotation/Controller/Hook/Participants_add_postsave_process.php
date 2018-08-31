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
        'MiscIdentifierControl.misc_identifier_name' => 'kidney transplant bank no lab',
        'MiscIdentifierControl.flag_active' => 1
    )
));
if ($miscIdentifierControlId) {
    $miscIdentifierControlId = $miscIdentifierControlId['MiscIdentifierControl']['id'];
    $urlToFlash = '/ClinicalAnnotation/MiscIdentifiers/add/' . $this->Participant->getLastInsertID() . "/$miscIdentifierControlId";
    $_SESSION['created_participant']['next_identifier_controls'] = array(
        'saint-luc id nbr',
        'ramq nbr'
    );
}