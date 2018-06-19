<?php
$structureLinks = array(
    'top' => '/Study/StudyRelated/edit/' . $atimMenuVariables['StudySummary.id'] . '/' . $atimMenuVariables['StudyRelated.id'] . '/',
    'bottom' => array(
        'cancel' => '/Study/StudyRelated/detail/' . $atimMenuVariables['StudySummary.id'] . '/' . $atimMenuVariables['StudyRelated.id'] . '/'
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