<?php 
$structure_links = array(
		'top' => '/administrate/groups/add/'.$atim_menu_variables['Bank.id'].'/',
		'bottom'=>array(
			'cancel'=>'/administrate/groups/index/'.$atim_menu_variables['Bank.id'].'/', 
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
	
?>
