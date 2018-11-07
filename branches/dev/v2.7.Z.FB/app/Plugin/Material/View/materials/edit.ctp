<?php
$structureLinks = array(
    'top' => '/Material/Materials/edit/' . $atimMenuVariables['Material.id'],
    'bottom' => array(
        'cancel' => '/Material/Materials/detail/' . $atimMenuVariables['Material.id']
    )
);

$this->Structures->build($atimStructure, array(
    'links' => $structureLinks
));