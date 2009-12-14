<?php 
	
		$structure_settings = array(
			'form_bottom'=>false, 
			'form_inputs'=>false,
			'actions'=>false,
			'pagination'=>false,
			'header' => __('diagnosis', null)
		);
	
		$structure_links = array(
				'top'=>'/clinicalannotation/event_masters/add/'.$atim_menu_variables['EventControl.event_group'].'/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['EventControl.id'].'/',
			'radiolist'=>array(
					'EventMaster.diagnosis_master_id'=>'%%DiagnosisMaster.id'.'%%'
				)
			);
		$structures->build($empty_structure, array('settings'=>$structure_settings, 'links' => $structure_links));
		unset($structure_settings['header']);
		$structure_settings['form_top'] = false;
	?>
			<table class="structure" cellspacing="0">
		<tbody>
			<tr><td style='text-align: left; padding-left: 10px;'><input type='radio' name='data[EventMaster][diagnosis_master_id]' checked='checked' value=''/><?php echo(__('N/A', null));?></td></tr>
			</tbody></table>
	<?php
	$final_atim_structure = $diagnosis_structure;
	$final_options = array( 'type'=>'radiolist', 'settings'=>$structure_settings, 'data'=>$data_for_checklist, 'links'=>$structure_links );
	$hook_link = $structures->hook('dx_list');
	if( $hook_link ) { require($hook_link); } 
	$structures->build( $final_atim_structure , $final_options);
	
	$structure_settings = array(
		'form_top' => false);

	$structure_links = array(
		'top'=>'/clinicalannotation/event_masters/add/'.$atim_menu_variables['EventControl.event_group'].'/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['EventControl.id'].'/',
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/event_masters/listall/'.$atim_menu_variables['EventControl.event_group'].'/'.$atim_menu_variables['Participant.id']
		)
	);
	
	$final_atim_structure = $atim_structure;
	$final_options = array( 'settings'=>$structure_settings, 'links'=>$structure_links);
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
	$structures->build( $final_atim_structure,  $final_options);
?>