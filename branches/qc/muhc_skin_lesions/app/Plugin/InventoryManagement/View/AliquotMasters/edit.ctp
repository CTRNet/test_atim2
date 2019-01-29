<?php
$structureLinks = array(
    'top' => '/InventoryManagement/AliquotMasters/edit/' . $atimMenuVariables['Collection.id'] . '/' . $atimMenuVariables['SampleMaster.id'] . '/' . $atimMenuVariables['AliquotMaster.id'],
    'bottom' => array(
        'cancel' => '/InventoryManagement/SampleMasters/detail/' . $atimMenuVariables['Collection.id'] . '/' . $atimMenuVariables['SampleMaster.id']
    )
);

$structureOverride = array();
$dropdownOptions = array();

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'override' => $structureOverride,
    'dropdown_options' => $dropdownOptions
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);