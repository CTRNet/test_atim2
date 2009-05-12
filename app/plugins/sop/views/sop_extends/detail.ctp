<?
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/sop_extends/edit/%%SopExtends.id%%, 
			'list'=>'/sop_extends/listall/%%SopExtends.id%%'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>