<?php 
	$structure_links = array("top" => "/administrate/dropdowns/add/".$control_id."/");
	$structure_override = array();
	$final_options = array('links' => $structure_links, 'override' => $structure_override, 'type' => 'datagrid', 'settings'=> array('pagination' => false, 'add_fields' => true, 'del_fields' => true));
	$structures->build($administrate_dropdown_values, $final_options)
?>