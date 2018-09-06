<?php
$structureLinks = array(
    'top' => '/Order/OrderItems/defineOrderItemsReturned/' . $orderId . '/' . $orderLineId . '/' . $shipmentId . '/',
    'bottom' => array(
        'cancel' => $urlToCancel
    )
);

$finalOptions = array(
    'type' => 'editgrid',
    'links' => $structureLinks,
    'settings' => array(
        'pagination' => false,
        'header' => __('order items'),
        'paste_disabled_fields' => array(
            'OrderItem.order_item_shipping_label',
            'OrderItem.date_added',
            'OrderItem.added_by'
        )
    ),
    'extras' => '<input type="hidden" name="data[url_to_cancel]" value="' . $urlToCancel . '"/><input type="hidden" name="data[order_item_ids]" value="' . $orderItemIds . '"/>'
);

$finalAtimStructure = $atimStructure;

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);

?>
<script type="text/javascript">
var copyControl = true;
</script>