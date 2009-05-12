<?
	$structure_links = array(
		'top'=>'/sop_extends/add/%%SopExtends.id%%',
		'bottom'=>array(
			'cancel'=>'/sop_extends/listall/%%SopExtends.id%%'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>