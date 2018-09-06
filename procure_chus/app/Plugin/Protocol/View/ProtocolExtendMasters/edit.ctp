<?php
$structureLinks = array(
    'top' => '/Protocol/ProtocolExtendMasters/edit/' . $atimMenuVariables['ProtocolMaster.id'] . '/' . $atimMenuVariables['ProtocolExtendMaster.id'] . '/',
    'bottom' => array(
        'cancel' => '/Protocol/ProtocolExtendMasters/detail/' . $atimMenuVariables['ProtocolMaster.id'] . '/' . $atimMenuVariables['ProtocolExtendMaster.id'] . '/'
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