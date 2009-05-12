<?
	$structure_links = array(
		'top'=>'/sop_master/edit/%%SopMaster.id%%/',
		'bottom'=>array(
			'delete'=>'/sop_master/delete/%%SopMaster.id%%/,
			'cancel'=>'/sop_master/detail/%%SopMaster.id%%/
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>