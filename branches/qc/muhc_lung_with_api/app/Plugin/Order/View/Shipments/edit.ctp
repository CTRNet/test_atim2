<?php
$structureLinks = array(
    'top' => '/Order/Shipments/edit/' . $atimMenuVariables['Order.id'] . '/' . $atimMenuVariables['Shipment.id'] . '/',
    'bottom' => array(
        'cancel' => '/Order/Shipments/detail/' . $atimMenuVariables['Order.id'] . '/' . $atimMenuVariables['Shipment.id'] . '/',
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