<?php

	$structure_links = array(
		'index' => array('detail'=>'/Administrate/Groups/detail/%%Group.id%%'),
		'bottom' => array(
			'add' => '/Administrate/Groups/add/'
		)
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
	?>