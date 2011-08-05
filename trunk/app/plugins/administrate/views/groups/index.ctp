<?php

	$structure_links = array(
		'index'=>array('detail'=>'/administrate/groups/detail/%%Group.id%%'),
		'bottom'=>array(
			'add' => '/administrate/groups/add/',
			'search for users' => '/administrate/users/search/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
	?>