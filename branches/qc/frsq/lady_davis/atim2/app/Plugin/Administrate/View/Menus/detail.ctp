<?php
$structureLinks = array(
    'bottom' => array(
        'edit' => '/Administrate/Menus/edit/%%Menu.id%%'
    )
);

$this->Structures->build($atimStructure, array(
    'links' => $structureLinks
));