<?php
$structureLinks = array(
    'index' => array(
        'detail' => array(
            'link' => '/Administrate/StorageControls/seeStorageLayout/%%StorageCtrl.id%%/',
            'icon' => 'detail'
        ),
        'edit' => '/Administrate/StorageControls/edit/%%StorageCtrl.id%%/',
        'copy for new storage control' => array(
            'link' => '/Administrate/StorageControls/add/0/%%StorageCtrl.id%%/',
            'icon' => 'duplicate'
        ),
        'change active status' => array(
            'link' => '/Administrate/StorageControls/changeActiveStatus/%%StorageCtrl.id%%/listAll/',
            'icon' => 'confirm'
        ),
        'delete' => '/Administrate/StorageControls/delete/%%StorageCtrl.id%%/'
    ),
    'bottom' => array(
        'add' => array(
            'no coordinate' => '/Administrate/StorageControls/add/no_d/0/',
            '1 coordinate' => '/Administrate/StorageControls/add/1d/0/',
            '2 coordinates' => '/Administrate/StorageControls/add/2d/0/',
            'tma block' => '/Administrate/StorageControls/add/tma/0/'
        )
    )
);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'index',
    'links' => $structureLinks,
    'settings' => array(
        'pagination' => true
    ),
    'override' => array()
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);