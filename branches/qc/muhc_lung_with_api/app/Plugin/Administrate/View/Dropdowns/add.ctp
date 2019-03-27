<?php
$structureLinks = array(
    "top" => "/Administrate/Dropdowns/add/" . $controlData['StructurePermissibleValuesCustomControl']['id'] . "/",
    "bottom" => array(
        "cancel" => "/Administrate/Dropdowns/view/" . $controlData['StructurePermissibleValuesCustomControl']['id'] . "/"
    )
);
$structureOverride = array(
    'StructurePermissibleValuesCustom.use_as_input' => 1
);
$structureSettings = array(
    'pagination' => false,
    'add_fields' => true,
    'del_fields' => true,
    'header' => __('list') . ' : ' . $controlData['StructurePermissibleValuesCustomControl']['name']
);
$finalOptions = array(
    'links' => $structureLinks,
    'override' => $structureOverride,
    'type' => 'addgrid',
    'settings' => $structureSettings
);

$this->Structures->build($administrateDropdownValues, $finalOptions);