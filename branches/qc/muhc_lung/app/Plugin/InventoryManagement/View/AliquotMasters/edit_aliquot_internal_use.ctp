<?php
$structureLinks = array(
    'top' => '/InventoryManagement/AliquotMasters/editAliquotInternalUse/' . $atimMenuVariables['AliquotMaster.id'] . '/' . $aliquotUseId . '/',
    'bottom' => array(
        'cancel' => '/InventoryManagement/AliquotMasters/detailAliquotInternalUse/' . $atimMenuVariables['AliquotMaster.id'] . '/' . $aliquotUseId . '/'
    )
);

$structureSettings = array(
    'header' => __('aliquot use/event', null)
);

$structureOverride = array();

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'override' => $structureOverride,
    'type' => 'edit',
    'settings' => $structureSettings
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);