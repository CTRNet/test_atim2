<?php
	$structure_links = array(
		'index'=>array('detail'=>'/sop_master/detail/%%SopMaster.id%%/),
		'bottom'=>array(
			'add'=>'/sop_master/add/%%SopMaster.id%%',
			'list'=>'/sop_master/listall/%%SopMaster.id%%'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );
?>