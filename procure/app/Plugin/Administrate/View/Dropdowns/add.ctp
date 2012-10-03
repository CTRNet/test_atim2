<?php 

	$structure_links = array(
		"top" => "/Administrate/Dropdowns/add/".$control_data['StructurePermissibleValuesCustomControl']['id']."/",
		"bottom" => array("cancel" => "/Administrate/Dropdowns/view/".$control_data['StructurePermissibleValuesCustomControl']['id']."/"));
	$structure_override = array('StructurePermissibleValuesCustom.use_as_input' => 1);
	$structure_settings = array('pagination' => false, 'add_fields' => true, 'del_fields' => true, 'header' => __('list') . ' : ' . $control_data['StructurePermissibleValuesCustomControl']['name']);
	$final_options = array('links' => $structure_links, 'override' => $structure_override, 'type' => 'addgrid', 'settings'=> $structure_settings);
	
	$this->Structures->build($administrate_dropdown_values, $final_options)
	
?>