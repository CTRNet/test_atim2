<?php
$structureLinks = array();

$structureLinks['index'] = array(
    'details' => array(
        'link' => '/Order/Orders/detail/%%OrderItem.order_id%%/',
        'icon' => 'detail'
    )
);

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