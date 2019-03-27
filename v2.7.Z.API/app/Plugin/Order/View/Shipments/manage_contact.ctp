<?php

$canDelete = AppController::checkLinkPermission('/Order/Shipments/deleteContact/');
$structureLinks = array(
    'index' => array(
        'detail' => 'javascript:void(0)',
        'delete' => $canDelete ? 'javascript:deleteContact(%%ShipmentContact.id%%);' : '/cannot/'
    ),
    'bottom' => array(
        'cancel' => 'javascript:void(0);'
    )
);

$finalOptions = array(
    'links' => $structureLinks,
    'settings' =>array(
        'header' => __("contacts information"), 
        'pagination' => 1,
        'actions' => true
    )
);

if($searchId == -2){
    $finalOptions['type'] = "index";
    $settings['actions'] = false;
}else{
    $finalOptions['type'] = "search";
    $finalOptions['links']['top'] = '/Order/Shipments/manageContact/-2';
    $settings['actions'] = true;
}


$finalAtimStructure = $atimStructure;
// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM

$this->Structures->build($finalAtimStructure, $finalOptions);