<?php

// --------- Lists with values ----------------------------------------------------------------------------------------------
$finalAtimStructure = array();
$finalOptions = array(
    'type' => 'detail',
    'links' => array(),
    'settings' => array(
        'header' => __('used lists', null),
        'actions' => false
    ),
    'extras' => $this->Structures->ajaxIndex('Administrate/Dropdowns/subIndex/not_empty')
);

$displayNextForm = true;

// CUSTOM CODE
$hookLink = $this->Structures->hook('not_empty');
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
if ($displayNextForm)
    $this->Structures->build($finalAtimStructure, $finalOptions);
    
    // --------- Empty lists ----------------------------------------------------------------------------------------------

$finalAtimStructure = array();
$finalOptions = array(
    'type' => 'detail',
    'links' => array(),
    'settings' => array(
        'header' => __('empty lists', null),
        'actions' => true
    ),
    'extras' => $this->Structures->ajaxIndex('Administrate/Dropdowns/subIndex/empty')
);

$displayNextForm = true;

// CUSTOM CODE
$hookLink = $this->Structures->hook('empty');
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
if ($displayNextForm)
    $this->Structures->build($finalAtimStructure, $finalOptions);