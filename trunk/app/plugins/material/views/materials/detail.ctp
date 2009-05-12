<?
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/material/edit/%%Material.id%%, 
			'list'=>'/material/listall/%%Material.id%%'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>