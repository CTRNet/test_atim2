<?php
$links = array(
    "bottom" => array(
        "add" => "/Administrate/Dropdowns/add/" . $controlData['StructurePermissibleValuesCustomControl']['id'] . "/",
        "configure" => "/Administrate/Dropdowns/configure/" . $controlData['StructurePermissibleValuesCustomControl']['id'] . "/"
    ),
    'index' => array(
        'edit' => '/Administrate/Dropdowns/edit/' . $controlData['StructurePermissibleValuesCustomControl']['id'] . '/%%StructurePermissibleValuesCustom.id%%'
    )
);
$structureSettings = array(
    "pagination" => false,
    'header' => __('list') . ' : ' . $controlData['StructurePermissibleValuesCustomControl']['name']
);
$finalOptions = array(
    "type" => "index",
    "data" => $this->request->data,
    "links" => $links,
    "settings" => $structureSettings
);

$this->Structures->build($administrateDropdownValues, $finalOptions);