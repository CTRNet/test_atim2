<?php
if ($addChemoComplication) {
    // Display precision
    $this->Structures->build($finalAtimStructure, $finalOptions);
    
    // Display complication
    $structureSettings = array(
        'pagination' => false,
        'actions' => $isAjax,
        ($isAjax ? 'language_heading' : 'header') => __('complications')
    );
    $structureLinks['index'] = array(
        'edit' => '/ClinicalAnnotation/TreatmentExtendMasters/edit/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['TreatmentMaster.id'] . '/%%TreatmentExtendMaster.id%%',
        'delete' => '/ClinicalAnnotation/TreatmentExtendMasters/delete/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['TreatmentMaster.id'] . '/%%TreatmentExtendMaster.id%%'
    );
    $finalOptions = array(
        'data' => $txExtendData2,
        'type' => 'index',
        'settings' => $structureSettings,
        'links' => $structureLinks
    );
    $finalAtimStructure = $extendFormAlias2;
    pr(($txExtendType ? __($txExtendType) : __('add precision')));/*
    $structureLinks['bottom']['add precision'] = array(
        'chemotherapy drugs' => $structureLinks['bottom']['add']['add precision'],
        'chemotherapy complications' => $structureLinks['bottom']['add precision'] . '/chemo_complications'
    );*/
    
    $tmpKeyName = $txExtendType ? __($txExtendType) : __('add precision');
    $structureLinks['bottom']['add'][__('chemotherapy complications')] = array(
        'link' => $structureLinks['bottom']['add'][$tmpKeyName]['link'] . '/chemo_complications',
        'icon' => $structureLinks['bottom']['add'][$tmpKeyName]['icon']
    );
}