<?php
$structureLinks = array(
    'top' => '/ClinicalAnnotation/MiscIdentifiers/add/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['MiscIdentifierControl.id'] . '/',
    'bottom' => array(
        'cancel' => '/ClinicalAnnotation/Participants/profile/' . $atimMenuVariables['Participant.id'] . '/'
    )
);

$structureOverride = array();

if (isset($this->request->data['MiscIdentifierControl']['misc_identifier_format']) && $this->request->data['MiscIdentifierControl']['misc_identifier_format']) {
    $structureOverride['MiscIdentifier.identifier_value'] = $this->request->data['MiscIdentifierControl']['misc_identifier_format'];
}

// Set form structure and option
$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'override' => $structureOverride
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);