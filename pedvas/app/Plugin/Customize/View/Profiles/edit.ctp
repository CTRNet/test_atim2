<?php 
	$structure_links = array(
		'top'=>'/Customize/Profiles/edit',
		'bottom'=>array(
			'cancel'=>'/Customize/Profiles/index'
		)
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>