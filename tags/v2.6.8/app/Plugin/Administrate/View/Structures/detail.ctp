<?php 
	$structure_links = array(
		'bottom'=>array('edit'=>'/Administrate/Structure/edit/%%Structure.id%%')
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>