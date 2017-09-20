<?php
$structureLinks = array(
    'top' => '/Drug/Drugs/edit/' . $atimMenuVariables['Drug.id'] . '/',
    'bottom' => array(
        'cancel' => '/Drug/Drugs/detail/' . $atimMenuVariables['Drug.id'] . '/'
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