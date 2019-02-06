<?php
$structureLinks = array(
    'index' => array(
        'detail' => '/Protocol/ProtocolExtendMasters/detail/' . $atimMenuVariables['ProtocolMaster.id'] . '/%%ProtocolExtendMaster.id%%/',
        'edit' => '/Protocol/ProtocolExtendMasters/edit/' . $atimMenuVariables['ProtocolMaster.id'] . '/%%ProtocolExtendMaster.id%%/',
        'delete' => '/Protocol/ProtocolExtendMasters/delete/' . $atimMenuVariables['ProtocolMaster.id'] . '/%%ProtocolExtendMaster.id%%/'
    ),
    'bottom' => array(
        'add' => '/Protocol/ProtocolExtendMasters/add/' . $atimMenuVariables['ProtocolMaster.id']
    )
);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'index',
    'links' => $structureLinks
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);