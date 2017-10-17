<?php
$structureLinks = array(
    'top' => '/InventoryManagement/AliquotMasters/editRealiquoting/' . $realiquotingId,
    'bottom' => array(
        'cancel' => '/InventoryManagement/AliquotMasters/detail/' . $atimMenuVariables['Collection.id'] . '/' . $atimMenuVariables['SampleMaster.id'] . '/' . $atimMenuVariables['AliquotMaster.id']
    )
);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'edit',
    'links' => $structureLinks,
    'settings' => array(
        'header' => __('realiquoted parent')
    )
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);