<?php
$structureLinks = array(
    'top' => '/Material/Materials/add/',
    'bottom' => array(
        'cancel' => '/Material/Materials/index/'
    )
);

$this->Structures->build($atimStructure, array(
    'links' => $structureLinks
));