<?php
$structureLinks = array(
    'top' => '/Study/StudySummaries/add/',
    'bottom' => array(
        'cancel' => '/Study/StudySummaries/search/'
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