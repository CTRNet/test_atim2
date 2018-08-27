<?php
$canDelete = AppController::checkLinkPermission('/Order/Shipments/deleteContact/');
$this->Structures->build($atimStructure, array(
    'type' => 'index',
    'links' => array(
        'index' => array(
            'detail' => 'javascript:',
            'delete' => $canDelete ? 'javascript:deleteContact(%%ShipmentContact.id%%);' : '/cannot/'
        )
    ),
    'settings' => array(
        'header' => __('manage contacts'),
        'pagination' => false
    )
));