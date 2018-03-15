<?php
$structureLinks = array(
    'top' => '/Study/StudyReviews/edit/' . $atimMenuVariables['StudySummary.id'] . '/' . $atimMenuVariables['StudyReview.id'] . '/',
    'bottom' => array(
        'cancel' => '/Study/StudyReviews/detail/' . $atimMenuVariables['StudySummary.id'] . '/' . $atimMenuVariables['StudyReview.id'] . '/'
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