<?php 
$final_atim_structure = $atim_structure;
$final_options = array(
	'type' => 'index',
	'settings' => array('pagination' => false), 
	'links' => array(
		'index' => array('manage' => array('link' => '/Administrate/ReusableMiscIdentifiers/manage/%%MiscIdentifierControl.id%%', 'icon' => 'edit'))
	)
);

$hook_link = $this->Structures->hook();
if( $hook_link ) {
	require($hook_link);
}

$this->Structures->build( $final_atim_structure, $final_options );
?>