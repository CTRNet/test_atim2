<?php
$structureLinks = array(
    'bottom' => array(
        'edit' => '/Study/StudyRelated/edit/' . $atimMenuVariables['StudySummary.id'] . '/%%StudyRelated.id%%/',
        'delete' => '/Study/StudyRelated/delete/' . $atimMenuVariables['StudySummary.id'] . '/%%StudyRelated.id%%/'
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