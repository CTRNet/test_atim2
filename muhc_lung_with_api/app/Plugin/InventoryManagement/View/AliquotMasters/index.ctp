<?php
$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'search',
    'links' => array(
        'top' => '/InventoryManagement/AliquotMasters/search/' . AppController::getNewSearchId()
    ),
    'settings' => array(
        'header' => array(
            'title' => __('search type', null) . ': ' . __('aliquots', null),
            'description' => __("more information about the types of samples and aliquots are available %s here", $helpUrl)
        ),
        'actions' => false
    )
);

$finalAtimStructure2 = $emptyStructure;
$finalOptions2 = array(
    'extras' => '<div class="ajax_search_results"></div>'
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);
$this->Structures->build($finalAtimStructure2, $finalOptions2);