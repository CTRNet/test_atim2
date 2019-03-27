<?php
$structureLinks = array(
    'top' => null,
    'index' => '/Study/StudyContacts/detail/' . $atimMenuVariables['StudySummary.id'] . '/%%StudyContact.id%%',
    'bottom' => array(
        'add' => '/Study/StudyContacts/add/' . $atimMenuVariables['StudySummary.id'] . '/'
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