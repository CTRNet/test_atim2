<?php
$structureLinks = array(
    'index' => array(
        'delete' => '/StorageLayout/StorageCoordinates/delete/' . $atimMenuVariables['StorageMaster.id'] . '/%%StorageCoordinate.id%%'
    ),
    'bottom' => array(
        'add' => '/StorageLayout/StorageCoordinates/add/' . $atimMenuVariables['StorageMaster.id'] . '/'
    )
);

if (isset($addLinks)) {
    $structureLinks['bottom']['add to storage'] = $addLinks;
}

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'index',
    'links' => $structureLinks
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);