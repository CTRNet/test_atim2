<?php
$structureLinks = array(
    'top' => '/Protocol/ProtocolMasters/add/' . $atimMenuVariables['ProtocolControl.id'],
    'bottom' => array(
        'cancel' => '/Protocol/ProtocolMasters/search/'
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