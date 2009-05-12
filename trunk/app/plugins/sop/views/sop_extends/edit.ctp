<?
	$structure_links = array(
		'top'=>'/sop_extends/edit/%%SopExtends.id%%/',
		'bottom'=>array(
			'delete'=>'/sop_extends/delete/%%SopExtends.id%%/,
			'cancel'=>'/sop_extends/detail/%%SopExtends.id%%/
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>