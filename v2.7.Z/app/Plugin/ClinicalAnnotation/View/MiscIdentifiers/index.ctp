<?php
$structure_links = array(
    'bottom' => array(
        'add participant' => '/ClinicalAnnotation/Participants/add/'
    )
);

$final_atim_structure = $atim_structure;
$final_options = array(
    'type' => 'search',
    'links' => array(
        'top' => '/ClinicalAnnotation/MiscIdentifiers/search/' . AppController::getNewSearchId()
    ),
    'settings' => array(
        'header' => __('search type', null) . ': ' . __('misc identifiers', null),
        'actions' => false
    )
);

$final_atim_structure2 = $empty_structure;
$final_options2 = array(
    'links' => $structure_links,
    'extras' => '<div class="ajax_search_results"></div>'
);

// CUSTOM CODE
$hook_link = $this->Structures->hook('index'); // when the caller is search, the hook will be 'search_index.php'
if ($hook_link) {
    require ($hook_link);
}

// BUILD FORM
$this->Structures->build($final_atim_structure, $final_options);
$this->Structures->build($final_atim_structure2, $final_options2);
?>