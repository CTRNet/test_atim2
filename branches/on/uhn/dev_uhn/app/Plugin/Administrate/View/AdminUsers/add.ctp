<?php
$structureLinks = array(
    'top' => '/Administrate/AdminUsers/add/' . $atimMenuVariables['Group.id'] . '/',
    'bottom' => array(
        'cancel' => '/Administrate/AdminUsers/listall/' . $atimMenuVariables['Group.id']
    )
);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'type' => 'add'
);

$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

$this->Structures->build($finalAtimStructure, $finalOptions);