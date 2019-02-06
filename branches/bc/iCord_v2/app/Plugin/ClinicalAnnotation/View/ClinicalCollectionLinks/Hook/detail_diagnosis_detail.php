<?php
/**
 * **********************************************************************
 * iCord
 * ***********************************************************************
 *
 * Clinical Annotation plugin custom code
 *
 * @author N. Luc - CTRNet (nicol.luc@gmail.com)
 * @since 2019-01-31
 */

// Hide the Treatment and Event selection sections
$finalOptions['settings']['actions'] = true;
$structureBottomLinks = array(
    'edit' => '/ClinicalAnnotation/ClinicalCollectionLinks/edit/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['Collection.id'],
    'delete collection link' => '/ClinicalAnnotation/ClinicalCollectionLinks/delete/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['Collection.id'],
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
$finalOptions['links'] = array(
    'bottom' => $structureBottomLinks
);