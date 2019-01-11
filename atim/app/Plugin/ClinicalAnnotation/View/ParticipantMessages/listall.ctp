<?php
$structureLinks = array(
    'index' => array(
        'detail' => '/ClinicalAnnotation/ParticipantMessages/detail/' . $atimMenuVariables['Participant.id'] . '/%%ParticipantMessage.id%%/',
        'edit' => '/ClinicalAnnotation/ParticipantMessages/edit/' . $atimMenuVariables['Participant.id'] . '/%%ParticipantMessage.id%%/',
        'delete' => '/ClinicalAnnotation/ParticipantMessages/delete/' . $atimMenuVariables['Participant.id'] . '/%%ParticipantMessage.id%%/'
    ),
    'bottom' => array(
        'add' => '/ClinicalAnnotation/ParticipantMessages/add/' . $atimMenuVariables['Participant.id'] . '/'
    )
);

// Set form structure and option
$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'index',
    'links' => $structureLinks
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);