<?php
$structureLinks = array(
    'top' => '/Sop/SopMasters/edit/' . $atimMenuVariables['SopMaster.id'] . '/',
    'bottom' => array(
        'cancel' => '/Sop/SopMasters/detail/%%SopMaster.id%%/'
    )
);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

$this->Structures->build($finalAtimStructure, $finalOptions);
