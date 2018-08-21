<?php
// object_ids_to_add
// 1- ITEM LIST
$structureOverride = array();

$extras = array();
$finalAtimStructure = $atimStructureForNewItemsList;
$finalOptions = array(
    'type' => 'index',
    'data' => $newItemsData,
    'settings' => array(
        'actions' => false,
        'pagination' => false,
        'header' => array(
            'title' => __('add to order'),
            'description' => ($objectModelName == 'AliquotMaster' ? __('aliquots') : __('tma slides'))
        )
    ),
    'override' => $structureOverride
);

// CUSTOM CODE
$hookLink = $this->Structures->hook('new_items');
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);

// 2- ORDER ITEMS DATA ENTRY

$extras = $this->Form->input('object_ids_to_add', array(
    'type' => 'hidden',
    'value' => $objectIdsToAdd
)) . $this->Form->input('url_to_cancel', array(
    'type' => 'hidden',
    'value' => $urlToCancel
));

$finalAtimStructure = $atimStructureOrderitemsData;
$finalOptions = array(
    'type' => 'add',
    'extras' => $extras,
    'data' => $this->request->data,
    'links' => array(
        'top' => '/Order/OrderItems/addOrderItemsInBatch/' . $objectModelName
    ),
    'settings' => array(
        'actions' => false,
        'header' => '1 - ' . __('order item data'),
        'form_top' => true,
        'form_bottom' => false
    )
);

// CUSTOM CODE
$hookLink = $this->Structures->hook('order_item');
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);

// 3- ORDER OR ORDER LINES SELECTION

$structureLinks = array(
    'radiolist' => array(
        'FunctionManagement.selected_order_and_order_line_ids' => '%%Generated.order_and_order_line_ids%%'
    ),
    'bottom' => array(
        'cancel' => $urlToCancel
    ),
    'top' => '/Order/OrderItems/addOrderItemsInBatch/' . $objectModelName
);

$linkedObjects = array();
if (Configure::read('order_item_to_order_objetcs_link_setting') != 2)
    $linkedObjects[] = __('order');
if (Configure::read('order_item_to_order_objetcs_link_setting') != 3)
    $linkedObjects[] = __('order line');
$header = '2 - ' . str_replace('%%order_objects%%', implode(' ' . __('or') . ' ', $linkedObjects), __('%%order_objects%% selection', null));
if (Configure::read('order_item_to_order_objetcs_link_setting') == 3) {
    // Merge all orders in one array() then reset $orderAndOrderLineData
    $tmpAllOrders = array();
    foreach ($orderAndOrderLineData as $newDataToMerge) {
        $tmpAllOrders[] = $newDataToMerge['order'][0];
    }
    $orderAndOrderLineData = array(
        array(
            'order' => $tmpAllOrders,
            'lines' => array()
        )
    );
}

$hookLink = $this->Structures->hook('order_and_order_lines');

while ($newOrderDataSet = array_shift($orderAndOrderLineData)) {
    // Display Order Title
    $languageHeading = __('order') . ' : ' . $newOrderDataSet['order'][0]['Order']['order_number'];
    if (Configure::read('order_item_to_order_objetcs_link_setting') == 3)
        $languageHeading = null;
        // Display Order Selection (if allowed)
    $lastList = empty($orderAndOrderLineData) && empty($newOrderDataSet['lines']);
    if ($itemToOrderDirectLinkAllowed && Configure::read('order_item_to_order_objetcs_link_setting') != 2) {
        // Item can be directly linked to an order
        $structureSettings = array(
            'pagination' => false,
            'form_inputs' => false,
            'form_top' => false,
            'form_bottom' => $lastList ? true : false,
            'actions' => $lastList ? true : false,
            'header' => $header,
            'language_heading' => $languageHeading
        );
        
        $finalOptions = array(
            'type' => 'index',
            'settings' => $structureSettings,
            'data' => $newOrderDataSet['order'],
            'links' => $structureLinks
        );
        $finalAtimStructure = $atimStructureOrder;
        $hookLink = $this->Structures->hook('orders');
        if ($hookLink) {
            require ($hookLink);
        }
        $this->Structures->build($finalAtimStructure, $finalOptions);
        $header = null;
        $languageHeading = null;
    }
    // Display Order Line Selection
    if ($newOrderDataSet['lines']) {
        $lastList = empty($orderAndOrderLineData);
        $structureSettings = array(
            'pagination' => false,
            'form_inputs' => false,
            'form_top' => false,
            'form_bottom' => $lastList ? true : false,
            'actions' => $lastList ? true : false,
            'header' => $header,
            'language_heading' => $languageHeading
        );
        $finalOptions = array(
            'type' => 'index',
            'settings' => $structureSettings,
            'data' => $newOrderDataSet['lines'],
            'links' => $structureLinks
        );
        $finalAtimStructure = $atimStructureOrderLine;
        $hookLink = $this->Structures->hook('order_lines');
        if ($hookLink) {
            require ($hookLink);
        }
        $this->Structures->build($finalAtimStructure, $finalOptions);
    }
    $header = null;
    $languageHeading = null;
}