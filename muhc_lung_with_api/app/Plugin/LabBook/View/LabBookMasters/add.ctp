<?php
$bottomButtons = array();
$settings = array();

if ($isAjax) {
    $settings['header'] = array(
        'title' => __('add lab book'),
        'description' => $bookType
    );
} else {
    $bottomButtons['cancel'] = '/labbook/LabBookMasters/index/';
}

$structureLinks = array(
    'top' => '/labbook/LabBookMasters/add/' . $atimMenuVariables['LabBookControl.id'] . '/' . $isAjax,
    'bottom' => $bottomButtons
);

$structureOverride = array();

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