<?php
$structureLinks = array(
    'index' => array(
        'detail' => '/ClinicalAnnotation/ReproductiveHistories/detail/' . $atimMenuVariables['Participant.id'] . '/%%ReproductiveHistory.id%%/',
        'edit' => '/ClinicalAnnotation/ReproductiveHistories/edit/' . $atimMenuVariables['Participant.id'] . '/%%ReproductiveHistory.id%%/',
        'delete' => '/ClinicalAnnotation/ReproductiveHistories/delete/' . $atimMenuVariables['Participant.id'] . '/%%ReproductiveHistory.id%%/'
    ),
    'bottom' => array(
        'add' => '/ClinicalAnnotation/ReproductiveHistories/add/' . $atimMenuVariables['Participant.id'] . '/'
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