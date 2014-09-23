<?php 

	$structure_links = array(
		'top' => '/ClinicalAnnotation/EventMasters/add/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['EventControl.id'].'/',
	);
	
	// 1- EVENT DATA
	
	$structure_settings = array(
		'actions'		=> false, 
		'header' 		=> $ev_header,
		'form_bottom'	=> false
	);
	
	$final_atim_structure = $atim_structure;
	$final_options = array( 
		'settings' => $structure_settings, 
		'links' => $structure_links
	);
	
	if($use_addgrid) {
		// *** Add new events in batch *** 
		$final_options['settings'] = array_merge($final_options['settings'], array('pagination' => false, 'add_fields' => true, 'del_fields' => true));
		$final_options['type'] = 'addgrid';
	}
	
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
	
	$this->Structures->build( $final_atim_structure,  $final_options);

	// 2- DIAGNOSTICS
			
	// Define radio should be checked
	$radio_checked = $initial_display || empty($this->request->data['EventMaster']['diagnosis_master_id']);
	$final_options = array(
		'type'	=> 'tree',
		'data'	=> $data_for_checklist,
		'settings'	=> array(
			'form_top'	=> false,
			'header' => __('related diagnosis'),
			'tree'		=> array('DiagnosisMaster' => 'DiagnosisMaster'),
			'form_inputs' => false
			
		), 'extras'	=> array('start' => '<input type="radio" name="data[EventMaster][diagnosis_master_id]" value="" '.($radio_checked ? 'checked="checked"' : '').'/>'.__('n/a', null)),
		'links'	=> array(
			'top' => '/ClinicalAnnotation/EventMasters/add/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['EventControl.id'].'/',
			'bottom' => array('cancel'=>'/ClinicalAnnotation/EventMasters/listall/'.$atim_menu_variables['EventControl.event_group'].'/'.$atim_menu_variables['Participant.id']),
			'tree'	=> array(
				'DiagnosisMaster' => array(
					'radiolist' => array('EventMaster.diagnosis_master_id'=>'%%DiagnosisMaster.id'.'%%')
				)
			)
		)
	);
	$final_atim_structure = array('DiagnosisMaster' => $diagnosis_structure);

	$display_next_sub_form = true;
	
	$hook_link = $this->Structures->hook('dx_list');
	if( $hook_link ) {
		require($hook_link);
	}
	
	if($display_next_sub_form) $this->Structures->build($final_atim_structure, $final_options);
?>
<script>
var treeView = true;
var copyControl = true;
</script>
