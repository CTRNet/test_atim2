<?php
$structureLinks = array(
    'top' => '/Administrate/Banks/edit/' . $atimMenuVariables['Bank.id'],
    'bottom' => array(
        'cancel' => '/Administrate/Banks/detail/' . $atimMenuVariables['Bank.id']
    )
);

$this->Structures->build($atimStructure, array(
    'links' => $structureLinks
));