<?php
$structureLinks = array(
    'top' => '/Tools/Template/add/',
    'bottom' => array(
        'cancel' => '/Tools/Template/listProtocolsAndTemplates/'
    )
);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'settings' => array(
        'header' => __('template', null)
    )
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);