<?php
	$structure_links = array(
		'top'=>'/sop/sop_extends/edit/'.$atim_menu_variables['SopMaster.id'].'/%%SopExtend.id%%/',
		'bottom'=>array(
			'delete'=>'/sop/sop_extends/delete/'.$atim_menu_variables['SopMaster.id'].'/%%SopExtend.id%%/',
			'cancel'=>'/sop/sop_extends/detail/'.$atim_menu_variables['SopMaster.id'].'/%%SopExtend.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>