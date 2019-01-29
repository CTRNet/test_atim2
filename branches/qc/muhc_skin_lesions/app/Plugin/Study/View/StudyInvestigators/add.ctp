<?php
$structureLinks = array(
    'top' => '/Study/StudyInvestigators/add/' . $atimMenuVariables['StudySummary.id'] . '/',
    'bottom' => array(
        'cancel' => '/Study/StudySummaries/detail/' . $atimMenuVariables['StudySummary.id'] . '/'
    )
);

// Set form structure and option
$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'settings' => array(
        'header' => __('study investigator')
    ),
    'links' => $structureLinks
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);