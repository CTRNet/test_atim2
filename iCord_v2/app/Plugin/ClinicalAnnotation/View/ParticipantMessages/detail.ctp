<?php
$structureLinks = array(
    'bottom' => array(
        'edit' => '/ClinicalAnnotation/ParticipantMessages/edit/' . $atimMenuVariables['Participant.id'] . '/%%ParticipantMessage.id%%/',
        'delete' => '/ClinicalAnnotation/ParticipantMessages/delete/' . $atimMenuVariables['Participant.id'] . '/%%ParticipantMessage.id%%/'
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