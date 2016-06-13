<?php 
$structure_links = array(
		'top' => '/Administrate/Groups/edit/' . $atim_menu_variables['Group.id'],
		'bottom'=>array(
			'cancel'=>'/Administrate/Groups/detail/' . $atim_menu_variables['Group.id'],
		)
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
	
?>
