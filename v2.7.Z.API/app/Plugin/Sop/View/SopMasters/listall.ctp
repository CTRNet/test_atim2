<?php
$addLinks = array();
foreach ($sopControls as $sopControl) {
    $addLinks[__($sopControl['SopControl']['sop_group']) . ' - ' . __($sopControl['SopControl']['type'])] = '/Sop/SopMasters/add/' . $sopControl['SopControl']['id'] . '/';
}
ksort($addLinks);

$structureLinks = array(
    'index' => array(
        'detail' => '/Sop/SopMasters/detail/%%SopMaster.id%%/'
    ),
    'bottom' => array(
        'add' => $addLinks
    )
);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'index',
    'links' => $structureLinks
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

$this->Structures->build($finalAtimStructure, $finalOptions);