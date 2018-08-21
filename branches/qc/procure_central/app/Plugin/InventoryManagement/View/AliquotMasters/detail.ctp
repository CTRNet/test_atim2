<?php
$settings = array();

// Set links
$structureLinks = array(
    'index' => array(),
    'bottom' => array()
);
$colIdSampIdAlId = $atimMenuVariables['Collection.id'] . '/' . $atimMenuVariables['SampleMaster.id'] . '/' . $atimMenuVariables['AliquotMaster.id'];
$structureLinks['bottom']['edit'] = '/InventoryManagement/AliquotMasters/edit/' . $colIdSampIdAlId;
$structureLinks['bottom']['delete'] = '/InventoryManagement/AliquotMasters/delete/' . $colIdSampIdAlId;
$structureLinks['bottom']['print barcode'] = array(
    'link' => '/InventoryManagement/AliquotMasters/printBarcodes/model:AliquotMaster/id:' . $atimMenuVariables['AliquotMaster.id'],
    'icon' => 'barcode'
);
$structureLinks['bottom']['storage'] = '/underdevelopment/';
if (! empty($aliquotStorageData)) {
    $structureLinks['bottom']['storage'] = array(
        'plugin storagelayout access to storage' => array(
            "link" => '/StorageLayout/StorageMasters/detail/' . $aliquotStorageData['StorageMaster']['id'],
            "icon" => "storage"
        ),
        'remove from storage' => array(
            "link" => '/InventoryManagement/AliquotMasters/removeAliquotFromStorage/' . $colIdSampIdAlId,
            "icon" => "storage"
        )
    );
}
if (Configure::read('order_item_type_config') != '3')
    $structureLinks['bottom']['add to order'] = array(
        "link" => '/Order/OrderItems/addOrderItemsInBatch/AliquotMaster/' . $atimMenuVariables['AliquotMaster.id'] . '/',
        "icon" => "add_to_order"
    );
$structureLinks['bottom']['add uses/events'] = array(
    "link" => '/InventoryManagement/AliquotMasters/addAliquotInternalUse/' . $atimMenuVariables['AliquotMaster.id'],
    "icon" => "use"
);
$structureLinks['bottom']['realiquoting'] = array(
    'realiquot' => array(
        "link" => '/InventoryManagement/AliquotMasters/realiquotInit/creation/' . $atimMenuVariables['AliquotMaster.id'],
        "icon" => "aliquot"
    ),
    'define realiquoted children' => array(
        "link" => '/InventoryManagement/AliquotMasters/realiquotInit/definition/' . $atimMenuVariables['AliquotMaster.id'],
        "icon" => "aliquot"
    )
);
$structureLinks['bottom']['create derivative'] = $canCreateDerivative ? '/InventoryManagement/SampleMasters/batchDerivativeInit/' . $atimMenuVariables['AliquotMaster.id'] : 'cannot';

if ($isFromTreeViewOrLayout == 1) {
    // Tree view
    $settings['header'] = __('aliquot', null) . ': ' . __('details');
} elseif ($isFromTreeViewOrLayout == 2) {
    // Storage Layout
    $structureLinks = array();
    $structureLinks['bottom']['access to aliquot'] = '/InventoryManagement/AliquotMasters/detail/' . $atimMenuVariables['Collection.id'] . '/' . $atimMenuVariables['SampleMaster.id'] . '/' . $atimMenuVariables['AliquotMaster.id'];
    if ($aliquotMasterData['Collection']['participant_id'])
        $structureLinks['bottom']['access to participant'] = '/ClinicalAnnotation/Participants/profile/' . $aliquotMasterData['Collection']['participant_id'];
    $settings['header'] = __('aliquot', null);
}

$finalAtimStructure = $atimStructure;
if ($isFromTreeViewOrLayout) {
    // DISPLAY ONLY ALIQUOT DETAIL FORM
    // 1- ALIQUOT DETAIL
    $finalOptions = array(
        'links' => $structureLinks,
        'data' => $aliquotMasterData,
        'settings' => $settings
    );
    
    // CUSTOM CODE
    $hookLink = $this->Structures->hook('aliquot_detail_1');
    if ($hookLink) {
        require ($hookLink);
    }
    
    // BUILD FORM
    $this->Structures->build($finalAtimStructure, $finalOptions);
} else {
    // DISPLAY BOTH ALIQUOT DETAIL FORM AND ALIQUOT USES LIST
    // 1- ALIQUOT DETAIL
    $finalOptions = array(
        'settings' => array(
            'actions' => false
        ),
        'data' => $aliquotMasterData
    );
    
    // CUSTOM CODE
    $hookLink = $this->Structures->hook('aliquot_detail_2');
    if ($hookLink) {
        require ($hookLink);
    }
    
    // BUILD FORM
    $this->Structures->build($finalAtimStructure, $finalOptions);
    $dataUrl = sprintf('InventoryManagement/AliquotMasters/listallUses/%d/%d/%d/', $atimMenuVariables['Collection.id'], $atimMenuVariables['SampleMaster.id'], $atimMenuVariables['AliquotMaster.id']);
    // 2- USES LIST
    $finalAtimStructure = $emptyStructure;
    $finalOptions = array(
        'data' => array(),
        'settings' => array(
            'header' => __('history'),
            'language_heading' => __('uses and events'),
            'actions' => false
        ),
        'extras' => $this->Structures->ajaxIndex($dataUrl)
    );
    
    // CUSTOM CODE
    $hookLink = $this->Structures->hook('uses');
    if ($hookLink) {
        require ($hookLink);
    }
    
    // BUILD FORM
    $this->Structures->build($finalAtimStructure, $finalOptions);
    
    // 3- STORAGE HISTORY
    $dataUrl = sprintf('InventoryManagement/AliquotMasters/storageHistory/%d/%d/%d/', $atimMenuVariables['Collection.id'], $atimMenuVariables['SampleMaster.id'], $atimMenuVariables['AliquotMaster.id']);
    unset($structureLinks['index']);
    $finalAtimStructure = $emptyStructure;
    $finalOptions = array(
        'links' => $structureLinks,
        'settings' => array(
            'language_heading' => __('storage') . ' (' . __('system data') . ')',
            'actions' => false
        ),
        'extras' => $this->Structures->ajaxIndex($dataUrl)
    );
    
    $hookLink = $this->Structures->hook('storage_history');
    if ($hookLink) {
        require ($hookLink);
    }
    
    $this->Structures->build($finalAtimStructure, $finalOptions);
    
    // 4 - REALIQUOTED PARENTS
    $dataUrl = sprintf('InventoryManagement/AliquotMasters/listAllRealiquotedParents/%d/%d/%d/', $atimMenuVariables['Collection.id'], $atimMenuVariables['SampleMaster.id'], $atimMenuVariables['AliquotMaster.id']);
    unset($structureLinks['index']);
    $finalAtimStructure = $emptyStructure;
    $finalOptions = array(
        'links' => $structureLinks,
        'settings' => array(
            'header' => __('realiquoted parent')
        ),
        'extras' => $this->Structures->ajaxIndex($dataUrl)
    );
    
    $hookLink = $this->Structures->hook('realiquoted_parent');
    if ($hookLink) {
        require ($hookLink);
    }
    
    $this->Structures->build($finalAtimStructure, $finalOptions);
}