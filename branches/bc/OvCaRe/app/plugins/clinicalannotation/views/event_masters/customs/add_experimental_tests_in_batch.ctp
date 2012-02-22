<?php 

	$structure_links = array(
		'top' => '/clinicalannotation/event_masters/addExperimentalTestsInBatch/'.$atim_menu_variables['Participant.id'],
	);
	
	// 1- EVENT DATA
	
	$structure_settings = array(
		'actions'		=> false, 
		'add_fields' => true, 
		'del_fields' => true,
		'header'		=> '1- ' . __('experimental tests', null),
		'form_bottom'	=> false,
		'paste_disabled_fields' => array('EventDetail.test','EventDetail.result')
	);
	
	$final_atim_structure = $atim_structure;
	$final_options = array( 
		'type' => 'addgrid',
		'data' => $tests_data,
		'settings' => $structure_settings, 
		'links' => $structure_links,
	);
	
	$hook_link = $structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
	
	$structures->build( $final_atim_structure,  $final_options);
	
	// 2- DIAGNOSTICS
			
	// Define radio should be checked
	$radio_checked = $initial_display || empty($this->data['EventMaster']['diagnosis_master_id']);
	$final_options = array(
		'type'	=> 'tree',
		'data'	=> $data_for_checklist,
		'settings'	=> array(
			'form_top'	=> false,
			'header' => '2- ' . __('related diagnosis', null),
			'tree'		=> array('DiagnosisMaster' => 'DiagnosisMaster'),
			'form_inputs' => false
			
		), 'extras'	=> array('start' => '<input type="radio" name="data[EventMaster][diagnosis_master_id]" value="" '.($radio_checked ? 'checked="checked"' : '').'/>'.__('n/a', null)),
		'links'	=> array(
			'top' => '/clinicalannotation/event_masters/add/'.$atim_menu_variables['EventControl.event_group'].'/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['EventControl.id'].'/',
			'bottom' => array('cancel'=>'/clinicalannotation/event_masters/listall/'.$atim_menu_variables['EventControl.event_group'].'/'.$atim_menu_variables['Participant.id']),
			'tree'	=> array(
				'DiagnosisMaster' => array(
					'radiolist' => array('EventMaster.diagnosis_master_id'=>'%%DiagnosisMaster.id'.'%%')
				)
			)
		)
	);
	$final_atim_structure = array('DiagnosisMaster' => $diagnosis_structure);
	
	$hook_link = $structures->hook('dx_list');
	if( $hook_link ) {
		require($hook_link);
	}
	
	$structures->build($final_atim_structure, $final_options);
?>
<script type="text/javascript">
var copyStr = "<?php echo(__("copy", null)); ?>";
var pasteStr = "<?php echo(__("paste")); ?>";
var copyingStr = "<?php echo(__("copying")); ?>";
var pasteOnAllLinesStr = "<?php echo(__("paste on all lines")); ?>";
var copyControl = true;
var treeView = true;
</script>