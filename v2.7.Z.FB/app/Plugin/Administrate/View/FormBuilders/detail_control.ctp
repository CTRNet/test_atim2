<?php

$data = $formData["data"];
$formBuilderId = $formData["formBuilderId"];
$controlId = $formData["controlId"];
$model = $formData["model"];

$structureLinks = array(
    'bottom' => array(
        'back' => "/Administrate/FormBuilders/detail/$formBuilderId",
        'edit' => "/Administrate/FormBuilders/edit/" . "/$formBuilderId/$controlId",
        'clone' => "/Administrate/FormBuilders/cloneControl/" . "/$formBuilderId/$controlId",
        'disable' => "/Administrate/FormBuilders/disable/" . "/$formBuilderId/$controlId",
        'delete' => "/Administrate/FormBuilders/delete/" . "/$formBuilderId/$controlId",
    )
);
$this->request->data = $data["control"];
$structureOptions = array(
    'type' => 'detail',
    'data' => $data["control"],
    'settings' =>array(
        'header' => __("control information"), 
        'pagination' => 0
    )
);

$this->Structures->build($atimStructureForDetailControl, $structureOptions);

$structureOptions = array(
    'type' => 'index',
    'data' => $data["master"],
    'settings' =>array(
        'header' => __("not editable fields"), 
        'pagination' => 0
    )
);

$this->Structures->build($atimStructureForControl, $structureOptions);

$structureOptions = array(
    'links' => $structureLinks,
    'type' => 'index',
    'data' => $data["detail"],
    'settings' =>array(
        'header' => __("editable fields"), 
        'pagination' => 0
    )
);
$this->Structures->build($atimStructureForControl, $structureOptions);