<?php
$structureLinks = array(
    'index' => array(
        'detail' => '/material/materials/detail/%%Material.id%%'
    ),
    'bottom' => array(
        'add' => '/material/materials/add',
        'search' => '/material/materials/index'
    )
);

$this->Structures->build($atimStructure, array(
    'type' => 'index',
    'links' => $structureLinks
));