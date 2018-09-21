<?php
$structureLinks = array(
    'top' => null,
    'index' => array(
        'detail' => '/Order/Shipments/detail/%%Shipment.order_id%%/%%Shipment.id%%/',
        'copy for new shipment' => array(
            'link' => '/Order/Shipments/add/%%Shipment.order_id%%/%%Shipment.id%%/',
            'icon' => 'duplicate'
        ),
        'add items to shipment' => array(
            'link' => '/Order/Shipments/addToShipment/%%Shipment.order_id%%/%%Shipment.id%%/',
            'icon' => 'add_to_shipment'
        ),
        'delete' => '/Order/Shipments/delete/%%Shipment.order_id%%/%%Shipment.id%%/'
    ),
    'bottom' => array(
        'add' => '/Order/Shipments/add/' . $atimMenuVariables['Order.id'] . '/'
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