<?php
$structureLinks = array(
    'top' => '/StorageLayout/StorageCoordinates/add/' . $atimMenuVariables['StorageMaster.id'],
    'bottom' => array(
        'cancel' => '/StorageLayout/StorageCoordinates/listAll/' . $atimMenuVariables['StorageMaster.id']
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