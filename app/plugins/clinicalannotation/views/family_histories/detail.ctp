<?php 
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/clinicalannotation/family_histories/edit/'.$atim_menu_variables['Participant.id'].'/%%FamilyHistory.id%%',
			'delete'=>'/clinicalannotation/family_histories/delete/'.$atim_menu_variables['Participant.id'].'/%%FamilyHistory.id%%',
			'list'=>'/clinicalannotation/family_histories/listall/'.$atim_menu_variables['Participant.id'].'/'			
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>