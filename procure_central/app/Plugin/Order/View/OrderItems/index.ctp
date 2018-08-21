<?php
$structureLinks = array(
    'bottom' => array(
        'new search' => OrderAppController::$searchLinks,
        'add order' => '/Order/Orders/add/'
    )
);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'search',
    'links' => array(
        'top' => '/Order/OrderItems/search/' . AppController::getNewSearchId()
    ),
    'settings' => array(
        'header' => __('search type', null) . ': ' . __('order item', null),
        'actions' => false
    )
);
$finalAtimStructure2 = $emptyStructure;
$finalOptions2 = array(
    'links' => $structureLinks,
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