<?php
if ($_SESSION['Auth']['User']['id'] == $atimMenuVariables['User.id']) {
    $structureLinks = array(
        'bottom' => array(
            'edit' => '/Administrate/AdminUsers/edit/' . $atimMenuVariables['Group.id'] . '/%%User.id%%'
        )
    );
} else {
    $structureLinks = array(
        'bottom' => array(
            'edit' => '/Administrate/AdminUsers/edit/' . $atimMenuVariables['Group.id'] . '/%%User.id%%',
            'change group' => array(
                'link' => '/Administrate/AdminUsers/changeGroup/' . $atimMenuVariables['Group.id'] . '/%%User.id%%',
                'icon' => 'users'
            ),
            'delete' => '/Administrate/AdminUsers/delete/' . $atimMenuVariables['Group.id'] . '/%%User.id%%'
        )
    );
}
$this->Structures->build($atimStructure, array(
    'links' => $structureLinks
));