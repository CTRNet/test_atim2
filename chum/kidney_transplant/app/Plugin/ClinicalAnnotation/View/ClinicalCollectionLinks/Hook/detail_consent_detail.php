<?php
$finalOptions['settings']['actions'] = 1;
$structureBottomLinks = array(
    'edit' => '/ClinicalAnnotation/ClinicalCollectionLinks/edit/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['Collection.id'],
    'delete collection link' => '/ClinicalAnnotation/ClinicalCollectionLinks/delete/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['Collection.id'],
    'details' => array(
        'collection' => '/InventoryManagement/Collections/detail/' . $atimMenuVariables['Collection.id']
    ),
    'copy for new collection' => array(
        'link' => '/InventoryManagement/Collections/add/0/' . $atimMenuVariables['Collection.id'],
        'icon' => 'duplicate'
    )
);
if ($collectionData['consent_master_id']) {
    $structureBottomLinks['details']['consent'] = '/ClinicalAnnotation/ConsentMasters/detail/' . $collectionData['participant_id'] . '/' . $collectionData['consent_master_id'] . '/';
}
$finalOptions['links']['bottom'] = $structureBottomLinks;