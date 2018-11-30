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
$structureLinks = array();

$addLinks = array();
foreach ($specimenSampleControlsList as $sampleControl) {
    $addLinks[__($sampleControl['SampleControl']['sample_type'])] = '/InventoryManagement/SampleMasters/add/' . $atimMenuVariables['Collection.id'] . '/' . $sampleControl['SampleControl']['id'];
}
ksort($addLinks);

$settings = array();
if ($isAjax && ! $hideHeader)
    $settings['header'] = __('collection');

$bottomLinks = array(
    'edit' => '/InventoryManagement/Collections/edit/' . $atimMenuVariables['Collection.id'],
    'delete' => '/InventoryManagement/Collections/delete/' . $atimMenuVariables['Collection.id'],
    'copy for new collection' => array(
        'link' => '/InventoryManagement/Collections/add/0/' . $atimMenuVariables['Collection.id'],
        'icon' => 'duplicate'
    ),
    'print barcodes' => array(
        'link' => '/InventoryManagement/AliquotMasters/printBarcodes/model:Collection/id:' . $atimMenuVariables['Collection.id'],
        'icon' => 'barcode'
    ),
    'add specimen' => $addLinks,
    'add from template' => $templates
);
if (empty($participantId)) {
    $bottomLinks['participant data'] = '/underdevelopment/';
} else {
    $bottomLinks['participant data'] = array(
        'profile' => array(
            'icon' => 'participant',
            'link' => '/ClinicalAnnotation/Participants/profile/' . $participantId
        ),
        'participant inventory' => array(
            'icon' => 'participant',
            'link' => '/ClinicalAnnotation/ClinicalCollectionLinks/listall/' . $participantId
        ),
        'participant collection link' => array(
            'icon' => 'participant',
            'link' => '/ClinicalAnnotation/ClinicalCollectionLinks/detail/' . $participantId . '/' . $atimMenuVariables['Collection.id']
        )
    );
}

$structureLinks['bottom'] = $bottomLinks;

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'settings' => $settings
);

if (! $isAjax && ! empty($sampleData)) {
    $finalOptions['settings']['actions'] = false;
}

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);

if (! $isAjax && ! empty($sampleData)) {
    $structureSettings = array(
        'tree' => array(
            'SampleMaster' => 'SampleMaster'
        ),
        'header' => __('collection contents')
    );
    $structureLinks['tree'] = array(
        'SampleMaster' => array(
            'detail' => array(
                'link' => '/InventoryManagement/SampleMasters/detail/%%SampleMaster.collection_id%%/%%SampleMaster.id%%/1/',
                'icon' => 'flask'
            ),
            'access to all data' => array(
                'link' => '/InventoryManagement/SampleMasters/detail/%%SampleMaster.collection_id%%/%%SampleMaster.id%%/',
                'icon' => 'detail'
            )
        )
    );
    $structureLinks['tree_expand'] = array(
        'SampleMaster' => '/InventoryManagement/SampleMasters/contentTreeView/%%SampleMaster.collection_id%%/%%SampleMaster.id%%/1/'
    );
    $structureLinks['ajax'] = array(
        'index' => array(
            'detail' => array(
                'json' => array(
                    'update' => 'frame',
                    'callback' => 'set_at_state_in_tree_root'
                )
            )
        )
    );
    $finalOptions = array(
        'type' => 'tree',
        'data' => $sampleData
    );
    
    $structureExtras = array();
    $structureExtras[10] = '<div id="frame"></div>';
    
    // BUILD
    $finalAtimStructure = array(
        'SampleMaster' => $sampleMastersForCollectionTreeView
    );
    $finalOptions = array(
        'type' => 'tree',
        'data' => $sampleData,
        'settings' => $structureSettings,
        'links' => $structureLinks,
        'extras' => $structureExtras
    );
    
    // CUSTOM CODE
    $hookLink = $this->Structures->hook();
    if ($hookLink) {
        require ($hookLink);
    }
    
    // BUILD FORM
    $this->Structures->build($finalAtimStructure, $finalOptions);
}
?>
<script>
    var duplicatedSamples = [];
    var treeTable = null;
</script>