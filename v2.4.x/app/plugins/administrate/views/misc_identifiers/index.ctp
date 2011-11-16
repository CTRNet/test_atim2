<?php 
$final_atim_structure = $atim_structure;
$final_options = array(
	'type' => 'index',
	'settings' => array(
		'pagination' => false
	), 'links' => array(
		'index' => array(
			'detail' => '/administrate/misc_identifiers/manage/%%MiscIdentifierControl.id%%'
		)
	)
);

$hook_link = $structures->hook();
if( $hook_link ) {
	require($hook_link);
}
$structures->build( $final_atim_structure, $final_options );
?>