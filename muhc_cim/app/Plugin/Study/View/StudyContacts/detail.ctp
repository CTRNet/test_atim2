<?php
$structureLinks = array(
    'bottom' => array(
        'edit' => '/Study/StudyContacts/edit/' . $atimMenuVariables['StudySummary.id'] . '/%%StudyContact.id%%/',
        'delete' => '/Study/StudyContacts/delete/' . $atimMenuVariables['StudySummary.id'] . '/%%StudyContact.id%%/'
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