<?php 
	$structure_links = array(
		'index'=>array('detail'=>'/Administrate/Structure/detail/%%Structure.id%%')	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>