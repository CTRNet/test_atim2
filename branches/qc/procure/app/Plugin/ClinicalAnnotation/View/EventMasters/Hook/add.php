<?php
$final_options['settings']['actions'] = true;
$final_options['settings']['form_bottom'] = true;

// Set links fot he clinical file update process
if (isset($_SESSION['procure_clinical_file_update_process'])) {
    unset($final_options['links']['bottom']['cancel']);
    $final_options['links']['top'] .= $_SESSION['procure_clinical_file_update_process']['current_page_url_suffix'];
    $final_options['links']['bottom'][__('skip go to %s', __($_SESSION['procure_clinical_file_update_process']['next_page_title']))] = array(
        'link' => $_SESSION['procure_clinical_file_update_process']['next_page_url'],
        'icon' => 'procureskip'
    );
}