<?php
$structureLinks = array(
    'bottom' => array(
        'edit' => '/Protocol/ProtocolMasters/edit/' . $atimMenuVariables['ProtocolMaster.id'] . '/',
        'delete' => '/Protocol/ProtocolMasters/delete/' . $atimMenuVariables['ProtocolMaster.id'] . '/'
    )
);

$structureSettings = array();
if ($displayPrecisions)
    $structureSettings['actions'] = false;

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

if ($displayPrecisions) {
    $finalAtimStructure = array();
    $finalOptions['type'] = 'detail';
    $finalOptions['settings']['header'] = __('precision');
    $finalOptions['settings']['actions'] = true;
    $finalOptions['extras'] = $this->Structures->ajaxIndex('Protocol/ProtocolExtendMasters/listall/' . $atimMenuVariables['ProtocolMaster.id']);
    $finalOptions['links']['bottom']['add precision'] = '/Protocol/ProtocolExtendMasters/add/' . $atimMenuVariables['ProtocolMaster.id'];
    
    $hookLink = $this->Structures->hook('precision');
    if ($hookLink) {
        require ($hookLink);
    }
    
    $this->Structures->build($finalAtimStructure, $finalOptions);
}