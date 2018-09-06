<?php
$structureLinks = array(
    'top' => '/ClinicalAnnotation/ConsentMasters/add/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['ConsentControl.id'] . '/',
    'bottom' => array(
        'cancel' => '/ClinicalAnnotation/ConsentMasters/listall/' . $atimMenuVariables['Participant.id'] . '/'
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