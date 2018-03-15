<?php
$structureLinks = array(
    'bottom' => array(
        'add' => '/Study/StudySummaries/add'
    )
);

// Set form structure and option
$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'search',
    'links' => array(
        'top' => '/Study/StudySummaries/search/' . AppController::getNewSearchId() . '/'
    ),
    'settings' => array(
        'header' => __('search type', null) . ': ' . __('study and project', null),
        'actions' => false
    )
);

$finalAtimStructure2 = $emptyStructure;
$finalOptions2 = array(
    'links' => $structureLinks,
    'extras' => '<div class="ajax_search_results"></div>'
);

// CUSTOM CODE
$hookLink = $this->Structures->hook('index'); // when the caller is search, the hook will be 'search_index.php'
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);
$this->Structures->build($finalAtimStructure2, $finalOptions2);