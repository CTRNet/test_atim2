<?php 
	$structure_links = array(
		'bottom'=>array('edit'=>'/administrate/structures/edit/%%Structure.id%%', 'list'=>'/administrate/structures/index')
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>