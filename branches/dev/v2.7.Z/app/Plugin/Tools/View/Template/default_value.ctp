<?php
$structureLinks = array(
    'top' => "/Tools/Template/edit/$nodeId",
);

$structureOverride = array();
$dropdownOptions = array();

$finalAtimStructure = $structure;

$finalOptions = array(
    'type' => 'add',
    'links' => $structureLinks,
    'override' => $structureOverride,
    'dropdown_options' => $dropdownOptions
);

$this->Structures->build($finalAtimStructure, $finalOptions);