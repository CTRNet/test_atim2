<?php 
$structure_links = array(
		'top' => '/administrate/groups/edit/'.$atim_menu_variables['Bank.id'].'/%%Group.id%%',
		'bottom'=>array(
			'cancel'=>'/administrate/groups/detail/'.$atim_menu_variables['Bank.id'].'/%%Group.id%%', 
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
	
?>
