<?php 
	
	$top_link = '/ClinicalAnnotation/EventMasters/addExperimentalTestsInBatch/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['EventControl.id'];
	$structure_links = array('top' => $top_link);
	
	// 1- EVENT DATA
	
	$structure_settings = array(
		'actions'		=> false, 
		'add_fields' => true, 
		'del_fields' => true,
		'header'		=> '1- ' . $ev_header,
		'form_bottom'	=> false,
		'paste_disabled_fields' => array('EventDetail.test','EventDetail.result')
	);
	
	$final_atim_structure = $atim_structure;
	$final_options = array(  
		'type' => 'addgrid',
		'settings' => $structure_settings, 
		'links' => $structure_links
	);
	
	$this->Structures->build( $final_atim_structure,  $final_options);
	
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
			'top' => $top_link,
			'bottom' => array('cancel'=>'/ClinicalAnnotation/EventMasters/listall/'.$atim_menu_variables['EventControl.event_group'].'/'.$atim_menu_variables['Participant.id']),
			'tree'	=> array(
				'DiagnosisMaster' => array(
					'radiolist' => array('EventMaster.diagnosis_master_id'=>'%%DiagnosisMaster.id'.'%%')
				)
			)
		)
	);
	$final_atim_structure = array('DiagnosisMaster' => $diagnosis_structure);
	
	$this->Structures->build($final_atim_structure, $final_options);
?>
<script type="text/javascript">
var copyStr = "<?php echo(__("copy", null)); ?>";
var pasteStr = "<?php echo(__("paste")); ?>";
var copyingStr = "<?php echo(__("copying")); ?>";
var pasteOnAllLinesStr = "<?php echo(__("paste on all lines")); ?>";
var copyControl = true;
var treeView = true;
</script>