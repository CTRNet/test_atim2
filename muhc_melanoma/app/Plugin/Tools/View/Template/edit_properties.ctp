<?php
$structureLinks = array(
    'top' => '/Tools/Template/editProperties/' . $atimMenuVariables['Template.id'] . '/',
    'bottom' => array(
        'cancel' => '/Tools/Template/edit/' . $atimMenuVariables['Template.id'] . '/'
    )
);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'settings' => array(
        'header' => __('template', null)
    ),
    'type' => 'edit'
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);