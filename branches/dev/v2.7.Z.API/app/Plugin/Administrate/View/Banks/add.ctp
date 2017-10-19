<?php
$structureLinks = array(
    'top' => '/Administrate/Banks/add/',
    'bottom' => array(
        'cancel' => '/Administrate/Banks/index/'
    )
);

$this->Structures->build($atimStructure, array(
    'links' => $structureLinks
));