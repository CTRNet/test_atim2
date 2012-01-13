<?php 
	$structure_links = array(
		'index'=>array('detail'=>'/Customize/announcements/detail/%%Announcement.id%%')
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>