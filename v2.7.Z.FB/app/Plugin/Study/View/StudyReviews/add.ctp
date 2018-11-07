<?php
$structureLinks = array(
    'top' => '/Study/StudyReviews/add/' . $atimMenuVariables['StudySummary.id'] . '/',
    'bottom' => array(
        'cancel' => '/Study/StudyReviews/listall/' . $atimMenuVariables['StudySummary.id'] . '/'
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