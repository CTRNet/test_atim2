<?php
// 1- SHIPMENT DETAILS
$addItemsToShipmentLink = array(
    'link' => '/Order/Shipments/addToShipment/' . $atimMenuVariables['Order.id'] . '/' . $atimMenuVariables['Shipment.id'] . '/',
    'icon' => 'add_to_shipment'
);
if ($addToShipmentsSubsetLimits) {
    $addItemsToShipmentLink = array();
    foreach ($addToShipmentsSubsetLimits as $key => $subSetData) {
        list ($start, $limit) = $subSetData;
        $addItemsToShipmentLink[__('batchset') . ' #' . $key] = array(
            'link' => '/Order/Shipments/addToShipment/' . $atimMenuVariables['Order.id'] . '/' . $atimMenuVariables['Shipment.id'] . "/0/$start/$limit",
            'icon' => 'add_to_shipment'
        );
    }
}
$structureLinks = array(
    'bottom' => array(
        'edit' => '/Order/Shipments/edit/' . $atimMenuVariables['Order.id'] . '/' . $atimMenuVariables['Shipment.id'] . '/',
        'copy for new shipment' => array(
            'link' => '/Order/Shipments/add/' . $atimMenuVariables['Order.id'] . '/' . $atimMenuVariables['Shipment.id'] . '/',
            'icon' => 'duplicate'
        ),
        'delete' => '/Order/Shipments/delete/' . $atimMenuVariables['Order.id'] . '/' . $atimMenuVariables['Shipment.id'] . '/',
        'order items' => array(
            'define order items returned' => array(
                'link' => '/Order/OrderItems/defineOrderItemsReturned/' . $atimMenuVariables['Order.id'] . '/0/' . $atimMenuVariables['Shipment.id'],
                'icon' => 'order items returned'
            ),
            'edit all items' => array(
                'link' => '/Order/OrderItems/editInBatch/' . $atimMenuVariables['Order.id'] . '/0/' . $atimMenuVariables['Shipment.id'] . '/0/',
                'icon' => 'edit'
            ),
            'edit shipped items' => array(
                'link' => '/Order/OrderItems/editInBatch/' . $atimMenuVariables['Order.id'] . '/0/' . $atimMenuVariables['Shipment.id'] . '/0/shipped/',
                'icon' => 'edit'
            ),
            'edit returned items' => array(
                'link' => '/Order/OrderItems/editInBatch/' . $atimMenuVariables['Order.id'] . '/0/' . $atimMenuVariables['Shipment.id'] . '/0/shipped & returned/',
                'icon' => 'edit'
            )
        ),
        'shipments' => array(
            'add items to shipment' => $addItemsToShipmentLink
        )
    )
);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks
);

if ($isFromTreeView) {
    $finalOptions['settings']['header'] = __('shipping');
    $finalOptions['settings']['actions'] = true;
} else {
    $finalOptions['settings']['actions'] = false;
}

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);

// 2- SHIPPED ITEMS
if (! $isFromTreeView) {
    
    $structureLinks['bottom'] = array_merge(array(
        'new search' => OrderAppController::$searchLinks
    ), $structureLinks['bottom']);
    
    $counter = 0;
    $allStatus = array(
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
                'end' => $this->Structures->ajaxIndex('Order/OrderItems/listall/' . $atimMenuVariables['Order.id'] . '/' . $status . '/0/' . $atimMenuVariables['Shipment.id'] . '/Shipment/')
            )
        );
        if ($counter == 1)
            $finalOptions['settings']['header'] = __('order items', null);
        if ($counter == sizeof($allStatus))
            $finalOptions['settings']['actions'] = true;
            
            // CUSTOM CODE
        $hookLink = $this->Structures->hook('items');
        if ($hookLink) {
            require ($hookLink);
        }
        
        // BUILD FORM
        $this->Structures->build($finalAtimStructure, $finalOptions);
    }
}