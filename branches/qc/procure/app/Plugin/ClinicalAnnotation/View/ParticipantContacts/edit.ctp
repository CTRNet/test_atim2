<?php
$structureLinks = array(
    'top' => '/ClinicalAnnotation/ParticipantContacts/edit/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['ParticipantContact.id'] . '/',
    'bottom' => array(
        'cancel' => '/ClinicalAnnotation/ParticipantContacts/detail/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['ParticipantContact.id'] . '/'
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