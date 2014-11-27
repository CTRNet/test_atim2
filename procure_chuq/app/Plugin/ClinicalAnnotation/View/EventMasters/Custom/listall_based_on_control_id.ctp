<?php
	
	$structure_links = array(
		'index'=>array(
			'detail'=>'/ClinicalAnnotation/EventMasters/detail/'.$atim_menu_variables['Participant.id'].'/%%EventMaster.id%%/',
			'edit'=>'/ClinicalAnnotation/EventMasters/edit/'.$atim_menu_variables['Participant.id'].'/%%EventMaster.id%%/'));
	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'type'=>'index',
		'settings'	=> array('pagination' => true, 'actions' => false),
		'links'=>$structure_links);
	$this->Structures->build( $final_atim_structure, $final_options );
	
?>
