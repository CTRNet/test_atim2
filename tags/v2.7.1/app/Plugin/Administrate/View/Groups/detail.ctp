<?php
$structureLinks = array(
    'bottom' => array(
        'edit' => '/Administrate/Groups/edit/%%Group.id%%',
        'delete' => '/Administrate/Groups/delete/%%Group.id%%',
        'add user' => '/Administrate/AdminUsers/add/%%Group.id%%'
    )
);
if (! $displayEditButton) {
    unset($structureLinks['bottom']['delete'], $structureLinks['bottom']['edit']);
}

$this->Structures->build($atimStructure, array(
    'links' => $structureLinks,
    'settings' => array(
        'actions' => false
    )
));

$finalAtimStructure = array();
$finalOptions = array(
    'type' => 'detail',
    'links' => $structureLinks,
    'settings' => array(
        'header' => __('users', null)
    ),
    'extras' => $this->Structures->ajaxIndex('Administrate/AdminUsers/listall/' . $atimMenuVariables['Group.id'])
);

$this->Structures->build($finalAtimStructure, $finalOptions);