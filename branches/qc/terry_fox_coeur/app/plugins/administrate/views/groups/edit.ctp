<?php 
$structure_links = array(
		'top' => '/administrate/groups/edit/%%Group.id%%',
		'bottom'=>array(
			'cancel'=>'/administrate/groups/detail/%%Group.id%%', 
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
	
?>
