<?php
$structureLinks = array(
    'bottom' => array(
        'edit' => '/Study/StudyReviews/edit/' . $atimMenuVariables['StudySummary.id'] . '/%%StudyReview.id%%/',
        'delete' => '/Study/StudyReviews/delete/' . $atimMenuVariables['StudySummary.id'] . '/%%StudyReview.id%%/'
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