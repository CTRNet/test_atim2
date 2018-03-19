<?php
$structureLinks = array(
    'index' => array(
        'detail' => '/ClinicalAnnotation/FamilyHistories/detail/' . $atimMenuVariables['Participant.id'] . '/%%FamilyHistory.id%%/',
        'edit' => '/ClinicalAnnotation/FamilyHistories/edit/' . $atimMenuVariables['Participant.id'] . '/%%FamilyHistory.id%%/',
        'delete' => '/ClinicalAnnotation/FamilyHistories/delete/' . $atimMenuVariables['Participant.id'] . '/%%FamilyHistory.id%%/'
    ),
    'bottom' => array(
        'add' => '/ClinicalAnnotation/FamilyHistories/add/' . $atimMenuVariables['Participant.id']
    )
);

// Set form structure and option
/* ==> Note: Set both form structure and option into 2 variables to allow hooks to modify them */

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