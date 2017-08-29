<?php
$structureLinks = array(
    'bottom' => array(
        'edit' => '/Administrate/Banks/edit/%%Bank.id%%',
        'delete' => '/Administrate/Banks/delete/%%Bank.id%%/'
    )
);

$this->Structures->build($atimStructure, array(
    'links' => $structureLinks
));