<?php 
	// 1- DIAGNOSTICS
	
	// Setup diagnosis radio-button pick list for linking treatment to a diagnosis
	$structure_settings = array(
		'form_bottom'=>false, 
		'form_inputs'=>false,
		'actions'=>false,
		'pagination'=>false,
		'header' => __('diagnosis', null)
	);
	
	$structure_links = array(
		'top'=>'/clinicalannotation/treatment_masters/edit/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'],
		'radiolist'=>array(
			'TreatmentMaster.diagnosis_master_id'=>'%%DiagnosisMaster.id'.'%%'
		)
	);
			
	$final_options = array( 'type'=>'radiolist', 'settings'=>$structure_settings, 'data'=>$data_for_checklist, 'links'=>$structure_links );
	$final_atim_structure = $diagnosis_structure; 
	$hook_link = $structures->hook('dx_list');
	if( $hook_link ) { require($hook_link); }
	$structures->build($final_atim_structure, $final_options);
	
	$checkNA = true;
	foreach($data_for_checklist as $c_data){
	if($c_data['DiagnosisMaster']['id'] == $this->data['TreatmentMaster']['diagnosis_master_id']){
			$checkNA = false;
			break;
		}
	}
	?>
	<table class="structure" cellspacing="0">
		<tbody>
			<tr><td style='text-align: left; padding-left: 10px;'><input type='radio' name='data[TreatmentMaster][diagnosis_master_id]' <?php echo($checkNA ? "checked='checked'" : ""); ?> value=''/><?php echo(__('n/a', null));?></td>
			</tr></tbody></table>
	<?php
	
	// 2- TRT DATA

	$structure_settings = array(
		'form_top'=>false,
		'header' => __('treatment', null), 
		'separator' => true
	);
		
	// Setup treatment add form and links for display
	$structure_links = array(
		'top'=>'/clinicalannotation/treatment_masters/edit/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'],
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/treatment_masters/detail/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id']
		)
	);
	
	$structure_override = array('TreatmentMaster.protocol_id'=>$protocol_list);
	
	$final_options = array('links'=>$structure_links,'settings'=>$structure_settings,'override'=>$structure_override);
	$final_atim_structure = $atim_structure; 
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
	$structures->build( $final_atim_structure, $final_options );
?>