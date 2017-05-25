<?php
$structure_links = array(
    'bottom' => array(
        'edit' => '/Study/StudyFundings/edit/' . $atim_menu_variables['StudySummary.id'] . '/%%StudyFunding.id%%/',
        'delete' => '/Study/StudyFundings/delete/' . $atim_menu_variables['StudySummary.id'] . '/%%StudyFunding.id%%/'
    )
);

// Set form structure and option
$final_atim_structure = $atim_structure;
$final_options = array(
    'settings' => array(
        'header' => __('study funding')
    ),
    'links' => $structure_links
);

// CUSTOM CODE
$hook_link = $this->Structures->hook();
if ($hook_link) {
    require ($hook_link);
}

// BUILD FORM
$this->Structures->build($final_atim_structure, $final_options);
?>