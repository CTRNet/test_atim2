<?php
$structureLinks = array(
    'top' => null,
    'bottom' => array(
        'edit' => '/InventoryManagement/AliquotMasters/editAliquotInternalUse/' . $atimMenuVariables['AliquotMaster.id'] . '/%%AliquotInternalUse.id%%/',
        'delete' => '/InventoryManagement/AliquotMasters/deleteAliquotInternalUse/' . $atimMenuVariables['AliquotMaster.id'] . '/%%AliquotInternalUse.id%%/'
    )
);

$structureSettings = array(
    'header' => __('aliquot use/event', null)
);

// Set form structure and option
$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'type' => 'detail',
    'settings' => $structureSettings
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);