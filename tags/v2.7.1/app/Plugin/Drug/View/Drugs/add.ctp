<?php
$structureLinks = array(
    'top' => '/Drug/Drugs/add/',
    'bottom' => array(
        'cancel' => '/Drug/Drugs/search/'
    )
);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'settings' => array(
        'pagination' => false,
        'add_fields' => true,
        'del_fields' => true
    ),
    'type' => 'addgrid'
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);