<?php
$structureLinks = array(
    'top' => '/Order/OrderItems/edit/' . $atimMenuVariables['Order.id'] . '/' . $atimMenuVariables['OrderItem.id'],
    'bottom' => array(
        'cancel' => $urlToCancel
    )
);

$structureOverride = array();

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'override' => $structureOverride,
    'settings' => array(
        'header' => __('order item')
    ),
    'extras' => '<input type="hidden" name="data[url_to_cancel]" value="' . $urlToCancel . '"/>'
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);