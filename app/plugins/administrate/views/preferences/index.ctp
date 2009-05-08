<?php 
	$structure_links = array(
		'bottom'=>array('edit'=>'/administrate/preferences/edit/'.$atim_menu_variables['Bank.id'].'/'.$atim_menu_variables['Group.id'].'/'.$atim_menu_variables['User.id'])
	);
	
	$structures->build( $atim_structure, array('type'=>'detail','links'=>$structure_links) );
?>