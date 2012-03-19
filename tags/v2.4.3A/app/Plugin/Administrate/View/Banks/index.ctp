<?php 
	$structure_links = array(
		'index'=>array('detail'=>'/Administrate/banks/detail/%%Bank.id%%'),
		'bottom'=>array(
			'add'=>'/Administrate/banks/add'
		)
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>