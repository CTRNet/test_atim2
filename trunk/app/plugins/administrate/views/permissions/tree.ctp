<?php 
	$structure_links = array(
		'top'=>'/administrate/permissions/tree/%%Bank.id%%/%%Group.id%%'
	);
	
	$structures->build( $atim_structure, array('type'=>'tree', 'links'=>$structure_links) );
	
	pr($this->data);
?>