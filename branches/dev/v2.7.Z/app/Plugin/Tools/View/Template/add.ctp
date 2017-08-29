<?php
$structureLinks = array(
    'top' => '/Tools/Template/add/',
    'bottom' => array(
        'cancel' => '/Tools/Template/index/'
    )
);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);