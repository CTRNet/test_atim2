<?php

// Set links and settings
$structureLinks = array();
$settings = array(
    'header' => __('tma slide'),
    'actions' => ($isFromTreeViewOrLayout) ? true : false
);

// Basic
$structureLinks = array(
    'bottom' => array(
        'edit' => '/StorageLayout/TmaSlides/edit/' . $atimMenuVariables['StorageMaster.id'] . '/' . $atimMenuVariables['TmaSlide.id'] . '/1',
        'delete' => '/StorageLayout/TmaSlides/delete/' . $atimMenuVariables['StorageMaster.id'] . '/' . $atimMenuVariables['TmaSlide.id'],
        'add tma slide use' => '/StorageLayout/TmaSlideUses/add/' . $atimMenuVariables['TmaSlide.id']
    )
);

// Clean up based on form type
if ($isFromTreeViewOrLayout == 1) {
    // Tree view
} elseif ($isFromTreeViewOrLayout == 2) {
    // Storage Layout
    $structureLinks = array();
    $structureLinks['bottom']['access to all data'] = '/StorageLayout/TmaSlides/detail/' . $atimMenuVariables['StorageMaster.id'] . '/' . $atimMenuVariables['TmaSlide.id'];
}

$structureOverride = array();

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'override' => $structureOverride,
    'settings' => $settings
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);

// TMA Slide Uses

if (! $isFromTreeViewOrLayout) {
    
    // Uses
    
    $finalAtimStructure = array();
    $finalOptions = array(
        'links' => $structureLinks,
        'settings' => array(
            'actions' => (Configure::read('order_item_type_config') == '2'),
            'header' => __('analysis/scoring', null)
        ),
        'extras' => array(
            'end' => $this->Structures->ajaxIndex('StorageLayout/TmaSlideUses/listAll/' . $atimMenuVariables['StorageMaster.id'] . '/' . $atimMenuVariables['TmaSlide.id'])
        )
    );
    
    // CUSTOM CODE
    $hookLink = $this->Structures->hook('uses');
    if ($hookLink) {
        require ($hookLink);
    }
    
    // BUILD FORM
    $this->Structures->build($finalAtimStructure, $finalOptions);
    
    // Orders
    
    if (Configure::read('order_item_type_config') != '2') {
        
        $structureLinks['bottom']['add to order'] = array(
            "link" => '/Order/OrderItems/addOrderItemsInBatch/TmaSlide/' . $atimMenuVariables['TmaSlide.id'] . '/',
            "icon" => "add_to_order"
        );
        
        $finalAtimStructure = array();
        $finalOptions = array(
            'links' => $structureLinks,
            'settings' => array(
                'header' => __('orders', null)
            ),
            'extras' => array(
                'end' => $this->Structures->ajaxIndex('Order/OrderItems/listAllOrderItemsLinkedToOneObject/TmaSlide/' . $atimMenuVariables['TmaSlide.id'])
            )
        );
        
        // CUSTOM CODE
        $hookLink = $this->Structures->hook('orders');
        if ($hookLink) {
            require ($hookLink);
        }
        
        // BUILD FORM
        $this->Structures->build($finalAtimStructure, $finalOptions);
    }
}