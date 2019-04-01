<?php
$model = $formData['model'];
$formBuilderId = $formData['formBuilderId'];
$this->request->data = (!empty($formData['master']))?$formData['indexData']:$formData['indexData'];
$structureLinks = array(
    'index' => array(
        'detail' => '/Administrate/FormBuilders/detailControl/' . "/$formBuilderId" . "/%%$model.id%%",
        'edit' => '/Administrate/FormBuilders/edit/' . "/$formBuilderId" . "/%%$model.id%%",
        'clone' => '/Administrate/FormBuilders/cloneControl/' . "/$formBuilderId" . "/%%$model.id%%",
        'disable' => '/Administrate/FormBuilders/disable/' . "/$formBuilderId" . "/%%$model.id%%",
        'delete' => '/Administrate/FormBuilders/delete/' . "/$formBuilderId" . "/%%$model.id%%"
    ),
    'bottom' => array(
        'back' => '/Administrate/FormBuilders',
        'add' => '/Administrate/FormBuilders/add/'. $formBuilderId
    )
);

$structureOptions = array(
    'links' => $structureLinks,
    'type' => 'index',
    'settings' =>array(
        'pagination' => 0
    )
);

$this->Structures->build($atimStructure, $structureOptions);