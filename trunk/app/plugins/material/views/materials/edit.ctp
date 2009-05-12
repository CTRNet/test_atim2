<?
	$structure_links = array(
		'top'=>'/material/edit/%%Material.id%%/',
		'bottom'=>array(
			'delete'=>'/material/delete/%%Material.id%%/,
			'cancel'=>'/material/detail/%%Material.id%%/
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>