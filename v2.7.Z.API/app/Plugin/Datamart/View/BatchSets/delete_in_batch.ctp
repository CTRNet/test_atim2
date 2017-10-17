<?php
$structureLinks = array(
    'top' => '/Datamart/BatchSets/deleteInBatch/',
    'checklist' => array(
        'BatchSet.ids][' => '%%BatchSet.id%%'
    ),
    'bottom' => array(
        'cancel' => '/Datamart/BatchSets/index/user'
    )
);
$structureOverride = array();

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'index',
    'data' => $userBatchsets,
    'settings' => array(
        'header' => __('select batchsets to delete'),
        'pagination' => false,
        'form_inputs' => false
    ),
    'links' => $structureLinks,
    'override' => $structureOverride
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);