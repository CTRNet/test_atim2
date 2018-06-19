<?php
$structureLinks = array(
    'bottom' => array(
        'edit' => '/Administrate/PreferencesAdmin/edit/' . $atimMenuVariables['Group.id'] . '/' . $atimMenuVariables['User.id']
    )
);

$this->Structures->build($atimStructure, array(
    'type' => 'detail',
    'links' => $structureLinks
));