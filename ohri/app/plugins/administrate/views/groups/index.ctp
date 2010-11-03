<?php

	$structure_links = array(
		'index'=>array('detail'=>'/administrate/groups/detail/%%Group.id%%'),
		'bottom'=>array('add'=>'/administrate/groups/add/')
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
	?>