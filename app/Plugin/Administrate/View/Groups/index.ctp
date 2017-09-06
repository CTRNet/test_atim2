<?php
$structureLinks = array(
    'index' => array(
        'detail' => '/Administrate/Groups/detail/%%Group.id%%'
    ),
    'bottom' => array(
        'add' => '/Administrate/Groups/add/',
        'search for users' => '/Administrate/AdminUsers/search/'
    )
);

$this->Structures->build($atimStructure, array(
    'links' => $structureLinks
));