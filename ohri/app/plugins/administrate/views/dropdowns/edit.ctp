<?php 

	$structure_links = array(
		"top" => "/administrate/dropdowns/edit/".$atim_menu_variables['StructurePermissibleValuesCustom.control_id']."/".$atim_menu_variables['StructurePermissibleValuesCustom.id']."/",
		'bottom' => array('cancel' => '/administrate/dropdowns/view/'.$atim_menu_variables['StructurePermissibleValuesCustom.control_id']));
	$structure_override = array();
	$structure_settings = array('header' => __('list', true) . ' : ' . $control_data['StructurePermissibleValuesCustomControl']['name']);
	$final_options = array('links' => $structure_links, 'override' => $structure_override, 'type' => 'edit', 'settings'=> $structure_settings);
	
	$structures->build($administrate_dropdown_values, $final_options)
	
?>