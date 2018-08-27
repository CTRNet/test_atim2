<?php
$structureLinks = array(
    'index' => array(
        'detail' => '/Material/Materials/detail/%%Material.id%%'
    ),
    'bottom' => array(
        'add' => '/Material/Materials/add',
        'search' => '/Material/Materials/index'
    )
);

$this->Structures->build($atimStructure, array(
    'type' => 'index',
    'links' => $structureLinks
));