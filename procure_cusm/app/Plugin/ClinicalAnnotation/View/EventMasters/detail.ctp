<?php
$structureLinks = array(
    'index' => array(
        'detail' => '/ClinicalAnnotation/DiagnosisMasters/detail/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%'
    ),
    'bottom' => array(
        'edit' => '/ClinicalAnnotation/EventMasters/edit/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['EventMaster.id'],
        'delete' => '/ClinicalAnnotation/EventMasters/delete/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['EventMaster.id']
    )
);

// 1- EVENT DATA

$structureSettings = array(
    'actions' => $isAjax,
    'form_bottom' => ! $isAjax
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

if (! $isAjax) {
    
    $flagUseForCcl = $this->data['EventControl']['flag_use_for_ccl'];
    
    // 2- DIAGNOSTICS
    
    $structureSettings = array(
        'form_inputs' => false,
        'pagination' => false,
        'actions' => $flagUseForCcl ? false : true,
        'form_bottom' => true,
        'header' => __('related diagnosis'),
        'form_top' => false
    );
    
    $finalOptions = array(
        'data' => $diagnosisData,
        'type' => 'index',
        'settings' => $structureSettings,
        'links' => $structureLinks
    );
    $finalAtimStructure = $diagnosisStructure;
    
    if (! AppController::checkLinkPermission('/ClinicalAnnotation/DiagnosisMasters/listall')) {
        $finalOptions['type'] = 'detail';
        $finalAtimStructure = array();
        $finalOptions['extras'] = '<div>' . __('You are not authorized to access that location.') . '</div>';
    }
    
    $displayNextSubForm = true;
    
    $hookLink = $this->Structures->hook('dx_list');
    if ($hookLink) {
        require ($hookLink);
    }
    
    if ($displayNextSubForm)
        $this->Structures->build($finalAtimStructure, $finalOptions);
    
    $finalAtimStructure = array();
    $finalOptions['type'] = 'detail';
    $finalOptions['settings']['header'] = __('links to collections');
    $finalOptions['settings']['actions'] = true;
    $finalOptions['extras'] = $this->Structures->ajaxIndex('ClinicalAnnotation/ClinicalCollectionLinks/listall/' . $atimMenuVariables['Participant.id'] . '/noActions:/filterModel:EventMaster/filterId:' . $atimMenuVariables['EventMaster.id']);
    
    $displayNextSubForm = $flagUseForCcl ? true : false;
    
    $hookLink = $this->Structures->hook('ccl');
    if ($hookLink) {
        require ($hookLink);
    }
    
    if ($displayNextSubForm)
        $this->Structures->build(array(), $finalOptions);
}