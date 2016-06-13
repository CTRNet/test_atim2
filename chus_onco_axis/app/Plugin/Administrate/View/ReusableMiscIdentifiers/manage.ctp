<?php 
$final_atim_structure = $atim_structure;
$final_options = array(
	'type' => 'index',
	'settings' => array(
		'pagination' => false,
		'form_inputs' => false,
		'header' => array(
			'title' => $title,
			'description' => __('select the identifiers you wish to delete permanently')),
		'confirmation_msg' => __('core_are you sure you want to delete this data?')), 
	'links' => array(
		'bottom' => array(
			'list' => '/Administrate/ReusableMiscIdentifiers/index/'), 
		'top' => '/Administrate/ReusableMiscIdentifiers/manage/'.$atim_menu_variables['MiscIdentifierControl.id'],
		'checklist' => array(
			'MiscIdentifier.selected_id][' => '%%MiscIdentifier.id%%'))
);
 
$hook_link = $this->Structures->hook();
if( $hook_link ) {
	require($hook_link);
}
$this->Structures->build( $final_atim_structure, $final_options );

?>
