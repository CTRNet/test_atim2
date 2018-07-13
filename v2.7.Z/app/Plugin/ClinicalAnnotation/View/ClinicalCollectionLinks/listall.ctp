<?php

// ------ 1- Link Display ---------------------------------------------------
$structureLinks = array(
    'index' => array(
        'detail' => '/ClinicalAnnotation/ClinicalCollectionLinks/detail/' . $atimMenuVariables['Participant.id'] . '/%%Collection.id%%/',
        'edit' => '/ClinicalAnnotation/ClinicalCollectionLinks/edit/' . $atimMenuVariables['Participant.id'] . '/%%Collection.id%%/',
        'delete collection link' => '/ClinicalAnnotation/ClinicalCollectionLinks/delete/' . $atimMenuVariables['Participant.id'] . '/%%Collection.id%%/',
        'collection' => array(
            'link' => '/InventoryManagement/Collections/detail/%%Collection.id%%/',
            'icon' => 'collection'
        )
    )
);

$structureOverride = array();

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'index',
    'links' => $structureLinks,
    'override' => $structureOverride,
    'settings' => array(
        'actions' => false,
        'pagination' => false
    )
);

if (! $isAjax)
    $finalOptions['settings']['header'] = __('links to collections');
    
    // CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);

// ------ 2- Collection Contents ---------------------------------------------------

// SETTINGS

if (! $isAjax) {
    $structureSettings = array(
        'tree' => array(
            'Collection' => 'Collection'
        ),
        'header' => __('collections content')
    );
    
    // LINKS
    
    $addButtonLinks = '/ClinicalAnnotation/ClinicalCollectionLinks/add/' . $atimMenuVariables['Participant.id'] . '/';
    if ($collectionProtocols) {
        $addButtonLinks = array();
        $addButtonLinks['collection'] = array(
            'link' => '/ClinicalAnnotation/ClinicalCollectionLinks/add/' . $atimMenuVariables['Participant.id'] . '/',
            'icon' => 'add_collection'
        );
        foreach ($collectionProtocols as $collectionProtocolId => $collectionProtocolName) {
            $addButtonLinks[$collectionProtocolName] = array(
                'link' => '/ClinicalAnnotation/ClinicalCollectionLinks/add/' . $atimMenuVariables['Participant.id'] . '/' . $collectionProtocolId,
                'icon' => 'add_collection_protocol'
            );
        }
    }
    
    $structureLinks = array(
        'bottom' => array(
            'add' => $addButtonLinks
        ),
        'tree' => array(
            'Collection' => array(
                'detail' => array(
                    'link' => '/InventoryManagement/Collections/detail/%%Collection.id%%',
                    'icon' => 'collection'
                ),
                'access to all data' => array(
                    'link' => '/InventoryManagement/Collections/detail/%%Collection.id%%/',
                    'icon' => 'detail'
                )
            )
        ),
        'tree_expand' => array(
            'Collection' => '/InventoryManagement/SampleMasters/contentTreeView/%%Collection.id%%/0/1/'
        ),
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
    
    $structureOverride = array();
    
    // BUILD
    
    $finalAtimStructure = $treeViewAtimStructure;
    $finalOptions = array(
        'type' => 'tree',
        'settings' => $structureSettings,
        'links' => $structureLinks,
        'extras' => $structureExtras,
        'override' => $structureOverride
    );
    
    // CUSTOM CODE
    $hookLink = $this->Structures->hook('tree_view');
    if ($hookLink) {
        require ($hookLink);
    }
    
    // BUILD FORM
    $this->Structures->build($finalAtimStructure, $finalOptions);
}