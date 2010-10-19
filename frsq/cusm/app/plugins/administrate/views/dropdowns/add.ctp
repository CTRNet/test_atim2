<?php 

	$structure_links = array("top" => "/administrate/dropdowns/add/".$control_data['StructurePermissibleValuesCustomControl']['id']."/");
	$structure_override = array();
	$structure_settings = array('pagination' => false, 'add_fields' => true, 'del_fields' => true, 'header' => __('list', true) . ' : ' . $control_data['StructurePermissibleValuesCustomControl']['name']);
	$final_options = array('links' => $structure_links, 'override' => $structure_override, 'type' => 'datagrid', 'settings'=> $structure_settings);
	
	$structures->build($administrate_dropdown_values, $final_options)
	
?>