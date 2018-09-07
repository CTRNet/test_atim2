<?php
$structureLinks = array(
    'index' => array(
        'detail' => '/Order/Orders/detail/%%OrderItem.order_id%%/'
    ),
    'bottom' => array(
        'new search' => OrderAppController::$searchLinks,
        'add order' => '/Order/Orders/add/'
    )
);

$settings = array(
    'return' => true
);
if (isset($isAjax)) {
    $settings['actions'] = false;
} else {
    $settings['header'] = __('search type', null) . ': ' . __('order item', null);
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
$form = $this->Structures->build($finalAtimStructure, $finalOptions);
if (isset($isAjax)) {
    $this->layout = 'json';
    $this->json = array(
        'page' => $form,
        'new_search_id' => AppController::getNewSearchId()
    );
} else {
    echo $form;
}