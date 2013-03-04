<?php 
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/Sop/SopMasters/listall/',
			'edit'=>'/Sop/SopMasters/edit/%%SopMaster.id%%/',
			'delete'=>'/Sop/SopMasters/delete/%%SopMaster.id%%/'
		)
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>