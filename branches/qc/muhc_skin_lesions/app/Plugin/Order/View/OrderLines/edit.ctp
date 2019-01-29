<?php
$structureLinks = array(
    'top' => '/Order/OrderLines/edit/' . $atimMenuVariables['Order.id'] . '/' . $atimMenuVariables['OrderLine.id'],
    'bottom' => array(
        'cancel' => '/Order/OrderLines/detail/' . $atimMenuVariables['Order.id'] . '/' . $atimMenuVariables['OrderLine.id']
    )
);

$structureOverride = array();

$finalAtimStructure = $atimStructure;
$finalOptions = array(
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