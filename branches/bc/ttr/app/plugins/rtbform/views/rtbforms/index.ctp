<?php
	$structure_links = array(
		'top'=>array('search'=>'/rtbform/rtbforms/search/'),
		'bottom'=>array(
			'add'=>'/rtbform/rtbforms/add/'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'search','links'=>$structure_links) );
?>