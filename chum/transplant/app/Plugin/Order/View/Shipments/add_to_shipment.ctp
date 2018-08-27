<?php
$structureLinks = array(
    'top' => '/Order/Shipments/addToShipment/' . $atimMenuVariables['Order.id'] . '/' . $atimMenuVariables['Shipment.id'] . "/$orderLineId",
    'bottom' => array(
        'cancel' => '/Order/Shipments/detail/' . $atimMenuVariables['Order.id'] . '/' . $atimMenuVariables['Shipment.id'] . '/'
    ),
    'checklist' => array(
        'OrderItem.id][' => '%%OrderItem.id%%'
    )
);

$structureSettings = array(
    'pagination' => true,
    'header' => __('add items to shipment', null),
    'form_inputs' => false
);

$finalOptions = array(
    'type' => 'index',
    'links' => $structureLinks,
    'settings' => $structureSettings
);

if (isset($languageHeading)) {
    $finalOptions['settings']['language_heading'] = $languageHeading;
}

$finalAtimStructure = $atimStructure;

// CUSTOM CODE
$hookLink = $this->Structures->hook();

// BUILD FORM

$this->Structures->build($finalAtimStructure, $finalOptions);

?>
<script>
    var dataLimit=<?php echo $dataLimit;?>;
    var dataIndex="<?php echo "OrderItem";?>";
    var controller="<?php echo "Shipments";?>"; //Until now not used in Javascript's code
    var action="<?php echo "addToShipment";?>"; //Until now not used in Javascript's code
</script>