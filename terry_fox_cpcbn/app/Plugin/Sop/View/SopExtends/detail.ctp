<?php
$structureLinks = array(
    'bottom' => array(
        'edit' => '/Sop/SopExtends/edit/' . $atimMenuVariables['SopMaster.id'] . '/%%SopExtend.id%%/',
        'delete' => '/Sop/SopExtends/delete/' . $atimMenuVariables['SopMaster.id'] . '/%%SopExtend.id%%/'
    )
);

$structureOverride = array(
    'SopExtend.material_id' => $materialList
);
$this->Structures->build($atimStructure, array(
    'links' => $structureLinks,
    'override' => $structureOverride
));