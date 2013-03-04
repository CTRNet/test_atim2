<?php 
	$structure_links = array(
		'bottom'=>array('edit'=>'/Administrate/structures/edit/%%Structure.id%%', 'list'=>'/Administrate/structures/index')
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>