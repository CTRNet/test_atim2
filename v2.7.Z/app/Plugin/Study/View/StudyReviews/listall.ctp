<?php
$structureLinks = array(
    'top' => NULL,
    'index' => '/Study/StudyReviews/detail/' . $atimMenuVariables['StudySummary.id'] . '/%%StudyReview.id%%',
    'bottom' => array(
        'add' => '/Study/StudyReviews/add/' . $atimMenuVariables['StudySummary.id'] . '/'
    )
);

// Set form structure and option
$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'index',
    'links' => $structureLinks
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);