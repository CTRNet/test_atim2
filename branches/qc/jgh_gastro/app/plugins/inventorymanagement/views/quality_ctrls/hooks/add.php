<?php
$final_options['settings']['form_bottom'] = false;
$final_options['settings']['actions'] = false;

$structures->build( $final_atim_structure, $final_options );

$final_atim_structure = $qc_gastro_qc_scores;
$final_options['settings']['header'] = __("scores", true);
$final_options['settings']['form_bottom'] = true;
$final_options['settings']['actions'] = true;
$final_options['settings']['form_top'] = false;
$final_options['settings']['add_fields'] = true;
$final_options['settings']['del_fields'] = true;
$final_options['type'] = 'addgrid';