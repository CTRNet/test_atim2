<?php 
	$structure_links = array(
		'top'=>'/Administrate/structure_formats/edit/'.$atim_menu_variables['Structure.id'].'/'.$atim_menu_variables['StructureFormat.id'],
		'bottom'=>array('cancel'=>'/Administrate/structure_formats/detail/'.$atim_menu_variables['Structure.id'].'/'.$atim_menu_variables['StructureFormat.id'])
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>