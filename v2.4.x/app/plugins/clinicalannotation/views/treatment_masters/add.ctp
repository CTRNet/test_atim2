<?php 

	$structure_links = array(
		'top'=>'/clinicalannotation/treatment_masters/add/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentControl.id'],
	);
	
	// 1- TRT
	$structure_settings = array(
		'actions'		=> false, 
		'header' 		=> '1- ' . __('data', null) . ' : ' . $tx_header,
		'form_bottom'	=> false
	);
	
			 	
	$final_options = array(
		'links'		=> $structure_links,
		'settings'	=> $structure_settings 
	);
	$final_atim_structure = $atim_structure; 
	
	$hook_link = $structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
	
	$structures->build( $final_atim_structure, $final_options );	
	
	// 2- SEPARATOR & HEADER
	
	$structure_settings = array(
		'header' 		=> '2- ' . __('related diagnosis', null),
		'form_top' 		=> false,
		'tree'			=> array('DiagnosisMaster' => 'DiagnosisMaster'),
		'form_inputs'	=> false
	);
	
	// Define radio should be checked
	$radio_checked = $initial_display || empty($this->data['TreatmentMaster']['diagnosis_master_id']);
	
	$structure_links = array(
		'top'=>'/clinicalannotation/treatment_masters/add/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentControl.id'],
		'tree'	=> array(
			'DiagnosisMaster' => array(
				'radiolist' => array('TreatmentMaster.diagnosis_master_id' => '%%DiagnosisMaster.id'.'%%') 
			)
		), 'bottom'=>array(
			'cancel'=>'/clinicalannotation/treatment_masters/listall/'.$atim_menu_variables['Participant.id'].'/'
		)
	);

	$final_options = array(
		'type'		=> 'tree',
		'data'		=> $data_for_checklist, 
		'settings'	=> $structure_settings,
		'links'		=> $structure_links,
		'extras' 	=> array('start' => '<input type="radio" name="data[TreatmentMaster][diagnosis_master_id]" '.($radio_checked ? 'checked="checked"' : '').' value=""/>'.__('n/a', null))
	);
	
	$final_atim_structure = array('DiagnosisMaster' => $diagnosis_structure);

	$hook_link = $structures->hook('dx_list');
	if($hook_link){
		require($hook_link);
	}	
	$structures->build($final_atim_structure, $final_options);
?>
<script>
var treeView = true;
</script>