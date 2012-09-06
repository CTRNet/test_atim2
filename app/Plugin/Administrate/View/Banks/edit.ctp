<?php 
	$structure_links = array(
		'top'=>'/Administrate/Banks/edit/'.$atim_menu_variables['Bank.id'],
		'bottom'=>array(
			'cancel'=>'/Administrate/Banks/detail/'.$atim_menu_variables['Bank.id']
		)
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>