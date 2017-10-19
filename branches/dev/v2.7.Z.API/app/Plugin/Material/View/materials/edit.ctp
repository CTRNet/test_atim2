<?php
$structureLinks = array(
    'top' => '/material/materials/edit/' . $atimMenuVariables['Material.id'],
    'bottom' => array(
        'cancel' => '/material/materials/detail/' . $atimMenuVariables['Material.id']
    )
);

$this->Structures->build($atimStructure, array(
    'links' => $structureLinks
));