<?php
$structureLinks = array(
    'top' => '/Administrate/AdminUsers/edit/' . $atimMenuVariables['Group.id'] . '/' . $atimMenuVariables['User.id'] . '/',
    'bottom' => array(
        'cancel' => '/Administrate/AdminUsers/detail/' . $atimMenuVariables['Group.id'] . '/' . $atimMenuVariables['User.id'] . '/'
    )
);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'type' => 'edit'
);

$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

$this->Structures->build($finalAtimStructure, $finalOptions);