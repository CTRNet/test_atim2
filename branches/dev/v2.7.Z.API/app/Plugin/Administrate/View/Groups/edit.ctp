<?php
$structureLinks = array(
    'top' => '/Administrate/Groups/edit/' . $atimMenuVariables['Group.id'],
    'bottom' => array(
        'cancel' => '/Administrate/Groups/detail/' . $atimMenuVariables['Group.id']
    )
);

$this->Structures->build($atimStructure, array(
    'links' => $structureLinks
));