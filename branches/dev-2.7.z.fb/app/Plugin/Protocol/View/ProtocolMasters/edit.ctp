<?php
$structureLinks = array(
    'top' => '/Protocol/ProtocolMasters/edit/' . $atimMenuVariables['ProtocolMaster.id'] . '/',
    'bottom' => array(
        'cancel' => '/Protocol/ProtocolMasters/detail/' . $atimMenuVariables['ProtocolMaster.id'] . '/'
    )
);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);