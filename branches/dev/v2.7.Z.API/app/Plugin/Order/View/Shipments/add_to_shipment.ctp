<?php
$structureLinks = array(
    'top' => '/Order/Shipments/addToShipment/' . $atimMenuVariables['Order.id'] . '/' . $atimMenuVariables['Shipment.id'] . "/$orderLineId/$offset/$limit",
    'bottom' => array(
        'cancel' => '/Order/Shipments/detail/' . $atimMenuVariables['Order.id'] . '/' . $atimMenuVariables['Shipment.id'] . '/'
    ),
    'checklist' => array(
        'OrderItem.id][' => '%%OrderItem.id%%'
    )
);

$structureSettings = array(
    'pagination' => false,
    'header' => __('add items to shipment', null),
    'actions' => false,
    'form_inputs' => false,
    'form_bottom' => false
);

$finalAtimStructure = $atimStructure;
$finalAtimStructureWithOrderLines = $atimStructureWithOrderLines;
$finalOptions = array(
    'type' => 'index',
    'links' => $structureLinks,
    'settings' => $structureSettings
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();

// BUILD FORM
while ($data = array_shift($this->request->data)) {
    $linkedToOrderLine = $data['order_line_id'] ? true : false;
    if (empty($this->request->data)) {
        $finalOptions['settings']['actions'] = true;
        $finalOptions['settings']['form_bottom'] = true;
    }
    $finalOptions['settings']['language_heading'] = $linkedToOrderLine ? __('line') . ': ' . $data['name'] : null;
    $finalOptions['data'] = $data['data'];
    if ($hookLink) {
        require ($hookLink);
    }
    $this->Structures->build(($linkedToOrderLine ? $finalAtimStructureWithOrderLines : $finalAtimStructure), $finalOptions);
    
    $finalOptions['settings']['header'] = array();
}

?>
