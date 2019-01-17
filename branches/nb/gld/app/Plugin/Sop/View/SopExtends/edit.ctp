<?php
$structureLinks = array(
    'top' => '/Sop/SopExtends/edit/' . $atimMenuVariables['SopMaster.id'] . '/' . $atimMenuVariables['SopExtend.id'] . '/',
    'bottom' => array(
        'delete' => '/Sop/SopExtends/delete/' . $atimMenuVariables['SopMaster.id'] . '/' . $atimMenuVariables['SopExtend.id'] . '/',
        'cancel' => '/Sop/SopExtends/detail/' . $atimMenuVariables['SopMaster.id'] . '/' . $atimMenuVariables['SopExtend.id'] . '/'
    )
);

$structureOverride = array(
    'SopExtend.material_id' => $materialList
);
$this->Structures->build($atimStructure, array(
    'links' => $structureLinks
));