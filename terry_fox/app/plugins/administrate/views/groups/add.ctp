<?php 
$structure_links = array(
		'top' => '/administrate/groups/add/',
		'bottom'=>array(
			'cancel'=>'/administrate/groups/index/', 
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
	
?>
