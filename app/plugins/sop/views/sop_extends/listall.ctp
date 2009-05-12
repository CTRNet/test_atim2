<?php
	$structure_links = array(
		'index'=>array('detail'=>'/sop_extends/detail/%%SopExtend.id%%/),
		'bottom'=>array(
			'add'=>'/sop_extends/add/%%SopExtend.id%%',
			'list'=>'/sop_extends/listall/%%SopExtend.id%%'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );
?>