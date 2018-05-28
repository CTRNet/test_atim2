<?php
$structureLinks = array(
    'bottom' => array(
        'edit' => '/Protocol/ProtocolExtendMasters/edit/' . $atimMenuVariables['ProtocolMaster.id'] . '/%%ProtocolExtendMaster.id%%/',
        'delete' => '/Protocol/ProtocolExtendMasters/delete/' . $atimMenuVariables['ProtocolMaster.id'] . '/%%ProtocolExtendMaster.id%%/'
    )
);

$structureSettings = array(
    'header' => __('precision')
);

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