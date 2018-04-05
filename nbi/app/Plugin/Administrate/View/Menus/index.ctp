<?php
$structureLinks = array(
    'index' => array(
        'detail' => '/Administrate/Menus/detail/%%Menu.id%%'
    )
);

$this->Structures->build($atimStructure, array(
    'type' => 'tree',
    'links' => $structureLinks
));