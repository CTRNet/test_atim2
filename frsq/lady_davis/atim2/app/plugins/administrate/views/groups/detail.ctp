<?php 
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/administrate/groups/edit/'.$atim_menu_variables['Bank.id'].'/%%Group.id%%', 
			'delete'=>'/administrate/groups/delete/'.$atim_menu_variables['Bank.id'].'/%%Group.id%%', 
			'list'=>'/administrate/groups/index/'.$atim_menu_variables['Bank.id']
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>
