<?php
$structureLinks = array(
    'index' => array(
        'detail' => '/Administrate/StructureFormats/detail/' . $atimMenuVariables['Structure.id'] . '/%%StructureFormat.id%%'
    )
);

$this->Structures->build($atimStructure, array(
    'links' => $structureLinks
));