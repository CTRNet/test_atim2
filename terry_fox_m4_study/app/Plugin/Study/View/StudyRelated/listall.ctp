<?php
$structureLinks = array(
    'top' => null,
    'index' => '/Study/StudyRelated/detail/' . $atimMenuVariables['StudySummary.id'] . '/%%StudyRelated.id%%/',
    'bottom' => array(
        'add' => '/Study/StudyRelated/add/' . $atimMenuVariables['StudySummary.id'] . '/'
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