<?php
$links = array(
    'top' => '/InventoryManagement/QualityCtrls/add/' . $atimMenuVariables['SampleMaster.id'],
    'bottom' => array(
        'cancel' => '/InventoryManagement/QualityCtrls/listAll/' . $atimMenuVariables['Collection.id'] . '/' . $atimMenuVariables['SampleMaster.id'] . '/'
    ),
    'radiolist' => array(
        'ViewAliquot.aliquot_master_id' => '%%AliquotMaster.id%%'
    )
);

$finalAtimStructure = $emptyStructure;
$finalOptions = array(
    'type' => 'detail',
    'links' => $links,
    'data' => array(),
    'settings' => array(
        'header' => __('quality control creation process') . ' - ' . __('tested aliquot selection'),
        'pagination' => false,
        'form_inputs' => false,
        'actions' => false,
        'form_bottom' => false
    )
);
$hookLink = $this->Structures->hook('empty');
if ($hookLink) {
    require ($hookLink);
}
$this->Structures->build($finalAtimStructure, $finalOptions);

echo "<div style='padding: 10px;'>", $this->Form->radio('ViewAliquot.aliquot_master_id', array(
    '' => __('unspecified')
), array(
    'value' => ''
)), "</div>";

foreach ($aliquotDataVol as &$aliquotDataUnit) {
    unset($aliquotDataUnit['ViewAliquot']['aliquot_master_id']);
}
unset($aliquotDataUnit);

$finalAtimStructure = $aliquotStructureVol;
$finalOptions = array(
    'type' => 'index',
    'links' => $links,
    'data' => $aliquotDataVol,
    'settings' => array(
        'pagination' => false,
        'form_inputs' => false,
        'form_top' => false,
        'form_bottom' => false,
        'actions' => false,
        'language_heading' => __('aliquots with volume')
    )
);

$hookLink = $this->Structures->hook('aliquot_vol');
if ($hookLink) {
    require ($hookLink);
}
$this->Structures->build($finalAtimStructure, $finalOptions);

foreach ($aliquotDataNoVol as &$aliquotDataUnit) {
    unset($aliquotDataUnit['ViewAliquot']['aliquot_master_id']);
}
unset($aliquotDataUnit);
$finalAtimStructure = $aliquotStructureNoVol;
$finalOptions = array(
    'type' => 'index',
    'links' => $links,
    'data' => $aliquotDataNoVol,
    'settings' => array(
        'pagination' => false,
        'form_inputs' => false,
        'form_top' => false,
        'language_heading' => __('aliquots without volume')
    )
);

$hookLink = $this->Structures->hook('aliquot_no_vol');
if ($hookLink) {
    require ($hookLink);
}
$this->Structures->build($finalAtimStructure, $finalOptions);