<?php
$structureLinks = array(
    'top' => '/Study/StudyContacts/edit/' . $atimMenuVariables['StudySummary.id'] . '/' . $atimMenuVariables['StudyContact.id'] . '/',
    'bottom' => array(
        'cancel' => '/Study/StudyContacts/detail/' . $atimMenuVariables['StudySummary.id'] . '/' . $atimMenuVariables['StudyContact.id'] . '/'
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