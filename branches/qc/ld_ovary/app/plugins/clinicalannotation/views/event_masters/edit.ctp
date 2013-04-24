<?php 

	$structure_links = array(
		'top'=>'/clinicalannotation/event_masters/edit/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['EventMaster.id'],
	);
	
	// 1- EVENT DATA
	
	$structure_settings = array(
		'actions'		=> false, 
		'header' 		=> '1- ' . __('data', null),
		'form_bottom'	=> false);
		
	$final_atim_structure = $atim_structure;
	$final_options = array( 'settings'=>$structure_settings, 'links'=>$structure_links );
	
	$hook_link = $structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
	
	$structures->build( $final_atim_structure, $final_options);		

	// 2- SEPARATOR & HEADER
	
	$structure_settings = array(
		'header'		=> '2- ' . __('related diagnosis', null),
		'form_top'		=> false,
		'tree'			=> array('DiagnosisMaster' => 'DiagnosisMaster'),
		'form_inputs'	=> false
	);

	// Define radio should be checked
	$radio_checked = empty($this->data['EventMaster']['diagnosis_master_id']); 
	
	$structure_links = array(
		'top'=>'/clinicalannotation/event_masters/edit/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['EventMaster.id'],
		'bottom'=>array(
				'cancel'=>'/clinicalannotation/event_masters/detail/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['EventMaster.id']
		),'tree'	=> array(
			'DiagnosisMaster' => array(
				'radiolist' => array('EventMaster.diagnosis_master_id'=>'%%DiagnosisMaster.id'.'%%')			
			)
		)
	);
	
	
	$final_options = array(
		'type'		=> 'tree',
		'data'		=> $data_for_checklist,
		'settings'	=> $structure_settings,
		'links'		=> $structure_links,
		'extras'	=> array('start' => '<input type="radio" name="data[EventMaster][diagnosis_master_id]" '.($radio_checked ? 'checked="checked"' : '').' value=""/>'.__('n/a', null))
	);
	$final_atim_structure = array('DiagnosisMaster' => $diagnosis_structure);
	
	$hook_link = $structures->hook('dx_list');
	if($hook_link){
		require($hook_link);
	}
	
	$structures->build( $final_atim_structure, $final_options);
?>
<script>
var treeView = true;
</script>