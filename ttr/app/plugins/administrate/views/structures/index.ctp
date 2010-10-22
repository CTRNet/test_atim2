<?php 
	$structure_links = array(
		'index'=>array('detail'=>'/administrate/structures/detail/%%Structure.id%%')	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>