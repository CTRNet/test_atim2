<?php
$structureLinks = array(
    'top' => '/Order/Orders/edit/' . $atimMenuVariables['Order.id'],
    'bottom' => array(
        'cancel' => '/Order/Orders/detail/' . $atimMenuVariables['Order.id']
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