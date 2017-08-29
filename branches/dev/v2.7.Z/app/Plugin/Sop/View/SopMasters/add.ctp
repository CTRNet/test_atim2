<?php
$structureLinks = array(
    'top' => '/Sop/SopMasters/add/' . $atimMenuVariables['SopControl.id'] . '/',
    'bottom' => array(
        'cancel' => '/Sop/SopMasters/listall/'
    )
);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'settings' => array(
        'header' => __($sopControlData['sop_group']) . ' - ' . __($sopControlData['type'])
    )
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

$this->Structures->build($finalAtimStructure, $finalOptions);