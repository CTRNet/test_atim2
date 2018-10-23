<?php
/**
 * **********************************************************************
 * CHUM-BioTransit Project
 * ***********************************************************************
 *
 * ClinicalAnnotation plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-10-22
 */

// No additional object (treatment, etc) coulde be joined to the participant-collection link
// Hide 'Edit' button
$finalOptions['settings']['actions'] = true;
$finalOptions['settings']['form_bottom'] = true;
$finalOptions['links']['bottom'] = array(
    'copy for new collection' => array(
        'link' => '/InventoryManagement/collections/add/0/' . $atimMenuVariables['Collection.id'],
        'icon' => 'copy'
    ),
    'delete collection link' => '/ClinicalAnnotation/ClinicalCollectionLinks/delete/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['Collection.id'],
    'list' => '/ClinicalAnnotation/ClinicalCollectionLinks/listall/' . $atimMenuVariables['Participant.id'] . '/',
    'details' => array(
        'collection' => '/InventoryManagement/Collections/detail/' . $atimMenuVariables['Collection.id']
    )
);