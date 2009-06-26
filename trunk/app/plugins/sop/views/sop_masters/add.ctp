<?php 
	$structure_links = array(
		'top'=>'/sop/sop_masters/add/'.$atim_menu_variables['SopControl.id'].'/',
		'bottom'=>array(
			'cancel'=>'/sop/sop_masters/listall/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>