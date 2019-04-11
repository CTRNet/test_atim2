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

// Set links and basic sample settings
$structureLinks = array();
$sampleSettings = array();

// If a parent sample is defined then set the 'Show Parent' button
$showParentLink = null;
if (! empty($parentSampleMasterId)) {
    $showParentLink = array(
        'link' => '/InventoryManagement/SampleMasters/detail/' . $atimMenuVariables['Collection.id'] . '/' . $parentSampleMasterId,
        'icon' => 'sample'
    );
}

// Create array of derivative type that could be created from studied sample for the ADD button
$addDerivatives = array();
foreach ($allowedDerivativeType as $sampleControl) {
    $addDerivatives[__($sampleControl['SampleControl']['sample_type'])] = '/InventoryManagement/SampleMasters/add/' . $atimMenuVariables['Collection.id'] . '/' . $sampleControl['SampleControl']['id'] . '/' . $atimMenuVariables['SampleMaster.id'];
}
ksort($addDerivatives);

// Create array of aliquot type that could be created for the studied sample for the ADD button
$addAliquots = array();
foreach ($allowedAliquotType as $aliquotControl) {
    $addAliquots[__($aliquotControl['AliquotControl']['aliquot_type'])] = '/InventoryManagement/AliquotMasters/add/' . $atimMenuVariables['SampleMaster.id'] . '/' . $aliquotControl['AliquotControl']['id'];
}
ksort($addAliquots);

$structureLinks['bottom'] = array(
    'edit' => '/InventoryManagement/SampleMasters/edit/' . $atimMenuVariables['Collection.id'] . '/' . $atimMenuVariables['SampleMaster.id'],
    'delete' => '/InventoryManagement/SampleMasters/delete/' . $atimMenuVariables['Collection.id'] . '/' . $atimMenuVariables['SampleMaster.id'],
    'print barcodes' => array(
        'link' => '/InventoryManagement/AliquotMasters/printBarcodes/model:SampleMaster/id:' . $atimMenuVariables['SampleMaster.id'],
        'icon' => 'barcode'
    ),
    'add derivative' => $addDerivatives,
    'add aliquot' => $addAliquots,
    'see parent sample' => ($isFromTreeView ? null : $showParentLink),
    'see lab book' => null
);

if (isset($labBookMasterId)) {
    $structureLinks['bottom']['see lab book'] = array(
        'link' => '/labbook/LabBookMasters/detail/' . $labBookMasterId,
        'icon' => 'lab_book'
    );
} else {
    unset($structureLinks['bottom']['see lab book']);
}

// Clean up structure link
foreach (array(
    'add derivative',
    'add aliquot',
    'see parent sample'
) as $field) {
    if (empty($structureLinks['bottom'][$field])) {
        unset($structureLinks['bottom'][$field]);
    }
}

if ($isFromTreeView) {
    // Detail form displayed in tree view
    $sampleSettings['header'] = __('sample', null);
}

// Set override
$dropdownOptions = array(
    'SampleMaster.parent_id' => (isset($parentSampleDataForDisplay) && (! empty($parentSampleDataForDisplay))) ? $parentSampleDataForDisplay : array(
        '' => ''
    )
);

// ** 1 - SAMPLE DETAIL **

$sampleSettings['actions'] = $isFromTreeView ? true : false;

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'dropdown_options' => $dropdownOptions,
    'links' => $structureLinks,
    'settings' => $sampleSettings,
    'data' => $sampleMasterData
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);

if (! $isFromTreeView) {
    
    // ** 2 - ALIQUOTS LISTS **
    
    $hookLink = $this->Structures->hook('aliquots');
    
    if (! empty($aliquotsData)) {
        $structureLinks['index'] = array(
            'detail' => '/InventoryManagement/AliquotMasters/detail/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%',
            'edit' => '/InventoryManagement/AliquotMasters/edit/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%',
            'delete' => '/InventoryManagement/AliquotMasters/delete/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%'
        );
        
        $counter = 0;
        $nbOfAliquots = sizeof($aliquotsData);
        foreach ($aliquotsData as $aliquotControlId => $aliquots) {
            $counter ++;
            $finalAtimStructure = $aliquotsStructures[$aliquotControlId];
            $finalOptions = array(
                'type' => 'index',
                'links' => $structureLinks,
                'dropdown_options' => $dropdownOptions,
                'data' => $aliquots,
                'settings' => array(
                    'language_heading' => __($aliquots[0]['AliquotControl']['aliquot_type']),
                    'header' => ($counter == 1) ? __('aliquots', null) : array(),
                    'actions' => (empty($parentSampleMasterId) && ($counter == $nbOfAliquots)) ? true : false,
                    'pagination' => false,
                    'batchset' => array(
                        'link' => '/InventoryManagement/SampleMasters/detail/' . $atimMenuVariables['Collection.id'] . '/' . $atimMenuVariables['SampleMaster.id'],
                        'var' => 'aliquotsData',
                        'ctrl' => $aliquotControlId
                    )
                )
            );
            $isFirst = false;
            
            // CUSTOM CODE
            if ($hookLink) {
                require ($hookLink);
            }
            
            // BUILD FORM
            $this->Structures->build($finalAtimStructure, $finalOptions);
        }
    } else {
        $finalAtimStructure = $aliquotMastersStructure;
        $finalOptions = array(
            'type' => 'index',
            'data' => array(),
            'links' => $structureLinks,
            'settings' => array(
                'header' => __('aliquots'),
                'pagination' => false,
                'actions' => empty($parentSampleMasterId) ? true : false
            )
        );
        
        if ($hookLink)
            require ($hookLink);
            
            // BUILD FORM
        $this->Structures->build($finalAtimStructure, $finalOptions);
    }
    
    // ** 3 - SOURCE ALIQUOTS **
    
    if (! empty($parentSampleMasterId)) {
        $finalAtimStructure = $aliquotSourceStruct;
        
        $structureLinks['index'] = array(
            'source aliquot detail' => '/InventoryManagement/AliquotMasters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%',
            'edit link' => '/InventoryManagement/AliquotMasters/editSourceAliquot/%%SourceAliquot.sample_master_id%%/%%SourceAliquot.aliquot_master_id%%/',
            'delete link' => '/InventoryManagement/AliquotMasters/deleteSourceAliquot/%%SourceAliquot.sample_master_id%%/%%SourceAliquot.aliquot_master_id%%/'
        );
        
        $structureLinks['bottom']['add source aliquots'] = '/InventoryManagement/AliquotMasters/addSourceAliquots/' . $atimMenuVariables['Collection.id'] . '/' . $atimMenuVariables['SampleMaster.id'] . '/';
        
        $finalOptions = array(
            'type' => 'index',
            'links' => $structureLinks,
            'data' => $aliquotSource,
            'settings' => array(
                'header' => __('listall source aliquots'),
                'pagination' => false
            )
        );
        
        // CUSTOM CODE
        $hookLink = $this->Structures->hook('aliquot_source');
        if ($hookLink)
            require ($hookLink);
            
            // BUILD FORM
        $this->Structures->build($finalAtimStructure, $finalOptions);
    }
}