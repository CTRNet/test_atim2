<?php
$structureLinks = array(
    'top' => '/Administrate/PreferencesAdmin/edit/' . $atimMenuVariables['Group.id'] . '/' . $atimMenuVariables['User.id'],
    'bottom' => array(
        'cancel' => '/Administrate/PreferencesAdmin/index/' . $atimMenuVariables['Group.id'] . '/' . $atimMenuVariables['User.id']
    )
);

$this->Structures->build($atimStructure, array(
    'links' => $structureLinks
));