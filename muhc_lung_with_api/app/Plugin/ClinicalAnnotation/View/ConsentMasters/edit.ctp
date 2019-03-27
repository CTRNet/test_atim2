<?php
$structureLinks = array(
    'top' => '/ClinicalAnnotation/ConsentMasters/edit/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['ConsentMaster.id'] . '/',
    'bottom' => array(
        'cancel' => '/ClinicalAnnotation/ConsentMasters/detail/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['ConsentMaster.id'] . '/'
    )
);

$structureSettings = array(
    'header' => __($consentType, null)
);

// Set form structure and option
$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'settings' => $structureSettings
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);