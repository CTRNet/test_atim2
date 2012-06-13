<?php 
	$structure_links = array(
		'top'=>'/Sop/SopMasters/add/'.$atim_menu_variables['SopControl.id'].'/',
		'bottom'=>array(
			'cancel'=>'/Sop/SopMasters/listall/'
		)
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>