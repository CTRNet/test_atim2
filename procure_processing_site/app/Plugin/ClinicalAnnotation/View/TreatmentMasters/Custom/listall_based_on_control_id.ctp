<?php
	
	$structure_links = array(
		'index'=>array(
			'detail'=>'/ClinicalAnnotation/TreatmentMasters/detail/'.$atim_menu_variables['Participant.id'].'/%%TreatmentMaster.id%%/',
			'edit'=>'/ClinicalAnnotation/TreatmentMasters/edit/'.$atim_menu_variables['Participant.id'].'/%%TreatmentMaster.id%%/'));
	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'type'=>'index',
		'settings'	=> array('pagination' => true, 'actions' => false),
		'links'=>$structure_links);
	$this->Structures->build( $final_atim_structure, $final_options );
	
?>
	
	
	

