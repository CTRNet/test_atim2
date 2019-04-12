<?php
 /**
 *
 * ATiM - Advanced Tissue Management Application
 * Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 *
 * Licensed under GNU General Public License
 * For full copyright and license information, please see the LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 *
 * @author        Canadian Tissue Repository Network <info@ctrnet.ca>
 * @copyright     Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 * @link          http://www.ctrnet.ca
 * @since         ATiM v 2
 * @license       http://www.gnu.org/licenses  GNU General Public License
 */
$consentControlData = isset($collectionData['ConsentControl']) ? $collectionData['ConsentControl'] : null;
$diagnosisControlData = isset($collectionData['DiagnosisControl']) ? $collectionData['DiagnosisControl'] : null;
$treatmentControlData = isset($collectionData['TreatmentControl']) ? $collectionData['TreatmentControl'] : null;
$eventControlData = isset($collectionData['EventControl']) ? $collectionData['EventControl'] : null;

$collectionData = $collectionData['Collection'];

$noDataAvailable = '<div>' . __('core_no_data_available') . '</div>';

// ************** 1- COLLECTION **************
$structureSettings = array(
    'actions' => false,
    'header' => array(
        'title' => __('collection'),
        'description' => null
    )
);

$finalAtimStructure = $emptyStructure;
$finalOptions = array(
    'type' => 'detail',
    'data' => array(),
    'settings' => $structureSettings,
    'extras' => $this->Structures->ajaxIndex('InventoryManagement/Collections/detail/' . $collectionData['id'] . '/1')
);

// CUSTOM CODE
$hookLink = $this->Structures->hook('collection_detail');
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);

// ************** 2- CONSENT **************
$finalOptions['settings']['header'] = array(
    'title' => __('consent'),
    'description' => null
);
if (! is_null($consentControlData))
    $finalOptions['settings']['header']['description'] = __($consentControlData['controls_type']);
$finalOptions['extras'] = $collectionData['consent_master_id'] ? $this->Structures->ajaxIndex('ClinicalAnnotation/ConsentMasters/detail/' . $collectionData['participant_id'] . '/' . $collectionData['consent_master_id']) : $noDataAvailable;

$displayNextSubForm = $cclsList['ConsentMaster']['active'];

// CUSTOM CODE
$hookLink = $this->Structures->hook('consent_detail');
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
if ($displayNextSubForm){
    $this->Structures->build($finalAtimStructure, $finalOptions);
}
    
    // ************** 3- DIAGNOSIS **************
$finalOptions['settings']['header'] = array(
    'title' => __('diagnosis'),
    'description' => null
);
if (! is_null($diagnosisControlData)){
    $finalOptions['settings']['header']['description'] = __($diagnosisControlData['category']) . ' - ' . __($diagnosisControlData['controls_type']);
}
$finalOptions['extras'] = $collectionData['diagnosis_master_id'] ? $this->Structures->ajaxIndex('ClinicalAnnotation/DiagnosisMasters/detail/' . $collectionData['participant_id'] . '/' . $collectionData['diagnosis_master_id']) : $noDataAvailable;

$displayNextSubForm = $cclsList['DiagnosisMaster']['active'];

$hookLink = $this->Structures->hook('diagnosis_detail');
if ($hookLink) {
    require ($hookLink);
}

if ($displayNextSubForm){
    $this->Structures->build($finalAtimStructure, $finalOptions);
}
    
    // ************** 4 - Tx **************
$finalOptions['settings']['header'] = array(
    'title' => __('treatment'),
    'description' => null
);
if (! is_null($treatmentControlData)){
    $finalOptions['settings']['header']['description'] = __($treatmentControlData['tx_method']) . (empty($treatmentControlData['disease_site']) ? '' : ' - ' . __($treatmentControlData['disease_site']));
}
$finalOptions['extras'] = $collectionData['treatment_master_id'] ? $this->Structures->ajaxIndex('ClinicalAnnotation/TreatmentMasters/detail/' . $collectionData['participant_id'] . '/' . $collectionData['treatment_master_id']) : $noDataAvailable;

$displayNextSubForm = $cclsList['TreatmentMaster']['active'];

$hookLink = $this->Structures->hook('treatment_detail');
if ($hookLink) {
    require ($hookLink);
}
if ($displayNextSubForm){
    $this->Structures->build($finalAtimStructure, $finalOptions);
}
    
    // ************** 5 - Event **************
$finalOptions['settings']['header'] = array(
    'title' => __('annotation'),
    'description' => null
);
if (! is_null($eventControlData)){
    $finalOptions['settings']['header']['description'] = __($eventControlData['event_group']) . ' - ' . __($eventControlData['event_type']) . (empty($eventControlData['disease_site']) ? '' : ' - ' . __($eventControlData['disease_site']));
}    
$finalOptions['settings']['actions'] = true;
$finalOptions['extras'] = $collectionData['event_master_id'] ? $this->Structures->ajaxIndex('ClinicalAnnotation/EventMasters/detail/' . $collectionData['participant_id'] . '/' . $collectionData['event_master_id'] . '/1/') : $noDataAvailable;

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
if ($collectionData['diagnosis_master_id']) {
    $structureBottomLinks['details']['diagnosis'] = '/ClinicalAnnotation/DiagnosisMasters/detail/' . $collectionData['participant_id'] . '/' . $collectionData['diagnosis_master_id'] . '/';
}
if ($collectionData['treatment_master_id']) {
    $structureBottomLinks['details']['treatment'] = '/ClinicalAnnotation/TreatmentMasters/detail/' . $collectionData['participant_id'] . '/' . $collectionData['treatment_master_id'] . '/';
}
if ($collectionData['event_master_id']) {
    $structureBottomLinks['details']['event'] = '/ClinicalAnnotation/EventMasters/detail/' . $collectionData['participant_id'] . '/' . $collectionData['event_master_id'] . '/';
}

$displayNextSubForm = $cclsList['EventMaster']['active'];

$hookLink = $this->Structures->hook('event_detail');
if ($hookLink) {
    require ($hookLink);
}

if ($displayNextSubForm){
    $this->Structures->build($finalAtimStructure, $finalOptions);
}

$finalOptions['links'] = array(
    'bottom' => $structureBottomLinks
);

$formOptions = array(
    'settings' => array(
        'actions' => true,
        'form_bottom' => true
    ),
    'links' => array(
        'bottom' => $finalOptions['links']['bottom']
    )
);
$this->Structures->build($emptyStructure, $formOptions);