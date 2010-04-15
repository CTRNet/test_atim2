<?php 
	$structure_links = array(
		'index'=>array('detail'=>'/customize/announcements/detail/%%Bank.id%%')
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>