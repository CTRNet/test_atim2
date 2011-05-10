<?php
		
	$links = array(
		"bottom" => array(
			"add" => "/administrate/dropdowns/add/".$control_data['StructurePermissibleValuesCustomControl']['id']."/",
			'list' => '/administrate/dropdowns/index'),
		'index'=>array('edit'=>'/administrate/dropdowns/edit/'.$control_data['StructurePermissibleValuesCustomControl']['id'].'/%%StructurePermissibleValuesCustom.id%%'));
	$structure_settings = array("pagination" => false, 'header' => __('list', true) . ' : ' . $control_data['StructurePermissibleValuesCustomControl']['name']);
	$final_options = array("type" => "index", "data" => $this->data, "links" => $links, "settings" => $structure_settings);
	
	$structures->build($administrate_dropdown_values, $final_options);

?>