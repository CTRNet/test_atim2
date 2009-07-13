<?php
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/sop/sop_extends/listall/'.$atim_menu_variables['SopMaster.id'].'/',
			'edit'=>'/sop/sop_extends/edit/'.$atim_menu_variables['SopMaster.id'].'/%%SopExtend.id%%/', 
			'delete'=>'/sop/sop_extends/delete/'.$atim_menu_variables['SopMaster.id'].'/%%SopExtend.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>