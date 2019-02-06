<?php
$structureLinks = array(
    'top' => '/ClinicalAnnotation/MiscIdentifiers/edit/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['MiscIdentifier.id'] . '/',
    'bottom' => array(
        'cancel' => '/ClinicalAnnotation/Participants/profile/' . $atimMenuVariables['Participant.id'] . '/'
    )
);

$structureOverride = array();

// Set form structure and option
$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'override' => $structureOverride
);
if ($atimStructure['Structure'][0]['alias'] == "incrementedmiscidentifiers") {
    $finalOptions['settings']['header'] = __("generated identifier");
}

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);