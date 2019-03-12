<?php
/**
 * **********************************************************************
 * CUSM
 * ***********************************************************************
 *
 * Clinical Annotation plugin custom code
 *
 * @author N. Luc - CTRNet (nicol.luc@gmail.com)
 * @since 2018-10-15
 */
 
// --------------------------------------------------------------------------------
// Limit collection link to consent and identifier
// --------------------------------------------------------------------------------

$finalOptions['settings']['actions'] = true;
$finalOptions['settings']['form_bottom'] = true;
$finalOptions['links']['bottom'] = array(
    'copy for new collection' => array(
        'link' => '/InventoryManagement/collections/add/0/' . $atimMenuVariables['Collection.id'],
        'icon' => 'copy'
    ),
    'edit' => '/ClinicalAnnotation/ClinicalCollectionLinks/edit/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['Collection.id'],
    'delete collection link' => '/ClinicalAnnotation/ClinicalCollectionLinks/delete/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['Collection.id'],
    'list' => '/ClinicalAnnotation/ClinicalCollectionLinks/listall/' . $atimMenuVariables['Participant.id'] . '/',
    'details' => array(
        'collection' => '/InventoryManagement/Collections/detail/' . $atimMenuVariables['Collection.id']
    )
);
if ($collectionData['consent_master_id']) {
    $finalOptions['links']['bottom']['details']['consent'] = '/ClinicalAnnotation/ConsentMasters/detail/' . $collectionData['participant_id'] . '/' . $collectionData['consent_master_id'] . '/';
}