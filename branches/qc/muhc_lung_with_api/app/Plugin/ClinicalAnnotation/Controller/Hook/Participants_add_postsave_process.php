<?php
/**
 * **********************************************************************
 * CUSM
 * ***********************************************************************
 *
 * Clinical Annotation plugin custom code
 *
 * @author N. Luc - CTRNet (nicol.luc@gmail.com)
 * @since 2018-10-15
 */

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
        'MiscIdentifierControl.misc_identifier_name' => 'lung bank participant number',
        'MiscIdentifierControl.flag_active' => 1
    )
));
if ($miscIdentifierControlId) {
    $miscIdentifierControlId = $miscIdentifierControlId['MiscIdentifierControl']['id'];
    $urlToFlash = '/ClinicalAnnotation/MiscIdentifiers/add/' . $this->Participant->getLastInsertID() . "/$miscIdentifierControlId";
    $_SESSION['cusm_next_identifier_controls'] = array(
        'ramq nbr',
        'MGH-MRN'
    );
}