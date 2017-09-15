<?php
$structureLinks = array(
    'top' => '/Administrate/StorageControls/add/' . $storageCategory . '/0/',
    'bottom' => array(
        'cancel' => '/Administrate/StorageControls/listAll/'
    )
);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'settings' => array(
        'header' => __('storage layout description', null) . ' : ' . __(str_replace(array(
            'no_d',
            'tma',
            '2d',
            '1d'
        ), array(
            'no coordinate',
            '1 coordinate',
            '2 coordinates',
            'tma block'
        ), $storageCategory))
    ),
    'links' => $structureLinks
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);