<?php 
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/Administrate/Preferences/edit/'.$atim_menu_variables['Group.id'].'/'.$atim_menu_variables['User.id']
		)
	);
	
	$this->Structures->build( $atim_structure, array('type'=>'detail','links'=>$structure_links) );
?>