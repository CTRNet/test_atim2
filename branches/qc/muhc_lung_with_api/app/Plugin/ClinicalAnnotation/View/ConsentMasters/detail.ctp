<?php
$structureLinks = array(
    'top' => null,
    'bottom' => array(
        'edit' => '/ClinicalAnnotation/ConsentMasters/edit/' . $atimMenuVariables['Participant.id'] . '/%%ConsentMaster.id%%/',
        'delete' => '/ClinicalAnnotation/ConsentMasters/delete/' . $atimMenuVariables['Participant.id'] . '/%%ConsentMaster.id%%/'
    )
);

$structureSettings = array(
    'actions' => $isAjax
);
if (! $isAjax)
    $structureSettings['header'] = __($consentType, null);
    
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

if (! $isAjax) {
    $finalAtimStructure = array();
    $finalOptions['settings']['header'] = __('links to collections');
    $finalOptions['settings']['actions'] = true;
    $finalOptions['extras'] = $this->Structures->ajaxIndex('ClinicalAnnotation/ClinicalCollectionLinks/listall/' . $atimMenuVariables['Participant.id'] . '/noActions:/filterModel:ConsentMaster/filterId:' . $atimMenuVariables['ConsentMaster.id']);
    
    $hookLink = $this->Structures->hook('ccl');
    if ($hookLink) {
        require ($hookLink);
    }
    
    $this->Structures->build(array(), $finalOptions);
}