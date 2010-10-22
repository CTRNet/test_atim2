<?php 
	$structure_links = array(
		'bottom'=>array(
			'search'=>'/rtbform/rtbforms/index/',
			'edit'=>'/rtbform/rtbforms/edit/%%Rtbform.id%%/',
			'delete'=>'/rtbform/rtbforms/delete/%%Rtbform.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>