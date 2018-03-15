<?php
$structureLinks = array(
    'top' => '/ClinicalAnnotation/DiagnosisMasters/edit/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['DiagnosisMaster.id'] . '/',
    'bottom' => array(
        'cancel' => '/ClinicalAnnotation/DiagnosisMasters/detail/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['DiagnosisMaster.id'] . '/'
    )
);

// 1- DIAGNOSTIC DATA

$structureSettings = array(
    'header' => null
);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'settings' => $structureSettings
);

$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

$this->Structures->build($finalAtimStructure, $finalOptions);