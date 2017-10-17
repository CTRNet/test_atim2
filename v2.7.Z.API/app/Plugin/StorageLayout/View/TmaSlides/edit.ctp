<?php
$structureLinks = array(
    'top' => '/StorageLayout/TmaSlides/edit/' . $atimMenuVariables['StorageMaster.id'] . '/' . $atimMenuVariables['TmaSlide.id'] . "/$fromSlidePage",
    'bottom' => array(
        'cancel' => ($fromSlidePage ? '/StorageLayout/TmaSlides/detail/' . $atimMenuVariables['StorageMaster.id'] . '/' . $atimMenuVariables['TmaSlide.id'] : '/StorageLayout/StorageMasters/detail/' . $atimMenuVariables['StorageMaster.id'])
    )
);

$structureOverride = array();
$settings = array(
    'header' => __('tma slide')
);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'override' => $structureOverride,
    'settings' => $settings
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);