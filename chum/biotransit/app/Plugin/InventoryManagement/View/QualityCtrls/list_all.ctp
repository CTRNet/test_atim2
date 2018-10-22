<?php
$structureLinks = array(
    'index' => array(
        'detail' => '/InventoryManagement/QualityCtrls/detail/' . $atimMenuVariables['Collection.id'] . '/' . $atimMenuVariables['SampleMaster.id'] . '/%%QualityCtrl.id%%',
        'edit' => '/InventoryManagement/QualityCtrls/edit/' . $atimMenuVariables['Collection.id'] . '/' . $atimMenuVariables['SampleMaster.id'] . '/%%QualityCtrl.id%%',
        'delete' => '/InventoryManagement/QualityCtrls/delete/' . $atimMenuVariables['Collection.id'] . '/' . $atimMenuVariables['SampleMaster.id'] . '/%%QualityCtrl.id%%'
    ),
    'bottom' => array(
        'add' => '/InventoryManagement/QualityCtrls/addInit/' . $atimMenuVariables['Collection.id'] . '/' . $atimMenuVariables['SampleMaster.id'] . '/'
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