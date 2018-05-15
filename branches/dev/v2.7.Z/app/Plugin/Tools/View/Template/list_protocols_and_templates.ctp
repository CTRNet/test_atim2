<?php
$links = array(
    'bottom' => array(
        'add' => array(
            'protocol' => '/Tools/CollectionProtocol/add/',
            'template' => '/Tools/Template/add/'
        )
    )
);

// --------- Collection Protocols ----------------------------------------------------------------------------------------------
$finalAtimStructure = array();
$finalOptions = array(
    'type' => 'detail',
    'links' => array(),
    'settings' => array(
        'header' => __('collections protocols', null),
        'actions' => false
    ),
    'extras' => $this->Structures->ajaxIndex('Tools/CollectionProtocol/index')
);

$displayNextForm = true;

// CUSTOM CODE
$hookLink = $this->Structures->hook('protocol');
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
if ($displayNextForm)
    $this->Structures->build($finalAtimStructure, $finalOptions);
    
    // --------- Collection Template ----------------------------------------------------------------------------------------------

$finalAtimStructure = array();
$finalOptions = array(
    'type' => 'detail',
    'links' => $links,
    'settings' => array(
        'header' => __('collection templates', null),
        'actions' => true
    ),
    'extras' => $this->Structures->ajaxIndex('Tools/Template/index')
);

$displayNextForm = true;

// CUSTOM CODE
$hookLink = $this->Structures->hook('template');
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
if ($displayNextForm)
    $this->Structures->build($finalAtimStructure, $finalOptions);