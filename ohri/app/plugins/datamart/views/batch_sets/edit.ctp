<?php 
	$structure_links = array(
		'top'=>'/datamart/batch_sets/edit/'.$atim_menu_variables['Param.Type_Of_List'].'/'.$atim_menu_variables['BatchSet.id'],
		'bottom'=>array(
			'cancel'=>'/datamart/batch_sets/listall/'.$atim_menu_variables['Param.Type_Of_List'].'/'.$atim_menu_variables['BatchSet.id']
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>