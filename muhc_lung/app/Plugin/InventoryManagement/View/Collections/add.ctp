<?php
$structureLinks = array(
    'top' => '/InventoryManagement/Collections/add/' . $atimVariables['Collection.id'] . '/' . $copySource,
    'bottom' => array(
        'cancel' => 'javascript:history.go(-1)'
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