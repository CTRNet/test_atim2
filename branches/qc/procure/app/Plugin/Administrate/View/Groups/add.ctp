<?php 
$structure_links = array(
		'top' => '/Administrate/Groups/add/',
		'bottom'=>array(
			'cancel'=>'/Administrate/Groups/index/', 
		)
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
	
?>
