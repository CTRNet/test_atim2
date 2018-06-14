<?php
$structureLinks = array(
    'top' => '/Sop/SopExtends/add/' . $atimMenuVariables['SopMaster.id'] . '/',
    'bottom' => array(
        'cancel' => '/Sop/SopExtends/listall/' . $atimMenuVariables['SopMaster.id'] . '/'
    )
);

$structureOverride = array(
    'SopExtend.material_id' => $materialList
);
$this->Structures->build($atimStructure, array(
    'links' => $structureLinks,
    'override' => $structureOverride
));