<?php
$structureLinks = array(
    'top' => '/Administrate/StructureFormats/edit/' . $atimMenuVariables['Structure.id'] . '/' . $atimMenuVariables['StructureFormat.id'],
    'bottom' => array(
        'cancel' => '/Administrate/StructureFormats/detail/' . $atimMenuVariables['Structure.id'] . '/' . $atimMenuVariables['StructureFormat.id']
    )
);

$this->Structures->build($atimStructure, array(
    'links' => $structureLinks
));