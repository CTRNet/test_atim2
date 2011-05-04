<?php 

	$structure_links = array(
		'top'=>'/clinicalannotation/event_masters/edit/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['EventMaster.id'],
		'radiolist'=>array(
			'EventMaster.diagnosis_master_id'=>'%%DiagnosisMaster.id'.'%%'
		),
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/event_masters/detail/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['EventMaster.id']
		)
	);
	
	// 1- EVENT DATA
	
	$structure_settings = array(
		'actions'=>false, 
		
		'header' => '1- ' . __('data', null),
		'form_bottom'=>false);
		
	$final_atim_structure = $atim_structure;
	$final_options = array( 'settings'=>$structure_settings, 'links'=>$structure_links );
	
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
	
	$structures->build( $final_atim_structure, $final_options);		

	// 2- SEPARATOR & HEADER
	
	$structure_settings = array(
		'actions'=>false, 

		'header' => '2- ' . __('related diagnosis', null),
		'form_top' => false,
		'form_bottom'=>false
	);

	$structures->build($empty_structure, array('settings'=>$structure_settings));
	
	// 3- DIAGNOSTICS
	
	$structure_settings = array(
		'form_inputs'=>false,
		'pagination'=>false,
		
		'form_top' => false
	);
	
	$final_atim_structure = $diagnosis_structure;
	$final_options = array( 'type'=>'index', 'settings'=>$structure_settings, 'data'=>$data_for_checklist, 'links'=>$structure_links );

	$hook_link = $structures->hook('dx_list');
	if( $hook_link ) { require($hook_link); }
	
	// Define radio should be checked
	$radio_checked = false;
	if(empty($this->data['EventMaster']['diagnosis_master_id'])) { 
		$radio_checked = true; 
	}
	
?>

	<!-- N/A value -->
	<table class="structure" cellspacing="0">
		<tbody>
			<tr><td style='text-align: left; padding-left: 10px;'><input type='radio' name='data[EventMaster][diagnosis_master_id]' <?php if($radio_checked) { echo("checked='checked'"); }?> value=''/><?php echo(__('n/a', null));?></td></tr>
		</tbody>
	</table>

<?php

	$structures->build( $final_atim_structure,  $final_options);
	
?>