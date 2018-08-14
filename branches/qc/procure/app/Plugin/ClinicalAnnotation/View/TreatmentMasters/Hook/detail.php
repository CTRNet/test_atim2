<?php
if (isset($add_link_for_procure_forms)) {
    foreach ($add_link_for_procure_forms as $button_title => $links) {
        $final_options['links']['bottom'][$button_title] = $links;
        $structure_links['bottom'][$button_title] = $links;
    }
}

// To not display Related Diagnosis Event and Linked Collections
$is_ajax = true;
$final_options['settings']['actions'] = true;
$final_options['settings']['form_bottom'] = true;
unset($final_options['links']['bottom']['add precision']);		

