<?php
	$structure_links = array(
		'top'=>'/sop/sop_extends/add/'.$atim_menu_variables['SopMaster.id'].'/',
		'bottom'=>array(
			'cancel'=>'/sop/sop_extends/listall/'.$atim_menu_variables['SopMaster.id'].'/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>