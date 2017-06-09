<?php
$structureLinks = array();

$structureLinks['index'] = array(
    'items details' => array(
        'link' => '%%Generated.item_detail_link%%/',
        'icon' => 'detail'
    )
);
switch ($status) {
    case 'pending':
        $structureLinks['index']['edit addition to order data'] = array(
            'link' => '/Order/OrderItems/edit/%%OrderItem.order_id%%/%%OrderItem.id%%/' . $mainFormModel . '/',
            'icon' => 'edit'
        );
        $structureLinks['index']['remove from order'] = array(
            'link' => '/Order/OrderItems/delete/%%OrderItem.order_id%%/%%OrderItem.id%%/' . $mainFormModel . '/',
            'icon' => 'remove_from_order'
        );
        break;
    case 'shipped':
        $structureLinks['index']['shipment details'] = array(
            'link' => '/Order/Shipments/detail/%%OrderItem.order_id%%/%%Shipment.id%%/',
            'icon' => 'shipments'
        );
        $structureLinks['index']['remove from shipment'] = array(
            'link' => '/Order/Shipments/deleteFromShipment/%%OrderItem.order_id%%/%%OrderItem.id%%/%%Shipment.id%%/' . $mainFormModel . '/',
            'icon' => 'remove_from_shipment'
        );
        $structureLinks['index']['define order item as returned'] = array(
            'link' => '/Order/OrderItems/defineOrderItemsReturned/%%OrderItem.order_id%%/0/0/%%OrderItem.id%%/',
            'icon' => 'order items returned'
        );
        break;
    case 'shipped & returned':
        $structureLinks['index']['edit return data'] = array(
            'link' => '/Order/OrderItems/edit/%%OrderItem.order_id%%/%%OrderItem.id%%/' . $mainFormModel . '/',
            'icon' => 'edit'
        );
        $structureLinks['index']['shipment details'] = array(
            'link' => '/Order/Shipments/detail/%%OrderItem.order_id%%/%%Shipment.id%%/',
            'icon' => 'shipments'
        );
        $structureLinks['index']['remove from shipment'] = array(
            'link' => '/Order/Shipments/deleteFromShipment/%%OrderItem.order_id%%/%%OrderItem.id%%/%%Shipment.id%%/' . $mainFormModel . '/',
            'icon' => 'remove_from_shipment'
        );
        $structureLinks['index']['change status to shipped'] = array(
            'link' => '/Order/OrderItems/removeFlagReturned/%%OrderItem.order_id%%/%%OrderItem.id%%/' . $mainFormModel . '/',
            'icon' => 'remove flag returned'
        );
        break;
}

if (! empty($atimMenuVariables['OrderLine.id'])) {
    unset($structureLinks['index']['order line details']);
}

$structureOverride = array();

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'index',
    'links' => $structureLinks,
    'override' => $structureOverride
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);

?>
