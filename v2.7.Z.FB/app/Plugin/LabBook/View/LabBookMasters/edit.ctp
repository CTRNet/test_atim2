<?php
$structureLinks = array(
    'top' => '/labbook/LabBookMasters/edit/' . $atimMenuVariables['LabBookMaster.id'],
    'bottom' => array(
        'cancel' => '/labbook/LabBookMasters/detail/' . $atimMenuVariables['LabBookMaster.id']
    )
);

$structureOverride = array();

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'override' => $structureOverride
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);