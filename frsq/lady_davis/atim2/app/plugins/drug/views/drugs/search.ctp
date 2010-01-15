<?php
	$structure_links = array(
		'index'=>array('detail'=>'/drug/drugs/detail/%%Drug.id%%'),
		'bottom'=>array(
			'add'=>'/drug/drugs/add',
			'search'=>'/drug/drugs/index'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );

?>