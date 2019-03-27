<?php
$structureLinks = array(
    'top' => '/Study/StudyContacts/add/' . $atimMenuVariables['StudySummary.id'] . '/',
    'bottom' => array(
        'cancel' => '/Study/StudyContacts/listall/' . $atimMenuVariables['StudySummary.id'] . '/'
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