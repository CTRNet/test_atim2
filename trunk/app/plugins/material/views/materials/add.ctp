<?
	$structure_links = array(
		'top'=>'/material/add/%%Material.id%%',
		'bottom'=>array(
			'cancel'=>'/material/listall/%%Material.id%%'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>