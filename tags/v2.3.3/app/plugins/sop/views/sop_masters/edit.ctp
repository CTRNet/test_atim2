<?php 
	$structure_links = array(
		'top'=>'/sop/sop_masters/edit/'.$atim_menu_variables['SopMaster.id'].'/',
		'bottom'=>array(
			'cancel'=>'/sop/sop_masters/detail/%%SopMaster.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>