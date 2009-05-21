<?php 

	$structure_links = array(
		'index'=>array('detail'=>'/clinicalannotation/reproductive_histories/detail/'.$atim_menu_variables['Participant.id'].'/%%ReproductiveHistory.id%%/'),
		'bottom'=>array(
			'add'=>'/clinicalannotation/reproductive_histories/add/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );

?>