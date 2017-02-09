<?php 
	$structure_links = array(
		'bottom'=>array('edit'=>'/Administrate/StructureFormats/edit/'.$atim_menu_variables['Structure.id'].'/%%StructureFormat.id%%')
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>