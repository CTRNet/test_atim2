<?php
$is_ajax = true;
$final_options['settings']['actions'] = true;
unset($final_options['links']['bottom']['add identifier']);
$final_options['links']['bottom']['add collection'] = '/ClinicalAnnotation/ClinicalCollectionLinks/add/'.$atim_menu_variables['Participant.id'].'/';
