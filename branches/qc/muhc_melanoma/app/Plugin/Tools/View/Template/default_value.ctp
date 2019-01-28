<?php
$structureLinks = array(
    'top' => "/Tools/Template/edit/$nodeId"
);

$structureOverride = array();
$dropdownOptions = array();

$finalAtimStructure = $structure;

$finalOptions = array(
    'type' => 'add',
    'links' => $structureLinks,
    'override' => $structureOverride,
    'settings' => array(
        'header' => __('set default values', null)
    ),
    'dropdown_options' => $dropdownOptions
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

$this->Structures->build($finalAtimStructure, $finalOptions);