<?php
$structureLinks = array(
    'top' => '/material/materials/add/',
    'bottom' => array(
        'cancel' => '/material/materials/index/'
    )
);

$this->Structures->build($atimStructure, array(
    'links' => $structureLinks
));