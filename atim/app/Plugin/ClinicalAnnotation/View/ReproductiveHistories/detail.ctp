<?php
$structureLinks = array(
    'bottom' => array(
        'edit' => '/ClinicalAnnotation/ReproductiveHistories/edit/' . $atimMenuVariables['Participant.id'] . '/%%ReproductiveHistory.id%%/',
        'delete' => '/ClinicalAnnotation/ReproductiveHistories/delete/' . $atimMenuVariables['Participant.id'] . '/%%ReproductiveHistory.id%%/'
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