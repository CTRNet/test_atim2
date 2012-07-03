<?php 
	$structure_links = array(
		'bottom'=>array('edit'=>'/Administrate/structure_formats/edit/'.$atim_menu_variables['Structure.id'].'/%%StructureFormat.id%%', 'list'=>'/Administrate/structure_formats/listall/'.$atim_menu_variables['Structure.id'])
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>