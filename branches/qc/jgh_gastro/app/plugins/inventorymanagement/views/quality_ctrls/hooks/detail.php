<?php
$structures->build( $final_atim_structure, $final_options );

$final_atim_structure = $qc_gastro_qc_scores;
$final_options['settings']['form_top'] = false;
$final_options['settings']['pagination'] = false;
$final_options['data'] = $score_data;
$final_options['type'] = 'index';