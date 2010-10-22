<?php 
	$structure_links = array(
		'index'=>array('detail'=>'/administrate/structure_formats/detail/'.$atim_menu_variables['Structure.id'].'/%%StructureFormat.id%%'),
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>