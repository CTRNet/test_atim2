<?php

// SETTINGS
$structureSettings = array(
    'tree' => array(
        'SampleMaster' => 'SampleMaster',
        'AliquotMaster' => 'AliquotMaster',
        'TmaBlock' => 'AliquotMaster',
        'QualityCtrl' => 'SampleUseForCollectionTreeView',
        'SpecimenReviewMaster' => 'SampleUseForCollectionTreeView'
    )
);
$atimStructure['SampleUseForCollectionTreeView']['Accuracy']['Generated']['sample_use_date'] = 'sample_use_date_accuracy';

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
        ),
        'TmaBlock' => array(
            'detail' => array(
                'link' => '/InventoryManagement/AliquotMasters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/1/',
                'icon' => 'tma block'
            ),
            'access to all data' => array(
                'link' => '/InventoryManagement/AliquotMasters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/',
                'icon' => 'detail'
            )
        ),
        'SpecimenReviewMaster' => array(
            'detail' => array(
                'link' => '/InventoryManagement/SpecimenReviews/detail/%%SpecimenReviewMaster.collection_id%%/%%SpecimenReviewMaster.sample_master_id%%/%%SpecimenReviewMaster.id%%/',
                'icon' => 'specimen review'
            ),
            'access to all data' => array(
                'link' => '/InventoryManagement/SpecimenReviews/detail//%%SpecimenReviewMaster.collection_id%%/%%SpecimenReviewMaster.sample_master_id%%/%%SpecimenReviewMaster.id%%/',
                'icon' => 'detail'
            )
        ),
        'QualityCtrl' => array(
            'detail' => array(
                'link' => '/InventoryManagement/QualityCtrls/detail/%%SampleMaster.collection_id%%/%%QualityCtrl.sample_master_id%%/%%QualityCtrl.id%%/1/',
                'icon' => 'quality controls'
            ),
            'access to all data' => array(
                'link' => '/InventoryManagement/QualityCtrls/detail/%%SampleMaster.collection_id%%/%%QualityCtrl.sample_master_id%%/%%QualityCtrl.id%%/',
                'icon' => 'detail'
            )
        )
    ),
    'tree_expand' => array(
        'SampleMaster' => '/InventoryManagement/SampleMasters/contentTreeView/%%SampleMaster.collection_id%%/%%SampleMaster.id%%/1/',
        'AliquotMaster' => '/InventoryManagement/AliquotMasters/contentTreeView/%%AliquotMaster.collection_id%%/%%AliquotMaster.id%%/1/',
        'TmaBlock' => '/InventoryManagement/AliquotMasters/contentTreeView/%%AliquotMaster.collection_id%%/%%AliquotMaster.id%%/1/'
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