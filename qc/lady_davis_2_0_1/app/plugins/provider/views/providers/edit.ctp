<?php 
	$structure_links = array(
		'top'=>'/provider/providers/edit/'.$atim_menu_variables['Provider.id'].'/',
		'bottom'=>array(
			'cancel'=>'/provider/providers/detail/%%Provider.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>