<?php
$finalAtimStructure = array();
$finalOptions = array(
    'links' => array(),
    'type' => 'detail',
    'settings' => array(
        'header' => __('tries', null),
        'actions' => false
    ),
    'extras' => array(
        'end' => $this->Structures->ajaxIndex('Administrate/ProcureBanksDataMergeSummary/listAllTries/')
    )
);
$this->Structures->build($finalAtimStructure, $finalOptions);

$finalAtimStructure = array();
$finalOptions = array(
    'links' => array(),
    'type' => 'detail',
    'settings' => array(
        'header' => __('messages', null),
        'actions' => true
    ),
    'extras' => array(
        'end' => $this->Structures->ajaxIndex('Administrate/ProcureBanksDataMergeSummary/listAllMessages/')
    )
);
$this->Structures->build($finalAtimStructure, $finalOptions);