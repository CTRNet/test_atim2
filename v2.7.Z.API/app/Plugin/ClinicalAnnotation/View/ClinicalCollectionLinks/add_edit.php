<?php

// Consent----------------
$structureLinks['radiolist'] = array(
    'Collection.consent_master_id' => '%%ConsentMaster.id%%'
);
$structureSettings['header'] = __('consent');
$structureSettings['form_top'] = false;
// consent
$finalAtimStructure = $atimStructureConsentDetail;
$finalOptions = array(
    'type' => 'index',
    'data' => $consentData,
    'settings' => $structureSettings,
    'links' => $structureLinks,
    'extras' => array(
        'end' => '<input type="radio" name="data[Collection][consent_master_id]" ' . ($consentFound ? '' : 'checked="checked"') . '" value=""/>' . __('n/a')
    )
);
if (! AppController::checkLinkPermission('/ClinicalAnnotation/ConsentMasters/detail/')) {
    $finalAtimStructure = array();
    $finalOptions['type'] = 'detail';
    $finalOptions['data'] = array();
    $finalOptions['extras'] = '<div>' . __('You are not authorized to access that location.') . '</div>';
}

$displayNextSubForm = $cclsList['ConsentMaster']['active'];

// CUSTOM CODE
$hookLink = $this->Structures->hook('consent_detail');
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
if ($displayNextSubForm) {
    $this->Structures->build($finalAtimStructure, $finalOptions);
}

// Dx---------------------
$structureLinks['radiolist'] = array(
    'Collection.diagnosis_master_id' => '%%DiagnosisMaster.id' . '%%'
);
$structureLinks['tree'] = array(
    'DiagnosisMaster' => array(
        'radiolist' => array(
            'Collection.diagnosis_master_id' => '%%DiagnosisMaster.id' . '%%'
        )
    )
);

$structureSettings['header'] = __('diagnosis');
$structureSettings['tree'] = array(
    'DiagnosisMaster' => 'DiagnosisMaster'
);

$finalAtimStructure = array(
    'DiagnosisMaster' => $atimStructureDiagnosisDetail
);
$finalOptions = array(
    'type' => 'tree',
    'data' => $diagnosisData,
    'settings' => $structureSettings,
    'links' => $structureLinks,
    'extras' => array(
        'end' => '<input type="radio" name="data[Collection][diagnosis_master_id]"  ' . ($foundDx ? '' : 'checked="checked"') . ' value=""/>' . __('n/a')
    )
);
if (! AppController::checkLinkPermission('/ClinicalAnnotation/DiagnosisMasters/detail/')) {
    $finalAtimStructure = array();
    $finalOptions['type'] = 'detail';
    $finalOptions['data'] = array();
    $finalOptions['extras'] = '<div>' . __('You are not authorized to access that location.') . '</div>';
}

$displayNextSubForm = $cclsList['DiagnosisMaster']['active'];

// CUSTOM CODE
$hookLink = $this->Structures->hook('diagnosis_detail');
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
if ($displayNextSubForm)
    $this->Structures->build($finalAtimStructure, $finalOptions);
    
    // tx----------------
$structureLinks['radiolist'] = array(
    'Collection.treatment_master_id' => '%%TreatmentMaster.id%%'
);
unset($structureLinks['tree']);

$structureSettings['header'] = __('treatments');
unset($structureSettings['tree']);

$finalAtimStructure = $atimStructureTx;
$finalOptions = array(
    'type' => 'index',
    'data' => $txData,
    'settings' => $structureSettings,
    'links' => $structureLinks,
    'extras' => array(
        'end' => '<input type="radio" name="data[Collection][treatment_master_id]"  ' . ($foundTx ? '' : 'checked="checked"') . ' value=""/>' . __('n/a')
    )
);
if (! AppController::checkLinkPermission('/ClinicalAnnotation/TreatmentMasters/detail/')) {
    $finalAtimStructure = array();
    $finalOptions['type'] = 'detail';
    $finalOptions['data'] = array();
    $finalOptions['extras'] = '<div>' . __('You are not authorized to access that location.') . '</div>';
}

$displayNextSubForm = $cclsList['TreatmentMaster']['active'];

// CUSTOM CODE
$hookLink = $this->Structures->hook('trt_detail');
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
if ($displayNextSubForm)
    $this->Structures->build($finalAtimStructure, $finalOptions);
    
    // event----------------
$structureLinks['radiolist'] = array(
    'Collection.event_master_id' => '%%EventMaster.id%%'
);

$structureSettings['header'] = __('annotation');

$finalAtimStructure = $atimStructureEvent;
$finalOptions = array(
    'type' => 'index',
    'data' => $eventData,
    'settings' => $structureSettings,
    'links' => $structureLinks,
    'extras' => array(
        'end' => '<input type="radio" name="data[Collection][event_master_id]"  ' . ($foundEvent ? '' : 'checked="checked"') . ' value=""/>' . __('n/a')
    )
);
if (! AppController::checkLinkPermission('/ClinicalAnnotation/EventMasters/detail/')) {
    $finalAtimStructure = array();
    $finalOptions['type'] = 'detail';
    $finalOptions['data'] = array();
    $finalOptions['extras'] = '<div>' . __('You are not authorized to access that location.') . '</div>';
}

$displayNextSubForm = $cclsList['EventMaster']['active'];

// CUSTOM CODE
$hookLink = $this->Structures->hook('event_detail');
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
if ($displayNextSubForm){
    $this->Structures->build($finalAtimStructure, $finalOptions);
}

$formOptions = array(
    'settings' => array(
        'actions' => true,
        'form_bottom' => true
    ),
    'links' => array(
        'top' => $finalOptions['links']['top']
    )
);
if (isset($finalOptions['links']['bottom'])){
    $formOptions['links']['top'] = $finalOptions['links']['bottom'];
}
$this->Structures->build($emptyStructure, $formOptions);