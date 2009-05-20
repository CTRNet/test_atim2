<?php 

	$structure_links = array(
		'index'=>array('detail'=>'/clinicalannotation/misc_identifiers/detail/'.$atim_menu_variables['Participant.id'].'/%%MiscIdentifier.id%%/'),
		'bottom'=>array(
			'add'=>'/clinicalannotation/misc_identifiers/add/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );

?>
