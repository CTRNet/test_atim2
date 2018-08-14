<?php
$structureLinks = array(
    'top' => '/Administrate/AdminUsers/add/' . $atimMenuVariables['Group.id'] . '/',
    'bottom' => array(
        'cancel' => '/Administrate/Groups/detail/' . $atimMenuVariables['Group.id']
    )
);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'type' => 'add',
    'settings' => array(
        'header' => __('user', null)
    )
);

$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

$this->Structures->build($finalAtimStructure, $finalOptions);