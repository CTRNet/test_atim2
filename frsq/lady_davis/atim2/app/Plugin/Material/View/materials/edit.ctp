<?php 
	$structure_links = array(
		'top'=>'/material/materials/edit/'.$atim_menu_variables['Material.id'],
		'bottom'=>array(
			'cancel'=>'/material/materials/detail/'.$atim_menu_variables['Material.id']
		)
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>