<?php 
	$structure_links = array(
		'top'=>'/rtbform/rtbforms/add/',
		'bottom'=>array(
			'cancel'=>'/rtbform/rtbforms/index/'
		)
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>