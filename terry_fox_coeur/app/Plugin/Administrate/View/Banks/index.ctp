<?php
$structureLinks = array(
    'index' => array(
        'detail' => '/Administrate/Banks/detail/%%Bank.id%%'
    ),
    'bottom' => array(
        'add' => '/Administrate/Banks/add'
    )
);

$this->Structures->build($atimStructure, array(
    'links' => $structureLinks
));