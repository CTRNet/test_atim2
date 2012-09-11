<?php 
	$structure_links = array(
		'index'=>array('detail'=>'/Administrate/Banks/detail/%%Bank.id%%'),
		'bottom'=>array(
			'add'=>'/Administrate/Banks/add'
		)
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>