<?php
$structureLinks = array(
    'top' => '/InventoryManagement/AliquotMasters/editSourceAliquot/' . $atimMenuVariables['SampleMaster.id'] . '/' . $atimMenuVariables['AliquotMaster.id'] . '/',
    'bottom' => array(
        'cancel' => '/InventoryManagement/SampleMasters/detail/' . $atimMenuVariables['Collection.id'] . '/' . $atimMenuVariables['SampleMaster.id']
    )
);

if (! $showSubmitButton)
    unset($structureLinks['top']);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'edit',
    'links' => $structureLinks,
    'settings' => array(
        'header' => __('listall source aliquots')
    )
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);