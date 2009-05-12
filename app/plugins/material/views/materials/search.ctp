<?php
	$structure_links = array(
		'index'=>array('detail'=>'/material/detail/%%Material.id%%/),
		'bottom'=>array(
			'add'=>'/material/add/%%Material.id%%',
			'list'=>'/material/listall/%%Material.id%%'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );
?>