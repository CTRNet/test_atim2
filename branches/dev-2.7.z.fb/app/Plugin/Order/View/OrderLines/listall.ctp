<?php
$keyAddAliquot = __('add items to order') . ' : ' . __('aliquot');
$keyAddSlide = __('add items to order') . ' : ' . __('tma slide');
$structureLinks = array(
    'index' => array(
        'detail' => '/Order/OrderLines/detail/%%Order.id%%/%%OrderLine.id%%/',
        'edit' => '/Order/OrderLines/edit/%%Order.id%%/%%OrderLine.id%%/',
        $keyAddAliquot => array(
            'link' => '/Order/OrderItems/add/%%Order.id%%/%%OrderLine.id%%/AliquotMaster',
            'icon' => 'add_to_order'
        ),
        $keyAddSlide => array(
            'link' => '/Order/OrderItems/add/%%Order.id%%/%%OrderLine.id%%/TmaSlide',
            'icon' => 'add_to_order'
        ),
        'delete' => '/Order/OrderLines/delete/%%Order.id%%/%%OrderLine.id%%/'
    ),
    'bottom' => array(
        'add order line' => '/Order/OrderLines/add/' . $atimMenuVariables['Order.id'] . '/',
        'add shipment' => array(
            'link' => '/Order/Shipments/add/' . $atimMenuVariables['Order.id'] . '/',
            'icon' => 'create_shipment'
        )
    )
);
if (Configure::read('order_item_type_config') == '1') {
    unset($structureLinks['index'][$keyAddSlide]);
    unset($structureLinks['index'][$keyAddAliquot]);
}
if (Configure::read('order_item_type_config') == '2')
    unset($structureLinks['index'][$keyAddSlide]);
if (Configure::read('order_item_type_config') == '3')
    unset($structureLinks['index'][$keyAddAliquot]);

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