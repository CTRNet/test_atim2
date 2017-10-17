<?php
$structureLinks = array(
    'top' => '/Study/StudyResults/edit/' . $atimMenuVariables['StudySummary.id'] . '/' . $atimMenuVariables['StudyResult.id'] . '/',
    'bottom' => array(
        'cancel' => '/Study/StudyResults/detail/' . $atimMenuVariables['StudySummary.id'] . '/' . $atimMenuVariables['StudyResult.id'] . '/'
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