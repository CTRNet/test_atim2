<?php
	$structure_links = array(
		'index'=>array(
			'detail'=>'/provider/providers/detail/%%Provider.id%%/'
		),
		'bottom'=>array(
			'add' =>'/provider/providers/add/',
			'search'=>'/provider/providers/index/'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );
?>