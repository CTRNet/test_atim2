<?php 
$final_atim_structure = $atim_structure;
$final_options = array(
	'type' => 'index',
	'settings' => array(
		'pagination' => false
	), 'links' => array(
		'index' => array(
			'detail' => '/Administrate/MiscIdentifiers/manage/%%MiscIdentifierControl.id%%'
		)
	)
);

$hook_link = $this->Structures->hook();
if( $hook_link ) {
	require($hook_link);
}
$this->Structures->build( $final_atim_structure, $final_options );
?>