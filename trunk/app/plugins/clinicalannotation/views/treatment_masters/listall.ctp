<?php 

	$structure_links = array(
		'index'=>array('detail'=>'/clinicalannotation/treatment_masters/detail/'.$atim_menu_variables['Participant.id'].'/%%TxMaster.id%%/'),
		'bottom'=>array(
			'add'=>'/clinicalannotation/treatment_masters/add/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );

?>
