<?php
$final_options['settings']['form_bottom'] = false;
$final_options['settings']['actions'] = false;
$structures->build( $final_atim_structure, $final_options );

$final_atim_structure = $qc_nd_sardo_protocol;
$final_options = array(
	'type'	=> 'index',
	'data'	=> $previous_sardo_proto,
	'settings' => array('pagination' => false),
	'links'	=> $final_options['links']	
);