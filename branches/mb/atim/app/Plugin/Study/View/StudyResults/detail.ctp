<?php
$structureLinks = array(
    'bottom' => array(
        'edit' => '/Study/StudyResults/edit/' . $atimMenuVariables['StudySummary.id'] . '/%%StudyResult.id%%/',
        'delete' => '/Study/StudyResults/delete/' . $atimMenuVariables['StudySummary.id'] . '/%%StudyResult.id%%/'
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