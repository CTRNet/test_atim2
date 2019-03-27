<?php
$structureLinks = array(
    "top" => '/labbook/LabBookMasters/editSynchOptions/' . $atimMenuVariables['LabBookMaster.id'],
    'bottom' => array(
        'cancel' => '/labbook/LabBookMasters/detail/' . $atimMenuVariables['LabBookMaster.id']
    )
);

// DERIVATIVE DETAILS

$structureOverride = array();
$settings = array(
    'header' => __('derivative', null),
    'actions' => false,
    "form_bottom" => false,
    'pagination' => false,
    'name_prefix' => 'derivative'
);

$finalAtimStructure = $labBookDerivativesSummary;
$finalOptions = array(
    'type' => 'editgrid',
    'links' => $structureLinks,
    'override' => $structureOverride,
    'data' => $this->request->data['derivative'],
    'settings' => $settings
);

$hookLink = $this->Structures->hook('derivatives');
if ($hookLink) {
    require ($hookLink);
}

$this->Structures->build($finalAtimStructure, $finalOptions);

// REALIQUOTING

$structureOverride = array();
$settings = array(
    'header' => __('realiquoting', null),
    'pagination' => false,
    'name_prefix' => 'realiquoting'
);

$finalAtimStructure = $labBookRealiquotingsSummary;
$finalOptions = array(
    'type' => 'editgrid',
    'links' => $structureLinks,
    'override' => $structureOverride,
    'data' => $this->request->data['realiquoting'],
    'settings' => $settings
);

$hookLink = $this->Structures->hook('derivatives');
if ($hookLink) {
    require ($hookLink);
}

$this->Structures->build($finalAtimStructure, $finalOptions);