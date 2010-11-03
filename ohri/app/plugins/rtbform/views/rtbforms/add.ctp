<?php 
	$structure_links = array(
		'top'=>'/rtbform/rtbforms/add/',
		'bottom'=>array(
			'cancel'=>'/rtbform/rtbforms/index/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>