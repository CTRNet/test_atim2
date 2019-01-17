<?php
$structureLinks = array(
    'bottom' => array(
        'edit' => '/Study/StudyFundings/edit/' . $atimMenuVariables['StudySummary.id'] . '/%%StudyFunding.id%%/',
        'delete' => '/Study/StudyFundings/delete/' . $atimMenuVariables['StudySummary.id'] . '/%%StudyFunding.id%%/'
    )
);

// Set form structure and option
$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'settings' => array(
        'header' => __('study funding')
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