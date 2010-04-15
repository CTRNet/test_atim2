<?php 
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/sop/sop_masters/listall/',
			'edit'=>'/sop/sop_masters/edit/%%SopMaster.id%%/',
			'delete'=>'/sop/sop_masters/delete/%%SopMaster.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>