<?php
$structureLinks = array(
    'top' => '/Administrate/Groups/add/',
    'bottom' => array(
        'cancel' => '/Administrate/Groups/index/'
    )
);

$this->Structures->build($atimStructure, array(
    'links' => $structureLinks
));