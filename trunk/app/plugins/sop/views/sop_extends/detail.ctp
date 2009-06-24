<?php
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/sop/sop_extends/edit/'.$atim_menu_variables['SopMaster.id'].'/%%SopExtend.id%%/', 
			'list'=>'/sop/sop_extends/listall/'.$atim_menu_variables['SopMaster.id'].'/%%SopExtend.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>