<?php
$structureLinks = array(
    'top' => '/Administrate/Menus/edit/%%Menu.id%%',
    'bottom' => array(
        'delete' => '/Administrate/Menus/delete/%%Menu.id%%',
        'cancel' => '/Administrate/Menus/detail/%%Menu.id%%'
    )
);

$this->Structures->build($atimStructure, array(
    'links' => $structureLinks
));