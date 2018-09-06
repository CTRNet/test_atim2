<?php
$structureLinks = array(
    'index' => array(
        'detail' => '/Sop/SopExtends/detail/' . $atimMenuVariables['SopMaster.id'] . '/%%SopExtend.id%%/'
    ),
    'bottom' => array(
        'add' => '/Sop/SopExtends/add/' . $atimMenuVariables['SopMaster.id'] . '/'
    )
);

$structureOverride = array(
    'SopExtend.material_id' => $materialList
);
$this->Structures->build($atimStructure, array(
    'type' => 'index',
    'links' => $structureLinks,
    'override' => $structureOverride
));