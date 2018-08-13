<?php
$structureLinks = array(
    'top' => '/ClinicalAnnotation/DiagnosisMasters/add/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['tableId'] . '/' . $atimMenuVariables['DiagnosisMaster.parent_id'] . '/',
    'bottom' => array(
        'cancel' => '/ClinicalAnnotation/DiagnosisMasters/listall/' . $atimMenuVariables['Participant.id'] . '/'
    )
);

// 1- DIAGNOSTIC DATA

$structureSettings = array(
    'tabindex' => 100,
    'header' => __('new ' . $dxCtrl['DiagnosisControl']['category']) . ' : ' . __($dxCtrl['DiagnosisControl']['controls_type'], null)
);

$structureOverride = array();
if ($dxCtrl['DiagnosisControl']['id'] == 15) {
    // unknown primary, add a disease code
    $structureOverride['DiagnosisMaster.icd10_code'] = 'D489';
}

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'settings' => $structureSettings,
    'override' => $structureOverride
);

$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

$this->Structures->build($finalAtimStructure, $finalOptions);