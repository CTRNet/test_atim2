<?php
$structureLinks = array(
    'bottom' => array(
        'edit' => '/Drug/Drugs/edit/' . $atimMenuVariables['Drug.id'] . '/',
        'delete' => '/Drug/Drugs/delete/' . $atimMenuVariables['Drug.id'] . '/'
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