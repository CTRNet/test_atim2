<?php
$structureLinks = array(
    'top' => '/InventoryManagement/Collections/edit/' . $atimMenuVariables['Collection.id'],
    'bottom' => array(
        'cancel' => '/InventoryManagement/Collections/detail/' . $atimMenuVariables['Collection.id']
    )
);

$structureOverride = array();

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'override' => $structureOverride
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);