<?php 
	$structure_links = array(
		'top'=>'/Customize/profiles/edit',
		'bottom'=>array(
			'cancel'=>'/Customize/profiles/index'
		)
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>