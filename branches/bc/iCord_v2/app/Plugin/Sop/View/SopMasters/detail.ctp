<?php
$structureLinks = array(
    'bottom' => array(
        'edit' => '/Sop/SopMasters/edit/%%SopMaster.id%%/',
        'delete' => '/Sop/SopMasters/delete/%%SopMaster.id%%/'
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

$this->Structures->build($finalAtimStructure, $finalOptions);