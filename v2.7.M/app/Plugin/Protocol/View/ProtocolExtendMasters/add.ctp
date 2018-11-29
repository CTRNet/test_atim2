<?php
$structureLinks = array(
    'top' => '/Protocol/ProtocolExtendMasters/add/' . $atimMenuVariables['ProtocolMaster.id'],
    'bottom' => array(
        'cancel' => '/Protocol/ProtocolMasters/detail/' . $atimMenuVariables['ProtocolMaster.id']
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