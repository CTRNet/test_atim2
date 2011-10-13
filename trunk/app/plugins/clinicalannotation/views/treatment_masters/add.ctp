<?php 

	$structure_links = array(
		'top'=>'/clinicalannotation/treatment_masters/add/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentControl.id'],
		'radiolist'=>array(
			'TreatmentMaster.diagnosis_master_id'=>'%%DiagnosisMaster.id'.'%%'
		),
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/treatment_masters/listall/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
	
	// 1- TRT
	
	$structure_override = array();
	
	$structure_settings = array(
		'actions'=>false, 
		
		'header' => '1- ' . __('data', null) . ' : ' . $tx_header,
		'form_bottom'=>false);
	
//	if(isset($available_protocols)) { $structure_override['TreatmentMaster.protocol_master_id'] = $available_protocols; }
			 	
	$final_options = array('links'=>$structure_links,'settings'=>$structure_settings, 'override'=>$structure_override);
	$final_atim_structure = $atim_structure; 
	
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
	
	$structures->build( $final_atim_structure, $final_options );	
	
	// 2- SEPARATOR & HEADER
	
	$structure_settings = array(
		'actions'=>false, 

		'header' => '2- ' . __('related diagnosis', null),
		'form_top' => false,
		'form_bottom'=>false
	);	

	$structures->build($empty_structure, array('settings'=>$structure_settings));	
	
	// 3- DIAGNOSTICS

	// Define radio should be checked
	$radio_checked = false;
	if($initial_display || empty($this->data['TreatmentMaster']['diagnosis_master_id'])) { 
		$radio_checked = true; 
	}
	
?>
	
	<!-- N/A value -->
	<table class="structure" cellspacing="0">
		<tbody>
			<tr><td style='text-align: left; padding-left: 10px;'><input type='radio' name='data[TreatmentMaster][diagnosis_master_id]' <?php if($radio_checked) { echo("checked='checked'"); }?> value=''/><?php echo(__('n/a', null));?></td>
			</tr>
		</tbody>
	</table>
			
<?php

	$hook_link = $structures->hook('dx_list');	
	$primary_sets_counter = sizeof($data_for_checklist);
	foreach($data_for_checklist as $new_primary_set) {
		$primary_sets_counter--;
		
		$structure_settings = array(
			'pagination'	=> false,
			'form_inputs'	=> false,
			'form_top'		=> false,
			'form_bottom'	=> $primary_sets_counter? false : true,
			'actions'		=> $primary_sets_counter? false : true,
			'language_heading' => __('new '.$new_primary_set['category'], true) . ' - ' . __($new_primary_set['controls_type'], true)
		);
		
		$final_options = array( 'type'=>'index', 'settings'=>$structure_settings, 'data'=>$new_primary_set['dx_list'], 'links'=>$structure_links );
		$final_atim_structure = $diagnosis_structure;
		
		if( $hook_link ) { require($hook_link); }
		
		$structures->build( $final_atim_structure, $final_options );
	}
	
?>