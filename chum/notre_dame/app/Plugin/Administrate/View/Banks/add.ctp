<?php 
	$structure_links = array(
		'top'=>'/Administrate/Banks/add/',
		'bottom'=>array(
			'cancel'=>'/Administrate/Banks/index/'
		)
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>
