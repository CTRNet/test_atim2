<?php 
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/Administrate/Groups/edit/%%Group.id%%', 
			'delete'=>'/Administrate/Groups/delete/%%Group.id%%', 
			'list'=>'/Administrate/Groups/index/'
		)
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>
