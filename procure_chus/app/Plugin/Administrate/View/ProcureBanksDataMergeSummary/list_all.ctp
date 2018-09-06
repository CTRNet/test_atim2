<?php
$final_atim_structure = array();
$final_options = array(
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
$this->Structures->build($final_atim_structure, $final_options);

$final_atim_structure = array();
$final_options = array(
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
$this->Structures->build($final_atim_structure, $final_options);