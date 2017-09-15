<?php
$structureLinks = array(
    'bottom' => array(
        'edit' => '/Administrate/StructureFormats/edit/' . $atimMenuVariables['Structure.id'] . '/%%StructureFormat.id%%'
    )
);

$this->Structures->build($atimStructure, array(
    'links' => $structureLinks
));