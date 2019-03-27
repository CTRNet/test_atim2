<?php
$structureLinks = array(
    'index' => array(
        'detail' => '/Administrate/Banks/detail/%%Bank.id%%',
        'edit' => '/Administrate/Banks/edit/%%Bank.id%%',
        'delete' => '/Administrate/Banks/delete/%%Bank.id%%/'
    ),
    'bottom' => array(
        'add' => '/Administrate/Banks/add'
    )
);

$this->Structures->build($atimStructure, array(
    'links' => $structureLinks
));