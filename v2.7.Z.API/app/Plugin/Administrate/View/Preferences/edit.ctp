<?php
$structureLinks = array(
    'top' => '/Administrate/Preferences/edit/' . $atimMenuVariables['Group.id'] . '/' . $atimMenuVariables['User.id'],
    'bottom' => array(
        'cancel' => '/Administrate/Preferences/index/' . $atimMenuVariables['Group.id'] . '/' . $atimMenuVariables['User.id']
    )
);

$this->Structures->build($atimStructure, array(
    'links' => $structureLinks
));