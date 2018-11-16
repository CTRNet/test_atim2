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
        'MiscIdentifierControl.misc_identifier_name' => 'ohri_ovary_bank_participant_id',
        'MiscIdentifierControl.flag_active' => 1
    )
));
if ($miscIdentifierControlId) {
    $miscIdentifierControlId = $miscIdentifierControlId['MiscIdentifierControl']['id'];
    $urlToFlash = '/ClinicalAnnotation/MiscIdentifiers/add/' . $this->Participant->getLastInsertID() . "/$miscIdentifierControlId";
    $_SESSION['ohri_transp_next_identifier_controls'] = array(
        'ohri_hospital_card'
    );
}