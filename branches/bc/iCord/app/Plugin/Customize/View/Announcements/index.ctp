<?php 
	$structure_links = array(
		'index'=>array('detail'=>'/Customize/Announcements/detail/%%Announcement.id%%')
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>