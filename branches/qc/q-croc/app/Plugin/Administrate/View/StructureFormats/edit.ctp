<?php 
	$structure_links = array(
		'top'=>'/Administrate/StructureFormats/edit/'.$atim_menu_variables['Structure.id'].'/'.$atim_menu_variables['StructureFormat.id'],
		'bottom'=>array('cancel'=>'/Administrate/StructureFormats/detail/'.$atim_menu_variables['Structure.id'].'/'.$atim_menu_variables['StructureFormat.id'])
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>