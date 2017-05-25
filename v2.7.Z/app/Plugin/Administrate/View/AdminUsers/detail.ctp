<?php
if ($_SESSION['Auth']['User']['id'] == $atim_menu_variables['User.id']) {
    $structure_links = array(
        'bottom' => array(
            'edit' => '/Administrate/AdminUsers/edit/' . $atim_menu_variables['Group.id'] . '/%%User.id%%'
        )
    );
} else {
    $structure_links = array(
        'bottom' => array(
            'edit' => '/Administrate/AdminUsers/edit/' . $atim_menu_variables['Group.id'] . '/%%User.id%%',
            'delete' => '/Administrate/AdminUsers/delete/' . $atim_menu_variables['Group.id'] . '/%%User.id%%'
        )
    );
}
$this->Structures->build($atim_structure, array(
    'links' => $structure_links
));
?>