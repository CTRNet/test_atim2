<?php
$structureLinks = array(
    'top' => '/ClinicalAnnotation/ReproductiveHistories/edit/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['ReproductiveHistory.id'] . '/',
    'bottom' => array(
        'cancel' => '/ClinicalAnnotation/ReproductiveHistories/detail/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['ReproductiveHistory.id'] . '/'
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