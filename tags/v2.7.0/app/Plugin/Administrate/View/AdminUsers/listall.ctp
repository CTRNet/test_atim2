<?php
$structureLinks = array(
    'index' => array(
        'detail' => '/Administrate/AdminUsers/detail/' . $atimMenuVariables['Group.id'] . '/%%User.id%%'
    ),
    'bottom' => array(
        'add' => '/Administrate/AdminUsers/add/' . $atimMenuVariables['Group.id']
    )
);

$this->Structures->build($atimStructure, array(
    'links' => $structureLinks,
    'type' => 'index'
));