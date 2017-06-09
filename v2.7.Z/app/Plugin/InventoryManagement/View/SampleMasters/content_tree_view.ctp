<?php

// SETTINGS
$structureSettings = array(
    'tree' => array(
        'SampleMaster' => 'SampleMaster',
        'AliquotMaster' => 'AliquotMaster'
    )
);

// LINKS
$bottom = array();
if (! $isAjax) {
    
    $addLinks = array();
    foreach ($specimenSampleControlsList as $sampleControl) {
        $addLinks[__($sampleControl['SampleControl']['sample_type'])] = '/InventoryManagement/SampleMasters/add/' . $collectionId . '/' . $sampleControl['SampleControl']['id'];
    }
    ksort($addLinks);
    
    $bottom = array(
        'add specimen' => $addLinks
    );
    if (! empty($templates)) {
        $bottom['add from template'] = $templates;
    }
}

$structureLinks = array(
    'tree' => array(
        'SampleMaster' => array(
            'detail' => array(
                'link' => '/InventoryManagement/SampleMasters/detail/%%SampleMaster.collection_id%%/%%SampleMaster.id%%/1/',
                'icon' => 'flask'
            ),
            'access to all data' => array(
                'link' => '/InventoryManagement/SampleMasters/detail/%%SampleMaster.collection_id%%/%%SampleMaster.id%%/',
                'icon' => 'detail'
            )
        ),
        'AliquotMaster' => array(
            'detail' => array(
                'link' => '/InventoryManagement/AliquotMasters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/1/',
                'icon' => 'aliquot'
            ),
            'access to all data' => array(
                'link' => '/InventoryManagement/AliquotMasters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/',
                'icon' => 'detail'
            )
        )
    ),
    'tree_expand' => array(
        'SampleMaster' => '/InventoryManagement/SampleMasters/contentTreeView/%%SampleMaster.collection_id%%/%%SampleMaster.id%%/1/',
        'AliquotMaster' => '/InventoryManagement/AliquotMasters/contentTreeView/%%AliquotMaster.collection_id%%/%%AliquotMaster.id%%/1/'
    ),
    'bottom' => $bottom,
    'ajax' => array(
        'index' => array(
            'detail' => array(
                'json' => array(
                    'update' => 'frame',
                    'callback' => 'set_at_state_in_tree_root'
                )
            )
        )
    )
);

// EXTRAS

$structureExtras = array();
$structureExtras[10] = '<div id="frame"></div>';

// BUILD

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'tree',
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
	
