<?php 
	$structure_links = array(
		'top'=>'/material/materials/add/',
		'bottom'=>array(
			'cancel'=>'/material/materials/index/'
		)
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>