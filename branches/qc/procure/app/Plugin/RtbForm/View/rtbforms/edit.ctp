<?php 
	$structure_links = array(
		'top'=>'/rtbform/rtbforms/edit/%%Rtbform.id%%/',
		'bottom'=>array(
			'cancel'=>'/rtbform/rtbforms/profile/%%Rtbform.id%%/'
		)
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>