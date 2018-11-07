<?php

// ----- ORDER DETAIL -----
$structureLinks = array(
    'index' => array(),
    'bottom' => array(
        'new search' => OrderAppController::$searchLinks,
        'edit' => '/Order/Orders/edit/' . $atimMenuVariables['Order.id'] . '/',
        'delete' => '/Order/Orders/delete/' . $atimMenuVariables['Order.id'] . '/',
        'order lines' => array(
            'add' => array(
                'link' => '/Order/OrderLines/add/' . $atimMenuVariables['Order.id'] . '/',
                'icon' => 'order line add'
            )
        ),
        'order items' => array(),
        'shipments' => array(
            'add' => array(
                'link' => '/Order/Shipments/add/' . $atimMenuVariables['Order.id'] . '/',
                'icon' => 'create_shipment'
            )
        )
    )
);
if (Configure::read('order_item_to_order_objetcs_link_setting') == 3)
    unset($structureLinks['bottom']['order lines']);
    
    // Add item links management
switch (Configure::read('order_item_type_config')) {
    case '1':
        $structureLinks['bottom']['order items'][__('add items to order') . ' : ' . __('tma slide')] = array(
            'link' => '/Order/OrderItems/add/' . $atimMenuVariables['Order.id'] . '/0/TmaSlide',
            'icon' => 'add_to_order'
        );
        $structureLinks['bottom']['order items'][__('add items to order') . ' : ' . __('aliquot')] = array(
            'link' => '/Order/OrderItems/add/' . $atimMenuVariables['Order.id'] . '/0/AliquotMaster',
            'icon' => 'add_to_order'
        );
        break;
    case '2':
        $structureLinks['bottom']['order items'][__('add items to order') . ' : ' . __('aliquot')] = array(
            'link' => '/Order/OrderItems/add/' . $atimMenuVariables['Order.id'] . '/0/AliquotMaster',
            'icon' => 'add_to_order'
        );
        break;
    case '3':
        $structureLinks['bottom']['order items'][__('add items to order') . ' : ' . __('tma slide')] = array(
            'link' => '/Order/OrderItems/add/' . $atimMenuVariables['Order.id'] . '/0/TmaSlide',
            'icon' => 'add_to_order'
        );
        break;
}
$structureLinks['bottom']['order items']['define order items returned'] = array(
    'link' => '/Order/OrderItems/defineOrderItemsReturned/' . $atimMenuVariables['Order.id'] . '/',
    'icon' => 'order items returned'
);
if (Configure::read('order_item_to_order_objetcs_link_setting') == 2)
    unset($structureLinks['bottom']['order items']);
    
    // Edit item links management
$structureLinks['bottom']['order items']['edit all items'] = array(
    'link' => '/Order/OrderItems/editInBatch/' . $atimMenuVariables['Order.id'] . '/0/0/0/',
    'icon' => 'edit'
);
$structureLinks['bottom']['order items']['edit pending items'] = array(
    'link' => '/Order/OrderItems/editInBatch/' . $atimMenuVariables['Order.id'] . '/0/0/0/pending',
    'icon' => 'edit'
);
$structureLinks['bottom']['order items']['edit shipped items'] = array(
    'link' => '/Order/OrderItems/editInBatch/' . $atimMenuVariables['Order.id'] . '/0/0/0/shipped/',
    'icon' => 'edit'
);
$structureLinks['bottom']['order items']['edit returned items'] = array(
    'link' => '/Order/OrderItems/editInBatch/' . $atimMenuVariables['Order.id'] . '/0/0/0/shipped & returned/',
    'icon' => 'edit'
);

// Add to shipment links management
$addToShipmentLinks = array();
foreach ($shipmentsList as $shipment) {
    $addToShipmentLinks[$shipment['Shipment']['shipment_code']] = array(
        'link' => '/Order/Shipments/addToShipment/' . $shipment['Shipment']['order_id'] . '/' . $shipment['Shipment']['id'],
        'icon' => 'add_to_shipment'
    );
}
ksort($addToShipmentLinks);
foreach ($addToShipmentLinks as $shipmentKey => $shipmentLink)
    $structureLinks['bottom']['shipments'][__('add items to shipment') . ' # ' . $shipmentKey] = $shipmentLink;

$structureOverride = array();

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'override' => $structureOverride,
    'settings' => array(
        'header' => ($isFromTreeView ? __('order') : ''),
        'actions' => ($isFromTreeView ? true : false)
    ),
    'data' => $orderData
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);

if (! $isFromTreeView) {
    // ----- ORDER LINES -----
    
    if (Configure::read('order_item_to_order_objetcs_link_setting') != 3) {
        $finalAtimStructure = array();
        $finalOptions = array(
            'links' => $structureLinks,
            'settings' => array(
                'header' => __('order_order lines', null),
                'actions' => false
            ),
            'extras' => array(
                'end' => $this->Structures->ajaxIndex('Order/OrderLines/listall/' . $atimMenuVariables['Order.id'])
            )
        );
        
        // CUSTOM CODE
        $hookLink = $this->Structures->hook('order_lines');
        if ($hookLink) {
            require ($hookLink);
        }
        
        // BUILD FORM
        $this->Structures->build($finalAtimStructure, $finalOptions);
    }
    
    // ----- ORDER ITEMS -----
    
    $counter = 0;
    $allStatus = array(
        'pending',
        'shipped',
        'shipped & returned'
    );
    foreach ($allStatus as $status) {
        $counter ++;
        $finalAtimStructure = array();
        $finalOptions = array(
            'links' => $structureLinks,
            'settings' => array(
                'language_heading' => __($status, null),
                'actions' => false
            ),
            'extras' => array(
                'end' => $this->Structures->ajaxIndex('Order/OrderItems/listall/' . $atimMenuVariables['Order.id'] . '/' . $status . '/0/0/Order/')
            )
        );
        if ($counter == 1)
            $finalOptions['settings']['header'] = __('order items', null);
            
            // CUSTOM CODE
        $hookLink = $this->Structures->hook('order_items');
        if ($hookLink) {
            require ($hookLink);
        }
        
        // BUILD FORM
        $this->Structures->build($finalAtimStructure, $finalOptions);
    }
    
    // ----- SHIPMENTS -----
    
    $finalAtimStructure = array();
    $finalOptions = array(
        'links' => $structureLinks,
        'settings' => array(
            'header' => __('shipments', null)
        ),
        'extras' => array(
            'end' => $this->Structures->ajaxIndex('Order/Shipments/listall/' . $atimMenuVariables['Order.id'])
        )
    );
    
    // CUSTOM CODE
    $hookLink = $this->Structures->hook('shipments');
    if ($hookLink) {
        require ($hookLink);
    }
    
    // BUILD FORM
    $this->Structures->build($finalAtimStructure, $finalOptions);
}