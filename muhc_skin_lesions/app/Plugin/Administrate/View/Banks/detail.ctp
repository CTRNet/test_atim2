<?php
$structureLinks = array(
    'bottom' => array(
        'edit' => '/Administrate/Banks/edit/%%Bank.id%%',
        'delete' => '/Administrate/Banks/delete/%%Bank.id%%/',
        'add announcement' => "/Administrate/Announcements/add/bank/%%Bank.id%%"
    )
);

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
        'header' => __('announcements', null)
    ),
    'extras' => $this->Structures->ajaxIndex('Administrate/Announcements/index/bank/' . $atimMenuVariables['Bank.id'])
);

$this->Structures->build($finalAtimStructure, $finalOptions);