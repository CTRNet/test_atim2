<?php 

	$structure_links = array(
		'index'=>array('detail'=>'/clinicalannotation/participant_messages/detail/'.$atim_menu_variables['Participant.id'].'/%%ParticipantMessage.id%%/'),
		'bottom'=>array(
			'add'=>'/clinicalannotation/participant_messages/add/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );

?>
