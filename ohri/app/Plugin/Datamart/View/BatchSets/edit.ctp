<?php 
	$structure_links = array(
		'top'=>'/Datamart/BatchSets/edit/'.$atim_menu_variables['BatchSet.id'],
		'bottom'=>array(
			'cancel'=>'/Datamart/BatchSets/listall/'.$atim_menu_variables['BatchSet.id']
		)
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>