<?php
$structureLinks = array(
    'index' => array(
        'detail' => '/InventoryManagement/SampleMasters/detail/%%ViewSample.collection_id%%/%%ViewSample.sample_master_id%%'
    ),
    'bottom' => array(
        'add collection' => '/InventoryManagement/Collections/add'
    )
);

$settings = array(
    'return' => true
);
if (isset($isAjax)) {
    $settings['actions'] = false;
} else {
    $settings['header'] = array(
        'title' => __('search type', null) . ': ' . __('samples', null),
        'description' => __("more information about the types of samples and aliquots are available %s here", $helpUrl)
    );
}

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'index',
    'links' => $structureLinks,
    'settings' => $settings
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$page = $this->Structures->build($finalAtimStructure, $finalOptions);
if (isset($isAjax)) {
    $this->layout = 'json';
    $this->json = array(
        'page' => $page,
        'new_search_id' => AppController::getNewSearchId()
    );
} else {
    echo $page;
}