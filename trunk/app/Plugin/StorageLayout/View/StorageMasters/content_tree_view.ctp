<?php

// SETTINGS
$structureSettings = array(
    'tree' => array(
        'StorageMaster' => 'StorageMaster',
        'AliquotMaster' => 'AliquotMaster',
        'TmaBlock' => 'TmaBlock',
        'TmaSlide' => 'TmaSlide',
        'Generated' => 'Generated'
    )
);

// LINKS
$bottom = array();
if (isset($search)) {
    $bottom = array(
        'search' => '/StorageLayout/StorageMasters/search',
        'add' => $addLinks
    );
} elseif (! $isAjax && isset($addLinks)) {
    $bottom = array(
        'add to storage' => $addLinks
    );
}

$structureLinks = array(
    'tree' => array(
        'StorageMaster' => array(
            'detail' => array(
                'link' => '/StorageLayout/StorageMasters/detail/%%StorageMaster.id%%/1',
                'icon' => 'storage'
            ),
            'access to all data' => array(
                'link' => '/StorageLayout/StorageMasters/detail/%%StorageMaster.id%%/',
                'icon' => 'detail'
            )
        ),
        'AliquotMaster' => array(
            'detail' => array(
                'link' => '/InventoryManagement/AliquotMasters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/1/0',
                'icon' => 'aliquot'
            ),
            'access to all data' => array(
                'link' => '/InventoryManagement/AliquotMasters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/',
                'icon' => 'detail'
            )
        ),
        'TmaBlock' => array(
            'detail' => array(
                'link' => '/StorageLayout/StorageMasters/detail/%%TmaBlock.id%%/1',
                'icon' => 'tma block'
            ),
            'access to all data' => array(
                'link' => '/StorageLayout/StorageMasters/detail/%%TmaBlock.id%%/',
                'icon' => 'detail'
            )
        ),
        'TmaSlide' => array(
            'detail' => array(
                'link' => '/StorageLayout/TmaSlides/detail/%%TmaSlide.tma_block_storage_master_id%%/%%TmaSlide.id%%/1',
                'icon' => 'slide'
            ),
            'access to all data' => array(
                'link' => '/StorageLayout/TmaSlides/detail/%%TmaSlide.tma_block_storage_master_id%%/%%TmaSlide.id%%/',
                'icon' => 'detail'
            )
        ),
        'Generated' => array(
            'access to the list' => array(
                'link' => '/StorageLayout/StorageMasters/contentListView/' . $atimMenuVariables['StorageMaster.id'],
                'icon' => 'detail'
            )
        )
    ),
    'tree_expand' => array(
        'StorageMaster' => '/StorageLayout/StorageMasters/contentTreeView/%%StorageMaster.id%%/1/',
        'TmaBlock' => '/StorageLayout/StorageMasters/contentTreeView/%%TmaBlock.id%%/1/'
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