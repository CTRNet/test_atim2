<?php 

	$structure_links = array(
		'index'=>array('profile'=>'/rtbform/rtbforms/profile/%%Rtbform.id%%'),
		'bottom'=>array(
			'add'=>'/rtbform/rtbforms/add/',
			'search'=>'/rtbform/rtbforms/index/'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );

?>