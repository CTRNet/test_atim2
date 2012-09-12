<?php 
	$structure_links = array(
		'top'=>'/Customize/Preferences/edit',
		'bottom'=>array(
			'cancel'=>'/Customize/Preferences/index'
		)
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>