<?php
$structureLinks = array(
    'top' => '/Administrate/PasswordsAdmin/index/' . $atimMenuVariables['Group.id'] . '/' . $atimMenuVariables['User.id']
);

$this->Structures->build($atimStructure, array(
    'type' => 'edit',
    'links' => $structureLinks,
    'settings' => array(
        'stretch' => false
    )
));