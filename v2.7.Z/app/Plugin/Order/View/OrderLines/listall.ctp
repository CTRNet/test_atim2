<?php
$key_add_aliquot = __('add items to order') . ' : ' . __('aliquot');
$key_add_slide = __('add items to order') . ' : ' . __('tma slide');
$structure_links = array(
    'index' => array(
        'detail' => '/Order/OrderLines/detail/%%Order.id%%/%%OrderLine.id%%/',
        'edit' => '/Order/OrderLines/edit/%%Order.id%%/%%OrderLine.id%%/',
        $key_add_aliquot => array(
            'link' => '/Order/OrderItems/add/%%Order.id%%/%%OrderLine.id%%/AliquotMaster',
            'icon' => 'add_to_order'
        ),
        $key_add_slide => array(
            'link' => '/Order/OrderItems/add/%%Order.id%%/%%OrderLine.id%%/TmaSlide',
            'icon' => 'add_to_order'
        ),
        'delete' => '/Order/OrderLines/delete/%%Order.id%%/%%OrderLine.id%%/'
    ),
    'bottom' => array(
        'add order line' => '/Order/OrderLines/add/' . $atim_menu_variables['Order.id'] . '/',
        'add shipment' => array(
            'link' => '/Order/Shipments/add/' . $atim_menu_variables['Order.id'] . '/',
            'icon' => 'create_shipment'
        )
    )
);
if (Configure::read('order_item_type_config') == '1') {
    unset($structure_links['index'][$key_add_slide]);
    unset($structure_links['index'][$key_add_aliquot]);
}
if (Configure::read('order_item_type_config') == '2')
    unset($structure_links['index'][$key_add_slide]);
if (Configure::read('order_item_type_config') == '3')
    unset($structure_links['index'][$key_add_aliquot]);

$structure_override = array();

$final_atim_structure = $atim_structure;
$final_options = array(
    'type' => 'index',
    'links' => $structure_links,
    'override' => $structure_override
);

// CUSTOM CODE
$hook_link = $this->Structures->hook();
if ($hook_link) {
    require ($hook_link);
}

// BUILD FORM
$this->Structures->build($final_atim_structure, $final_options);
?>
