<?php 
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/administrate/groups/edit/%%Group.id%%', 
			'delete'=>'/administrate/groups/delete/%%Group.id%%', 
			'list'=>'/administrate/groups/index/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>
