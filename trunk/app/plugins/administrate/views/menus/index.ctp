<?php 
	$structure_links = array(
		'index'=>array('detail'=>'/administrate/menus/detail/%%Menu.id%%')
	);
	
	$structures->build( $atim_structure, array('type'=>'tree', 'links'=>$structure_links) );
?>