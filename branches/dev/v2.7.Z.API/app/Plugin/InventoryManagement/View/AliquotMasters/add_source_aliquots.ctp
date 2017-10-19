<?php
$structureLinks = array(
    'top' => '/InventoryManagement/AliquotMasters/addSourceAliquots/' . $atimMenuVariables['Collection.id'] . '/' . $atimMenuVariables['SampleMaster.id'] . '/',
    'bottom' => array(
        'cancel' => '/InventoryManagement/SampleMasters/detail/' . $atimMenuVariables['Collection.id'] . '/' . $atimMenuVariables['SampleMaster.id'] . '/'
    )
);

$structureOverride = array();

// no volume
$finalAtimStructure = $sourcealiquots;
$finalOptions = array(
    'data' => isset($this->request->data['no_vol']) ? $this->request->data['no_vol'] : array(),
    'links' => $structureLinks,
    'override' => $structureOverride,
    'type' => 'editgrid',
    'settings' => array(
        'header' => __('listall source aliquots'),
        'pagination' => false,
        'form_bottom' => false,
        'actions' => false,
        'language_heading' => __('aliquots without volume'),
        'name_prefix' => 'no_vol'
    )
);

// CUSTOM CODE
$hookLink = $this->Structures->hook('no_vol');
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);
// ----------------

// volume
$finalAtimStructure = $sourcealiquotsVolume;
$finalOptions = array(
    'data' => isset($this->request->data['vol']) ? $this->request->data['vol'] : array(),
    'links' => $structureLinks,
    'override' => $structureOverride,
    'type' => 'editgrid',
    'settings' => array(
        'pagination' => false,
        'form_top' => false,
        'language_heading' => __('aliquots with volume'),
        'name_prefix' => 'vol'
    )
);

// CUSTOM CODE
$hookLink = $this->Structures->hook('vol');
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);
// ----------------