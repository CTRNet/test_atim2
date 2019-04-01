<?php
$structureLinks = array(
    'top' => null,
    'bottom' => array(
        'edit' => '/ClinicalAnnotation/ParticipantContacts/edit/' . $atimMenuVariables['Participant.id'] . '/%%ParticipantContact.id%%/',
        'delete' => '/ClinicalAnnotation/ParticipantContacts/delete/' . $atimMenuVariables['Participant.id'] . '/%%ParticipantContact.id%%/'
    )
);

// Set form structure and option
$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);