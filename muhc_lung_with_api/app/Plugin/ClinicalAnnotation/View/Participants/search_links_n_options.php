<?php
$structureLinks = array(
    'index' => array(
        'detail' => '/ClinicalAnnotation/Participants/profile/%%Participant.id%%'
    ),
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
    $settings['header'] = __('search type', null) . ': ' . __('participants', null);
}

// Set form structure and option
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