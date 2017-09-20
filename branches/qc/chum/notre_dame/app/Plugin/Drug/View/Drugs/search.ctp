<?php
$structureLinks = array(
    'index' => array(
        'detail' => '/Drug/Drugs/detail/%%Drug.id%%'
    ),
    'bottom' => array(
        'search' => '/Drug/Drugs/search',
        'add' => '/Drug/Drugs/add'
    )
);

$settings = array(
    'return' => true
);
if (isset($isAjax)) {
    $settings['actions'] = false;
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