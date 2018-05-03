<?php

// 1- QUALITY CONTROL DATA
$structureLinks = array(
    'index' => array(
        'detail' => '/InventoryManagement/AliquotMasters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%',
        'delete' => '/InventoryManagement/QualityCtrls/deleteTestedAliquot/' . $atimMenuVariables['QualityCtrl.id'] . '/%%AliquotMaster.id%%/quality_controls_details/'
    ),
    'bottom' => array(
        'used aliquot' => '/InventoryManagement/AliquotMasters/detail/' . $atimMenuVariables['Collection.id'] . '/' . $atimMenuVariables['SampleMaster.id'] . '/' . $qualityCtrlData['QualityCtrl']['aliquot_master_id'],
        'edit' => '/InventoryManagement/QualityCtrls/edit/' . $atimMenuVariables['Collection.id'] . '/' . $atimMenuVariables['SampleMaster.id'] . '/' . $atimMenuVariables['QualityCtrl.id'] . '/',
        'delete' => '/InventoryManagement/QualityCtrls/delete/' . $atimMenuVariables['Collection.id'] . '/' . $atimMenuVariables['SampleMaster.id'] . '/' . $atimMenuVariables['QualityCtrl.id'] . '/'
    )
);
if (empty($qualityCtrlData['QualityCtrl']['aliquot_master_id']))
    unset($structureLinks['bottom']['used aliquot']);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'data' => $qualityCtrlData,
    'links' => $structureLinks
);

if ($isFromTreeView) {
    $finalOptions['settings']['header'] = __('quality control');
}

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);