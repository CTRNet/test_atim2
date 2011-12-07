<?php 
	$structure_links = array(
		'top'=>'/administrate/structure_formats/edit/'.$atim_menu_variables['Structure.id'].'/'.$atim_menu_variables['StructureFormat.id'],
		'bottom'=>array('cancel'=>'/administrate/structure_formats/detail/'.$atim_menu_variables['Structure.id'].'/'.$atim_menu_variables['StructureFormat.id'])
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>