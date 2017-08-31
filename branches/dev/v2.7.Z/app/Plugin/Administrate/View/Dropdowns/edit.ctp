<?php
$structureLinks = array(
    "top" => "/Administrate/Dropdowns/edit/" . $atimMenuVariables['StructurePermissibleValuesCustom.control_id'] . "/" . $atimMenuVariables['StructurePermissibleValuesCustom.id'] . "/",
    'bottom' => array(
        'cancel' => '/Administrate/Dropdowns/view/' . $atimMenuVariables['StructurePermissibleValuesCustom.control_id']
    )
);
$structureOverride = array();
$structureSettings = array(
    'header' => __('list') . ' : ' . $controlData['StructurePermissibleValuesCustomControl']['name']
);
$finalOptions = array(
    'links' => $structureLinks,
    'override' => $structureOverride,
    'type' => 'edit',
    'settings' => $structureSettings
);

$this->Structures->build($administrateDropdownValues, $finalOptions);