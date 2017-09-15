<?php
$finalOptions['settings']['form_bottom'] = true;
$finalOptions['settings']['actions'] = true;
$finalOptions['settings']['form_top'] = false;
if (! is_null($treatmentControlData))
    $finalOptions['settings']['header']['description'] = __($treatmentControlData['tx_method']);

$structureBottomLinks = array(
    'edit' => '/ClinicalAnnotation/ClinicalCollectionLinks/edit/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['Collection.id'],
    'delete' => '/ClinicalAnnotation/ClinicalCollectionLinks/delete/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['Collection.id'],
    'list' => '/ClinicalAnnotation/ClinicalCollectionLinks/listall/' . $atimMenuVariables['Participant.id'] . '/',
    'details' => array(
        'collection' => '/InventoryManagement/Collections/detail/' . $atimMenuVariables['Collection.id']
    ),
    'copy for new collection' => array(
        'link' => '/InventoryManagement/Collections/add/0/' . $atimMenuVariables['Collection.id'],
        'icon' => 'copy'
    )
);

if ($collectionData['consent_master_id']) {
    $structureBottomLinks['details']['consent'] = '/ClinicalAnnotation/ConsentMasters/detail/' . $collectionData['participant_id'] . '/' . $collectionData['consent_master_id'] . '/';
}
if ($collectionData['diagnosis_master_id']) {
    $structureBottomLinks['details']['diagnosis'] = '/ClinicalAnnotation/DiagnosisMasters/detail/' . $collectionData['participant_id'] . '/' . $collectionData['diagnosis_master_id'] . '/';
}
if ($collectionData['treatment_master_id']) {
    $structureBottomLinks['details']['treatment'] = '/ClinicalAnnotation/TreatmentMasters/detail/' . $collectionData['participant_id'] . '/' . $collectionData['treatment_master_id'] . '/';
}
if ($collectionData['event_master_id']) {
    $structureBottomLinks['details']['event'] = '/ClinicalAnnotation/EventMasters/detail/' . $collectionData['participant_id'] . '/' . $collectionData['event_master_id'] . '/';
}
$finalOptions['links'] = array(
    'bottom' => $structureBottomLinks
);