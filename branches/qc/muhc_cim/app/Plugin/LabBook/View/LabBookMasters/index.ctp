<?php
$settings = array(
    'actions' => false,
    'header' => __('search type', null) . ': ' . __('lab book', null)
);
$addLinks = array();

foreach ($labBookControlsList as $control) {
    $addLinks[__($control['LabBookControl']['book_type'])] = '/labbook/LabBookMasters/add/' . $control['LabBookControl']['id'];
}
ksort($addLinks);
$structureLinks['bottom'] = array(
    'add' => $addLinks
);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'search',
    'links' => array(
        'top' => array(
            'search' => '/labbook/LabBookMasters/search/' . AppController::getNewSearchId()
        )
    ),
    'settings' => $settings
);

$finalAtimStructure2 = $emptyStructure;
$finalOptions2 = array(
    'links' => array(
        'bottom' => array(
            'add' => $addLinks
        )
    ),
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