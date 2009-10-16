<?php 

	$structure_links = array(
		'index'=>array('detail'=>'/clinicalannotation/family_histories/detail/'.$atim_menu_variables['Participant.id'].'/%%FamilyHistory.id%%/'),
		'bottom'=>array(
			'grid'	=> '/clinicalannotation/family_histories/grid/'.$atim_menu_variables['Participant.id'],
			'add'		=> '/clinicalannotation/family_histories/add/'.$atim_menu_variables['Participant.id']
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );

?>
