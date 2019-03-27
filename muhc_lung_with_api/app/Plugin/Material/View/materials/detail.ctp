<?php
$structureLinks = array(
    'bottom' => array(
        'search' => '/Material/Materials/index/',
        'edit' => '/Material/Materials/edit/%%Material.id%%/',
        'delete' => '/Material/Materials/delete/%%Material.id%%/'
    )
);

$this->Structures->build($atimStructure, array(
    'links' => $structureLinks
));