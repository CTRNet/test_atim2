<?php
$structureLinks = array(
    'top' => '/ClinicalAnnotation/TreatmentExtendMasters/edit/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['TreatmentMaster.id'] . '/' . $atimMenuVariables['TreatmentExtendMaster.id'],
    'bottom' => array(
        'cancel' => '/ClinicalAnnotation/TreatmentMasters/detail/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['TreatmentMaster.id']
    )
);

$structureOverride = array();

$structureSettings = array(
    'header' => ($txExtendType ? __($txExtendType, null) : __('precision', null))
);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'override' => $structureOverride,
    'settings' => $structureSettings
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);