<?php 
	$structure_links = array(
		'top'=>'/datamart/adhoc_saved/edit/'.$atim_menu_variables['Adhoc.id'].'/'.$atim_menu_variables['AdhocSaved.id'],
		'bottom'=>array(
			'cancel'=>'/datamart/adhoc_saved/search/'.$atim_menu_variables['Adhoc.id'].'/'.$atim_menu_variables['AdhocSaved.id']
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>