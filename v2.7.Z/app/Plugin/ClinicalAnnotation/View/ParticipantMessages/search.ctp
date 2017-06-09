<?php
$structureLinks = array(
    'index' => '/ClinicalAnnotation/ParticipantMessages/detail/%%ParticipantMessage.participant_id%%/%%ParticipantMessage.id%%/',
    'bottom' => array(
        'add participant' => '/ClinicalAnnotation/Participants/add/'
    )
);

$settings = array(
    'return' => true
);
if (isset($isAjax)) {
    $settings['actions'] = false;
} else {
    $settings['header'] = __('search type', null) . ': ' . __('participant messages', null);
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

?>
