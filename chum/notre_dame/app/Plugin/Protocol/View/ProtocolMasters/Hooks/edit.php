<?php
$final_options['settings']['form_bottom'] = false;
$final_options['settings']['actions'] = false;
$structures->build( $final_atim_structure, $final_options );

$final_atim_structure = $qc_nd_sardo_protocol;
$final_options = array(
	'type'	=> 'editgrid',
	'data'	=> $previous_sardo_proto ?: array(array()),
	'settings' => array('form_top' => false, "add_fields" => true, "del_fields" => true),
	'links'	=> $final_options['links']	
);