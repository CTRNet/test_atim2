<?php
$structureLinks = array(
    'top' => '/StorageLayout/StorageMasters/edit/' . $atimMenuVariables['StorageMaster.id'],
    'bottom' => array(
        'cancel' => '/StorageLayout/StorageMasters/detail/' . $atimMenuVariables['StorageMaster.id']
    )
);

$structureOverride = array();

if (isset($predefinedParentStorageSelectionLabel))
    $structureOverride['FunctionManagement.recorded_storage_selection_label'] = $predefinedParentStorageSelectionLabel;

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'override' => $structureOverride
);
$finalOptions['settings']['no_sanitization']['StorageMaster'] = array(
    'layout_description'
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);