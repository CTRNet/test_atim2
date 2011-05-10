<?php 
	$structure_links = array(
		'bottom'=>array('edit'=>'/administrate/structure_formats/edit/'.$atim_menu_variables['Structure.id'].'/%%StructureFormat.id%%', 'list'=>'/administrate/structure_formats/listall/'.$atim_menu_variables['Structure.id'])
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>