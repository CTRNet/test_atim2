<?php
$structureLinks = array(
    'top' => '/StorageLayout/TmaSlideUses/edit/' . $atimMenuVariables['TmaSlideUse.id'],
    'bottom' => array(
        'cancel' => '/StorageLayout/TmaSlides/detail/' . $atimMenuVariables['StorageMaster.id'] . '/' . $atimMenuVariables['TmaSlide.id']
    )
);

$structureOverride = array();
$settings = array(
    'header' => __('tma slide uses')
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