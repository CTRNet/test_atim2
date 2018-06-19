<?php

// SETTINGS
$structureSettings = array(
    'tree' => array(
        'AliquotMaster' => 'AliquotMaster',
        'OrderItemReturn' => 'ViewAliquotUse',
        'OrderItem' => 'ViewAliquotUse',
        'QualityCtrl' => 'ViewAliquotUse',
        'SampleMaster' => 'ViewAliquotUse',
        'Shipment' => 'ViewAliquotUse',
        'SpecimenReviewMaster' => 'ViewAliquotUse',
        'AliquotInternalUse' => 'ViewAliquotUse',
        'TmaBlock' => 'AliquotMaster'
    )
);

// LINKS
$bottom = array();

$structureLinks = array(
    'tree' => array(
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
        // *** Aliquot Uses ***
        'OrderItemReturn' => array(
            'detail' => array(
                'link' => '/Order/Shipments/detail/%%FunctionManagement.url_ids%%/1/',
                'icon' => 'order items returned'
            ),
            'access to all data' => array(
                'link' => '/Order/Shipments/detail/%%FunctionManagement.url_ids%%/1/',
                'icon' => 'detail'
            )
        ),
        'OrderItem' => array(
            'detail' => array(
                'link' => '/Order/Orders/detail/%%FunctionManagement.url_ids%%/1/',
                'icon' => 'order items'
            ),
            'access to all data' => array(
                'link' => '/Order/Orders/detail/%%FunctionManagement.url_ids%%/',
                'icon' => 'detail'
            )
        ),
        'QualityCtrl' => array(
            'detail' => array(
                'link' => '/InventoryManagement/QualityCtrls/detail/%%FunctionManagement.url_ids%%/1/',
                'icon' => 'quality controls'
            ),
            'access to all data' => array(
                'link' => '/InventoryManagement/QualityCtrls/detail/%%FunctionManagement.url_ids%%/',
                'icon' => 'detail'
            )
        ),
        'SampleMaster' => array(
            'detail' => array(
                'link' => '/InventoryManagement/SampleMasters/detail/%%FunctionManagement.url_ids%%/1/',
                'icon' => 'flask'
            ),
            'access to all data' => array(
                'link' => '/InventoryManagement/SampleMasters/detail/%%FunctionManagement.url_ids%%/',
                'icon' => 'detail'
            )
        ),
        'Shipment' => array(
            'detail' => array(
                'link' => '/Order/Shipments/detail/%%FunctionManagement.url_ids%%/1/',
                'icon' => 'shipping'
            ),
            'access to all data' => array(
                'link' => '/Order/Shipments/detail/%%FunctionManagement.url_ids%%/',
                'icon' => 'detail'
            )
        ),
        'SpecimenReviewMaster' => array(
            'detail' => array(
                'link' => '/InventoryManagement/SpecimenReviews/detail/%%FunctionManagement.url_ids%%/%%ViewAliquotUse.aliquot_master_id%%/',
                'icon' => 'specimen review'
            ),
            'access to all data' => array(
                'link' => '/InventoryManagement/SpecimenReviews/detail/%%FunctionManagement.url_ids%%/',
                'icon' => 'detail'
            )
        ),
        'AliquotInternalUse' => array(
            'detail' => array(
                'link' => '/InventoryManagement/AliquotMasters/detailAliquotInternalUse/%%FunctionManagement.url_ids%%/1/',
                'icon' => 'use'
            ),
            'access to all data' => array(
                'link' => '/InventoryManagement/AliquotMasters/detailAliquotInternalUse/%%FunctionManagement.url_ids%%/',
                'icon' => 'detail'
            )
        ),
        // *** TmaBlock (Core) ***
        'TmaBlock' => array(
            'detail' => array(
                'link' => '/InventoryManagement/AliquotMasters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/1/',
                'icon' => 'tma block'
            ),
            'access to all data' => array(
                'link' => '/InventoryManagement/AliquotMasters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/',
                'icon' => 'detail'
            )
        )
    ),
    'tree_expand' => array(
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