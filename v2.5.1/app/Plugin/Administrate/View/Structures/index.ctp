<?php 
	$structure_links = array(
		'index'=>array('detail'=>'/Administrate/structures/detail/%%Structure.id%%')	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>