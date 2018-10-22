<?php
$structureLinks = array(
    'bottom' => array(
        'edit' => '/Study/StudyInvestigators/edit/' . $atimMenuVariables['StudySummary.id'] . '/%%StudyInvestigator.id%%/',
        'delete' => '/Study/StudyInvestigators/delete/' . $atimMenuVariables['StudySummary.id'] . '/%%StudyInvestigator.id%%/'
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