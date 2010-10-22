<?php 

	$structure_links = array(
		'index'=>array('detail'=>'/material/materials/detail/%%Material.id%%'),
		'bottom'=>array(
			'add'=>'/material/materials/add',
			'search'=>'/material/materials/index'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );

?>