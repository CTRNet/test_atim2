<?php
$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'index',
    'links' => array(
        'index' => array(
            'detail' => '%%ViewAliquotUse.detail_url%%'
        )
    ),
    'settings' => array(
        'pagination' => false,
        'actions' => false
    )
);

if ($isFromTreeView)
    $finalOptions['settings']['header'] = __('aliquot') . ': ' . __('uses and events');

$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

$this->Structures->build($finalAtimStructure, $finalOptions);