<?php
$structureLinks = array(
    'bottom' => array(
        'add' => $addLinks,
        'tree view' => '/StorageLayout/StorageMasters/contentTreeView'
    )
);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'search',
    'links' => array(
        'top' => array(
            'search' => '/StorageLayout/StorageMasters/search/' . (isset($isAjax) ? '-1' : AppController::getNewSearchId())
        )
    ),
    'settings' => array(
        'actions' => false,
        'header' => __('search type', null) . ': ' . __('storages', null)
    )
);
$finalAtimStructure2 = $emptyStructure;
$finalOptions2 = array(
    'links' => $structureLinks,
    'extras' => '<div class="ajax_search_results"></div>'
);
if (isset($isAjax)) {
    unset($finalOptions2['links']['bottom']);
}

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);
$this->Structures->build($finalAtimStructure2, $finalOptions2);