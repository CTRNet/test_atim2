<?php 
	$structure_links = array(
		'top'=>'/Administrate/banks/add/',
		'bottom'=>array(
			'cancel'=>'/Administrate/banks/index/'
		)
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>
