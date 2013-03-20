<?php
		
	$links = array(
		"bottom" => array(
			"add" => "/Administrate/Dropdowns/add/".$control_data['StructurePermissibleValuesCustomControl']['id']."/",
			"configure" => "/Administrate/Dropdowns/configure/".$control_data['StructurePermissibleValuesCustomControl']['id']."/",
			'list' => '/Administrate/Dropdowns/index'),
		'index'=>array('edit'=>'/Administrate/Dropdowns/edit/'.$control_data['StructurePermissibleValuesCustomControl']['id'].'/%%StructurePermissibleValuesCustom.id%%'));
	$structure_settings = array("pagination" => false, 'header' => __('list') . ' : ' . $control_data['StructurePermissibleValuesCustomControl']['name']);
	$final_options = array("type" => "index", "data" => $this->request->data, "links" => $links, "settings" => $structure_settings);
	
	$this->Structures->build($administrate_dropdown_values, $final_options);

?>