<?php 
	$structure_links = array(
		'top'=>'/Sop/SopMasters/edit/'.$atim_menu_variables['SopMaster.id'].'/',
		'bottom'=>array(
			'cancel'=>'/Sop/SopMasters/detail/%%SopMaster.id%%/'
		)
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>