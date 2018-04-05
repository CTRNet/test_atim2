<?php
$structureLinks = array(
    'bottom' => array(
        'search' => '/material/materials/index/',
        'edit' => '/material/materials/edit/%%Material.id%%/',
        'delete' => '/material/materials/delete/%%Material.id%%/'
    )
);

$this->Structures->build($atimStructure, array(
    'links' => $structureLinks
));