<?php
$structureLinks = array(
    'top' => '/ClinicalAnnotation/Participants/edit/' . $atimMenuVariables['Participant.id'],
    'bottom' => array(
        'cancel' => '/ClinicalAnnotation/Participants/profile/' . $atimMenuVariables['Participant.id']
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