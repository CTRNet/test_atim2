<?php
$structureLinks = array(
    'top' => '/Order/Shipments/add/' . $atimMenuVariables['Order.id'] . '/0/' . $orderLineId . '/',
    'bottom' => array(
        'cancel' => '/Order/Orders/detail/' . $atimMenuVariables['Order.id'] . '/',
        'manage recipients' => array(
            'select recipient' => array(
                'icon' => 'detail',
                'link' => AppController::checkLinkPermission('/Order/Shipments/manageContact') ? 'javascript:manageContacts();' : '/notallowed/'
            ),
            'save recipient' => array(
                'icon' => 'disk',
                'link' => AppController::checkLinkPermission('/Order/Shipments/saveContact/') ? 'javascript:saveContact();' : '/notallowed/'
            )
        )
    )
);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);

require ("contacts_functions.php");