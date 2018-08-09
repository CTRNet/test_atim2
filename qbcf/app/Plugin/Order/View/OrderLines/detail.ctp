<?php
$structureLinks = array(
    'bottom' => array(
        'new search' => OrderAppController::$searchLinks,
        'edit' => '/Order/OrderLines/edit/' . $atimMenuVariables['Order.id'] . '/' . $atimMenuVariables['OrderLine.id'],
        'delete' => '/Order/OrderLines/delete/' . $atimMenuVariables['Order.id'] . '/' . $atimMenuVariables['OrderLine.id'],
        'order items' => array(),
        'shipments' => array(
            'add' => array(
                'link' => '/Order/Shipments/add/' . $atimMenuVariables['Order.id'] . '/0/' . $atimMenuVariables['OrderLine.id'],
                'icon' => 'create_shipment'
            )
        )
    )
);

// Add item links management
switch (Configure::read('order_item_type_config')) {
    case '1':
        $structureLinks['bottom']['order items'][__('add items to order line') . ' : ' . __('tma slide')] = array(
            'link' => '/Order/OrderItems/add/' . $atimMenuVariables['Order.id'] . '/' . $atimMenuVariables['OrderLine.id'] . '/TmaSlide',
            'icon' => 'add_to_order'
        );
        $structureLinks['bottom']['order items'][__('add items to order line') . ' : ' . __('aliquot')] = array(
            'link' => '/Order/OrderItems/add/' . $atimMenuVariables['Order.id'] . '/' . $atimMenuVariables['OrderLine.id'] . '/AliquotMaster',
            'icon' => 'add_to_order'
        );
        break;
    case '2':
        $structureLinks['bottom']['order items'][__('add items to order line') . ' : ' . __('aliquot')] = array(
            'link' => '/Order/OrderItems/add/' . $atimMenuVariables['Order.id'] . '/' . $atimMenuVariables['OrderLine.id'] . '/AliquotMaster',
            'icon' => 'add_to_order'
        );
        break;
    case '3':
        $structureLinks['bottom']['order items'][__('add items to order line') . ' : ' . __('tma slide')] = array(
            'link' => '/Order/OrderItems/add/' . $atimMenuVariables['Order.id'] . '/' . $atimMenuVariables['OrderLine.id'] . '/TmaSlide',
            'icon' => 'add_to_order'
        );
        break;
}
$structureLinks['bottom']['order items']['define order items returned'] = array(
    'link' => '/Order/OrderItems/defineOrderItemsReturned/' . $atimMenuVariables['Order.id'] . '/' . $atimMenuVariables['OrderLine.id'] . '/',
    'icon' => 'order items returned'
);
$structureLinks['bottom']['order items']['edit all items'] = array(
    'link' => '/Order/OrderItems/editInBatch/' . $atimMenuVariables['Order.id'] . '/' . $atimMenuVariables['OrderLine.id'] . '/0/0/',
    'icon' => 'edit'
);
$structureLinks['bottom']['order items']['edit pending items'] = array(
    'link' => '/Order/OrderItems/editInBatch/' . $atimMenuVariables['Order.id'] . '/' . $atimMenuVariables['OrderLine.id'] . '/0/0/pending',
    'icon' => 'edit'
);
$structureLinks['bottom']['order items']['edit shipped items'] = array(
    'link' => '/Order/OrderItems/editInBatch/' . $atimMenuVariables['Order.id'] . '/' . $atimMenuVariables['OrderLine.id'] . '/0/0/shipped/',
    'icon' => 'edit'
);
$structureLinks['bottom']['order items']['edit returned items'] = array(
    'link' => '/Order/OrderItems/editInBatch/' . $atimMenuVariables['Order.id'] . '/' . $atimMenuVariables['OrderLine.id'] . '/0/0/shipped & returned/',
    'icon' => 'edit'
);

// Add to shipment links management
$addToShipmentLinks = array();
foreach ($shipmentsList as $shipment) {
    $addToShipmentLinks[$shipment['Shipment']['shipment_code']] = array(
        'link' => '/Order/Shipments/addToShipment/' . $shipment['Shipment']['order_id'] . '/' . $shipment['Shipment']['id'] . '/' . $atimMenuVariables['OrderLine.id'],
        'icon' => 'add_to_shipment'
    );
}
ksort($addToShipmentLinks);
foreach ($addToShipmentLinks as $shipmentKey => $shipmentLink)
    $structureLinks['bottom']['shipments'][__('add items to shipment') . ' # ' . $shipmentKey] = $shipmentLink;

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'settings' => array(
        'actions' => false
    )
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);

// Items list

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
            'end' => $this->Structures->ajaxIndex('Order/OrderItems/listall/' . $atimMenuVariables['Order.id'] . '/' . $status . '/' . $atimMenuVariables['OrderLine.id'] . '/0/OrderLine/')
        )
    );
    if ($counter == 1)
        $finalOptions['settings']['header'] = __('order items', null);
    if ($counter == sizeof($allStatus))
        $finalOptions['settings']['actions'] = true;
        
        // CUSTOM CODE
    $hookLink = $this->Structures->hook('line_items');
    if ($hookLink) {
        require ($hookLink);
    }
    
    // BUILD FORM
    $this->Structures->build($finalAtimStructure, $finalOptions);
}