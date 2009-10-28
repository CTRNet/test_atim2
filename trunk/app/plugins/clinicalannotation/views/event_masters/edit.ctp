<?php 
	
		$structure_settings = array(
			'form_bottom'=>false, 
			'form_inputs'=>false,
			'actions'=>false,
			'pagination'=>false
		);
	
		$structure_links = array(
				'top'=>'/clinicalannotation/event_masters/edit/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['EventMaster.id'],
				'radiolist'=>array(
					'EventMaster.diagnosis_master_id'=>'%%DiagnosisMaster.id'.'%%'
				)
			);
			
	$structures->build( $atim_structure_for_checklist, array( 'type'=>'radiolist', 'settings'=>$structure_settings, 'data'=>$data_for_checklist, 'links'=>$structure_links ) );
	
		$structure_settings = array(
			'form_top'=>false
		);
	
		$structure_links = array(
			'top'=>'#',
			'bottom'=>array(
				'cancel'=>'/clinicalannotation/event_masters/detail/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['EventMaster.id']
			)
		);
		
	$structures->build( $atim_structure, array( 'settings'=>$structure_settings, 'links'=>$structure_links ) );
	
?>