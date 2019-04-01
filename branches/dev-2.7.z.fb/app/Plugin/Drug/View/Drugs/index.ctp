<?php
$structureLinks = array(
    'bottom' => array(
        'add' => '/Drug/Drugs/add/'
    )
);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'search',
    'links' => array(
        'top' => array(
            'search' => '/Drug/Drugs/search/' . AppController::getNewSearchId()
        )
    ),
    'settings' => array(
        'actions' => false,
        'header' => __('search type', null) . ': ' . __('drugs', null)
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