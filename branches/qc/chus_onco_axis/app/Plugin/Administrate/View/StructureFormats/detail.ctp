<?php 
	$structure_links = array(
		'bottom'=>array('edit'=>'/Administrate/StructureFormats/edit/'.$atim_menu_variables['Structure.id'].'/%%StructureFormat.id%%', 'list'=>'/Administrate/StructureFormats/listall/'.$atim_menu_variables['Structure.id'])
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>