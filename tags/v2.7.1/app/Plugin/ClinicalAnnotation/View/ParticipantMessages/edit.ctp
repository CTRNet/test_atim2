<?php
$structureLinks = array(
    'top' => '/ClinicalAnnotation/ParticipantMessages/edit/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['ParticipantMessage.id'] . '/',
    'bottom' => array(
        'cancel' => '/ClinicalAnnotation/ParticipantMessages/detail/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['ParticipantMessage.id'] . '/'
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