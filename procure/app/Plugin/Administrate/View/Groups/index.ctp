<?php
$structureLinks = array(
    'index' => array(
        'detail' => '/Administrate/Groups/detail/%%Group.id%%',
        'edit' => '/Administrate/Groups/edit/%%Group.id%%',
        'delete' => '/Administrate/Groups/delete/%%Group.id%%'
    ),
    'bottom' => array(
        'add' => '/Administrate/Groups/add/',
        'search for users' => '/Administrate/AdminUsers/search/'
    )
);

$this->Structures->build($atimStructure, array(
    'links' => $structureLinks
));