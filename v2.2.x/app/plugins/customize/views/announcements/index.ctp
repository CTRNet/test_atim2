<?php 
	$structure_links = array(
		'index'=>array('detail'=>'/customize/announcements/detail/%%Announcement.id%%')
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>