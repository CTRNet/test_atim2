<?php
$structureLinks = array(
    'index' => array(
        'detail' => '/StorageLayout/TmaSlides/detail/' . $atimMenuVariables['StorageMaster.id'] . '/%%TmaSlide.id%%',
        'edit' => '/StorageLayout/TmaSlides/edit/' . $atimMenuVariables['StorageMaster.id'] . '/%%TmaSlide.id%%',
        'delete' => '/StorageLayout/TmaSlides/delete/' . $atimMenuVariables['StorageMaster.id'] . '/%%TmaSlide.id%%',
        'add to order' => array(
            "link" => '/Order/OrderItems/addOrderItemsInBatch/TmaSlide/%%TmaSlide.id%%/',
            "icon" => "add_to_order"
        )
    ),
    'bottom' => array(
        'add' => '/StorageLayout/TmaSlides/add/' . $atimMenuVariables['StorageMaster.id'] . '/'
    )
);

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