<?php
$finalAtimStructure = $administrateDropdowns;
$finalOptions = array(
    'type' => 'index',
    'links' => array(
        'index' => array(
            'detail' => '/Administrate/Dropdowns/view/%%StructurePermissibleValuesCustomControl.id%%'
        )
    ),
    'settings' => array(
        'pagination' => true,
        'actions' => false
    ),
    'override' => array()
);

$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

$this->Structures->build($finalAtimStructure, $finalOptions);